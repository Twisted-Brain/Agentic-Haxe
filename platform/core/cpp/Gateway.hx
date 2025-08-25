package platform.core.cpp;

import sys.net.Socket;
import sys.Http;
import haxe.Json;
import domain.types.http.ApiModels.LlmRequest;
import domain.types.http.ApiModels.LlmResponse;
import haxe.io.Bytes;

class Gateway {
    private static final PORT = 9090;

    public static function main() {
        var server = new Socket();
        server.bind(new sys.net.Host("0.0.0.0"), PORT);
        server.listen(5);
        trace('C++ LLM Gateway running on http://localhost:' + PORT);

        while (true) {
            var client = server.accept();
            try {
                handleClient(client);
            } catch (e:Any) {
                trace('Error handling client: $e');
                client.close();
            }
        }
    }

    private static function handleClient(client:Socket) {
        var input = client.input;
        var requestLine = input.readLine();
        if (requestLine == null || requestLine == "") {
            client.close();
            return;
        }

        var parts = requestLine.split(" ");
        var method = parts[0];
        var uri = parts[1];

        var headers = new Map<String, String>();
        var contentLength = 0;
        while (true) {
            var line = input.readLine();
            if (line == null || line == "") {
                break;
            }
            var headerParts = line.split(": ");
            if (headerParts.length == 2) {
                headers.set(headerParts[0].toLowerCase(), headerParts[1]);
                if (headerParts[0].toLowerCase() == "content-length") {
                    contentLength = Std.parseInt(headerParts[1]);
                }
            }
        }

        if (method == "POST" && uri == "/llm/request") {
            if (contentLength > 0) {
                var bodyBytes = input.read(contentLength);
                var body = bodyBytes.toString();
                handleLlmRequest(body, client);
            } else {
                sendResponse(client, 400, "Bad Request", "{\"error\":\"Content-Length header required\"}");
            }
        } else {
            sendResponse(client, 404, "Not Found", "{\"error\":\"Not Found\"}");
        }
    }

    private static function handleLlmRequest(body:String, client:Socket) {
        try {
            var llmRequest:LlmRequest = haxe.Json.parse(body);
            var apiKey = Sys.getEnv("OPENROUTER_API_KEY");

            if (apiKey == null || apiKey == "") {
                sendResponse(client, 500, "Internal Server Error", "{\"error\":\"API key not configured\"}");
                return;
            }

            var http = new sys.Http("https://openrouter.ai/api/v1/chat/completions");
            http.setHeader("Authorization", 'Bearer $apiKey');
            http.setHeader("Content-Type", "application/json");

            var requestBody = haxe.Json.stringify({
                model: llmRequest.model,
                messages: [{ role: "user", content: llmRequest.message }]
            });
            http.setPostData(requestBody);

            http.onData = function(data:String) {
                var llmResponse:LlmResponse = new LlmResponse(data, llmRequest.model);
                sendResponse(client, 200, "OK", haxe.Json.stringify(llmResponse));
            };

            http.onError = function(error:String) {
                sendResponse(client, 500, "Internal Server Error", haxe.Json.stringify({ error: error }));
            };

            http.request(true);

        } catch (e:Any) {
            sendResponse(client, 400, "Bad Request", haxe.Json.stringify({ error: 'Invalid JSON format: $e' }));
        }
    }

    private static function sendResponse(client:Socket, statusCode:Int, statusText:String, body:String) {
        var response = 'HTTP/1.1 $statusCode $statusText\r\n';
        response += "Content-Type: application/json\r\n";
        response += 'Content-Length: ${Bytes.ofString(body).length}\r\n';
        response += "Connection: close\r\n";
        response += "\r\n";
        response += body;

        try {
            client.output.writeString(response);
        } catch (e:Any) {
            trace('Could not send response: $e');
        } finally {
            client.close();
        }
    }
}