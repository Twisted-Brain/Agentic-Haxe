package backend;

import sys.Http;
import haxe.Json;
import haxe.crypto.Base64;
import shared.ApiModels;
import cpp.vm.Thread;
import sys.thread.Mutex;
import Sys;

class LlmGatewayMain {
    private static var openRouterApiKey: String = "";
    private static var openRouterBaseUrl: String = "https://openrouter.ai/api/v1";
    private static var defaultModel: String = "openai/gpt-3.5-turbo";
    private static var isRunning: Bool = true;
    private static var requestMutex: Mutex;
    
    public static function main(): Void {
        trace("Starting Haxe C++ LLM Gateway...");
        
        requestMutex = new Mutex();
        initializeGateway();
        startGatewayServer();
    }
    
    private static function initializeGateway(): Void {
        trace("Initializing LLM Gateway...");
        
        // Load API key from environment or config
        openRouterApiKey = Sys.getEnv("OPENROUTER_API_KEY");
        if (openRouterApiKey == null || openRouterApiKey == "") {
            trace("Warning: OPENROUTER_API_KEY not set. Using demo mode.");
            openRouterApiKey = "demo-key";
        }
        
        // Override model if specified
        var envModel = Sys.getEnv("LLM_MODEL");
        if (envModel != null && envModel != "") {
            defaultModel = envModel;
        }
        
        trace('Gateway initialized with model: $defaultModel');
    }
    
    private static function startGatewayServer(): Void {
        trace("Starting gateway server on port 8080...");
        
        // Simple HTTP server simulation
        while (isRunning) {
            try {
                // In a real implementation, this would be a proper HTTP server
                // For now, we simulate processing requests
                processIncomingRequests();
                
                // Sleep to prevent busy waiting
                Sys.sleep(0.1);
            } catch (e: Dynamic) {
                trace('Error in gateway server: $e');
            }
        }
    }
    
    private static function processIncomingRequests(): Void {
        // Simulate processing queue of requests
        // In real implementation, this would handle HTTP requests
        
        // For demonstration, process a sample request
        var sampleRequest = new LlmRequest(
            "Hello, this is a test message from the Haxe C++ backend",
            defaultModel
        );
        
        var response = processLlmRequest(sampleRequest);
        if (response != null) {
            trace('Sample response processed: ${response.content.substring(0, 50)}...');
        }
    }
    
    public static function processLlmRequest(request: LlmRequest): LlmResponse {
        requestMutex.acquire();
        
        try {
            trace('Processing LLM request for model: ${request.model}');
            
            if (openRouterApiKey == "demo-key") {
                // Demo mode - return simulated response
                var result = createDemoResponse(request);
                requestMutex.release();
                return result;
            }
            
            // Real OpenRouter API call
            var response = callOpenRouterApi(request);
            requestMutex.release();
            return response;
            
        } catch (e: Dynamic) {
            trace('Error processing LLM request: $e');
            requestMutex.release();
            return new LlmResponse(
                "Error: Failed to process request - " + Std.string(e),
                "error",
                0,
                0
            );
        }
    }
    
    private static function callOpenRouterApi(request: LlmRequest): LlmResponse {
        var url = '$openRouterBaseUrl/chat/completions';
        
        var requestBody = {
            model: request.model,
            messages: [
                {
                    role: "user",
                    content: request.message
                }
            ],
            max_tokens: 1000,
            temperature: 0.7
        };
        
        var http = new Http(url);
        http.addHeader("Authorization", 'Bearer $openRouterApiKey');
        http.addHeader("Content-Type", "application/json");
        http.addHeader("HTTP-Referer", "https://github.com/your-repo");
        http.addHeader("X-Title", "Haxe LLM Gateway");
        
        var responseData: String = "";
        var hasError: Bool = false;
        
        http.onData = function(data: String) {
            responseData = data;
        };
        
        http.onError = function(error: String) {
            trace('HTTP Error: $error');
            hasError = true;
            responseData = error;
        };
        
        try {
            http.setPostData(Json.stringify(requestBody));
            http.request(true);
            
            if (hasError) {
                return new LlmResponse(
                    "API Error: " + responseData,
                    "error",
                    0,
                    0
                );
            }
            
            var parsedResponse = Json.parse(responseData);
            var content = parsedResponse.choices[0].message.content;
            var usage = parsedResponse.usage;
            
            return new LlmResponse(
                content,
                "success",
                usage.prompt_tokens,
                usage.completion_tokens
            );
            
        } catch (e: Dynamic) {
            trace('Exception calling OpenRouter API: $e');
            return new LlmResponse(
                "Exception: " + Std.string(e),
                "error",
                0,
                0
            );
        }
    }
    
    private static function createDemoResponse(request: LlmRequest): LlmResponse {
        var demoContent = 'Demo Response from Haxe C++ Gateway:\n\n';
        demoContent += 'Your message: "${request.message}"\n';
        demoContent += 'Model requested: ${request.model}\n';
        demoContent += 'Timestamp: ${Date.now()}\n\n';
        demoContent += 'This is a simulated response. To use real LLM, set OPENROUTER_API_KEY environment variable.';
        
        return new LlmResponse(
            demoContent,
            "success",
            50,  // Simulated prompt tokens
            100  // Simulated completion tokens
        );
    }
    
    public static function shutdown(): Void {
        trace("Shutting down LLM Gateway...");
        isRunning = false;
    }
}