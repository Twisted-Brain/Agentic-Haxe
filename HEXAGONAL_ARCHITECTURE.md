# Hexagonal Architecture for Haxe AI Project

<div align="center">
  <img src="assets/logo.png" alt="Haxe Hexagonal Architecture Logo" width="120" height="120">
</div>

## Overview
This document defines the Hexagonal Architecture (Ports and Adapters) implementation for our Haxe AI project, ensuring clean separation of concerns, testability, and platform independence.

## Architecture Principles

### Core Concepts
1. **Domain Core**: Business logic independent of external concerns
2. **Ports**: Interfaces defining how the core communicates with the outside world
3. **Adapters**: Concrete implementations of ports for specific technologies
4. **Dependency Inversion**: Core depends only on abstractions, not implementations

### Benefits for Haxe Multi-Target
- **Platform Independence**: Core logic works across all Haxe targets
- **Testability**: Easy to mock external dependencies
- **Flexibility**: Swap implementations without changing core logic
- **Maintainability**: Clear boundaries between layers

## Project Structure

```
src/
├── domain/                     # Domain Core (Business Logic)
│   ├── entities/              # Domain entities
│   │   ├── AIModel.hx
│   │   ├── ChatMessage.hx
│   │   └── InferenceRequest.hx
│   ├── services/              # Domain services
│   │   ├── AIInferenceService.hx
│   │   ├── ChatOrchestrator.hx
│   │   └── ModelManager.hx
│   └── valueobjects/          # Value objects
│       ├── ModelId.hx
│       ├── TokenCount.hx
│       └── ApiKey.hx
├── ports/                      # Interfaces (Contracts)
│   ├── primary/               # Driving ports (inbound)
│   │   ├── ChatServicePort.hx
│   │   ├── ModelServicePort.hx
│   │   └── InferencePort.hx
│   └── secondary/             # Driven ports (outbound)
│       ├── AIProviderPort.hx
│       ├── ConfigurationPort.hx
│       ├── LoggingPort.hx
│       └── StoragePort.hx
├── adapters/                   # Concrete Implementations
│   ├── primary/               # Driving adapters (controllers)
│   │   ├── web/
│   │   │   ├── HttpChatController.hx
│   │   │   └── WebSocketController.hx
│   │   ├── cli/
│   │   │   └── CommandLineInterface.hx
│   │   └── api/
│   │       └── RestApiController.hx
│   └── secondary/             # Driven adapters (infrastructure)
│       ├── ai-providers/
│       │   ├── OpenRouterAdapter.hx
│       │   ├── OpenAIAdapter.hx
│       │   └── AnthropicAdapter.hx
│       ├── storage/
│       │   ├── FileStorageAdapter.hx
│       │   ├── DatabaseAdapter.hx
│       │   └── MemoryStorageAdapter.hx
│       ├── configuration/
│       │   ├── EnvConfigAdapter.hx
│       │   └── JsonConfigAdapter.hx
│       └── logging/
│           ├── ConsoleLogAdapter.hx
│           ├── FileLogAdapter.hx
│           └── RemoteLogAdapter.hx
└── application/                # Application Layer
    ├── usecases/              # Use cases (application services)
    │   ├── ProcessChatUseCase.hx
    │   ├── StreamResponseUseCase.hx
    │   └── ManageModelsUseCase.hx
    └── dto/                   # Data Transfer Objects
        ├── ChatRequestDto.hx
        ├── ChatResponseDto.hx
        └── ModelInfoDto.hx
```

## Implementation Guidelines

### 1. Domain Layer (Core)
```haxe
// domain/entities/ChatMessage.hx
class ChatMessage {
    public final id: String;
    public final content: String;
    public final role: MessageRole;
    public final timestamp: Date;
    
    public function new(id: String, content: String, role: MessageRole) {
        this.id = id;
        this.content = content;
        this.role = role;
        this.timestamp = Date.now();
    }
    
    public function validate(): ValidationResult {
        // Domain validation logic
        if (content.length == 0) {
            return ValidationResult.error("Message content cannot be empty");
        }
        return ValidationResult.success();
    }
}

// domain/services/AIInferenceService.hx
class AIInferenceService {
    private var aiProviderPort: AIProviderPort;
    private var loggingPort: LoggingPort;
    
    public function new(aiProviderPort: AIProviderPort, loggingPort: LoggingPort) {
        this.aiProviderPort = aiProviderPort;
        this.loggingPort = loggingPort;
    }
    
    public function processInference(request: InferenceRequest): Promise<InferenceResult> {
        loggingPort.info('Processing inference request: ${request.id}');
        
        // Domain logic - no external dependencies
        var validationResult = request.validate();
        if (!validationResult.isSuccess) {
            return Promise.reject(new DomainError(validationResult.error));
        }
        
        return aiProviderPort.generateResponse(request)
            .then(response -> {
                loggingPort.info('Inference completed: ${request.id}');
                return new InferenceResult(request.id, response);
            });
    }
}
```

