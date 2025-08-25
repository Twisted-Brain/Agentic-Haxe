![Haxe Multi-Platform Logo](/assets/logo.png)

# PoC 02: Python Gateway med Haxe Domain og React Frontend

## Overblik

Dette Proof of Concept (PoC) demonstrerer, hvordan Haxe muliggør genbrug af kerneforretningslogik (`/domain`) på tværs af forskellige backend-platforme. Her implementerer vi en **Python-server**, der fungerer som en gateway til OpenRouter LLM, mens vi genbruger den samme **React-frontend** og de samme **domænemodeller** som i de foregående PoC'er.

Formålet er at validere, at den hexagonale arkitektur tillader os at udskifte en kernekomponent (backend-sproget) med minimal indvirkning på resten af systemet.

### Kerne-principper
- **Genbrug af Domæne**: `/domain`-laget, der indeholder API-modeller og forretningslogik, kompileres fra Haxe til Python og genbruges fuldstændigt.
- **Genbrug af Frontend**: React-webapp'en fra tidligere PoC'er genbruges uden ændringer.
- **Platform-specifik Gateway**: En ny Python-gateway implementeres for at håndtere HTTP-requests og kommunikation med OpenRouter.

## Arkitektur

Arkitekturen følger `00-Haxe-AI-Chat-PoC.md` og består af tre primære lag:

1.  **Frontend (React)**: Brugergrænsefladen, kompileret fra Haxe til JavaScript. Den er identisk med den, der bruges i PoC 01.
2.  **Backend (Python Server)**: En letvægts Python-server (f.eks. med Flask eller FastAPI), der eksponerer et API.
3.  **Gateway (Python/Haxe)**: Den Python-specifikke logik, der kalder den kompilerede Haxe-domænekode og interagerer med OpenRouter API'en.

![Hexagonal Architecture with Python](/assets/hexagonal-python.png)

## Implementeringsdetaljer

### 1. Haxe Domain (`/domain`)

Kerneforretningslogikken forbliver i Haxe for at sikre maksimal genbrugbarhed.

```haxe
// /domain/models/ApiModels.hx (Genbruges 100%)
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

### 2. Python Gateway (`/platform/core/python`)

Dette er den nye, platform-specifikke komponent. Den importerer den Haxe-genererede Python-kode fra `/domain`.

```python
# /platform/core/python/python_gateway_server.py

from flask import Flask, request, jsonify
import os
import requests

# Importer den Haxe-genererede domænekode
from domain.models import LlmRequest, LlmResponse

app = Flask(__name__)

OPENROUTER_API_KEY = os.getenv("OPENROUTER_API_KEY")

@app.route("/api/chat", methods=["POST"])
def chat():
    # Valider request med Haxe-modellen
    haxe_request = LlmRequest(message=request.json["message"])

    # Kald OpenRouter
    response = requests.post(
        "https://openrouter.ai/api/v1/chat/completions",
        headers={"Authorization": f"Bearer {OPENROUTER_API_KEY}"},
        json={
            "model": "gpt-3.5-turbo",
            "messages": [{"role": "user", "content": haxe_request.message}]
        }
    )
    
    llm_content = response.json()["choices"][0]["message"]["content"]

    # Opret respons med Haxe-modellen
    haxe_response = LlmResponse(content=llm_content)
    
    return jsonify({"content": haxe_response.content})

if __name__ == "__main__":
    app.run(port=8081)
```

### 3. React Frontend (`/platform/frontend/js`)

Frontend-koden er uændret. Den fortsætter med at kommunikere via det samme API-endpoint.

```haxe
// /platform/frontend/js/WebApp.hx (Genbruges 100%)
package platform.frontend.js;

import react.ReactComponent;
import react.ReactMacro.jsx;

class WebApp extends ReactComponent {
    override function render() {
        return jsx('
            <div>
                <h1>Haxe + Python Chat</h1>
                // ... (samme UI som før)
            </div>
        ');
    }

    private function sendMessage(message:String):Void {
        // API-kaldet peger nu på Python-serveren
        js.Browser.window.fetch("http://localhost:8081/api/chat", {
            method: "POST",
            headers: {"Content-Type": "application/json"},
            body: haxe.Json.stringify({message: message})
        })
        .then(response -> response.json())
        .then(data -> {
            // Opdater UI med svar
        });
    }
}
```

## Build-konfiguration

### Haxe til Python (Domain)

```hxml
# /build-domain-python.hxml
-cp domain
-python platform/core/python/domain
-main domain.models.ApiModels 
```

### Haxe til JS (Frontend)

```hxml
# /build-frontend.hxml (Genbruges 100%)
-cp platform/frontend/js
-cp domain
-main platform.frontend.js.WebApp
-js www/app.js
-lib hx-react
```

## Kørsel og Test

1.  **Kompilér domænet til Python:**
    ```bash
    haxe build-domain-python.hxml
    ```

2.  **Kompilér frontend til JavaScript:**
    ```bash
    haxe build-frontend.hxml
    ```

3.  **Start Python-serveren:**
    ```bash
    export OPENROUTER_API_KEY="din-nøgle-her"
    python platform/core/python/python_gateway_server.py
    ```

4.  **Åbn `www/index.html` i en browser.**

Applikationen bør nu fungere som forventet, hvor React-frontend'en kommunikerer med Python-backend'en, der genbruger Haxe-domænelogikken.