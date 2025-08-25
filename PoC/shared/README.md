# Shared Core Libraries

This directory contains the shared core libraries that form the foundation of our Hexagonal Architecture across all Haxe targets and PoCs. These super-libraries provide consistent functionality while maintaining platform independence.

## Core Library Architecture

```
shared/
├── README.md              # This file
├── ai-core/               # AI Core Library
│   ├── inference/         # Core inference logic, model loading, tokenization
│   ├── streaming/         # Stream handling, chunk processing, backpressure management
│   ├── memory/            # Memory optimization, caching strategies, GC optimization
│   ├── validation/        # Input/output validation, security checks
│   └── math/              # Vector operations, matrix operations, statistical functions
├── api-interfaces/        # API Interfaces Library
│   ├── http/              # HTTP client/server abstractions, WebSocket, REST API standards
│   ├── providers/         # AI provider contracts (OpenRouter, OpenAI, Anthropic)
│   ├── storage/           # Storage abstractions (database, filesystem, cache)
│   ├── messaging/         # Message queue, event bus, pub/sub interfaces
│   └── security/          # Authentication, authorization, encryption interfaces
├── utils/                 # Utilities Library
│   ├── async/             # Promise utilities, async iterators, timeout/retry mechanisms
│   ├── collections/       # Array, Map, Set, Queue utilities
│   ├── string/            # String manipulation, JSON handling, URL utilities
│   ├── validation/        # Validation helpers, input sanitization, format validation
│   ├── logging/           # Logging utilities, formatters, level management
│   ├── crypto/            # Hashing, encryption, random generation utilities
│   └── performance/       # Benchmarking, profiling, metrics collection
└── types/                 # Types Library
    ├── core/              # AI model types, inference requests/results, tokens
    ├── http/              # HTTP request/response types, headers, status codes
    ├── errors/            # AI-specific errors, validation errors, network errors
    ├── events/            # AI events, system events, user events
    ├── configuration/     # AI, server, security configuration types
    └── metrics/           # Performance, usage, error metrics
```

## Core Library Components

### `ai-core/` - AI Core Library
The foundational AI processing library used across all targets:
- **inference/**: Core inference logic, model loading, tokenization
- **streaming/**: Stream handling, chunk processing, backpressure management
- **memory/**: Memory optimization, caching strategies, GC optimization
- **validation/**: Input/output validation, security checks
- **math/**: Vector operations, matrix operations, statistical functions

### `api-interfaces/` - API Interfaces Library
Standardized interfaces for external communication:
- **http/**: HTTP client/server abstractions, WebSocket, REST API standards
- **providers/**: AI provider contracts (OpenRouter, OpenAI, Anthropic)
- **storage/**: Storage abstractions (database, filesystem, cache)
- **messaging/**: Message queue, event bus, pub/sub interfaces
- **security/**: Authentication, authorization, encryption interfaces

### `utils/` - Utilities Library
Common utility functions and helpers:
- **async/**: Promise utilities, async iterators, timeout/retry mechanisms
- **collections/**: Array, Map, Set, Queue utilities
- **string/**: String manipulation, JSON handling, URL utilities
- **validation/**: Validation helpers, input sanitization, format validation
- **logging/**: Logging utilities, formatters, level management
- **crypto/**: Hashing, encryption, random generation utilities
- **performance/**: Benchmarking, profiling, metrics collection

### `types/` - Types Library
Shared type definitions and data structures:
- **core/**: AI model types, inference requests/results, tokens
- **http/**: HTTP request/response types, headers, status codes
- **errors/**: AI-specific errors, validation errors, network errors
- **events/**: AI events, system events, user events
- **configuration/**: AI, server, security configuration types
- **metrics/**: Performance, usage, error metrics

## Usage in PoCs

Each PoC implementation can import and use these shared components:

```haxe
// Example usage in a PoC implementation
import shared.ai_core.AIModel;
import shared.api_interfaces.OpenRouterAPI;
import shared.utils.HttpClient;
import shared.types.AITypes;

class MyAIImplementation extends AIModel {
    var apiClient: OpenRouterAPI;
    
    public function new() {
        super();
        this.apiClient = new OpenRouterAPI();
    }
    
    public function processRequest(request: ChatRequest): ChatResponse {
        // Implementation using shared components
    }
}
```

## Development Guidelines

### Adding New Shared Components
1. Determine the appropriate directory (`ai-core`, `api-interfaces`, `utils`, or `types`)
2. Create the component with clear documentation
3. Ensure platform-agnostic implementation
4. Add comprehensive type annotations
5. Include unit tests
6. Update this README.md

### Platform Compatibility
All shared components must be compatible with all Haxe compilation targets:
- JavaScript (Node.js)
- Python
- PHP
- Java
- C#
- WebAssembly
- Neko
- C++

### Code Standards
- Use clear, descriptive naming
- Include comprehensive documentation
- Follow Haxe coding conventions
- Ensure type safety
- Handle errors gracefully
- Optimize for performance

## Testing

Shared components include their own test suites:
```bash
# Run tests for shared components
haxe -main TestRunner -cp shared -cp tests/shared
```

## Versioning

Shared components follow semantic versioning:
- **Major**: Breaking API changes
- **Minor**: New features, backward compatible
- **Patch**: Bug fixes, backward compatible

## Dependencies

Shared components minimize external dependencies to ensure broad compatibility:
- Core Haxe standard library only
- Platform-specific conditionals where necessary
- Optional dependencies clearly marked