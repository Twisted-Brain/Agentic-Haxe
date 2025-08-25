# Source Architecture Plan for Haxe AI Project

## Overview
This document outlines the planned restructuring of `/Users/lpm/Repo/Agentic-Haxe/src` to implement the architectural paradigms defined in `ARCHITECTURE_PARADIGMS.md`.

## Current Structure Analysis
```
src/
├── backend/
│   └── LlmGatewayMain.hx
├── frontend/
│   ├── WebAppMain.hx
│   ├── index.html
│   └── webapp-styles.css
└── shared/
    ├── ApiModels.hx
    └── SharedMain.hx
```

## Proposed Architecture Structure

### Backend Architecture (Server Targets)
**Targets**: Python, Java, PHP, C#, Neko
**Primary Paradigms**: Hexagonal Architecture + Event-Driven + CQRS + Functional

```
src/backend/
├── application/
│   ├── commands/
│   │   ├── handlers/
│   │   │   ├── ProcessInferenceCommandHandler.hx
│   │   │   ├── LoadModelCommandHandler.hx
│   │   │   └── ManageConversationCommandHandler.hx
│   │   └── models/
│   │       ├── ProcessInferenceCommand.hx
│   │       ├── LoadModelCommand.hx
│   │       └── ManageConversationCommand.hx
│   ├── queries/
│   │   ├── handlers/
│   │   │   ├── GetConversationQueryHandler.hx
│   │   │   ├── GetModelStatusQueryHandler.hx
│   │   │   └── GetAnalyticsQueryHandler.hx
│   │   └── models/
│   │       ├── GetConversationQuery.hx
│   │       ├── GetModelStatusQuery.hx
│   │       └── GetAnalyticsQuery.hx
│   ├── events/
│   │   ├── handlers/
│   │   │   ├── InferenceEventHandler.hx
│   │   │   ├── ModelEventHandler.hx
│   │   │   └── ConversationEventHandler.hx
│   │   └── domain/
│   │       ├── InferenceRequestedEvent.hx
│   │       ├── ModelLoadedEvent.hx
│   │       ├── ResponseGeneratedEvent.hx
│   │       └── ConversationUpdatedEvent.hx
│   └── services/
│       ├── InferenceOrchestrationService.hx
│       ├── ModelManagementService.hx
│       └── ConversationService.hx
├── domain/
│   ├── inference/
│   │   ├── entities/
│   │   │   ├── InferenceSession.hx
│   │   │   ├── AIModel.hx
│   │   │   └── InferenceResult.hx
│   │   ├── valueobjects/
│   │   │   ├── ModelId.hx
│   │   │   ├── InferenceRequest.hx
│   │   │   └── ResponseChunk.hx
│   │   ├── services/
│   │   │   ├── InferenceEngine.hx
│   │   │   └── ModelValidator.hx
│   │   └── repositories/
│   │       ├── IModelRepository.hx
│   │       └── IInferenceRepository.hx
│   ├── conversation/
│   │   ├── entities/
│   │   │   ├── Conversation.hx
│   │   │   ├── Message.hx
│   │   │   └── ConversationContext.hx
│   │   ├── valueobjects/
│   │   │   ├── ConversationId.hx
│   │   │   ├── MessageId.hx
│   │   │   └── ConversationMetadata.hx
│   │   ├── services/
│   │   │   ├── ConversationManager.hx
│   │   │   └── ContextProcessor.hx
│   │   └── repositories/
│   │       └── IConversationRepository.hx
│   └── shared/
│       ├── valueobjects/
│       │   ├── UserId.hx
│       │   ├── Timestamp.hx
│       │   └── ApiKey.hx
│       └── services/
│           ├── ValidationService.hx
│           └── SecurityService.hx
├── infrastructure/
│   ├── adapters/
│   │   ├── primary/
│   │   │   ├── http/
│   │   │   │   ├── HttpInferenceController.hx
│   │   │   │   ├── HttpConversationController.hx
│   │   │   │   └── HttpHealthController.hx
│   │   │   ├── websocket/
│   │   │   │   ├── WebSocketInferenceHandler.hx
│   │   │   │   └── WebSocketEventHandler.hx
│   │   │   └── grpc/
│   │   │       ├── GrpcInferenceService.hx
│   │   │       └── GrpcModelService.hx
│   │   └── secondary/
│   │       ├── persistence/
│   │       │   ├── SqlModelRepository.hx
│   │       │   ├── NoSqlConversationRepository.hx
│   │       │   └── InMemoryInferenceRepository.hx
│   │       ├── external/
│   │       │   ├── OpenRouterAdapter.hx
│   │       │   ├── HuggingFaceAdapter.hx
│   │       │   └── OpenAIAdapter.hx
│   │       ├── messaging/
│   │       │   ├── EventBusAdapter.hx
│   │       │   ├── MessageQueueAdapter.hx
│   │       │   └── StreamingAdapter.hx
│   │       └── caching/
│   │           ├── RedisCacheAdapter.hx
│   │           ├── InMemoryCacheAdapter.hx
│   │           └── ModelCacheAdapter.hx
│   ├── configuration/
│   │   ├── DependencyInjectionConfig.hx
│   │   ├── DatabaseConfig.hx
│   │   ├── ApiConfig.hx
│   │   └── SecurityConfig.hx
│   └── crosscutting/
│       ├── logging/
│       │   ├── ILogger.hx
│       │   ├── ConsoleLogger.hx
│       │   └── FileLogger.hx
│       ├── monitoring/
│       │   ├── MetricsCollector.hx
│       │   ├── HealthChecker.hx
│       │   └── PerformanceMonitor.hx
│       └── security/
│           ├── AuthenticationService.hx
│           ├── AuthorizationService.hx
│           └── EncryptionService.hx
└── main/
    ├── targets/
    │   ├── PythonMLMain.hx
    │   ├── JavaEnterpriseMain.hx
    │   ├── PhpHostingMain.hx
    │   ├── CSharpAzureMain.hx
    │   └── NekoPrototypingMain.hx
    └── bootstrap/
        ├── ApplicationBootstrap.hx
        ├── DependencyBootstrap.hx
        └── ConfigurationBootstrap.hx
```

