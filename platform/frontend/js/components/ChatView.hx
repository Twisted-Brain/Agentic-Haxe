package platform.frontend.js.components;

import react.ReactComponent;
import react.ReactMacro.jsx;
import domain.types.http.ApiModels.LlmRequest;

class ChatView extends ReactComponentOfProps<{}> {
    
    var state = {
        currentInput: "",
        chatHistory: []
    };

    function sendMessage() {
        var request:LlmRequest = new LlmRequest(this.state.currentInput);
        var xhr = new js.html.XMLHttpRequest();
        // Calls the Node.js server on port 8080
        xhr.open("POST", "http://localhost:8080/api/chat");
        xhr.setRequestHeader("Content-Type", "application/json");
        xhr.onreadystatechange = () -> {
            if (xhr.readyState == 4 && xhr.status == 200) {
                // handle response
            }
        }
        xhr.send(haxe.Json.stringify(request));
    }

    public function render() {
        return jsx('
            <div>
                <h1>Haxe Chat</h1>
                <div className="chat-history">
                    {this.state.chatHistory.map(message -> <p>{message}</p>)}
                </div>
                <input 
                    type="text" 
                    value={this.state.currentInput} 
                    onChange=${(e) -> this.setState({currentInput: e.target.value})} 
                />
                <button onClick=${(_) -> this.sendMessage()}>Send</button>
            </div>
        ');
    }
}