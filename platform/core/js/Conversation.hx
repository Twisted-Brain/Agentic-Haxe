package core.js;

import shared.domain.types.core.Result;
import shared.domain.types.core.Option;
import shared.domain.types.core.Validation;

/**
 * Conversation entity representing a chat conversation in the system
 * This is a core domain entity with business logic and validation
 */
class Conversation {
    public var id(default, null): String;
    public var title(default, null): Option<String>;
    public var userId(default, null): Option<String>;
    public var messages(default, null): Array<Message>;
    public var isArchived(default, null): Bool;
    public var tags(default, null): Array<String>;
    public var metadata(default, null): Map<String, Dynamic>;
    
    private var _createdAt: Float;
    private var _updatedAt: Float;
    private var _version: Int;
    
    public function new(
        id: String,
        ?title: Option<String>,
        ?userId: Option<String>,
        ?messages: Array<Message>,
        ?tags: Array<String>,
        ?metadata: Map<String, Dynamic>
    ) {
        this.id = id;
        this.title = title != null ? title : Option.none();
        this.userId = userId != null ? userId : Option.none();
        this.messages = messages != null ? messages : [];
        this.isArchived = false;
        this.tags = tags != null ? tags : [];
        this.metadata = metadata != null ? metadata : new Map<String, Dynamic>();
        this._createdAt = Date.now().getTime();
        this._updatedAt = this._createdAt;
        this._version = 1;
    }
    
    /**
     * Validate conversation
     */
    public function validate(): Validation<Conversation, String> {
        var errors = new Array<String>();
        
        if (id == null || id.length == 0) {
            errors.push("Conversation ID cannot be empty");
        }
        
        // Validate all messages
        for (i in 0...messages.length) {
            var messageValidation = messages[i].validate();
            if (messageValidation.isFailure()) {
                switch (messageValidation) {
                    case Failure(msgErrors): 
                        for (error in msgErrors) {
                            errors.push('Message $i: $error');
                        }
                    case Success(_): // Should not happen
                }
            }
        }
        
        return errors.length > 0 ? Validation.failure(errors) : Validation.success(this);
    }
    
    /**
     * Add a message to the conversation
     */
    public function addMessage(message: Message): Result<Void, String> {
        var validation = message.validate();
        return switch (validation) {
            case Success(_):
                messages.push(message);
                _updatedAt = Date.now().getTime();
                _version++;
                Result.ok(null);
            case Failure(errors):
                Result.err("Invalid message: " + errors.join(", "));
        };
    }
    
    /**
     * Remove a message by ID
     */
    public function removeMessage(messageId: String): Bool {
        var index = -1;
        for (i in 0...messages.length) {
            if (messages[i].id == messageId) {
                index = i;
                break;
            }
        }
        
        if (index != -1) {
            messages.splice(index, 1);
            _updatedAt = Date.now().getTime();
            _version++;
            return true;
        }
        return false;
    }
    
    /**
     * Get message by ID
     */
    public function getMessage(messageId: String): Option<Message> {
        for (message in messages) {
            if (message.id == messageId) {
                return Option.some(message);
            }
        }
        return Option.none();
    }
    
    /**
     * Get messages by role
     */
    public function getMessagesByRole(role: MessageRole): Array<Message> {
        return messages.filter(function(msg) return msg.role == role);
    }
    
    /**
     * Get last message
     */
    public function getLastMessage(): Option<Message> {
        return messages.length > 0 ? Option.some(messages[messages.length - 1]) : Option.none();
    }
    
    /**
     * Get message count
     */
    public function getMessageCount(): Int {
        return messages.length;
    }
    
    /**
     * Get total token count (if available in metadata)
     */
    public function getTotalTokens(): Option<Int> {
        var total = 0;
        var hasTokens = false;
        
        for (message in messages) {
            switch (message.getTokenCount()) {
                case Some(tokens):
                    total += tokens;
                    hasTokens = true;
                case None:
            }
        }
        
        return hasTokens ? Option.some(total) : Option.none();
    }
    
    /**
     * Set conversation title
     */
    public function setTitle(newTitle: String): Void {
        this.title = Option.some(newTitle);
        _updatedAt = Date.now().getTime();
        _version++;
    }
    
    /**
     * Clear conversation title
     */
    public function clearTitle(): Void {
        this.title = Option.none();
        _updatedAt = Date.now().getTime();
        _version++;
    }
    
    /**
     * Archive conversation
     */
    public function archive(): Void {
        this.isArchived = true;
        _updatedAt = Date.now().getTime();
        _version++;
    }
    
    /**
     * Unarchive conversation
     */
    public function unarchive(): Void {
        this.isArchived = false;
        _updatedAt = Date.now().getTime();
        _version++;
    }
    
    /**
     * Add tag
     */
    public function addTag(tag: String): Bool {
        if (tags.indexOf(tag) == -1) {
            tags.push(tag);
            _updatedAt = Date.now().getTime();
            _version++;
            return true;
        }
        return false;
    }
    
    /**
     * Remove tag
     */
    public function removeTag(tag: String): Bool {
        var index = tags.indexOf(tag);
        if (index != -1) {
            tags.splice(index, 1);
            _updatedAt = Date.now().getTime();
            _version++;
            return true;
        }
        return false;
    }
    
    /**
     * Check if conversation has tag
     */
    public function hasTag(tag: String): Bool {
        return tags.indexOf(tag) != -1;
    }
    
    /**
     * Update metadata
     */
    public function updateMetadata(key: String, value: Dynamic): Void {
        metadata.set(key, value);
        _updatedAt = Date.now().getTime();
        _version++;
    }
    
