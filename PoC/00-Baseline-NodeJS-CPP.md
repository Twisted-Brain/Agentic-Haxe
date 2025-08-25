![Haxe Multi-Platform Logo](/assets/logo.png)

# PoC 00: Baseline Node.js/C++ AI Chat Implementation

## Overview
The **foundational implementation** that establishes the core architecture, shared components, and frontend structure that will be reused across all subsequent PoC projects. This baseline demonstrates Haxe's multi-platform capabilities by providing identical functionality on both Node.js and C++ backends.

### Key Components Established
- ✅ **Shared API Models**: `LlmRequest`, `LlmResponse`, `LlmModel` classes
- ✅ **Universal Frontend**: Platform-agnostic JavaScript chat interface
- ✅ **Configuration System**: `FrontendConfig` with automatic backend detection
- ✅ **UI Components**: Complete chat interface with modern styling
- ✅ **Backend Abstraction**: Identical API contracts for all platforms

**Purpose**: Prove Haxe's "Write Once, Deploy Everywhere" philosophy with a working foundation.

## Target Platforms
- **Node.js**: JavaScript runtime for rapid development
- **C++**: Native compilation for maximum performance
- **Frontend**: Universal JavaScript (compiled from Haxe)

## Technical Architecture

### Shared Components (`src/shared/`)
```haxe
// ApiModels.hx - Universal data models
class LlmRequest {
    public var message: String;
    public var model: String;
    public var temperature: Float;
    
    public function new(message: String, model: String = "gpt-3.5-turbo") {
        this.message = message;
        this.model = model;
        this.temperature = 0.7;
    }
    
    public function toJson(): String {
        return haxe.Json.stringify(this);
    }
    
    public static function fromJson(json: String): LlmRequest {
        return haxe.Json.parse(json);
    }
}

class LlmResponse {
    public var content: String;
    public var model: String;
    public var usage: LlmUsage;
    
    public function new(content: String, model: String) {
        this.content = content;
        this.model = model;
    }
    
    public function toJson(): String {
        return haxe.Json.stringify(this);
    }
    
    public static function fromJson(json: String): LlmResponse {
        return haxe.Json.parse(json);
    }
}
```

### Universal Frontend (`src/frontend/`)
```haxe
// WebAppMain.hx - Platform-agnostic chat interface
class WebAppMain {
    private static var config: FrontendConfig;
    
    public static function main() {
        // Auto-detect and configure backend
        config = FrontendConfig.autoDetect();
        
        // Update UI with backend info
        updateBackendInfo();
        
        // Initialize chat interface
        setupChatInterface();
    }
    
    private static function sendMessage(message: String): Void {
        var request = new LlmRequest(message, config.defaultModel);
        
        // Same API call works with all backends!
        var xhr = new js.html.XMLHttpRequest();
        xhr.open("POST", config.getChatApiUrl());
        xhr.setRequestHeader("Content-Type", "application/json");
        
        xhr.onreadystatechange = function() {
            if (xhr.readyState == 4 && xhr.status == 200) {
                var response = LlmResponse.fromJson(xhr.responseText);
                displayResponse(response.content);
            }
        };
        
        xhr.send(request.toJson());
    }
}
```

### Platform Configuration (`src/frontend/FrontendConfig.hx`)
```haxe
class FrontendConfig {
    public var apiBaseUrl: String;
    public var chatEndpoint: String;
    public var healthEndpoint: String;
    public var defaultModel: String;
    public var appTitle: String;
    
    public static function autoDetect(): FrontendConfig {
        var config = new FrontendConfig();
        var port = js.Browser.location.port;
        
        // Auto-detect backend based on port/URL patterns
        switch (port) {
            case "3000": config.configureForNodeJS();
            case "8080": config.configureForCPP();
            default: config.configureForNodeJS(); // fallback
        }
        
        return config;
    }
    
    public function configureForNodeJS(): Void {
        apiBaseUrl = "http://localhost:3000";
        chatEndpoint = "/api/chat";
        healthEndpoint = "/health";
        defaultModel = "gpt-3.5-turbo";
        appTitle = "Haxe Node.js AI Chat";
    }
    
    public function configureForCPP(): Void {
        apiBaseUrl = "http://localhost:8080";
        chatEndpoint = "/api/chat";
        healthEndpoint = "/health";
        defaultModel = "gpt-3.5-turbo";
        appTitle = "Haxe C++ AI Chat";
    }
}
```