### Frontend Architecture (Browser Targets)
**Targets**: JavaScript, WebAssembly
**Primary Paradigms**: Reactive Programming + Event-Driven + Functional

```
src/frontend/
├── application/
│   ├── state/
│   │   ├── stores/
│   │   │   ├── ConversationStore.hx
│   │   │   ├── ModelStore.hx
│   │   │   └── UIStore.hx
│   │   ├── actions/
│   │   │   ├── ConversationActions.hx
│   │   │   ├── ModelActions.hx
│   │   │   └── UIActions.hx
│   │   └── reducers/
│   │       ├── ConversationReducer.hx
│   │       ├── ModelReducer.hx
│   │       └── UIReducer.hx
│   ├── services/
│   │   ├── ApiClientService.hx
│   │   ├── WebSocketService.hx
│   │   ├── StreamingService.hx
│   │   └── CacheService.hx
│   └── reactive/
│       ├── streams/
│       │   ├── InferenceStream.hx
│       │   ├── ConversationStream.hx
│       │   └── EventStream.hx
│       └── operators/
│           ├── StreamOperators.hx
│           └── ReactiveUtils.hx
├── presentation/
│   ├── components/
│   │   ├── chat/
│   │   │   ├── ChatInterface.hx
│   │   │   ├── MessageBubble.hx
│   │   │   ├── InputField.hx
│   │   │   └── StreamingIndicator.hx
│   │   ├── models/
│   │   │   ├── ModelSelector.hx
│   │   │   ├── ModelStatus.hx
│   │   │   └── ModelConfiguration.hx
│   │   ├── layout/
│   │   │   ├── MainLayout.hx
│   │   │   ├── Sidebar.hx
│   │   │   ├── Header.hx
│   │   │   └── Footer.hx
│   │   └── common/
│   │       ├── Button.hx
│   │       ├── Loading.hx
│   │       ├── ErrorBoundary.hx
│   │       └── Notification.hx
│   ├── pages/
│   │   ├── ChatPage.hx
│   │   ├── ModelsPage.hx
│   │   ├── SettingsPage.hx
│   │   └── AnalyticsPage.hx
│   └── routing/
│       ├── Router.hx
│       ├── RouteConfig.hx
│       └── NavigationService.hx
├── infrastructure/
│   ├── adapters/
│   │   ├── http/
│   │   │   ├── HttpClient.hx
│   │   │   ├── ApiAdapter.hx
│   │   │   └── RequestInterceptor.hx
│   │   ├── websocket/
│   │   │   ├── WebSocketClient.hx
│   │   │   └── ReconnectionManager.hx
│   │   ├── storage/
│   │   │   ├── LocalStorageAdapter.hx
│   │   │   ├── SessionStorageAdapter.hx
│   │   │   └── IndexedDBAdapter.hx
│   │   └── wasm/
│   │       ├── WasmInferenceEngine.hx
│   │       ├── WasmModelLoader.hx
│   │       └── WasmMemoryManager.hx
│   ├── configuration/
│   │   ├── AppConfig.hx
│   │   ├── ApiEndpoints.hx
│   │   └── FeatureFlags.hx
│   └── utils/
│       ├── DomUtils.hx
│       ├── ValidationUtils.hx
│       ├── FormattingUtils.hx
│       └── PerformanceUtils.hx
└── main/
    ├── targets/
    │   ├── JavaScriptMain.hx
    │   └── WebAssemblyMain.hx
    ├── bootstrap/
    │   ├── AppBootstrap.hx
    │   └── ComponentRegistry.hx
    └── assets/
        ├── styles/
        │   ├── main.css
        │   ├── components.css
        │   ├── themes.css
        │   └── responsive.css
        └── static/
            ├── index.html
            ├── manifest.json
            └── favicon.ico
```

