package shared;

import shared.ApiModels;

/**
 * Main class for shared library functionality
 * This provides common utilities used by both frontend and backend
 */
class SharedMain {
    public static function main(): Void {
        trace("Shared library initialized");
        
        // Test the shared models
        testApiModels();
    }
    
    private static function testApiModels(): Void {
        trace("Testing shared API models...");
        
        // Test LlmRequest
        var request = new LlmRequest("Hello, world!", "openai/gpt-3.5-turbo");
        var requestJson = request.toJson();
        trace('Request JSON: $requestJson');
        
        var parsedRequest = LlmRequest.fromJson(requestJson);
        trace('Parsed request message: ${parsedRequest.message}');
        
        // Test LlmResponse
        var response = new LlmResponse("Hello! How can I help you?", "success", 10, 15);
        var responseJson = response.toJson();
        trace('Response JSON: $responseJson');
        
        var parsedResponse = LlmResponse.fromJson(responseJson);
        trace('Parsed response content: ${parsedResponse.content}');
        trace('Response is success: ${parsedResponse.isSuccess()}');
        
        // Test LlmModel enum
        var model = LlmModel.GPT35Turbo;
        var modelString = LlmModelHelper.toString(model);
        trace('Model string: $modelString');
        
        var parsedModel = LlmModelHelper.fromString(modelString);
        trace('Parsed model: $parsedModel');
        
        // Test GatewayConfig
        var config = new GatewayConfig(
            "test-api-key",
            "https://openrouter.ai/api/v1",
            "openai/gpt-3.5-turbo"
        );
        var configJson = config.toJson();
        trace('Config JSON: $configJson');
        
        trace("Shared API models test completed successfully!");
    }
}

/**
 * Utility functions for the shared library
 */
class SharedUtils {
    /**
     * Validates if a string is a valid JSON
     */
    public static function isValidJson(jsonString: String): Bool {
        try {
            haxe.Json.parse(jsonString);
            return true;
        } catch (e: Dynamic) {
            return false;
        }
    }
    
    /**
     * Sanitizes user input to prevent injection attacks
     */
    public static function sanitizeInput(input: String): String {
        if (input == null) return "";
        
        // Remove potentially dangerous characters
        var sanitized = input;
        sanitized = StringTools.replace(sanitized, "<", "&lt;");
        sanitized = StringTools.replace(sanitized, ">", "&gt;");
        sanitized = StringTools.replace(sanitized, "&", "&amp;");
        sanitized = StringTools.replace(sanitized, '"', "&quot;");
        sanitized = StringTools.replace(sanitized, "'", "&#x27;");
        
        return sanitized;
    }
    
    /**
     * Formats timestamp to human readable string
     */
    public static function formatTimestamp(timestamp: Float): String {
        var date = Date.fromTime(timestamp);
        return DateTools.format(date, "%Y-%m-%d %H:%M:%S");
    }
    
    /**
     * Calculates processing time in milliseconds
     */
    public static function calculateProcessingTime(startTime: Float, endTime: Float): Float {
        return endTime - startTime;
    }
    
    /**
     * Validates API key format (basic validation)
     */
    public static function isValidApiKey(apiKey: String): Bool {
        if (apiKey == null || apiKey == "") return false;
        if (apiKey == "demo-key") return true; // Allow demo key
        
        // Basic validation - should be at least 20 characters
        return apiKey.length >= 20;
    }
    
    /**
     * Generates a simple request ID for tracking
     */
    public static function generateRequestId(): String {
        var timestamp = Std.int(Date.now().getTime());
        var random = Std.int(Math.random() * 10000);
        return 'req_${timestamp}_${random}';
    }
    
    /**
     * Truncates text to specified length with ellipsis
     */
    public static function truncateText(text: String, maxLength: Int): String {
        if (text == null || text.length <= maxLength) return text;
        return text.substring(0, maxLength - 3) + "...";
    }
    
    /**
     * Estimates token count (rough approximation)
     */
    public static function estimateTokenCount(text: String): Int {
        if (text == null || text == "") return 0;
        
        // Rough estimation: 1 token ≈ 4 characters for English text
        return Math.ceil(text.length / 4);
    }
}