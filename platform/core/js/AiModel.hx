package core.js;

import shared.domain.types.core.Result;
import shared.domain.types.core.Option;
import shared.domain.types.core.Validation;

/**
 * AI Model entity representing a language model in the system
 * This is a core domain entity with business logic and validation
 */
class AiModel {
    public var id(default, null): String;
    public var name(default, null): String;
    public var provider(default, null): String;
    public var modelType(default, null): ModelType;
    public var maxTokens(default, null): Int;
    public var contextWindow(default, null): Int;
    public var supportedFeatures(default, null): Array<ModelFeature>;
    public var pricing(default, null): Option<ModelPricing>;
    public var isAvailable(default, null): Bool;
    public var metadata(default, null): Map<String, Dynamic>;
    
    private var _createdAt: Float;
    private var _updatedAt: Float;
    private var _version: Int;
    
    public function new(
        id: String,
        name: String,
        provider: String,
        modelType: ModelType,
        maxTokens: Int,
        contextWindow: Int,
        supportedFeatures: Array<ModelFeature>,
        ?pricing: Option<ModelPricing>,
        ?metadata: Map<String, Dynamic>
    ) {
        this.id = id;
        this.name = name;
        this.provider = provider;
        this.modelType = modelType;
        this.maxTokens = maxTokens;
        this.contextWindow = contextWindow;
        this.supportedFeatures = supportedFeatures != null ? supportedFeatures : [];
        this.pricing = pricing != null ? pricing : Option.none();
        this.metadata = metadata != null ? metadata : new Map<String, Dynamic>();
        this.isAvailable = true;
        this._createdAt = Date.now().getTime();
        this._updatedAt = this._createdAt;
        this._version = 1;
    }
    
    /**
     * Validate model configuration
     */
    public function validate(): Validation<AiModel, String> {
        var errors = new Array<String>();
        
        if (id == null || id.length == 0) {
            errors.push("Model ID cannot be empty");
        }
        
        if (name == null || name.length == 0) {
            errors.push("Model name cannot be empty");
        }
        
        if (provider == null || provider.length == 0) {
            errors.push("Model provider cannot be empty");
        }
        
        if (maxTokens <= 0) {
            errors.push("Max tokens must be positive");
        }
        
        if (contextWindow <= 0) {
            errors.push("Context window must be positive");
        }
        
        if (contextWindow < maxTokens) {
            errors.push("Context window must be greater than or equal to max tokens");
        }
        
        return errors.length > 0 ? Validation.failure(errors) : Validation.success(this);
    }
    
    /**
     * Check if model supports a specific feature
     */
    public function supportsFeature(feature: ModelFeature): Bool {
        return supportedFeatures.indexOf(feature) != -1;
    }
    
    /**
     * Update model availability
     */
    public function setAvailability(available: Bool): Void {
        this.isAvailable = available;
        this._updatedAt = Date.now().getTime();
        this._version++;
    }
    
    /**
     * Update model pricing
     */
    public function updatePricing(newPricing: Option<ModelPricing>): Void {
        this.pricing = newPricing;
        this._updatedAt = Date.now().getTime();
        this._version++;
    }
    
    /**
     * Add supported feature
     */
    public function addFeature(feature: ModelFeature): Bool {
        if (!supportsFeature(feature)) {
            supportedFeatures.push(feature);
            this._updatedAt = Date.now().getTime();
            this._version++;
            return true;
        }
        return false;
    }
    
    /**
     * Remove supported feature
     */
    public function removeFeature(feature: ModelFeature): Bool {
        var index = supportedFeatures.indexOf(feature);
        if (index != -1) {
            supportedFeatures.splice(index, 1);
            this._updatedAt = Date.now().getTime();
            this._version++;
            return true;
        }
        return false;
    }
    
    /**
     * Update metadata
     */
    public function updateMetadata(key: String, value: Dynamic): Void {
        metadata.set(key, value);
        this._updatedAt = Date.now().getTime();
        this._version++;
    }
    
    /**
     * Get metadata value
     */
    public function getMetadata(key: String): Option<Dynamic> {
        return metadata.exists(key) ? Option.some(metadata.get(key)) : Option.none();
    }
    
    /**
     * Calculate estimated cost for token usage
     */
    public function calculateCost(inputTokens: Int, outputTokens: Int): Option<Float> {
        return switch (pricing) {
            case Some(p): 
                var inputCost = inputTokens * p.inputTokenPrice;
                var outputCost = outputTokens * p.outputTokenPrice;
                Option.some(inputCost + outputCost);
            case None: Option.none();
        };
    }
    
    /**
     * Check if model can handle request size
     */
    public function canHandleRequest(estimatedTokens: Int): Bool {
        return isAvailable && estimatedTokens <= maxTokens && estimatedTokens <= contextWindow;
    }
    
    /**
     * Get model age in milliseconds
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
     * Create a copy of this model with updated properties
     */
    public function copyWith(?
        name: String,
        ?provider: String,
        ?modelType: ModelType,
        ?maxTokens: Int,
        ?contextWindow: Int,
        ?supportedFeatures: Array<ModelFeature>,
        ?pricing: Option<ModelPricing>,
        ?isAvailable: Bool
    ): AiModel {
        var copy = new AiModel(
            this.id,
            name != null ? name : this.name,
            provider != null ? provider : this.provider,
            modelType != null ? modelType : this.modelType,
            maxTokens != null ? maxTokens : this.maxTokens,
            contextWindow != null ? contextWindow : this.contextWindow,
            supportedFeatures != null ? supportedFeatures : this.supportedFeatures.copy()
        );
        
        if (pricing != null) copy.pricing = pricing;
        if (isAvailable != null) copy.isAvailable = isAvailable;
        
        // Copy metadata
        for (key in this.metadata.keys()) {
            copy.metadata.set(key, this.metadata.get(key));
        }
        
        return copy;
    }
    
    /**
     * Convert to string representation
     */
    public function toString(): String {
        return 'AiModel(id=$id, name=$name, provider=$provider, type=$modelType, available=$isAvailable)';
    }
}

/**
 * Model type enumeration
 */
enum ModelType {
    Chat;
    Completion;
    Embedding;
    ImageGeneration;
    ImageAnalysis;
    AudioTranscription;
    AudioGeneration;
    CodeGeneration;
    Translation;
    Summarization;
    Custom(type: String);
}

/**
 * Model feature enumeration
 */
enum ModelFeature {
    Streaming;
    FunctionCalling;
    VisionSupport;
    AudioSupport;
    CodeExecution;
    WebSearch;
    FileUpload;
    MultiModal;
    FineTuning;
    CustomInstructions;
    JsonMode;
    ToolUse;
    Custom(feature: String);
}

/**
 * Model pricing structure
 */
typedef ModelPricing = {
    var inputTokenPrice: Float;
    var outputTokenPrice: Float;
    var currency: String;
    var billingUnit: String; // "per_token", "per_1k_tokens", "per_1m_tokens"
    var minimumCharge: Option<Float>;
    var discountTiers: Option<Array<{
        var threshold: Int;
        var discountPercent: Float;
    }>>;
}