### 2. Ports Layer (Interfaces)
```haxe
// ports/primary/ChatServicePort.hx
interface ChatServicePort {
    function processMessage(message: ChatMessage): Promise<ChatResponse>;
    function streamResponse(request: StreamRequest): AsyncIterator<StreamChunk>;
    function getConversationHistory(conversationId: String): Promise<Array<ChatMessage>>;
}

// ports/secondary/AIProviderPort.hx
interface AIProviderPort {
    function generateResponse(request: InferenceRequest): Promise<AIResponse>;
    function streamResponse(request: InferenceRequest): AsyncIterator<ResponseChunk>;
    function getAvailableModels(): Promise<Array<ModelInfo>>;
    function validateApiKey(apiKey: String): Promise<Bool>;
}

// ports/secondary/ConfigurationPort.hx
interface ConfigurationPort {
    function getApiKey(provider: String): String;
    function getModelConfig(modelId: String): ModelConfiguration;
    function getServerConfig(): ServerConfiguration;
}
```

### 3. Adapters Layer (Implementations)
```haxe
// adapters/primary/web/HttpChatController.hx
class HttpChatController {
    private var chatService: ChatServicePort;
    
    public function new(chatService: ChatServicePort) {
        this.chatService = chatService;
    }
    
    public function handleChatRequest(httpRequest: HttpRequest): Promise<HttpResponse> {
        var dto = ChatRequestDto.fromJson(httpRequest.body);
        var message = new ChatMessage(dto.id, dto.content, dto.role);
        
        return chatService.processMessage(message)
            .then(response -> {
                var responseDto = ChatResponseDto.fromDomain(response);
                return new HttpResponse(200, responseDto.toJson());
            })
            .catchError(error -> {
                return new HttpResponse(500, '{"error": "${error.message}"}');
            });
    }
}

// adapters/secondary/ai-providers/OpenRouterAdapter.hx
class OpenRouterAdapter implements AIProviderPort {
    private var httpClient: HttpClient;
    private var configPort: ConfigurationPort;
    
    public function new(httpClient: HttpClient, configPort: ConfigurationPort) {
        this.httpClient = httpClient;
        this.configPort = configPort;
    }
    
    public function generateResponse(request: InferenceRequest): Promise<AIResponse> {
        var apiKey = configPort.getApiKey("openrouter");
        var headers = [
            "Authorization" => 'Bearer $apiKey',
            "Content-Type" => "application/json"
        ];
        
        var payload = {
            model: request.modelId,
            messages: request.messages.map(m -> {
                role: m.role,
                content: m.content
            })
        };
        
        return httpClient.post("https://openrouter.ai/api/v1/chat/completions", payload, headers)
            .then(response -> AIResponse.fromOpenRouterResponse(response));
    }
}
```

### 4. Application Layer (Use Cases)
```haxe
// application/usecases/ProcessChatUseCase.hx
class ProcessChatUseCase {
    private var aiInferenceService: AIInferenceService;
    private var storagePort: StoragePort;
    
    public function new(aiInferenceService: AIInferenceService, storagePort: StoragePort) {
        this.aiInferenceService = aiInferenceService;
        this.storagePort = storagePort;
    }
    
    public function execute(request: ChatRequestDto): Promise<ChatResponseDto> {
        // Convert DTO to domain entity
        var message = new ChatMessage(request.id, request.content, request.role);
        
        // Validate domain rules
        var validation = message.validate();
        if (!validation.isSuccess) {
            return Promise.reject(new ValidationError(validation.error));
        }
        
        // Create inference request
        var inferenceRequest = new InferenceRequest(message, request.modelId);
        
        // Process through domain service
        return aiInferenceService.processInference(inferenceRequest)
            .then(result -> {
                // Store conversation
                storagePort.saveMessage(message);
                
                // Convert back to DTO
                return ChatResponseDto.fromDomain(result);
            });
    }
}
```

## Dependency Injection Configuration

