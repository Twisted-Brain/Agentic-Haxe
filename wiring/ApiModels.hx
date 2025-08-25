package wiring;

/**
 * Universal API data models for cross-platform communication
 * Used by all frontend and backend implementations
 */
class LlmRequest {
    public var message: String;
    public var model: String;
    public var temperature: Float;
    public var maxTokens: Int;
    public var timestamp: Float;
    
    public function new(message: String, model: String = "gpt-3.5-turbo", ?temperature: Float = 0.7, ?maxTokens: Int = 1000) {
        this.message = message;
        this.model = model;
        this.temperature = temperature;
        this.maxTokens = maxTokens;
        this.timestamp = Date.now().getTime();
    }
    
    public function toJson(): String {
        return haxe.Json.stringify(this);
    }
    
    public static function fromJson(json: String): LlmRequest {
        return haxe.Json.parse(json);
    }
}

class LlmResponse {
    public var content: String;
    public var status: String;
    public var promptTokens: Int;
    public var completionTokens: Int;
    public var totalTokens: Int;
    public var timestamp: Float;
    public var processingTimeMs: Int;
    
    public function new(content: String, status: String, promptTokens: Int = 0, completionTokens: Int = 0, totalTokens: Int = 0) {
        this.content = content;
        this.status = status;
        this.promptTokens = promptTokens;
        this.completionTokens = completionTokens;
        this.totalTokens = totalTokens;
        this.timestamp = Date.now().getTime();
        this.processingTimeMs = 0;
    }
    
    public function isSuccess(): Bool {
        return status == "success";
    }
    
    public function isError(): Bool {
        return status == "error";
    }
    
    public function toJson(): String {
        return haxe.Json.stringify(this);
    }
    
    public static function fromJson(json: String): LlmResponse {
        return haxe.Json.parse(json);
    }
}

enum LlmModel {
    GPT35Turbo;
    GPT4;
    GPT4Turbo;
    Claude3Haiku;
    Claude3Sonnet;
    Claude3Opus;
    Llama2_70B;
    Mixtral8x7B;
    Custom(name: String);
}

class LlmModelHelper {
    public static function toString(model: LlmModel): String {
        return switch (model) {
            case GPT35Turbo: "openai/gpt-3.5-turbo";
            case GPT4: "openai/gpt-4";
            case GPT4Turbo: "openai/gpt-4-turbo";
            case Claude3Haiku: "anthropic/claude-3-haiku";
            case Claude3Sonnet: "anthropic/claude-3-sonnet";
            case Claude3Opus: "anthropic/claude-3-opus";
            case Llama2_70B: "meta-llama/llama-2-70b-chat";
            case Mixtral8x7B: "mistralai/mixtral-8x7b-instruct";
            case Custom(name): name;
        };
    }
    
    public static function fromString(modelStr: String): LlmModel {
        return switch (modelStr) {
            case "openai/gpt-3.5-turbo": GPT35Turbo;
            case "openai/gpt-4": GPT4;
            case "openai/gpt-4-turbo": GPT4Turbo;
            case "anthropic/claude-3-haiku": Claude3Haiku;
            case "anthropic/claude-3-sonnet": Claude3Sonnet;
            case "anthropic/claude-3-opus": Claude3Opus;
            case "meta-llama/llama-2-70b-chat": Llama2_70B;
            case "mistralai/mixtral-8x7b-instruct": Mixtral8x7B;
            default: Custom(modelStr);
        };
    }
    
    public static function getAllModels(): Array<LlmModel> {
        return [
            GPT35Turbo,
            GPT4,
            GPT4Turbo,
            Claude3Haiku,
            Claude3Sonnet,
            Claude3Opus,
            Llama2_70B,
            Mixtral8x7B
        ];
    }
}