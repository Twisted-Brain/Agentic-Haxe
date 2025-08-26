<div align="center">
  <img src="../../assets/rd-banner.png" alt="R&D Banner">
</div>

# Component Reuse Pattern Documentation

## Overview

This document describes how components are designed for reuse across different Proof of Concepts (PoCs) in the Agentic Haxe project, following hexagonal architecture principles.

## Architecture Pattern

### Hexagonal Architecture Implementation

The project implements hexagonal architecture with clear separation between:

- **Domain Core**: Business logic independent of external concerns
- **Ports**: Interfaces defining contracts for external interactions
- **Adapters**: Platform-specific implementations of ports
- **Wiring**: Dependency injection and configuration

### Directory Structure

```
project/
├── domain/           # Core business logic (platform-independent)
│   ├── core/         # Domain entities and services
│   ├── ports/        # Interface definitions
│   └── types/        # Domain types and value objects
├── platform/         # Platform-specific implementations
│   ├── frontend/     # JavaScript/Browser implementations
│   └── core/         # Backend implementations (cpp, python, java, etc.)
└── wiring/           # Dependency injection and configuration
```

## Reusable Components

### 1. Frontend Components

#### WebAppMain.hx
- **Location**: `platform/frontend/WebAppMain.hx`
- **Purpose**: Main frontend application entry point
- **Reusability**: Can communicate with any backend through HTTP abstraction
- **Dependencies**: Uses platform-agnostic interfaces from `domain/ports/`

#### Platform Adapters
- **LoggerJs.hx**: Browser console logging implementation
- **PlatformClockJs.hx**: JavaScript Date/Performance API wrapper
- **HttpClientJs.hx**: XMLHttpRequest-based HTTP client

### 2. Domain Core (100% Reusable)

#### AiModel.hx
- **Location**: `domain/core/AiModel.hx`
- **Purpose**: AI model representation and configuration
- **Reusability**: Used across all PoCs without modification

#### Conversation.hx
- **Location**: `domain/core/Conversation.hx`
- **Purpose**: Chat conversation management
- **Reusability**: Platform-independent conversation logic

### 3. Port Interfaces (100% Reusable)

#### ILogger
- **Location**: `domain/ports/ILogger.hx`
- **Purpose**: Logging abstraction
- **Implementations**: LoggerJs, LoggerCpp, LoggerPython, etc.

#### IClock
- **Location**: `domain/ports/IClock.hx`
- **Purpose**: Time and timing abstraction
- **Implementations**: PlatformClockJs, PlatformClockCpp, etc.

#### IHttp
- **Location**: `domain/ports/IHttp.hx`
- **Purpose**: HTTP client abstraction
- **Implementations**: HttpClientJs, HttpClientCpp, etc.

### 4. Wiring Layer

#### DependencyContainer.hx
- **Location**: `wiring/DependencyContainer.hx`
- **Purpose**: Dependency injection container
- **Reusability**: Configures dependencies based on target platform

#### Platform Typedefs
- **Logger.hx**: Maps to platform-specific logger implementation
- **PlatformClock.hx**: Maps to platform-specific clock implementation
- **HttpClient.hx**: Maps to platform-specific HTTP client

## Cross-Platform Testing Results

### Successfully Tested Combinations

1. **JavaScript Frontend + Python ML Backend**
   - Frontend: `platform/frontend/WebAppMain.hx` compiled to JavaScript
   - Backend: Python ML service on port 8080
   - Status: ✅ Working

2. **JavaScript Frontend + Node.js Backend**
   - Frontend: Same JavaScript compilation
   - Backend: Node.js server on port 3000
   - Status: ✅ Working

3. **Shared Frontend Assets**
   - HTML: `platform/frontend/index.html`
   - CSS: `platform/frontend/webapp-styles.css`
   - Status: ✅ Reused across all frontend deployments

## Reuse Benefits

### Code Reuse Metrics
- **Domain Core**: 100% reusable across all PoCs
- **Port Interfaces**: 100% reusable across all PoCs
- **Frontend Logic**: 95% reusable (only HTTP endpoints differ)
- **Wiring Configuration**: 90% reusable (platform-specific mappings)

### Development Efficiency
- **Single Codebase**: One frontend works with multiple backends
- **Consistent API**: Same interfaces across all platforms
- **Reduced Testing**: Core logic tested once, works everywhere
- **Faster Development**: New PoCs reuse existing components

## Implementation Pattern

### Adding New Platform Support

1. **Create Platform Adapters**
   ```haxe
   // platform/core/newplatform/LoggerNewPlatform.hx
   package platform.core.newplatform;
   import domain.ports.ILogger;
   
   class LoggerNewPlatform implements ILogger {
       // Platform-specific implementation
   }
   ```

2. **Update Wiring Typedefs**
   ```haxe
   // wiring/Logger.hx
   #elseif newplatform
   typedef Logger = platform.core.newplatform.LoggerNewPlatform;
   ```

3. **Configure Build**
   ```hxml
   # build-newplatform.hxml
   --main frontend.WebAppMain
   --class-path platform
   --class-path domain
   --class-path wiring
   ```

### Frontend Reuse Process

1. **Compile for Target**: `haxe build-frontend.hxml`
2. **Copy Assets**: HTML and CSS files
3. **Configure Endpoints**: Update API base URLs if needed
4. **Deploy**: Same artifacts work with any compatible backend

## Best Practices

### Do's
- ✅ Keep domain logic platform-independent
- ✅ Use interfaces for all external dependencies
- ✅ Implement platform-specific adapters in `platform/` directory
- ✅ Use dependency injection for loose coupling
- ✅ Test core logic once, adapt for platforms

### Don'ts
- ❌ Put platform-specific code in domain layer
- ❌ Hardcode platform assumptions in business logic
- ❌ Skip interface definitions for external dependencies
- ❌ Duplicate business logic across platforms
- ❌ Tightly couple frontend to specific backend implementation

## Future Enhancements

### Planned Improvements
1. **C++ Backend Integration**: Complete C++ backend implementation
2. **WebAssembly Target**: Compile domain logic to WASM
3. **Mobile Platforms**: Add iOS/Android platform adapters
4. **Cloud Deployment**: Add cloud-specific platform adapters

### Scalability Considerations
- **Microservices**: Each PoC can become independent service
- **API Gateway**: Centralized routing to different backends
- **Load Balancing**: Distribute requests across platform implementations
- **Monitoring**: Unified logging and metrics across platforms

## Conclusion

The hexagonal architecture pattern enables significant code reuse across PoCs while maintaining clean separation of concerns. The same frontend can communicate with multiple backend implementations, and core business logic remains platform-independent.

This approach reduces development time, improves consistency, and enables rapid prototyping of new platform combinations.

<div align="center">
  <img src="../../assets/footer.png" alt="Footer">
</div>