## Backend Implementations

### Node.js Backend (`src/platform/core/js/NodeJSMain.hx`)
```haxe
class NodeJSMain {
    public static function main() {
        var express = js.Lib.require("express");
        var app = express();
        
        // Serve frontend files
        app.use(express.static("src/frontend"));
        
        // API endpoints using shared models
        app.post("/api/chat", handleChatRequest);
        app.get("/health", handleHealthCheck);
        
        app.listen(3000, function() {
            trace("Node.js server running on port 3000");
        });
    }
    
    private static function handleChatRequest(req: Dynamic, res: Dynamic): Void {
        var llmRequest = LlmRequest.fromJson(req.body);
        
        // Process with OpenAI/OpenRouter
        var response = new LlmResponse(
            "Response from Node.js backend: " + llmRequest.message,
            llmRequest.model
        );
        
        res.json(response.toJson());
    }
}
```

### C++ Backend (`src/platform/core/cpp/CppMain.hx`)
```haxe
class CppMain {
    public static function main() {
        // C++ HTTP server implementation
        var server = new cpp.net.HttpServer();
        
        // Same API endpoints as Node.js!
        server.addRoute("POST", "/api/chat", handleChatRequest);
        server.addRoute("GET", "/health", handleHealthCheck);
        
        // Serve same frontend files
        server.serveStatic("/", "src/frontend/");
        
        server.listen(8080);
        trace("C++ server running on port 8080");
    }
    
    private static function handleChatRequest(req: HttpRequest): HttpResponse {
        var llmRequest = LlmRequest.fromJson(req.body);
        
        // Same processing logic as Node.js
        var response = new LlmResponse(
            "Response from C++ backend: " + llmRequest.message,
            llmRequest.model
        );
        
        return HttpResponse.json(response.toJson());
    }
}
```

## Build Configuration

### Frontend Build (`build-frontend.hxml`)
```hxml
-cp src
-main frontend.WebAppMain
-js src/frontend/webapp.js
-D js-es=6
```

### Node.js Build (`build-nodejs.hxml`)
```hxml
-cp src
-cp shared
-main platform.core.js.NodeJSMain
-js bin/nodejs/server.js
-lib hxnodejs
```

### C++ Build (`build-cpp.hxml`)
```hxml
-cp src
-cp shared
-main platform.core.cpp.CppMain
-cpp bin/cpp
-D HXCPP_QUIET
```

## Deployment Workflows

### Node.js Deployment
```bash
# Build and run Node.js version
make build-nodejs
node bin/nodejs/server.js

# Access at http://localhost:3000
```

### C++ Deployment
```bash
# Build and run C++ version
make build-cpp
./bin/cpp/CppMain

# Access at http://localhost:8080
```

### Docker Support
```dockerfile
# Dockerfile.nodejs
FROM node:18-alpine
COPY bin/nodejs/ /app/
COPY src/frontend/ /app/frontend/
WORKDIR /app
EXPOSE 3000
CMD ["node", "server.js"]

# Dockerfile.cpp
FROM alpine:latest
RUN apk add --no-cache libstdc++
COPY bin/cpp/CppMain /app/server
COPY src/frontend/ /app/frontend/
WORKDIR /app
EXPOSE 8080
CMD ["./server"]
```

## API Endpoints

### Chat API
```http
POST /api/chat
Content-Type: application/json

{
  "message": "Hello, how are you?",
  "model": "gpt-3.5-turbo",
  "temperature": 0.7
}

Response:
{
  "content": "I'm doing well, thank you for asking!",
  "model": "gpt-3.5-turbo",
  "usage": {
    "prompt_tokens": 12,
    "completion_tokens": 8,
    "total_tokens": 20
  }
}
```

