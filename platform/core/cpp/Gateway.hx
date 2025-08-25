package platform.core.cpp;

import sys.Http;
import haxe.Json;
import domain.types.http.ApiModels.LlmRequest;
import domain.types.http.ApiModels.LlmResponse;
import webserver.WebServer;
import webserver.Request;
import webserver.Response;

class Gateway {
    public static function main() {
        var server = new WebServer();
        server.addRoute("POST", "/llm/request", handleLlmRequest);
        server.start(9090);
        trace('C++ LLM Gateway running on http://localhost:9090');
    }

    private static function handleLlmRequest(req:Request, res:Response) {
        try {
            var llmRequest:LlmRequest = haxe.Json.parse(req.bodyString());
            
            var apiKey = Sys.getEnv("OPENROUTER_API_KEY");
            if (apiKey == null || apiKey == "") {
                res.status(500).send(haxe.Json.stringify({ error: "API key not configured" }));
                return;
            }

            var http = new sys.Http("https://openrouter.ai/api/v1/chat/completions");
            http.setHeader("Authorization", 'Bearer $apiKey');
            http.setHeader("Content-Type", "application/json");

            var requestBody = haxe.Json.stringify({
                model: llmRequest.model,
                messages: [ { role: "user", content: llmRequest.prompt } ]
            });

            http.setPostData(requestBody);

            http.onData = function(data:String) {
                var llmResponse:LlmResponse = new LlmResponse(data, llmRequest.model);
                res.status(200).send(haxe.Json.stringify(llmResponse));
            };

            http.onError = function(error:String) {
                res.status(500).send(haxe.Json.stringify({ error: error }));
            };

            http.request(true);

        } catch (e:Any) {
            res.status(400).send(haxe.Json.stringify({ error: 'Invalid request format: ${e}' }));
        }
    }
}