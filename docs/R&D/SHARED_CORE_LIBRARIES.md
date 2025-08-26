# Shared Core Libraries for Haxe AI Project

<div align="center">
  <img src="../../assets/rd-banner.png" alt="R&D Banner">
</div>

## Overview
This document defines the shared core libraries that form the foundation of our Hexagonal Architecture across all Haxe targets and PoCs. These super-libraries provide consistent functionality while maintaining platform independence.

## Core Library Architecture

### 1. AI Core Library (`ai-core`)
The foundational AI processing library used across all targets.

```
shared/ai-core/
├── src/
│   ├── inference/
│   │   ├── InferenceEngineCore.hx          # Core inference logic
│   │   ├── ModelLoaderCore.hx              # Model loading abstraction
│   │   ├── TokenizerCore.hx                # Text tokenization
│   │   └── ResponseProcessorCore.hx        # Response processing
│   ├── streaming/
│   │   ├── StreamManagerCore.hx            # Stream handling
│   │   ├── ChunkProcessorCore.hx           # Chunk processing
│   │   └── BackpressureHandlerCore.hx      # Backpressure management
│   ├── memory/
│   │   ├── MemoryManagerCore.hx            # Memory optimization
│   │   ├── CacheManagerCore.hx             # Caching strategies
│   │   └── GarbageCollectorCore.hx         # GC optimization
│   ├── validation/
│   │   ├── InputValidatorCore.hx           # Input validation
│   │   ├── OutputValidatorCore.hx          # Output validation
│   │   └── SecurityValidatorCore.hx        # Security checks
│   └── math/
│       ├── VectorOperationsCore.hx         # Vector math
│       ├── MatrixOperationsCore.hx         # Matrix operations
│       └── StatisticsCore.hx               # Statistical functions
├── tests/
│   ├── inference/
│   ├── streaming/
│   ├── memory/
│   ├── validation/
│   └── math/
└── build.hxml
```

#### Key Classes
```haxe
// InferenceEngineCore.hx
class InferenceEngineCore {
    private var modelLoader: ModelLoaderCore;
    private var tokenizer: TokenizerCore;
    private var responseProcessor: ResponseProcessorCore;
    private var validator: InputValidatorCore;
    
    public function new(dependencies: InferenceCoreDependencies) {
        this.modelLoader = dependencies.modelLoader;
        this.tokenizer = dependencies.tokenizer;
        this.responseProcessor = dependencies.responseProcessor;
        this.validator = dependencies.validator;
    }
    
    public function processInference(request: InferenceRequestCore): Promise<InferenceResultCore> {
        return validator.validate(request)
            .then(validRequest -> tokenizer.tokenize(validRequest.input))
            .then(tokens -> modelLoader.getModel(request.modelId)
                .then(model -> model.inference(tokens)))
            .then(rawOutput -> responseProcessor.process(rawOutput));
    }
    
    public function streamInference(request: InferenceRequestCore): AsyncIterator<InferenceChunkCore> {
        // Streaming inference implementation
        return new StreamingInferenceIterator(request, this);
    }
}

// ModelLoaderCore.hx
abstract class ModelLoaderCore {
    public abstract function loadModel(modelId: String): Promise<AIModelCore>;
    public abstract function unloadModel(modelId: String): Promise<Void>;
    public abstract function getLoadedModels(): Array<String>;
    public abstract function getModelInfo(modelId: String): Promise<ModelInfoCore>;
}

// TokenizerCore.hx
class TokenizerCore {
    public function tokenize(text: String): Promise<Array<TokenCore>> {
        // Platform-independent tokenization logic
        return Promise.resolve(performTokenization(text));
    }
    
    public function detokenize(tokens: Array<TokenCore>): String {
        return tokens.map(token -> token.text).join("");
    }
    
    private function performTokenization(text: String): Array<TokenCore> {
        // Core tokenization algorithm
        var tokens = [];
        var words = text.split(" ");
        for (word in words) {
            tokens.push(new TokenCore(word, getTokenId(word)));
        }
        return tokens;
    }
}
```

### 2. API Interfaces Library (`api-interfaces`)
Standardized interfaces for external communication.

