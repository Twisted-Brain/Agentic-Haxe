package domain.core;

/**
 * Shared AI Model entity that represents an AI model configuration
 * Used across all targets for consistent model representation
 */
class AiModel {
    public var id: String;
    public var name: String;
    public var provider: String;
    public var maxTokens: Int;
    public var temperature: Float;
    public var topP: Float;
    public var frequencyPenalty: Float;
    public var presencePenalty: Float;
    public var systemPrompt: String;
    public var isActive: Bool;
    public var createdAt: Float;
    public var updatedAt: Float;
    
    public function new(
        id: String,
        name: String,
        provider: String,
        maxTokens: Int = 4096,
        temperature: Float = 0.7,
        topP: Float = 1.0,
        frequencyPenalty: Float = 0.0,
        presencePenalty: Float = 0.0,
        systemPrompt: String = "",
        isActive: Bool = true
    ) {
        this.id = id;
        this.name = name;
        this.provider = provider;
        this.maxTokens = maxTokens;
        this.temperature = temperature;
        this.topP = topP;
        this.frequencyPenalty = frequencyPenalty;
        this.presencePenalty = presencePenalty;
        this.systemPrompt = systemPrompt;
        this.isActive = isActive;
        this.createdAt = Date.now().getTime();
        this.updatedAt = Date.now().getTime();
    }
    
    public function updateSettings(
        ?maxTokens: Int,
        ?temperature: Float,
        ?topP: Float,
        ?frequencyPenalty: Float,
        ?presencePenalty: Float,
        ?systemPrompt: String
    ): Void {
        if (maxTokens != null) this.maxTokens = maxTokens;
        if (temperature != null) this.temperature = temperature;
        if (topP != null) this.topP = topP;
        if (frequencyPenalty != null) this.frequencyPenalty = frequencyPenalty;
        if (presencePenalty != null) this.presencePenalty = presencePenalty;
        if (systemPrompt != null) this.systemPrompt = systemPrompt;
        this.updatedAt = Date.now().getTime();
    }
    
    public function activate(): Void {
        this.isActive = true;
        this.updatedAt = Date.now().getTime();
    }
    
    public function deactivate(): Void {
        this.isActive = false;
        this.updatedAt = Date.now().getTime();
    }
    
    public function clone(): AiModel {
        return new AiModel(
            this.id + "_copy",
            this.name + " (Copy)",
            this.provider,
            this.maxTokens,
            this.temperature,
            this.topP,
            this.frequencyPenalty,
            this.presencePenalty,
            this.systemPrompt,
            false
        );
    }
    
    public function toJson(): Dynamic {
        return {
            id: this.id,
            name: this.name,
            provider: this.provider,
            maxTokens: this.maxTokens,
            temperature: this.temperature,
            topP: this.topP,
            frequencyPenalty: this.frequencyPenalty,
            presencePenalty: this.presencePenalty,
            systemPrompt: this.systemPrompt,
            isActive: this.isActive,
            createdAt: this.createdAt,
            updatedAt: this.updatedAt
        };
    }
    
    public static function fromJson(data: Dynamic): AiModel {
        var model = new AiModel(
            data.id,
            data.name,
            data.provider,
            data.maxTokens,
            data.temperature,
            data.topP,
            data.frequencyPenalty,
            data.presencePenalty,
            data.systemPrompt,
            data.isActive
        );
        model.createdAt = data.createdAt;
        model.updatedAt = data.updatedAt;
        return model;
    }
    
    /**
     * Generate a response using this AI model
     * This is a placeholder implementation - in a real system this would call the actual AI API
     */
    public function generateResponse(input: String): String {
        // Placeholder implementation - would integrate with actual AI service
        return "AI Response to: " + input + " (from " + this.name + ")";
    }
}