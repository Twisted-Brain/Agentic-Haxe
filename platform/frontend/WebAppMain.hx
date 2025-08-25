package platform.frontend;

import js.html.Document;
import js.html.Element;
import js.html.InputElement;
import js.html.TextAreaElement;
import js.html.ButtonElement;
import js.html.DivElement;
import js.Browser;
import wiring.ApiModels.LlmRequest;
using StringTools;

class WebAppMain {
    private var chatContainer: DivElement;
    private var messageInput: InputElement;
    private var sendButton: ButtonElement;
    private var responseArea: TextAreaElement;
    private var apiBaseUrl: String;
    
    public static function main(): Void {
        new WebAppMain();
    }
    
    public function new() {
        // Auto-detect backend based on port
        apiBaseUrl = detectBackendUrl();
        Browser.document.addEventListener("DOMContentLoaded", initializeWebApp);
    }
    
    private function detectBackendUrl(): String {
        var port = Browser.location.port;
        return switch (port) {
            case "3000": "http://localhost:3000"; // Node.js
            case "8080": "http://localhost:8080"; // Python/C++
            default: "http://localhost:3000"; // Default to Node.js
        };
    }
    
    private function initializeWebApp(): Void {
        createUserInterface();
        setupEventListeners();
        trace("Haxe WebApp initialized successfully");
    }
    
    private function createUserInterface(): Void {
        var body = Browser.document.body;
        
        // Main container
        var mainContainer = Browser.document.createDivElement();
        mainContainer.className = "webapp-container";
        
        // Title
        var title = Browser.document.createElement("h1");
        title.textContent = "Haxe LLM Gateway WebApp";
        title.className = "webapp-title";
        
        // Chat container
        chatContainer = Browser.document.createDivElement();
        chatContainer.className = "chat-container";
        
        // Input section
        var inputSection = Browser.document.createDivElement();
        inputSection.className = "input-section";
        
        messageInput = Browser.document.createInputElement();
        messageInput.type = "text";
        messageInput.placeholder = "Enter your message...";
        messageInput.className = "message-input";
        
        sendButton = Browser.document.createButtonElement();
        sendButton.textContent = "Send";
        sendButton.className = "send-button";
        
        // Response area
        responseArea = Browser.document.createTextAreaElement();
        responseArea.placeholder = "LLM response will appear here...";
        responseArea.className = "response-area";
        responseArea.readOnly = true;
        
        // Assemble UI
        inputSection.appendChild(messageInput);
        inputSection.appendChild(sendButton);
        
        mainContainer.appendChild(title);
        mainContainer.appendChild(chatContainer);
        mainContainer.appendChild(inputSection);
        mainContainer.appendChild(responseArea);
        
        body.appendChild(mainContainer);
    }
    
    private function setupEventListeners(): Void {
        sendButton.addEventListener("click", handleSendMessage);
        messageInput.addEventListener("keypress", function(event) {
            if (event.key == "Enter") {
                handleSendMessage();
            }
        });
    }
    
    private function handleSendMessage(): Void {
        var message = StringTools.trim(messageInput.value);
        if (message.length == 0) return;
        
        addMessageToChat("User", message);
        messageInput.value = "";
        
        // Simulate API call to backend
        sendToLlmGateway(message);
    }
    
    private function addMessageToChat(sender: String, message: String): Void {
        var messageDiv = Browser.document.createDivElement();
        messageDiv.className = "chat-message";
        messageDiv.innerHTML = '<strong>$sender:</strong> $message';
        chatContainer.appendChild(messageDiv);
        chatContainer.scrollTop = chatContainer.scrollHeight;
    }
    
    private function sendToLlmGateway(message: String): Void {
        var request = new LlmRequest(message, "gpt-3.5-turbo");
        
        var xhr = new js.html.XMLHttpRequest();
        xhr.open("POST", apiBaseUrl + "/api/chat");
        xhr.setRequestHeader("Content-Type", "application/json");
        
        xhr.onreadystatechange = function() {
            if (xhr.readyState == 4) {
                if (xhr.status == 200) {
                    try {
                        var response = haxe.Json.parse(xhr.responseText);
                        var content = response.content != null ? response.content : "No response content";
                        addMessageToChat("LLM", content);
                        responseArea.value = content;
                    } catch (e: Dynamic) {
                        var errorMsg = "Error parsing response: " + xhr.responseText;
                        addMessageToChat("Error", errorMsg);
                        responseArea.value = errorMsg;
                    }
                } else {
                    var errorMsg = "HTTP Error " + xhr.status + ": " + xhr.statusText;
                    addMessageToChat("Error", errorMsg);
                    responseArea.value = errorMsg;
                }
            }
        };
        
        xhr.send(haxe.Json.stringify(request));
    }
}