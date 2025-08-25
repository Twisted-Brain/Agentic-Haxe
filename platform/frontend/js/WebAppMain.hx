package frontend;

import js.html.Document;
import js.html.Element;
import js.html.InputElement;
import js.html.TextAreaElement;
import js.html.ButtonElement;
import js.html.DivElement;
import js.Browser;
import domain.core.AiModel;
import domain.core.Conversation;
import wiring.ApplicationBootstrap;
import wiring.DependencyContainer;
using StringTools;

class WebAppMain {
    private var chatContainer: DivElement;
    private var messageInput: InputElement;
    private var sendButton: ButtonElement;
    private var responseArea: TextAreaElement;
    
    public static function main(): Void {
        new WebAppMain();
    }
    
    public function new() {
        Browser.document.addEventListener("DOMContentLoaded", initializeWebApp);
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
        cast(messageDiv, js.html.HtmlElement).className = "chat-message";
        messageDiv.innerHTML = '<strong>$sender:</strong> $message';
        chatContainer.appendChild(messageDiv);
        chatContainer.scrollTop = chatContainer.scrollHeight;
    }
    
    private function sendToLlmGateway(message: String): Void {
        // This will connect to the C++ backend gateway
        var request = new LlmRequest(message, "gpt-3.5-turbo");
        
        // For now, simulate response
        haxe.Timer.delay(function() {
            var simulatedResponse = "This is a simulated response from the LLM gateway. Message received: " + message;
            addMessageToChat("LLM", simulatedResponse);
            responseArea.value = simulatedResponse;
        }, 1000);
    }
}