```
shared/api-interfaces/
├── src/
│   ├── http/
│   │   ├── HttpClientInterface.hx           # HTTP client abstraction
│   │   ├── HttpServerInterface.hx           # HTTP server abstraction
│   │   ├── WebSocketInterface.hx            # WebSocket abstraction
│   │   └── RestApiInterface.hx              # REST API standards
│   ├── providers/
│   │   ├── AIProviderInterface.hx           # AI provider contract
│   │   ├── OpenRouterInterface.hx           # OpenRouter specific
│   │   ├── OpenAIInterface.hx               # OpenAI specific
│   │   └── AnthropicInterface.hx            # Anthropic specific
│   ├── storage/
│   │   ├── StorageInterface.hx              # Storage abstraction
│   │   ├── DatabaseInterface.hx             # Database operations
│   │   ├── FileSystemInterface.hx           # File operations
│   │   └── CacheInterface.hx                # Caching interface
│   ├── messaging/
│   │   ├── MessageQueueInterface.hx         # Message queue abstraction
│   │   ├── EventBusInterface.hx             # Event bus interface
│   │   └── PubSubInterface.hx               # Pub/Sub interface
│   └── security/
│       ├── AuthenticationInterface.hx       # Auth abstraction
│       ├── AuthorizationInterface.hx        # Authorization interface
│       └── EncryptionInterface.hx           # Encryption interface
├── tests/
└── build.hxml
```

#### Key Interfaces
```haxe
// AIProviderInterface.hx
interface AIProviderInterface {
    function generateResponse(request: AIRequestCore): Promise<AIResponseCore>;
    function streamResponse(request: AIRequestCore): AsyncIterator<ResponseChunkCore>;
    function getAvailableModels(): Promise<Array<ModelInfoCore>>;
    function validateCredentials(): Promise<Bool>;
    function getUsageStats(): Promise<UsageStatsCore>;
}

// HttpClientInterface.hx
interface HttpClientInterface {
    function get(url: String, headers: Map<String, String>): Promise<HttpResponseCore>;
    function post(url: String, body: String, headers: Map<String, String>): Promise<HttpResponseCore>;
    function put(url: String, body: String, headers: Map<String, String>): Promise<HttpResponseCore>;
    function delete(url: String, headers: Map<String, String>): Promise<HttpResponseCore>;
    function stream(url: String, headers: Map<String, String>): AsyncIterator<HttpChunkCore>;
}

// StorageInterface.hx
interface StorageInterface {
    function store(key: String, value: String): Promise<Void>;
    function retrieve(key: String): Promise<String>;
    function delete(key: String): Promise<Void>;
    function exists(key: String): Promise<Bool>;
    function list(prefix: String): Promise<Array<String>>;
}
```

### 3. Utilities Library (`utils`)
Common utility functions and helpers.

```
shared/utils/
├── src/
│   ├── async/
│   │   ├── PromiseUtils.hx                  # Promise utilities
│   │   ├── AsyncIteratorUtils.hx            # Async iterator helpers
│   │   ├── TimeoutUtils.hx                  # Timeout handling
│   │   └── RetryUtils.hx                    # Retry mechanisms
│   ├── collections/
│   │   ├── ArrayUtils.hx                    # Array utilities
│   │   ├── MapUtils.hx                      # Map utilities
│   │   ├── SetUtils.hx                      # Set utilities
│   │   └── QueueUtils.hx                    # Queue utilities
│   ├── string/
│   │   ├── StringUtils.hx                   # String manipulation
│   │   ├── JsonUtils.hx                     # JSON handling
│   │   ├── UrlUtils.hx                      # URL utilities
│   │   └── EncodingUtils.hx                 # Encoding/decoding
│   ├── validation/
│   │   ├── ValidationUtils.hx               # Validation helpers
│   │   ├── SanitizationUtils.hx             # Input sanitization
│   │   └── FormatUtils.hx                   # Format validation
│   ├── logging/
│   │   ├── LoggerUtils.hx                   # Logging utilities
│   │   ├── LogFormatterUtils.hx             # Log formatting
│   │   └── LogLevelUtils.hx                 # Log level management
│   ├── crypto/
│   │   ├── HashUtils.hx                     # Hashing utilities
│   │   ├── EncryptionUtils.hx               # Encryption helpers
│   │   └── RandomUtils.hx                   # Random generation
│   └── performance/
│       ├── BenchmarkUtils.hx                # Benchmarking tools
│       ├── ProfilerUtils.hx                 # Performance profiling
│       └── MetricsUtils.hx                  # Metrics collection
├── tests/
└── build.hxml
```

