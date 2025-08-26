![Haxe Multi-Platform Logo](/assets/logo.png)

# PoC 01: Haxe 2-Tier - React Frontend & C++ Backend

## ::GOAL
This Proof of Concept (PoC) demonstrates a 2-tier, fullstack Haxe application based on the principles in [00-Haxe-AI-Chat-PoC.md](./00-Haxe-AI-Chat-PoC.md). The architecture consists of:
- A **React-based frontend** for a rich user experience following the [React UI Design](../docs/React-UI.md) guidelines.
- A unified **C++ backend server** that combines web server functionality with secure OpenRouter LLM gateway capabilities.
- A shared **`domain`** layer, compiled for both tiers, ensuring consistency and code reuse.

This setup showcases Haxe's unique ability to build high-performance, secure, and maintainable systems with minimal complexity while leveraging C++'s native performance for both web serving and API gateway functionality.

## ::TARGET PLATFORMS
- **Frontend**: JavaScript (React, compiled from Haxe)
- **Backend**: C++ (unified server with web serving and LLM gateway capabilities)

## ::TECHNICAL ARCHITECTURE
The application is divided into two distinct components:
1. **React Frontend (runs in browser)**: The user interacts with the chat UI following the design specifications in [React-UI.md](../docs/React-UI.md). It sends API requests directly to the C++ backend server.
2. **C++ Backend Server (runs on port 8080)**: A unified native application that:
   - Serves the static React app files
   - Exposes a `/api/chat` endpoint for frontend communication
   - Handles LLM requests by securely attaching the `OPENROUTER_API_KEY` from its environment
   - Forwards requests to the OpenRouter API and returns responses

This simplified architecture ensures maximum security by keeping the API key within the compiled C++ application while reducing complexity by eliminating the need for multiple services.

## ::UI DESIGN
The frontend follows the **Twisted Brain** design system as specified in [React-UI.md](../docs/React-UI.md):
- Modern AI chat interface with light/dark theme support
- Calm neon colors (Magenta `#FF49A8`, Cyan `#38E1FF`, Violet `#8A5BFF`)
- Twisted Brain logo integration
- Message bubbles with glow effects
- Virtual scrolling for performance
- File attachment and image support

---

### Code Examples

#### React Frontend (`platform/frontend/js/components/ChatView.hx`)
The frontend calls the C++ backend server directly.
```haxe
// ... (imports and class definition)
function sendMessage() {
    var request:LlmRequest = new LlmRequest(this.state.currentInput);
    var xhr = new js.html.XMLHttpRequest();
    // Calls the C++ server on port 8080
    xhr.open("POST", "http://localhost:8080/api/chat");
    xhr.setRequestHeader("Content-Type", "application/json");
    // ... (onreadystatechange and send logic)
}
// ... (render logic)
```

#### C++ Backend Server (`platform/core/cpp/BackendServer.hx`)
This unified server handles both web serving and LLM gateway functionality.
```haxe
package platform.core.cpp;

import domain.types.http.ApiModels;
// ... imports for a C++ web server library
class BackendServer {
    public static function main() {
        var server = new cpp.net.HttpServer(); // Example library
        
        // Serve static files for React app
        server.addStaticRoute("/", "./www/");
        
        // API endpoint for chat functionality
        server.addRoute("POST", "/api/chat", handleChatRequest);
        
        server.listen(8080);
        trace('C++ Backend Server running on http://localhost:8080');
    }

    private static function handleChatRequest(req:HttpRequest):HttpResponse {
        var llmRequest:LlmRequest = haxe.Json.parse(req.body);
        
        // Securely get API key from environment and call OpenRouter
        var apiKey = Sys.getEnv("OPENROUTER_API_KEY");
        if (apiKey == null) {
            return HttpResponse.error(500, '{"error": "API key not configured"}');
        }
        
        // Make request to OpenRouter API
        var openRouterReq = new sys.Http("https://openrouter.ai/api/v1/chat/completions");
        openRouterReq.setHeader("Authorization", "Bearer " + apiKey);
        openRouterReq.setHeader("Content-Type", "application/json");
        openRouterReq.setPostData(haxe.Json.stringify(llmRequest));
        
        var responseData = "";
        openRouterReq.onData = (data) -> responseData = data;
        openRouterReq.onError = (error) -> {
            return HttpResponse.error(500, '{"error": "OpenRouter API call failed"}');
        };
        
        openRouterReq.request(true);
        
        return HttpResponse.json(responseData);
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
-js www/build/app.js
-D js-es=6
```

#### C++ Backend Build (`build-backend.hxml`)
```hxml
-cp platform/core/cpp
-cp domain
-main platform.core.cpp.BackendServer
-cpp bin/backend_server
-D HXCPP_QUIET
```

### Deployment

1. **Build the frontend**: Compile React app to `www/build/app.js`
2. **Build the backend**: Compile C++ server to `bin/backend_server`
3. **Set environment variable**: `export OPENROUTER_API_KEY=your_api_key`
4. **Run the server**: `./bin/backend_server/BackendServer`
5. **Access the app**: Open `http://localhost:8080` in your browser

## ::CONCLUSION
This PoC demonstrates a streamlined 2-tier architecture using Haxe to target two platforms: a React frontend and a unified C++ backend. This model provides maximum security by isolating the API key in a compiled, native server while simplifying deployment and maintenance. The architecture leverages C++'s performance for both web serving and API gateway functionality, while the shared `domain` core demonstrates Haxe's power for creating highly reusable, cross-platform code. The UI follows the modern **Twisted Brain** design system for an engaging user experience.