### Platform-Specific Composition Root
```haxe
// Main.hx (for each target platform)
class Main {
    static function main() {
        // Configure dependencies based on compilation target
        var container = createDependencyContainer();
        
        // Start application
        var app = container.resolve(Application);
        app.start();
    }
    
    static function createDependencyContainer(): DependencyContainer {
        var container = new DependencyContainer();
        
        // Register ports and adapters
        #if python
        container.register(AIProviderPort, () -> new OpenRouterAdapter(new PythonHttpClient(), new EnvConfigAdapter()));
        container.register(StoragePort, () -> new FileStorageAdapter("/tmp/chat_data"));
        #elseif php
        container.register(AIProviderPort, () -> new OpenRouterAdapter(new PhpHttpClient(), new EnvConfigAdapter()));
        container.register(StoragePort, () -> new DatabaseAdapter("mysql://localhost/chatdb"));
        #elseif java
        container.register(AIProviderPort, () -> new OpenRouterAdapter(new JavaHttpClient(), new PropertiesConfigAdapter()));
        container.register(StoragePort, () -> new JpaStorageAdapter());
        #end
        
        // Register domain services
        container.register(AIInferenceService, (c) -> new AIInferenceService(
            c.resolve(AIProviderPort),
            c.resolve(LoggingPort)
        ));
        
        // Register use cases
        container.register(ProcessChatUseCase, (c) -> new ProcessChatUseCase(
            c.resolve(AIInferenceService),
            c.resolve(StoragePort)
        ));
        
        return container;
    }
}
```

## Testing Strategy

### Unit Testing Domain Logic
```haxe
// tests/domain/services/AIInferenceServiceTest.hx
class AIInferenceServiceTest {
    var mockAIProvider: MockAIProviderPort;
    var mockLogger: MockLoggingPort;
    var service: AIInferenceService;
    
    @Before
    public function setup() {
        mockAIProvider = new MockAIProviderPort();
        mockLogger = new MockLoggingPort();
        service = new AIInferenceService(mockAIProvider, mockLogger);
    }
    
    @Test
    public function testProcessInference_ValidRequest_ReturnsResult() {
        // Arrange
        var request = new InferenceRequest("test-id", "Hello", "gpt-3.5-turbo");
        var expectedResponse = new AIResponse("Hello! How can I help?");
        mockAIProvider.setResponse(expectedResponse);
        
        // Act
        var result = service.processInference(request);
        
        // Assert
        Assert.equals("test-id", result.requestId);
        Assert.equals(expectedResponse.content, result.response.content);
        Assert.isTrue(mockLogger.wasInfoCalled());
    }
}
```

### Integration Testing with Real Adapters
```haxe
// tests/integration/OpenRouterIntegrationTest.hx
class OpenRouterIntegrationTest {
    @Test
    public function testOpenRouterAdapter_RealAPI_ReturnsResponse() {
        // This test uses real OpenRouter API
        var config = new TestConfigAdapter();
        var httpClient = new RealHttpClient();
        var adapter = new OpenRouterAdapter(httpClient, config);
        
        var request = new InferenceRequest("test", "Say hello", "gpt-3.5-turbo");
        var response = adapter.generateResponse(request);
        
        Assert.isNotNull(response.content);
        Assert.isTrue(response.content.length > 0);
    }
}
```

## Platform-Specific Considerations

### Python Target
- Use Python-specific HTTP libraries through adapters
- Leverage NumPy/TensorFlow through secondary adapters
- File system access through storage adapters

### WebAssembly Target
- Browser-specific adapters for fetch API
- Local storage adapters for persistence
- WebGL adapters for GPU acceleration

### PHP Target
- cURL-based HTTP adapters
- MySQL/PostgreSQL storage adapters
- WordPress plugin adapters

### Java Target
- Spring Boot integration through adapters
- JPA storage adapters
- Enterprise security adapters

### C# Target
- .NET Core HTTP adapters
- Entity Framework storage adapters
- Azure service adapters

## Benefits of This Architecture

1. **Testability**: Easy to mock dependencies and test business logic
2. **Platform Independence**: Core logic works across all Haxe targets
3. **Flexibility**: Easy to swap implementations (e.g., different AI providers)
4. **Maintainability**: Clear separation of concerns
5. **Scalability**: Easy to add new features without breaking existing code
6. **Compliance**: Supports different deployment requirements per platform

## Migration Strategy

1. **Phase 1**: Define ports and domain entities
2. **Phase 2**: Implement core domain services
3. **Phase 3**: Create adapters for current functionality
4. **Phase 4**: Migrate existing code to use new architecture
5. **Phase 5**: Add comprehensive testing
6. **Phase 6**: Implement platform-specific optimizations

This hexagonal architecture ensures our Haxe AI project remains maintainable, testable, and truly cross-platform while leveraging the unique strengths of each compilation target.