### Shared Architecture (Cross-Platform)
**Used by**: Both backend and frontend
**Primary Paradigms**: Functional Programming + Domain Types

```
src/shared/
├── domain/
│   ├── types/
│   │   ├── core/
│   │   │   ├── Result.hx
│   │   │   ├── Option.hx
│   │   │   ├── Either.hx
│   │   │   └── Validation.hx
│   │   ├── ai/
│   │   │   ├── ModelType.hx
│   │   │   ├── InferenceMode.hx
│   │   │   ├── ResponseFormat.hx
│   │   │   └── ModelCapability.hx
│   │   ├── http/
│   │   │   ├── HttpMethod.hx
│   │   │   ├── HttpStatus.hx
│   │   │   ├── ContentType.hx
│   │   │   └── ApiResponse.hx
│   │   └── events/
│   │       ├── EventType.hx
│   │       ├── EventPriority.hx
│   │       └── EventMetadata.hx
│   ├── contracts/
│   │   ├── api/
│   │   │   ├── IInferenceApi.hx
│   │   │   ├── IModelApi.hx
│   │   │   └── IConversationApi.hx
│   │   ├── repositories/
│   │   │   ├── IRepository.hx
│   │   │   ├── IReadRepository.hx
│   │   │   └── IWriteRepository.hx
│   │   └── services/
│   │       ├── IEventBus.hx
│   │       ├── ICache.hx
│   │       └── ILogger.hx
│   └── models/
│       ├── requests/
│       │   ├── InferenceRequestModel.hx
│       │   ├── ConversationRequestModel.hx
│       │   └── ModelRequestModel.hx
│       ├── responses/
│       │   ├── InferenceResponseModel.hx
│       │   ├── ConversationResponseModel.hx
│       │   └── ModelResponseModel.hx
│       └── events/
│           ├── DomainEvent.hx
│           ├── InferenceEvent.hx
│           └── ConversationEvent.hx
├── utils/
│   ├── functional/
│   │   ├── FunctionComposition.hx
│   │   ├── Monads.hx
│   │   ├── Functors.hx
│   │   └── Applicatives.hx
│   ├── async/
│   │   ├── Promise.hx
│   │   ├── Observable.hx
│   │   ├── AsyncUtils.hx
│   │   └── ConcurrencyUtils.hx
│   ├── validation/
│   │   ├── Validator.hx
│   │   ├── ValidationRules.hx
│   │   └── ValidationResult.hx
│   ├── serialization/
│   │   ├── JsonSerializer.hx
│   │   ├── BinarySerializer.hx
│   │   └── SerializationUtils.hx
│   └── collections/
│       ├── ImmutableList.hx
│       ├── ImmutableMap.hx
│       ├── Stream.hx
│       └── CollectionUtils.hx
└── constants/
    ├── ApiConstants.hx
    ├── ErrorCodes.hx
    ├── EventTypes.hx
    └── ConfigurationKeys.hx
```

