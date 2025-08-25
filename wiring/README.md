# Wiring - Dependency Injection System

![Agentic Haxe Logo](/assets/logo.png)

This directory contains the **typedef-bindings** and dependency injection framework for the hexagonal architecture.

## Overview

The wiring system provides compile-time dependency injection using Haxe's typedef system. This eliminates runtime overhead while maintaining a clean separation between domain logic and platform-specific implementations. The goal is to define abstract interfaces in the `domain` layer and "wire" them to concrete, platform-specific implementations at compile time.

## How It Works

### 1. Typedef Bindings

The core of the wiring system is conditional compilation. For each abstract port (interface) defined in `domain/ports/`, we will create a corresponding `typedef` in the `wiring` directory. This `typedef` will resolve to a specific implementation from the `platform` directory based on the compilation target.

**Conceptual Example:**

A file like `wiring/HttpClient.hx` would contain:

```haxe
// wiring/HttpClient.hx
#if js
typedef HttpClient = platform.js.HttpClientJs;
#elseif cpp
typedef HttpClient = platform.cpp.HttpClientCpp;
#else
#error "Unsupported platform for HttpClient"
#end
```

### 2. Dependency Container (Future Goal)

A central `DependencyContainer` can be implemented to provide lazy initialization and clean access to all dependencies. This would allow any part of the application to request a dependency without knowing its concrete implementation.

```haxe
// Conceptual usage
var httpClient = DependencyContainer.getHttpClient();
var logger = DependencyContainer.getLogger();
```

### 3. Application Bootstrap (Future Goal)

An `ApplicationBootstrap` class will handle the proper initialization and shutdown sequence for the application, ensuring all dependencies are correctly configured before the main application logic runs.

```haxe
// Conceptual usage
ApplicationBootstrap.initialize();
// Your application code here
ApplicationBootstrap.shutdown();
```

## Benefits

1.  **Zero Runtime Overhead** - All binding happens at compile time.
2.  **Clean Domain Code** - No platform-specific imports in the domain layer.
3.  **Easy Testing** - Mock dependencies can be injected for testing.
4.  **Type Safety** - Full compile-time type checking.
5.  **Platform Agnostic** - The same domain code works across all Haxe targets.

## Adding New Dependencies

1.  Create an interface in `domain/ports/`.
2.  Implement the corresponding adapters in `platform/*/`.
3.  Create a `typedef` binding in the `wiring/` directory.
4.  (Optional) Add the new dependency to the `DependencyContainer`.
5.  (Optional) Update the `ApplicationBootstrap` if needed.

## Supported Platforms

- JavaScript (js)
- C++ (cpp)
- Java (java)
- Python (python)
- PHP (php)
- C# (cs)
- Neko (neko)

Unsupported platforms will generate compile-time errors with helpful messages.