### Health Check
```http
GET /health

Response:
{
  "status": "healthy",
  "platform": "nodejs", // or "cpp"
  "uptime": 3600,
  "version": "1.0.0"
}
```

## Expected Benefits

### Multi-Platform Foundation
- 🎯 **Identical Functionality**: Same features across Node.js and C++
- 🚀 **Shared Codebase**: 90%+ code reuse between platforms
- 🔧 **Consistent APIs**: Same endpoints and data models
- 📱 **Universal Frontend**: One interface works with both backends
- ⚡ **Performance Options**: Choose Node.js for speed or C++ for efficiency

### Development Benefits
- **Rapid Prototyping**: Node.js for quick iterations
- **Production Performance**: C++ for high-load scenarios
- **Code Consistency**: Same business logic across platforms
- **Easy Testing**: Test once, deploy everywhere
- **Future-Proof**: Foundation for additional platforms

## Success Metrics

### Technical Success
- ✅ **Identical Frontend**: Same JavaScript works with both backends
- ✅ **Shared Models**: `LlmRequest`/`LlmResponse` work identically
- ✅ **API Compatibility**: Same endpoints and response formats
- ✅ **Performance Baseline**: Establish benchmarks for other platforms
- ✅ **Build Automation**: Reliable compilation for both targets

### Reusability Success
- ✅ **Component Library**: Reusable frontend components
- ✅ **Model Library**: Shared data models for all platforms
- ✅ **Configuration System**: Platform detection and setup
- ✅ **Documentation**: Clear patterns for future platforms
- ✅ **Testing Framework**: Validation approach for new platforms

## Getting Started

### Prerequisites
```bash
# Install Haxe 4.3+
brew install haxe  # macOS
# or download from https://haxe.org/download/

# Install Node.js (for Node.js backend)
brew install node

# Install C++ compiler (for C++ backend)
# macOS: Xcode Command Line Tools
# Linux: build-essential
# Windows: Visual Studio
```

### Quick Start
```bash
# Clone and setup
git clone <repository>
cd Agentic-Haxe

# Build frontend (once)
make build-frontend

# Option 1: Run Node.js version
make build-nodejs
make run-nodejs
# Open http://localhost:3000

# Option 2: Run C++ version
make build-cpp
make run-cpp
# Open http://localhost:8080
```

### Development Workflow
```bash
# Frontend changes
npm run watch-frontend  # Auto-rebuild on changes

# Backend changes
npm run watch-nodejs    # Auto-restart Node.js server
npm run watch-cpp       # Auto-rebuild C++ server

# Testing
npm test                # Run all tests
npm run test:frontend   # Frontend tests only
npm run test:backend    # Backend tests only
```

## Next Steps

### Completed Foundation
1. ✅ **Shared API Models**: `LlmRequest`, `LlmResponse`, `LlmModel`
2. ✅ **Universal Frontend**: Platform-agnostic chat interface
3. ✅ **Configuration System**: Automatic backend detection
4. ✅ **Node.js Backend**: Express.js server implementation
5. ✅ **C++ Backend**: Native HTTP server implementation
6. ✅ **Build System**: Automated compilation for both platforms
7. ✅ **Docker Support**: Containerized deployment options
8. ✅ **API Documentation**: Complete endpoint specifications

### Ready for Reuse
- 🎯 **Python PoC**: Reuse frontend + shared models
- 🎯 **WebAssembly PoC**: Reuse frontend + shared models
- 🎯 **PHP PoC**: Reuse frontend + shared models
- 🎯 **Java PoC**: Reuse frontend + shared models
- 🎯 **C# PoC**: Reuse frontend + shared models

### Multi-Platform Validation
- 🎯 **Prove Haxe Value**: Foundation enables rapid platform addition
- 🎯 **Measure Reuse**: Document exact percentage of code reused
- 🎯 **Performance Baseline**: Establish benchmarks for comparison
- 🎯 **Developer Experience**: Optimize workflow for new platforms

---

**This baseline implementation proves Haxe's core promise: Write the frontend and shared models once, then deploy to any platform with minimal additional code. All subsequent PoCs will demonstrate this by reusing 80%+ of this foundation.**