package domain.core;

/**
 * Shared Conversation entity that represents a conversation with an AI model
 * Used across all targets for consistent conversation management
 */
class Conversation {
    public var id: String;
    public var title: String;
    public var modelId: String;
    public var messages: Array<ConversationMessage>;
    public var createdAt: Float;
    public var updatedAt: Float;
    public var isActive: Bool;
    public var metadata: Map<String, String>;
    
    public function new(
        id: String,
        title: String,
        modelId: String,
        ?messages: Array<ConversationMessage>
    ) {
        this.id = id;
        this.title = title;
        this.modelId = modelId;
        this.messages = messages != null ? messages : [];
        this.createdAt = Date.now().getTime();
        this.updatedAt = Date.now().getTime();
        this.isActive = true;
        this.metadata = new Map<String, String>();
    }
    
    public function addMessage(role: MessageRole, content: String, ?timestamp: Float): ConversationMessage {
        var message = new ConversationMessage(
            generateMessageId(),
            role,
            content,
            timestamp != null ? timestamp : Date.now().getTime()
        );
        this.messages.push(message);
        this.updatedAt = Date.now().getTime();
        return message;
    }
    
    public function addUserMessage(content: String): ConversationMessage {
        return addMessage(MessageRole.User, content);
    }
    
    public function addAssistantMessage(content: String): ConversationMessage {
        return addMessage(MessageRole.Assistant, content);
    }
    
    public function addSystemMessage(content: String): ConversationMessage {
        return addMessage(MessageRole.System, content);
    }
    
    public function getLastMessage(): ConversationMessage {
        return this.messages.length > 0 ? this.messages[this.messages.length - 1] : null;
    }
    
    public function getMessagesByRole(role: MessageRole): Array<ConversationMessage> {
        return this.messages.filter(msg -> msg.role == role);
    }
    
    public function updateTitle(newTitle: String): Void {
        this.title = newTitle;
        this.updatedAt = Date.now().getTime();
    }
    
    public function setMetadata(key: String, value: String): Void {
        this.metadata.set(key, value);
        this.updatedAt = Date.now().getTime();
    }
    
    public function getMetadata(key: String): String {
        return this.metadata.get(key);
    }
    
    public function archive(): Void {
        this.isActive = false;
        this.updatedAt = Date.now().getTime();
    }
    
    public function restore(): Void {
        this.isActive = true;
        this.updatedAt = Date.now().getTime();
    }
    
    public function getMessageCount(): Int {
        return this.messages.length;
    }
    
    public function getTotalTokenCount(): Int {
        // Rough estimation: 4 characters per token
        var totalChars = 0;
        for (message in this.messages) {
            totalChars += message.content.length;
        }
        return Math.ceil(totalChars / 4);
    }
    
    private function generateMessageId(): String {
        return "msg_" + Std.string(Date.now().getTime()) + "_" + Std.string(Math.floor(Math.random() * 1000));
    }
    
    public function toJson(): Dynamic {
        return {
            id: this.id,
            title: this.title,
            modelId: this.modelId,
            messages: this.messages.map(msg -> msg.toJson()),
            createdAt: this.createdAt,
            updatedAt: this.updatedAt,
            isActive: this.isActive,
            metadata: [for (key in this.metadata.keys()) key => this.metadata.get(key)]
        };
    }
    
    public static function fromJson(data: Dynamic): Conversation {
        var conversation = new Conversation(
            data.id,
            data.title,
            data.modelId
        );
        
        if (data.messages != null) {
            conversation.messages = [for (msgData in cast(data.messages, Array<Dynamic>)) ConversationMessage.fromJson(msgData)];
        }
        
        conversation.createdAt = data.createdAt;
        conversation.updatedAt = data.updatedAt;
        conversation.isActive = data.isActive;
        
        if (data.metadata != null) {
            for (field in Reflect.fields(data.metadata)) {
                conversation.metadata.set(field, Reflect.field(data.metadata, field));
            }
        }
        
        return conversation;
    }
}

/**
 * Message role enumeration
 */
enum MessageRole {
    System;
    User;
    Assistant;
}

/**
 * Individual conversation message
 */
class ConversationMessage {
    public var id: String;
    public var role: MessageRole;
    public var content: String;
    public var timestamp: Float;
    public var metadata: Map<String, String>;
    
    public function new(id: String, role: MessageRole, content: String, timestamp: Float) {
        this.id = id;
        this.role = role;
        this.content = content;
        this.timestamp = timestamp;
        this.metadata = new Map<String, String>();
    }
    
    public function setMetadata(key: String, value: String): Void {
        this.metadata.set(key, value);
    }
    
    public function getMetadata(key: String): String {
        return this.metadata.get(key);
    }
    
    public function toJson(): Dynamic {
        return {
            id: this.id,
            role: switch (this.role) {
                case MessageRole.System: "system";
                case MessageRole.User: "user";
                case MessageRole.Assistant: "assistant";
            },
            content: this.content,
            timestamp: this.timestamp,
            metadata: [for (key in this.metadata.keys()) key => this.metadata.get(key)]
        };
    }
    
    public static function fromJson(data: Dynamic): ConversationMessage {
        var role = switch (data.role) {
            case "system": MessageRole.System;
            case "user": MessageRole.User;
            case "assistant": MessageRole.Assistant;
            default: MessageRole.User;
        };
        
        var message = new ConversationMessage(
            data.id,
            role,
            data.content,
            data.timestamp
        );
        
        if (data.metadata != null) {
            for (field in Reflect.fields(data.metadata)) {
                message.metadata.set(field, Reflect.field(data.metadata, field));
            }
        }
        
        return message;
    }
}