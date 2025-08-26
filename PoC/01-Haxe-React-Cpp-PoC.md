![logo](../assets/logo.png)

# PoC: 2-Tier Haxe Application with React Frontend and C++ Backend

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

## ::TESTING STRATEGY

This project employs a multi-layered testing strategy to ensure robustness, correctness, and reliability across the entire application stack.

### 1. Unit Testing

**Goal:** Verify the correctness of individual components (classes, functions) in isolation.

*   **Domain Logic (`/domain`):**
    *   **Tool:** `munit` (a popular Haxe testing framework).
    *   **Scenario:** Create test cases for `Conversation.hx` to ensure state transitions (e.g., adding messages, tracking user/AI turns) are handled correctly.
    *   **Execution:** Run `haxe test.hxml` to compile and run tests on the desired target (e.g., Node.js for speed).

*   **Frontend Components (`/platform/frontend`):**
    *   **Tool:** `munit` and `js-virtual-dom`.
    *   **Scenario:** Test React components like `ChatView.hx` to verify that `render()` produces the correct DOM structure based on different state inputs (e.g., an empty message list vs. a populated one).
    *   **Execution:** Run frontend-specific test configuration.

*   **Backend Handlers (`/platform/core/cpp`):**
    *   **Tool:** `munit`.
    *   **Scenario:** Test the `handleChatRequest` function by mocking `HttpRequest` and `HttpResponse` objects. Verify that it correctly parses requests, handles missing API keys, and formats responses.
    *   **Execution:** Run backend-specific test configuration.

### 2. Integration Testing

**Goal:** Verify that different parts of the application work together as expected.

*   **Scenario 1: Frontend <-> Backend API**
    *   **Setup:** Run the C++ backend server. Use a separate Haxe test file to make HTTP requests to the `/api/chat` endpoint.
    *   **Verification:**
        *   Assert that a valid `POST` request receives a `200 OK` response.
        *   Assert that the response body is valid JSON and contains the expected fields.
        *   Assert that a request with a malformed body returns a `400 Bad Request` error.

*   **Scenario 2: Backend <-> OpenRouter API**
    *   **Setup:** Create a test that calls the internal function responsible for forwarding requests to OpenRouter.
    *   **Verification:**
        *   Use a mock HTTP client or a tool like `mock-server` to simulate the OpenRouter API.
        *   Ensure the `Authorization` header is correctly set with the API key.
        *   Verify that the backend correctly handles success and error responses from the mock OpenRouter API.

### 3. End-to-End (E2E) Testing

**Goal:** Simulate a real user workflow from the UI to the database and back.

*   **Tool:** A browser automation tool like `Selenium` or `Puppeteer` with a Haxe wrapper if available, or a JS-based test runner like `Cypress` acting on the compiled JS.
*   **Scenario:**
    1.  **Build and Run:** Compile both frontend and backend, set the `OPENROUTER_API_KEY`, and start the C++ server.
    2.  **Launch Browser:** The E2E test script opens a browser and navigates to `http://localhost:8080`.
    3.  **Interact with UI:**
        *   The script waits for the `ChatView` component to be rendered.
        *   It types "Hello, world!" into the text input field.
        *   It clicks the "Send" button.
    4.  **Verification:**
        *   The script asserts that the user's message ("Hello, world!") appears in the message list.
        *   It waits for the AI's response to appear in the message list.
        *   It checks the network tab (or uses proxying) to confirm a `POST` request was made to `/api/chat` and a successful response was received.

### Manual Test & Run Procedure

For quick validation and manual testing:

1.  **Build Frontend & Backend:**
    ```bash
    ./build.sh
    ```
2.  **Set Environment Variable:**
    ```bash
    export OPENROUTER_API_KEY='your_super_secret_key'
    ```
3.  **Run the Server:**
    ```bash
    ./bin/server
    ```
4.  **Access the Application:**
    *   Open your web browser and navigate to `http://localhost:8080`.

## ::CONCLUSION
This PoC demonstrates a streamlined 2-tier architecture using Haxe to target two platforms: a React frontend and a unified C++ backend. This model provides maximum security by isolating the API key in a compiled, native server while simplifying deployment and maintenance. The architecture leverages C++'s performance for both web serving and API gateway functionality, while the shared `domain` core demonstrates Haxe's power for creating highly reusable, cross-platform code. The UI follows the modern **Twisted Brain** design system for an engaging user experience.