package platform.core.cpp;

import haxe.Json;
import haxe.Http;
import sys.net.Host;
import sys.net.Socket;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;

typedef LlmRequest = {
    var message: String;
    var model: String;
}

typedef LlmResponse = {
    var response: String;
    var model: String;
}

@:keep
class Gateway {
    private static var serverSocket: Socket;
    private static var isRunning: Bool = false;
    
    public static function main() {
        trace('Starting C++ LLM Gateway on http://localhost:9090');
        startHttpServer();
    }
    
    private static function startHttpServer() {
        try {
            serverSocket = new Socket();
            serverSocket.bind(new Host("localhost"), 9090);
            serverSocket.listen(10);
            isRunning = true;
            
            trace('C++ LLM Gateway running on http://localhost:9090');
            
            while (isRunning) {
                try {
                    var clientSocket = serverSocket.accept();
                    handleClientRequest(clientSocket);
                } catch (e:Dynamic) {
                    trace('Error accepting client: $e');
                }
            }
        } catch (e:Dynamic) {
            trace('Failed to start server: $e');
        }
    }
    
    private static function handleClientRequest(clientSocket: Socket) {
        try {
            var requestData = "";
            var buffer = Bytes.alloc(4096);
            
            while (true) {
                try {
                    var bytesRead = clientSocket.input.readBytes(buffer, 0, 4096);
                    if (bytesRead == 0) break;
                    requestData += buffer.sub(0, bytesRead).toString();
                    if (requestData.indexOf("\r\n\r\n") != -1) break;
                } catch (e:Dynamic) {
                    break;
                }
            }
            
            var response = processHttpRequest(requestData);
            clientSocket.output.writeString(response);
            clientSocket.output.flush();
            clientSocket.close();
        } catch (e:Dynamic) {
            trace('Error handling client request: $e');
            try {
                clientSocket.close();
            } catch (closeError:Dynamic) {}
        }
    }
    
    private static function processHttpRequest(requestData: String): String {
        var lines = requestData.split("\r\n");
        if (lines.length == 0) return createErrorResponse(400, "Bad Request");
        
        var requestLine = lines[0];
        var parts = requestLine.split(" ");
        if (parts.length < 3) return createErrorResponse(400, "Bad Request");
        
        var method = parts[0];
        var path = parts[1];
        
        // Handle CORS preflight
        if (method == "OPTIONS") {
            return createCorsResponse();
        }
        
        if (method == "POST" && path == "/llm/request") {
            var bodyStart = requestData.indexOf("\r\n\r\n");
            if (bodyStart == -1) return createErrorResponse(400, "No body found");
            
            var body = requestData.substring(bodyStart + 4);
            return handleLlmRequest(body);
        }
        
        return createErrorResponse(404, "Not Found");
    }
    
    private static function createCorsResponse(): String {
        return "HTTP/1.1 204 No Content\r\n" +
               "Access-Control-Allow-Origin: *\r\n" +
               "Access-Control-Allow-Methods: POST, OPTIONS\r\n" +
               "Access-Control-Allow-Headers: Content-Type\r\n" +
               "Content-Length: 0\r\n" +
               "\r\n";
    }
    
    private static function handleLlmRequest(body: String): String {
        try {
            var llmRequest: LlmRequest = Json.parse(body);
            var apiKey = Sys.getEnv("OPENROUTER_API_KEY");
            
            if (apiKey == null || apiKey == "") {
                return createErrorResponse(500, "API key not configured");
            }
            
            var openRouterResponse = callOpenRouter(llmRequest, apiKey);
            return createJsonResponse(openRouterResponse);
        } catch (e:Dynamic) {
            trace('Error processing LLM request: $e');
            return createErrorResponse(500, "Internal server error: " + Std.string(e));
        }
    }
    
    private static function callOpenRouter(request: LlmRequest, apiKey: String): LlmResponse {
        try {
            var http = new Http("https://openrouter.ai/api/v1/chat/completions");
            
            var requestBody = Json.stringify({
                "model": request.model != null ? request.model : "openai/gpt-3.5-turbo",
                "messages": [
                    {
                        "role": "user",
                        "content": request.message
                    }
                ]
            });
            
            http.setHeader("Authorization", "Bearer " + apiKey);
            http.setHeader("Content-Type", "application/json");
            http.setPostData(requestBody);
            
            var responseData = "";
            var hasError = false;
            var errorMessage = "";
            
            http.onData = function(data) {
                responseData = data;
            };
            
            http.onError = function(error) {
                hasError = true;
                errorMessage = error;
            };
            
            http.request(true);
            
            if (hasError) {
                throw "OpenRouter API error: " + errorMessage;
            }
            
            var openRouterResponse = Json.parse(responseData);
            var content = "No response";
            
            if (openRouterResponse.choices != null && openRouterResponse.choices.length > 0) {
                content = openRouterResponse.choices[0].message.content;
            }
            
            return {
                response: content,
                model: request.model != null ? request.model : "openai/gpt-3.5-turbo"
            };
        } catch (e:Dynamic) {
            trace('OpenRouter API call failed: $e');
            return {
                response: "Sorry, I'm having trouble connecting to the AI service. Please try again later.",
                model: request.model != null ? request.model : "openai/gpt-3.5-turbo"
            };
        }
    }
    
    private static function createJsonResponse(data: Dynamic): String {
        var jsonData = Json.stringify(data);
        return "HTTP/1.1 200 OK\r\n" +
               "Content-Type: application/json\r\n" +
               "Access-Control-Allow-Origin: *\r\n" +
               "Content-Length: " + jsonData.length + "\r\n" +
               "\r\n" +
               jsonData;
    }
    
    private static function createErrorResponse(statusCode: Int, message: String): String {
        var errorData = Json.stringify({error: message});
        return 'HTTP/1.1 $statusCode $message\r\n' +
               "Content-Type: application/json\r\n" +
               "Access-Control-Allow-Origin: *\r\n" +
               "Content-Length: " + errorData.length + "\r\n" +
               "\r\n" +
               errorData;
    }
}