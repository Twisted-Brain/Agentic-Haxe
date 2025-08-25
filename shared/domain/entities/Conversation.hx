package shared.domain.entities;

import shared.domain.entities.Message;

/**
 * Conversation entity representing a chat conversation
 */
class Conversation {
    public var id: String;
    public var title: String;
    public var userId: String;
    public var messages: Array<Message>;
    public var createdAt: Date;
    public var updatedAt: Date;
    
    public function new(id: String, title: String, userId: String, ?messages: Array<Message>, ?createdAt: Date, ?updatedAt: Date) {
        this.id = id;
        this.title = title;
        this.userId = userId;
        this.messages = messages != null ? messages : [];
        this.createdAt = createdAt != null ? createdAt : Date.now();
        this.updatedAt = updatedAt != null ? updatedAt : Date.now();
    }
    
    public function addMessage(message: Message): Void {
        this.messages.push(message);
        this.updatedAt = Date.now();
    }
    
    public function getLastMessage(): Null<Message> {
        return this.messages.length > 0 ? this.messages[this.messages.length - 1] : null;
    }
    
    public function getMessageCount(): Int {
        return this.messages.length;
    }
}