#### Key Utilities
```haxe
// PromiseUtils.hx
class PromiseUtils {
    public static function timeout<T>(promise: Promise<T>, timeoutMs: Int): Promise<T> {
        return Promise.race([
            promise,
            new Promise((resolve, reject) -> {
                Timer.delay(() -> reject(new TimeoutError('Operation timed out after ${timeoutMs}ms')), timeoutMs);
            })
        ]);
    }
    
    public static function retry<T>(operation: () -> Promise<T>, maxRetries: Int, delayMs: Int = 1000): Promise<T> {
        return operation().catchError(error -> {
            if (maxRetries <= 0) {
                return Promise.reject(error);
            }
            return new Promise((resolve, reject) -> {
                Timer.delay(() -> {
                    retry(operation, maxRetries - 1, delayMs * 2)
                        .then(resolve)
                        .catchError(reject);
                }, delayMs);
            });
        });
    }
    
    public static function all<T>(promises: Array<Promise<T>>): Promise<Array<T>> {
        return Promise.all(promises);
    }
    
    public static function allSettled<T>(promises: Array<Promise<T>>): Promise<Array<PromiseResult<T>>> {
        return Promise.all(promises.map(p -> 
            p.then(value -> PromiseResult.fulfilled(value))
             .catchError(error -> Promise.resolve(PromiseResult.rejected(error)))
        ));
    }
}

// StringUtils.hx
class StringUtils {
    public static function isEmpty(str: String): Bool {
        return str == null || str.length == 0;
    }
    
    public static function isBlank(str: String): Bool {
        return isEmpty(str) || ~/^\s*$/.match(str);
    }
    
    public static function truncate(str: String, maxLength: Int, suffix: String = "..."): String {
        if (str.length <= maxLength) return str;
        return str.substr(0, maxLength - suffix.length) + suffix;
    }
    
    public static function sanitizeForJson(str: String): String {
        return str.replace('"', '\\"')
                  .replace('\n', '\\n')
                  .replace('\r', '\\r')
                  .replace('\t', '\\t');
    }
    
    public static function extractUrls(text: String): Array<String> {
        var urlRegex = ~/https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)/g;
        var urls = [];
        var match;
        while ((match = urlRegex.match(text)) != null) {
            urls.push(match.matched(0));
            text = urlRegex.matchedRight();
        }
        return urls;
    }
}

// ValidationUtils.hx
class ValidationUtils {
    public static function validateEmail(email: String): ValidationResult {
        var emailRegex = ~/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
        return emailRegex.match(email) 
            ? ValidationResult.success()
            : ValidationResult.error("Invalid email format");
    }
    
    public static function validateApiKey(apiKey: String): ValidationResult {
        if (StringUtils.isBlank(apiKey)) {
            return ValidationResult.error("API key cannot be empty");
        }
        if (apiKey.length < 10) {
            return ValidationResult.error("API key too short");
        }
        return ValidationResult.success();
    }
    
    public static function validateModelId(modelId: String): ValidationResult {
        if (StringUtils.isBlank(modelId)) {
            return ValidationResult.error("Model ID cannot be empty");
        }
        var modelIdRegex = ~/^[a-zA-Z0-9\-_\.]+$/;
        return modelIdRegex.match(modelId)
            ? ValidationResult.success()
            : ValidationResult.error("Invalid model ID format");
    }
}
```

### 4. Types Library (`types`)
Shared type definitions and data structures.

