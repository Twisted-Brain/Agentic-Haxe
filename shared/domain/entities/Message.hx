package shared.domain.entities;

/**
 * Message entity representing a single message in a conversation
 */
class Message {
    public var id: String;
    public var conversationId: String;
    public var content: String;
    public var role: MessageRole;
    public var timestamp: Date;
    public var metadata: Dynamic;
    
    public function new(id: String, conversationId: String, content: String, role: MessageRole, ?timestamp: Date, ?metadata: Dynamic) {
        this.id = id;
        this.conversationId = conversationId;
        this.content = content;
        this.role = role;
        this.timestamp = timestamp != null ? timestamp : Date.now();
        this.metadata = metadata;
    }
    
    public function isFromUser(): Bool {
        return this.role == MessageRole.User;
    }
    
    public function isFromAssistant(): Bool {
        return this.role == MessageRole.Assistant;
    }
    
    public function isSystemMessage(): Bool {
        return this.role == MessageRole.System;
    }
}

/**
 * Enum representing the role of a message sender
 */
enum MessageRole {
    User;
    Assistant;
    System;
}