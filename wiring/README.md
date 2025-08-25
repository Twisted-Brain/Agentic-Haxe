# Wiring - Dependency Injection System

This directory contains the **typedef-bindings** and dependency injection framework for the hexagonal architecture.

## Overview

The wiring system provides compile-time dependency injection using Haxe's typedef system. This eliminates runtime overhead while maintaining clean separation between domain logic and platform-specific implementations.

## Architecture

```
wiring/
├── HttpClient.hx          # HTTP client typedef bindings
├── Logger.hx              # Logger typedef bindings  
├── PlatformClock.hx       # Clock typedef bindings
├── DependencyContainer.hx # Central dependency container
├── ApplicationBootstrap.hx # Application initialization
└── README.md              # This documentation
```

## How It Works

### 1. Typedef Bindings

Each typedef file maps a generic interface to platform-specific implementations:

```haxe
// HttpClient.hx
#if js
typedef HttpClient = platform.js.HttpClientJs;
#elseif cpp
typedef HttpClient = platform.cpp.HttpClientCpp;
#end
```

### 2. Dependency Container

`DependencyContainer` provides lazy initialization and clean access to all dependencies:

```haxe
var httpClient = DependencyContainer.getHttpClient();
var logger = DependencyContainer.getLogger();
```

### 3. Application Bootstrap

`ApplicationBootstrap` handles proper initialization sequence:

```haxe
ApplicationBootstrap.initialize();
// Your application code here
ApplicationBootstrap.shutdown();
```

## Usage Examples

### Basic Usage

```haxe
import wiring.ApplicationBootstrap;
import wiring.DependencyContainer;

class Main {
    static function main() {
        // Initialize application
        ApplicationBootstrap.initialize();
        
        // Use dependencies
        var logger = DependencyContainer.getLogger();
        logger.info("Application started");
        
        var httpClient = DependencyContainer.getHttpClient();
        // Use HTTP client...
        
        // Shutdown gracefully
        ApplicationBootstrap.shutdown();
    }
}
```

### Testing with Dependency Injection

```haxe
// In your test setup
DependencyContainer.reset();
DependencyContainer.inject(
    httpClient: new MockHttpClient(),
    logger: new MockLogger()
);

// Run your tests...

// Cleanup
DependencyContainer.reset();
```

## Benefits

1. **Zero Runtime Overhead** - All binding happens at compile time
2. **Clean Domain Code** - No platform-specific imports in domain layer
3. **Easy Testing** - Mock dependencies can be injected for testing
4. **Type Safety** - Full compile-time type checking
5. **Platform Agnostic** - Same code works across all Haxe targets

## Adding New Dependencies

1. Create interface in `domain/ports/`
2. Implement adapters in `platform/*/`
3. Create typedef binding in `wiring/`
4. Add to `DependencyContainer`
5. Update `ApplicationBootstrap` if needed

## Supported Platforms

- JavaScript (js)
- C++ (cpp)
- Java (java)
- Python (python)
- PHP (php)
- C# (cs)
- Neko (neko)

Unsupported platforms will generate compile-time errors with helpful messages.