## Target-Specific Implementations

### Backend Targets

#### Python ML Target
- **Focus**: ML model integration, NumPy/TensorFlow interop
- **Paradigms**: Functional + Reactive + Event-Driven
- **Special Features**: Native Python ML library bindings

#### Java Enterprise Target
- **Focus**: Enterprise services, Spring Boot integration
- **Paradigms**: Microservices + DDD + CQRS
- **Special Features**: JVM performance optimization

#### PHP Hosting Target
- **Focus**: Traditional web hosting, LAMP stack
- **Paradigms**: Hexagonal + CQRS
- **Special Features**: PHP framework integration

#### C# Azure Target
- **Focus**: Cloud microservices, Azure integration
- **Paradigms**: Microservices + Event-Driven + CQRS
- **Special Features**: .NET ecosystem integration

#### Neko Prototyping Target
- **Focus**: Rapid prototyping, scripting
- **Paradigms**: Functional + Hexagonal
- **Special Features**: Fast compilation, interactive development

### Frontend Targets

#### JavaScript Target
- **Focus**: Traditional web applications
- **Paradigms**: Reactive + Event-Driven + Functional
- **Special Features**: DOM manipulation, browser APIs

#### WebAssembly Target
- **Focus**: High-performance browser AI
- **Paradigms**: Functional + Reactive
- **Special Features**: Near-native performance, memory management

## Build Configuration

### Multi-Target Build Files
```
build/
├── backend/
│   ├── python-ml.hxml
│   ├── java-enterprise.hxml
│   ├── php-hosting.hxml
│   ├── csharp-azure.hxml
│   └── neko-prototyping.hxml
├── frontend/
│   ├── javascript.hxml
│   └── webassembly.hxml
└── shared/
    ├── types.hxml
    ├── utils.hxml
    └── contracts.hxml
```

## Implementation Strategy

### Phase 1: Core Architecture (Week 1-2)
1. Implement shared domain types and contracts
2. Create basic hexagonal architecture structure
3. Set up dependency injection framework
4. Implement functional programming utilities

### Phase 2: Backend Implementation (Week 3-4)
1. Implement CQRS pattern for commands and queries
2. Add event-driven architecture with event sourcing
3. Create adapter implementations for each target
4. Set up target-specific main classes

### Phase 3: Frontend Implementation (Week 5-6)
1. Implement reactive programming patterns
2. Create component-based UI architecture
3. Add WebSocket and streaming support
4. Implement WebAssembly optimizations

### Phase 4: Integration & Testing (Week 7-8)
1. Cross-platform integration testing
2. Performance benchmarking
3. Security testing
4. Documentation and examples

## Benefits of This Architecture

### Separation of Concerns
- **Domain Logic**: Pure business logic, platform-independent
- **Application Logic**: Use cases and workflows
- **Infrastructure**: Platform-specific implementations
- **Presentation**: UI and user interaction

### Testability
- **Unit Tests**: Domain and application logic
- **Integration Tests**: Adapter implementations
- **End-to-End Tests**: Complete workflows
- **Performance Tests**: Target-specific benchmarks

### Maintainability
- **Clear Dependencies**: Hexagonal architecture prevents coupling
- **Functional Approach**: Immutable data, pure functions
- **Event-Driven**: Loose coupling between components
- **CQRS**: Optimized read/write operations

### Scalability
- **Microservices Ready**: Each domain can be a separate service
- **Event Sourcing**: Complete audit trail and replay capability
- **Reactive Streams**: Handle high-throughput scenarios
- **Multi-Target**: Deploy to optimal platforms

This architecture provides a solid foundation for implementing all the PoCs while maintaining code quality, testability, and platform-specific optimizations.