```
shared/types/
├── src/
│   ├── core/
│   │   ├── AIModelCore.hx                   # AI model types
│   │   ├── InferenceRequestCore.hx          # Request types
│   │   ├── InferenceResultCore.hx           # Result types
│   │   ├── TokenCore.hx                     # Token types
│   │   └── ModelInfoCore.hx                 # Model info types
│   ├── http/
│   │   ├── HttpRequestCore.hx               # HTTP request types
│   │   ├── HttpResponseCore.hx              # HTTP response types
│   │   ├── HttpHeadersCore.hx               # HTTP headers
│   │   └── HttpStatusCore.hx                # HTTP status codes
│   ├── errors/
│   │   ├── AIErrorCore.hx                   # AI-specific errors
│   │   ├── ValidationErrorCore.hx           # Validation errors
│   │   ├── NetworkErrorCore.hx              # Network errors
│   │   └── TimeoutErrorCore.hx              # Timeout errors
│   ├── events/
│   │   ├── AIEventCore.hx                   # AI events
│   │   ├── SystemEventCore.hx               # System events
│   │   └── UserEventCore.hx                 # User events
│   ├── configuration/
│   │   ├── AIConfigCore.hx                  # AI configuration
│   │   ├── ServerConfigCore.hx              # Server configuration
│   │   └── SecurityConfigCore.hx            # Security configuration
│   └── metrics/
│       ├── PerformanceMetricsCore.hx        # Performance metrics
│       ├── UsageMetricsCore.hx              # Usage metrics
│       └── ErrorMetricsCore.hx              # Error metrics
├── tests/
└── build.hxml
```

#### Key Types
```haxe
// InferenceRequestCore.hx
class InferenceRequestCore {
    public final id: String;
    public final modelId: String;
    public final input: String;
    public final parameters: InferenceParametersCore;
    public final metadata: Map<String, String>;
    public final timestamp: Date;
    
    public function new(id: String, modelId: String, input: String, 
                       parameters: InferenceParametersCore, 
                       metadata: Map<String, String> = null) {
        this.id = id;
        this.modelId = modelId;
        this.input = input;
        this.parameters = parameters;
        this.metadata = metadata ?? new Map();
        this.timestamp = Date.now();
    }
    
    public function validate(): ValidationResult {
        if (StringUtils.isBlank(id)) {
            return ValidationResult.error("Request ID cannot be empty");
        }
        if (StringUtils.isBlank(modelId)) {
            return ValidationResult.error("Model ID cannot be empty");
        }
        if (StringUtils.isBlank(input)) {
            return ValidationResult.error("Input cannot be empty");
        }
        return parameters.validate();
    }
    
    public function toJson(): String {
        return Json.stringify({
            id: id,
            modelId: modelId,
            input: input,
            parameters: parameters.toJson(),
            metadata: metadata,
            timestamp: timestamp.getTime()
        });
    }
    
    public static function fromJson(json: String): InferenceRequestCore {
        var data = Json.parse(json);
        return new InferenceRequestCore(
            data.id,
            data.modelId,
            data.input,
            InferenceParametersCore.fromJson(data.parameters),
            data.metadata
        );
    }
}

// AIErrorCore.hx
enum AIErrorType {
    ValidationError;
    NetworkError;
    TimeoutError;
    AuthenticationError;
    RateLimitError;
    ModelNotFoundError;
    InferenceError;
    SystemError;
}

class AIErrorCore extends Error {
    public final errorType: AIErrorType;
    public final errorCode: String;
    public final details: Map<String, String>;
    public final timestamp: Date;
    
    public function new(errorType: AIErrorType, message: String, 
                       errorCode: String = null, 
                       details: Map<String, String> = null) {
        super(message);
        this.errorType = errorType;
        this.errorCode = errorCode ?? generateErrorCode(errorType);
        this.details = details ?? new Map();
        this.timestamp = Date.now();
    }
    
    public function toJson(): String {
        return Json.stringify({
            errorType: Std.string(errorType),
            message: message,
            errorCode: errorCode,
            details: details,
            timestamp: timestamp.getTime()
        });
    }
    
    private function generateErrorCode(errorType: AIErrorType): String {
        return switch (errorType) {
            case ValidationError: "AI_VALIDATION_001";
            case NetworkError: "AI_NETWORK_002";
            case TimeoutError: "AI_TIMEOUT_003";
            case AuthenticationError: "AI_AUTH_004";
            case RateLimitError: "AI_RATELIMIT_005";
            case ModelNotFoundError: "AI_MODEL_006";
            case InferenceError: "AI_INFERENCE_007";
            case SystemError: "AI_SYSTEM_008";
        }
    }
}
```

## Cross-Platform Compatibility