    /**
     * Get metadata value
     */
    public function getMetadata(key: String): Option<Dynamic> {
        return metadata.exists(key) ? Option.some(metadata.get(key)) : Option.none();
    }
    
    /**
     * Get conversation summary
     */
    public function getSummary(maxLength: Int = 100): String {
        switch (getLastMessage()) {
            case Some(lastMsg):
                var content = lastMsg.content;
                return content.length > maxLength ? content.substr(0, maxLength) + "..." : content;
            case None:
                return "Empty conversation";
        }
    }
    
    /**
     * Export conversation to text format
     */
    public function exportToText(): String {
        var lines = new Array<String>();
        
        switch (title) {
            case Some(t): lines.push('Title: $t');
            case None:
        }
        
        lines.push('Created: ${Date.fromTime(_createdAt).toString()}');
        lines.push('Messages: ${messages.length}');
        lines.push('');
        
        for (message in messages) {
            var roleStr = switch (message.role) {
                case User: "User";
                case Assistant: "Assistant";
                case System: "System";
            };
            lines.push('[$roleStr]: ${message.content}');
            lines.push('');
        }
        
        return lines.join("\n");
    }
    
    /**
     * Get conversation age in milliseconds
     */
    public function getAge(): Float {
        return Date.now().getTime() - _createdAt;
    }
    
    /**
     * Get time since last update in milliseconds
     */
    public function getTimeSinceUpdate(): Float {
        return Date.now().getTime() - _updatedAt;
    }
    
    /**
     * Get current version
     */
    public function getVersion(): Int {
        return _version;
    }
    
    /**
     * Get creation timestamp
     */
    public function getCreatedAt(): Float {
        return _createdAt;
    }
    
    /**
     * Get last update timestamp
     */
    public function getUpdatedAt(): Float {
        return _updatedAt;
    }
    
    /**
     * Convert to string representation
     */
    public function toString(): String {
        var titleStr = switch (title) {
            case Some(t): t;
            case None: "Untitled";
        };
        return 'Conversation(id=$id, title=$titleStr, messages=${messages.length}, archived=$isArchived)';
    }
}

/**
 * Message entity representing a single message in a conversation
 */
class Message {
    public var id(default, null): String;
    public var conversationId(default, null): String;
    public var role(default, null): MessageRole;
    public var content(default, null): String;
    public var metadata(default, null): Map<String, Dynamic>;
    
    private var _createdAt: Float;
    private var _version: Int;
    
    public function new(
        id: String,
        conversationId: String,
        role: MessageRole,
        content: String,
        ?metadata: Map<String, Dynamic>
    ) {
        this.id = id;
        this.conversationId = conversationId;
        this.role = role;
        this.content = content;
        this.metadata = metadata != null ? metadata : new Map<String, Dynamic>();
        this._createdAt = Date.now().getTime();
        this._version = 1;
    }
    
    /**
     * Validate message
     */
    public function validate(): Validation<Message, String> {
        var errors = new Array<String>();
        
        if (id == null || id.length == 0) {
            errors.push("Message ID cannot be empty");
        }
        
        if (conversationId == null || conversationId.length == 0) {
            errors.push("Conversation ID cannot be empty");
        }
        
        if (content == null || content.length == 0) {
            errors.push("Message content cannot be empty");
        }
        
        return errors.length > 0 ? Validation.failure(errors) : Validation.success(this);
    }
    
    /**
     * Get token count from metadata
     */
    public function getTokenCount(): Option<Int> {
        return metadata.exists("tokens") ? Option.some(metadata.get("tokens")) : Option.none();
    }
    
    /**
     * Set token count in metadata
     */
    public function setTokenCount(tokens: Int): Void {
        metadata.set("tokens", tokens);
        _version++;
    }
    
    /**
     * Get processing time from metadata
     */
    public function getProcessingTime(): Option<Float> {
        return metadata.exists("processingTime") ? Option.some(metadata.get("processingTime")) : Option.none();
    }
    
    /**
     * Set processing time in metadata
     */
    public function setProcessingTime(time: Float): Void {
        metadata.set("processingTime", time);
        _version++;
    }
    
    /**
     * Get model ID from metadata
     */
    public function getModelId(): Option<String> {
        return metadata.exists("modelId") ? Option.some(metadata.get("modelId")) : Option.none();
    }
    
    /**
     * Set model ID in metadata
     */
    public function setModelId(modelId: String): Void {
        metadata.set("modelId", modelId);
        _version++;
    }
    
    /**
     * Update metadata
     */
    public function updateMetadata(key: String, value: Dynamic): Void {
        metadata.set(key, value);
        _version++;
    }
    
    /**
     * Get metadata value
     */
    public function getMetadata(key: String): Option<Dynamic> {
        return metadata.exists(key) ? Option.some(metadata.get(key)) : Option.none();
    }
    
    /**
     * Get creation timestamp
     */
    public function getCreatedAt(): Float {
        return _createdAt;
    }
    
    /**
     * Get current version
     */
    public function getVersion(): Int {
        return _version;
    }
    
    /**
     * Convert to string representation
     */
    public function toString(): String {
        var roleStr = switch (role) {
            case User: "User";
            case Assistant: "Assistant";
            case System: "System";
        };
        var preview = content.length > 50 ? content.substr(0, 50) + "..." : content;
        return 'Message(id=$id, role=$roleStr, content="$preview")';
    }
}

/**
 * Message role enumeration
 */
enum MessageRole {
    User;
    Assistant;
    System;
}