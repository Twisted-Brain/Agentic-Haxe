![Haxe Multi-Platform Logo](../assets/logo.png)

# PoC 02: Haxe 2-Tier - React Frontend & Python Backend

## Related Documents
- [PoC 00: Haxe AI Chat PoC](00-Haxe-AI-Chat-PoC.md) - Base architecture and requirements
- [React UI Design](../docs/React-UI.md) - Twisted Brain design system and UI specifications

## Overview

This Proof of Concept (PoC) demonstrates how Haxe enables reuse of core business logic (`/domain`) across different backend platforms. Here we implement a **Python server** that functions as both web server and gateway to OpenRouter LLM, while reusing the same **React frontend** and **domain models** from previous PoCs.

The purpose is to validate that the hexagonal architecture allows us to replace a core component (backend language) with minimal impact on the rest of the system.

### Core Principles
- **Domain Reuse**: The `/domain` layer containing API models and business logic is compiled from Haxe to Python and reused completely
- **Frontend Reuse**: The React webapp from previous PoCs is reused without changes
- **Platform-specific Implementation**: A new Python backend is implemented to handle both HTTP requests and OpenRouter communication

## Architecture

The architecture follows the specifications in `00-Haxe-AI-Chat-PoC.md` and consists of two primary tiers:

1. **Frontend (React)**: User interface compiled from Haxe to JavaScript, implementing the Twisted Brain design system from `React-UI.md`
2. **Backend (Python Server)**: A unified Python server that handles both:
   - Static file serving for the React application
   - API endpoints and OpenRouter LLM gateway functionality
   - Domain logic compiled from Haxe to Python

### Twisted Brain Design System
The React frontend implements the modern AI chat interface specified in `React-UI.md`:
- **Theme Support**: Light/dark mode with neon accent colors (Magenta #FF49A8, Cyan #38E1FF, Violet #8A5BFF)
- **Logo Integration**: Twisted Brain logo with glow effects
- **Component Architecture**: Header, MessageList with virtual scrolling, and Composer with file attachment support

## Implementation Details

### 1. Haxe Domain (`/domain`)

Core business logic remains in Haxe to ensure maximum reusability across platforms.

```haxe
// /domain/models/ApiModels.hx (100% Reused)
package domain.models;

class LlmRequest {
    public var message:String;
    public function new(message:String) {
        this.message = message;
    }
}

class LlmResponse {
    public var content:String;
    public function new(content:String) {
        this.content = content;
    }
}
```

### 2. Python Backend Server (`/platform/core/python`)

This is the new, platform-specific component that serves both as web server and LLM gateway. It imports the Haxe-generated Python code from `/domain`.

```python
# /platform/core/python/python_backend_server.py

from flask import Flask, request, jsonify, send_from_directory
import os
import requests

# Import Haxe-generated domain code
from domain.models import LlmRequest, LlmResponse

app = Flask(__name__, static_folder='../../../www')

OPENROUTER_API_KEY = os.getenv("OPENROUTER_API_KEY")

# Serve React application
@app.route('/')
def serve_react_app():
    return send_from_directory(app.static_folder, 'index.html')

@app.route('/<path:path>')
def serve_static_files(path):
    return send_from_directory(app.static_folder, path)

# API endpoints
@app.route("/api/chat", methods=["POST"])
def chat():
    # Validate request with Haxe model
    haxe_request = LlmRequest(message=request.json["message"])

    # Call OpenRouter
    response = requests.post(
        "https://openrouter.ai/api/v1/chat/completions",
        headers={"Authorization": f"Bearer {OPENROUTER_API_KEY}"},
        json={
            "model": "gpt-3.5-turbo",
            "messages": [{"role": "user", "content": haxe_request.message}]
        }
    )
    
    llm_content = response.json()["choices"][0]["message"]["content"]

    # Create response with Haxe model
    haxe_response = LlmResponse(content=llm_content)
    
    return jsonify({"content": haxe_response.content})

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080, debug=True)
```

### 3. React Frontend (`/platform/frontend/js`)

The frontend code is unchanged and implements the Twisted Brain design system. It continues to communicate via the same API endpoints.

```haxe
// /platform/frontend/js/WebApp.hx (100% Reused)
package platform.frontend.js;

import react.ReactComponent;
import react.ReactMacro.jsx;

class WebApp extends ReactComponent {
    override function render() {
        return jsx('
            <div className="twisted-brain-app">
                <Header logo="/assets/logo.png" title="Haxe + Python Chat" />
                <MessageList messages={messages} />
                <Composer onSend={sendMessage} />
            </div>
        ');
    }

    private function sendMessage(message:String):Void {
        // API call to Python backend server
        js.Browser.window.fetch("/api/chat", {
            method: "POST",
            headers: {"Content-Type": "application/json"},
            body: haxe.Json.stringify({message: message})
        })
        .then(response -> response.json())
        .then(data -> {
            // Update UI with response
            updateMessages(data.content);
        });
    }
}
```

## Build Configuration

### Haxe to Python (Domain)

```hxml
# /build-domain-python.hxml
-cp domain
-python platform/core/python/domain
-main domain.models.ApiModels
```

### Haxe to JavaScript (Frontend)

```hxml
# /build-frontend.hxml (100% Reused)
-cp platform/frontend/js
-cp domain
-main platform.frontend.js.WebApp
-js www/dist/bundle.js
-lib hx-react
```

### Python Dependencies

```txt
# /platform/core/python/requirements.txt
Flask==2.3.3
requests==2.31.0
flask-cors==4.0.0
```

## Deployment and Testing

### Development Setup

1. **Compile domain to Python:**
   ```bash
   haxe build-domain-python.hxml
   ```

2. **Compile frontend to JavaScript:**
   ```bash
   haxe build-frontend.hxml
   ```

3. **Install Python dependencies:**
   ```bash
   cd platform/core/python
   pip install -r requirements.txt
   ```

4. **Start the Python backend server:**
   ```bash
   export OPENROUTER_API_KEY="your-key-here"
   python platform/core/python/python_backend_server.py
   ```

5. **Access the application:**
   Open your browser and navigate to `http://localhost:8080`

### Production Deployment

For production deployment, consider using:
- **WSGI Server**: Gunicorn or uWSGI for better performance
- **Reverse Proxy**: Nginx for static file serving and load balancing
- **Environment Variables**: Secure API key management
- **Process Management**: systemd or supervisor for service management

```bash
# Example production startup with Gunicorn
gunicorn --bind 0.0.0.0:8080 --workers 4 python_backend_server:app
```

## Key Benefits

- **Simplified Architecture**: Single Python server handles both frontend serving and API endpoints
- **Code Reuse**: Domain logic compiled from Haxe ensures consistency across platforms
- **Easy Deployment**: Single server process reduces operational complexity
- **Development Efficiency**: Familiar Python ecosystem with Flask framework
- **Scalability**: Can be easily containerized and scaled horizontally

The application now functions as expected, with the React frontend communicating with the Python backend that reuses Haxe domain logic, demonstrating the flexibility and reusability of the hexagonal architecture pattern.

<div align="right">
  <img src="../assets/hdevm.png" alt="HDevelop & M" width="150" height="150">
</div>