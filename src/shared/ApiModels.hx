package shared;

/**
 * Shared API models for communication between frontend and backend
 */
class ApiModels {
    
}

/**
 * Request model for LLM API calls
 */
class LlmRequest {
    public var message: String;
    public var model: String;
    public var temperature: Float;
    public var maxTokens: Int;
    public var timestamp: Float;
    
    public function new(message: String, model: String, ?temperature: Float = 0.7, ?maxTokens: Int = 1000) {
        this.message = message;
        this.model = model;
        this.temperature = temperature;
        this.maxTokens = maxTokens;
        this.timestamp = Date.now().getTime();
    }
    
    public function toJson(): String {
        return haxe.Json.stringify({
            message: message,
            model: model,
            temperature: temperature,
            maxTokens: maxTokens,
            timestamp: timestamp
        });
    }
    
    public static function fromJson(json: String): LlmRequest {
        var data = haxe.Json.parse(json);
        var request = new LlmRequest(data.message, data.model, data.temperature, data.maxTokens);
        request.timestamp = data.timestamp;
        return request;
    }
}

/**
 * Response model for LLM API calls
 */
class LlmResponse {
    public var content: String;
    public var status: String;
    public var promptTokens: Int;
    public var completionTokens: Int;
    public var totalTokens: Int;
    public var timestamp: Float;
    public var processingTimeMs: Float;
    
    public function new(content: String, status: String, promptTokens: Int, completionTokens: Int, ?processingTimeMs: Float = 0) {
        this.content = content;
        this.status = status;
        this.promptTokens = promptTokens;
        this.completionTokens = completionTokens;
        this.totalTokens = promptTokens + completionTokens;
        this.timestamp = Date.now().getTime();
        this.processingTimeMs = processingTimeMs;
    }
    
    public function toJson(): String {
        return haxe.Json.stringify({
            content: content,
            status: status,
            promptTokens: promptTokens,
            completionTokens: completionTokens,
            totalTokens: totalTokens,
            timestamp: timestamp,
            processingTimeMs: processingTimeMs
        });
    }
    
    public static function fromJson(json: String): LlmResponse {
        var data = haxe.Json.parse(json);
        var response = new LlmResponse(
            data.content,
            data.status,
            data.promptTokens,
            data.completionTokens,
            data.processingTimeMs
        );
        response.timestamp = data.timestamp;
        return response;
    }
    
    public function isSuccess(): Bool {
        return status == "success" || status == "demo";
    }
    
    public function isError(): Bool {
        return status == "error";
    }
}

/**
 * Configuration model for the gateway
 */
class GatewayConfig {
    public var apiKey: String;
    public var baseUrl: String;
    public var defaultModel: String;
    public var timeout: Int;
    public var maxRetries: Int;
    
    public function new(apiKey: String, baseUrl: String, defaultModel: String, ?timeout: Int = 30000, ?maxRetries: Int = 3) {
        this.apiKey = apiKey;
        this.baseUrl = baseUrl;
        this.defaultModel = defaultModel;
        this.timeout = timeout;
        this.maxRetries = maxRetries;
    }
    
    public function toJson(): String {
        return haxe.Json.stringify({
            apiKey: "[REDACTED]", // Never expose API key in JSON
            baseUrl: baseUrl,
            defaultModel: defaultModel,
            timeout: timeout,
            maxRetries: maxRetries
        });
    }
}

/**
 * Available LLM models enum
 */
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
        }
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
            case _: Custom(modelStr);
        }
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