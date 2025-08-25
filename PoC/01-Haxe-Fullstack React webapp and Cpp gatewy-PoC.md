![Haxe Multi-Platform Logo](/assets/logo.png)

# PoC 01: Haxe Fullstack - React Frontend & C++ Gateway

## ::GOAL
This Proof of Concept (PoC) implements the architecture defined in `00-Haxe-AI-Chat-PoC.md`. It demonstrates a fullstack Haxe application featuring:
- A **React-based frontend** for the user interface, compiled from Haxe.
- A high-performance **C++ backend** acting as a secure gateway to the LLM.
- A shared **`domain`** layer for core logic and models, reusable across both frontend and backend.

This approach validates Haxe's power in creating a robust, multi-tiered application from a single codebase, adhering to the principles of Hexagonal Architecture.

## ::TARGET PLATFORMS
- **Backend**: C++ (for performance and native execution)
- **Frontend**: JavaScript (React, compiled from Haxe)

## ::TECHNICAL ARCHITECTURE
The project follows the structure defined in the main PoC document.

- **Shared Domain (`domain/`)**: The core of the application, containing all business logic, data models, and service interfaces. This code is compiled for both the C++ backend and the JS frontend.
    - `domain/types/http/`: Contains data transfer objects (DTOs) like `LlmRequest` and `LlmResponse`.
    - `domain/core/`: Contains core business logic like `Conversation.hx`.
    - `domain/ports/`: Defines interfaces for external services (e.g., `IHttpClient.hx`).

- **C++ Backend (`platform/core/cpp/`)**: The server-side implementation.
    - `platform/core/cpp/Main.hx`: Sets up the C++ web server, handles API requests, and securely communicates with the OpenRouter API using an environment variable.

- **React Frontend (`platform/frontend/js/`)**: The client-side implementation.
    - `platform/frontend/js/Main.hx`: The entry point for the React application.
    - `platform/frontend/js/components/`: Contains React components, such as `ChatView.hx`.

---

### Code Examples

#### API Models (`domain/types/http/ApiModels.hx`)
```haxe
package domain.types.http;

// Using abstracts for type safety and easy JSON conversion.
// See 00-Haxe-AI-Chat-PoC.md for API key handling strategy.
abstract LlmRequest(Dynamic) from Dynamic to Dynamic {
    public var message(get, never):String;
    public var model(get, never):String;
    public inline function new(message:String, model:String = "gryphe/mythomax-l2-13b") {
        this = { message: message, model: model };
    }
}

abstract LlmResponse(Dynamic) from Dynamic to Dynamic {
    public var content(get, never):String;
    public var model(get, never):String;
    public inline function new(content:String, model:String) {
        this = { content: content, model: model };
    }
}
```

#### C++ Backend (`platform/core/cpp/Main.hx`)
```haxe
package platform.core.cpp;

import domain.types.http.ApiModels;
// ... imports for a C++ web server library (e.g., HxWebSockets, etc.)

class Main {
    public static function main() {
        var server = new cpp.net.HttpServer(); // Example library

        server.addRoute("POST", "/api/chat", handleChatRequest);
        // Serve the compiled frontend application
        server.serveStatic("/", "platform/frontend/js/build/");

        server.listen(8080);
        trace('C++ server running on http://localhost:8080');
    }

    private static function handleChatRequest(req:HttpRequest):HttpResponse {
        // 1. Deserialize request from frontend
        var llmRequest:LlmRequest = haxe.Json.parse(req.body);

        // 2. Securely call OpenRouter using OPENROUTER_API_KEY from environment
        var openRouterResponse = callOpenRouter(llmRequest); // Implementation details omitted

        // 3. Serialize and return response to frontend
        var response:LlmResponse = new LlmResponse(openRouterResponse.content, openRouterResponse.model);
        return HttpResponse.json(response);
    }
}
```

#### React Frontend (`platform/frontend/js/components/ChatView.hx`)
```haxe
package platform.frontend.js.components;

import react.ReactComponent;
import react.ReactMacro.jsx;
import domain.types.http.ApiModels;

class ChatView extends ReactComponent {
    public function new() {
        super();
        this.state = { messages: [], currentInput: "" };
    }

    function sendMessage() {
        var request:LlmRequest = new LlmRequest(this.state.currentInput);
        var xhr = new js.html.XMLHttpRequest();
        xhr.open("POST", "/api/chat"); // Relative URL to the C++ backend
        xhr.setRequestHeader("Content-Type", "application/json");

        xhr.onreadystatechange = () -> {
            if (xhr.readyState == 4 && xhr.status == 200) {
                var response:LlmResponse = haxe.Json.parse(xhr.responseText);
                // Add response to messages state and re-render
                // ...
            }
        };
        xhr.send(haxe.Json.stringify(request));
    }

    override function render() {
        return jsx('
            <div>
                <h1>Haxe AI Chat (React + C++)</h1>
                <div className="chat-window">{/* ... render messages ... */}</div>
                <input
                    type="text"
                    value=${this.state.currentInput}
                    onChange=${(e) -> this.setState({ currentInput: e.target.value })}
                />
                <button onClick=${(_) -> sendMessage()}>Send</button>
            </div>
        ');
    }
}
```

---

### Build Configuration

#### Frontend Build (`build-frontend.hxml`)
```hxml
# Specifies class paths for frontend code and shared domain logic
-cp platform/frontend/js
-cp domain

# Entry point for the application
-main platform.frontend.js.Main

# Include the hx-react library
-lib hx-react

# Output compiled JavaScript file
-js platform/frontend/js/build/app.js

# Use modern JavaScript features
-D js-es=6
```

#### Backend Build (`build-cpp.hxml`)
```hxml
# Specifies class paths for C++ code and shared domain logic
-cp platform/core/cpp
-cp domain

# Entry point for the application
-main platform.core.cpp.Main

# Output directory for the C++ executable
-cpp bin/cpp_gateway

# Suppress verbose Haxe C++ compiler output
-D HXCPP_QUIET
```

## ::CONCLUSION
This PoC provides a concrete implementation of a fullstack Haxe application using a C++ backend and a React frontend. It follows the Hexagonal Architecture defined in `00-Haxe-AI-Chat-PoC.md`, demonstrating clean separation of concerns and high code reusability. This setup serves as a robust template for building powerful, cross-platform web applications with Haxe.