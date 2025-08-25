![Haxe Multi-Platform Logo](/assets/logo.png)

# PoC 01: Haxe 3-Tier - React, Node.js & C++ Gateway

## ::GOAL
This Proof of Concept (PoC) demonstrates a 3-tier, fullstack Haxe application based on the principles in `00-Haxe-AI-Chat-PoC.md`. The architecture consists of:
- A **React-based frontend** for a rich user experience.
- A **Node.js backend server** to handle application logic and serve the frontend.
- A high-performance **C++ gateway** that securely manages communication with the OpenRouter LLM.
- A shared **`domain`** layer, compiled for all three tiers, ensuring consistency and code reuse.

This setup showcases Haxe's unique ability to build complex, high-performance, and maintainable systems across different technology stacks from a unified codebase.

## ::TARGET PLATFORMS
- **Frontend**: JavaScript (React, compiled from Haxe)
- **Backend**: JavaScript (Node.js, compiled from Haxe)
- **Gateway**: C++ (for secure, high-performance native execution)

## ::TECHNICAL ARCHITECTURE
The application is divided into three distinct services that communicate over local HTTP:
1.  **React Frontend (runs in browser)**: The user interacts with the chat UI. It sends API requests to the Node.js backend.
2.  **Node.js Backend (runs on port 8080)**: Serves the static React app files. It exposes a `/api/chat` endpoint that receives requests from the frontend, performs any necessary business logic, and then calls the C++ gateway.
3.  **C++ Gateway (runs on port 9090)**: Exposes an internal `/llm/request` endpoint. It receives requests from the Node.js server, securely attaches the `OPENROUTER_API_KEY` from its environment, and forwards the request to the OpenRouter API.

This separation ensures that the API key is never exposed to the frontend or the Node.js server, residing only in the secure, compiled C++ gateway.

---

### Code Examples

#### React Frontend (`platform/frontend/js/components/ChatView.hx`)
The frontend calls the Node.js backend, not the gateway directly.
```haxe
// ... (imports and class definition)
function sendMessage() {
    var request:LlmRequest = new LlmRequest(this.state.currentInput);
    var xhr = new js.html.XMLHttpRequest();
    // Calls the Node.js server on port 8080
    xhr.open("POST", "http://localhost:8080/api/chat");
    xhr.setRequestHeader("Content-Type", "application/json");
    // ... (onreadystatechange and send logic)
}
// ... (render logic)
```

#### Node.js Backend (`platform/core/js/NodeServer.hx`)
This server acts as an intermediary, forwarding requests to the C++ gateway.
```haxe
package platform.core.js;

import sys.Http;
import js.node.Http;

class NodeServer {
    public static function main() {
        Http.createServer(function(req, res) {
            if (req.method == "POST" && req.url == "/api/chat") {
                var body = "";
                req.on("data", chunk -> body += chunk);
                req.on("end", () -> {
                    // Forward the request to the C++ gateway on port 9090
                    var gatewayReq = new sys.Http("http://localhost:9090/llm/request");
                    gatewayReq.setHeader("Content-Type", "application/json");
                    gatewayReq.setPostData(body);
                    gatewayReq.onData = (data) -> {
                        res.setHeader("Content-Type", "application/json");
                        res.end(data);
                    };
                    gatewayReq.onError = (error) -> {
                        res.statusCode = 500;
                        res.end('{"error": "Gateway communication failed"}');
                    };
                    gatewayReq.request(true);
                });
            } else {
                // Basic static file serving for the React app would go here
                res.statusCode = 404;
                res.end("Not Found");
            }
        }).listen(8080, () -> trace('Node.js server running on http://localhost:8080'));
    }
}
```

#### C++ Gateway (`platform/core/cpp/Gateway.hx`)
This native application is the only component with access to the API key.
```haxe
package platform.core.cpp;

import domain.types.http.ApiModels;
// ... imports for a C++ web server library
class Gateway {
    public static function main() {
        var server = new cpp.net.HttpServer(); // Example library
        server.addRoute("POST", "/llm/request", handleLlmRequest);
        server.listen(9090);
        trace('C++ LLM Gateway running on http://localhost:9090');
    }

    private static function handleLlmRequest(req:HttpRequest):HttpResponse {
        var llmRequest:LlmRequest = haxe.Json.parse(req.body);
        
        // Securely get API key from environment and call OpenRouter
        var apiKey = Sys.getEnv("OPENROUTER_API_KEY");
        // ... logic to make the actual call to OpenRouter API ...
        
        var response:LlmResponse = new LlmResponse("Response from LLM", llmRequest.model);
        return HttpResponse.json(response);
    }
}
```

---

### Build Configuration

#### Frontend Build (`build-frontend.hxml`)
```hxml
-cp platform/frontend/js
-cp domain
-main platform.frontend.js.Main
-lib hx-react
-js platform/frontend/js/build/app.js
-D js-es=6
```

#### Node.js Backend Build (`build-nodejs.hxml`)
```hxml
-cp platform/core/js
-cp domain
-main platform.core.js.NodeServer
-lib hxnodejs
-js bin/server.js
```

#### C++ Gateway Build (`build-cpp.hxml`)
```hxml
-cp platform/core/cpp
-cp domain
-main platform.core.cpp.Gateway
-cpp bin/cpp_gateway
-D HXCPP_QUIET
```

## ::CONCLUSION
This PoC outlines a robust 3-tier architecture using Haxe to target three distinct platforms: a React frontend, a Node.js backend, and a C++ gateway. This model provides maximum security by isolating the API key in a compiled, native gateway, while leveraging the strengths of Node.js for backend logic and React for the user interface. The shared `domain` core demonstrates Haxe's power for creating highly reusable, cross-platform code.