### Compilation Targets Support
```haxe
// Platform-specific implementations
#if python
    // Python-specific optimizations
    import python.lib.Json as PlatformJson;
#elseif js
    // JavaScript-specific optimizations
    import js.lib.JSON as PlatformJson;
#elseif java
    // Java-specific optimizations
    import java.lang.System as PlatformSystem;
#elseif cs
    // C#-specific optimizations
    import cs.system.DateTime as PlatformDateTime;
#elseif php
    // PHP-specific optimizations
    import php.Global as PlatformGlobal;
#end
```

### Build Configuration
```xml
<!-- shared/build.hxml -->
-cp src
-lib haxe-concurrent
-lib haxe-crypto
-lib haxe-json

# Python target
--next
-python bin/python/shared-core.py
-cp src
-main SharedCoreMain

# JavaScript target
--next
-js bin/js/shared-core.js
-cp src
-main SharedCoreMain

# Java target
--next
-java bin/java
-cp src
-main SharedCoreMain

# C# target
--next
-cs bin/cs
-cp src
-main SharedCoreMain

# PHP target
--next
-php bin/php
-cp src
-main SharedCoreMain
```

## Usage in PoCs

### Integration Example
```haxe
// In any PoC implementation
import shared.aicore.InferenceEngineCore;
import shared.apiinterfaces.AIProviderInterface;
import shared.utils.PromiseUtils;
import shared.types.InferenceRequestCore;

class PoCImplementation {
    private var inferenceEngine: InferenceEngineCore;
    private var aiProvider: AIProviderInterface;
    
    public function new(aiProvider: AIProviderInterface) {
        this.aiProvider = aiProvider;
        this.inferenceEngine = new InferenceEngineCore({
            modelLoader: new PlatformSpecificModelLoader(),
            tokenizer: new TokenizerCore(),
            responseProcessor: new ResponseProcessorCore(),
            validator: new InputValidatorCore()
        });
    }
    
    public function processRequest(request: InferenceRequestCore): Promise<InferenceResultCore> {
        return PromiseUtils.timeout(
            inferenceEngine.processInference(request),
            30000 // 30 second timeout
        ).catchError(error -> {
            LoggerUtils.error('Inference failed: ${error.message}');
            return Promise.reject(error);
        });
    }
}
```

## Testing Strategy

### Shared Test Suite
```haxe
// tests/SharedCoreTestSuite.hx
class SharedCoreTestSuite {
    @Test
    public function testInferenceEngineCore() {
        var mockDependencies = createMockDependencies();
        var engine = new InferenceEngineCore(mockDependencies);
        var request = new InferenceRequestCore("test-1", "gpt-3.5", "Hello", new InferenceParametersCore());
        
        var result = engine.processInference(request);
        Assert.isNotNull(result);
    }
    
    @Test
    public function testPromiseUtils() {
        var promise = Promise.resolve("test");
        var timeoutPromise = PromiseUtils.timeout(promise, 1000);
        
        timeoutPromise.then(result -> {
            Assert.equals("test", result);
        });
    }
    
    @Test
    public function testValidationUtils() {
        var result = ValidationUtils.validateEmail("test@example.com");
        Assert.isTrue(result.isSuccess);
        
        var invalidResult = ValidationUtils.validateEmail("invalid-email");
        Assert.isFalse(invalidResult.isSuccess);
    }
}
```

## Benefits of Shared Core Libraries

1. **Code Reuse**: Eliminate duplication across PoCs
2. **Consistency**: Standardized behavior across all targets
3. **Maintainability**: Single source of truth for core functionality
4. **Testing**: Comprehensive test coverage for shared components
5. **Performance**: Optimized implementations for each target
6. **Documentation**: Centralized documentation for core APIs
7. **Versioning**: Controlled evolution of core functionality

## Migration Path

1. **Phase 1**: Create shared type definitions
2. **Phase 2**: Implement core AI processing library
3. **Phase 3**: Add utility functions and helpers
4. **Phase 4**: Create standardized interfaces
5. **Phase 5**: Migrate existing PoCs to use shared libraries
6. **Phase 6**: Add comprehensive testing and documentation

These shared core libraries will serve as the foundation for all our Haxe AI PoCs, ensuring consistency, maintainability, and code reuse across all target platforms.

<div align="center">
  <img src="../../assets/footer.png" alt="Footer">
</div>