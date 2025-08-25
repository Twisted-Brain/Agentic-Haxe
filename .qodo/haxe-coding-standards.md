# Haxe Coding Standards for Agentic-Haxe

## General Principles

### 1. Type Safety
- Always specify explicit types where possible
- Use type inference only when types are obvious
- Leverage Haxe's static typing for cross-platform safety
- Avoid `Dynamic` type unless absolutely necessary

### 2. Code Style
- Use tabs for indentation (consistent with existing codebase)
- Line length should not exceed 120 characters
- Use meaningful variable and function names
- Add blank lines to separate logical code blocks

## Naming Conventions

### 1. Classes and Interfaces
```haxe
// Classes: PascalCase
class ApiModels { }
class LlmGatewayMain { }
class WebAppMain { }

// Interfaces: PascalCase with 'I' prefix when needed
interface IApiClient { }
```

### 2. Methods and Variables
```haxe
// Methods: camelCase
public function processRequest() { }
public function handleApiResponse() { }

// Variables: camelCase
var apiResponse: String;
var userMessage: String;
var isConnected: Bool;
```

### 3. Constants and Static Fields
```haxe
// Constants: UPPER_CASE
static inline var DEFAULT_PORT: Int = 8080;
static inline var API_VERSION: String = "v1";
static inline var MAX_RETRIES: Int = 3;
```

### 4. Packages and Modules
```haxe
// Packages: lowercase, separated by dots
package frontend.ui;
package backend.gateway;
package shared.models;
```

## File Organization

### 1. File Structure
```haxe
// File header with package declaration
package shared.models;

// Imports (grouped and sorted)
import haxe.Http;
import haxe.Json;

// Class documentation
/**
 * Represents API request/response models for cross-platform communication
 */
class ApiModels {
    // Constants first
    static inline var API_TIMEOUT: Int = 30000;
    
    // Public fields
    public var message: String;
    
    // Private fields
    private var _internal: String;
    
    // Constructor
    public function new() {
        // Implementation
    }
    
    // Public methods
    public function processMessage(): String {
        // Implementation
    }
    
    // Private methods
    private function _validateInput(): Bool {
        // Implementation
    }
}
```

### 2. Import Guidelines
- Group imports logically (standard library, external libraries, project modules)
- Sort imports alphabetically within groups
- Use specific imports rather than wildcard imports
- Remove unused imports

## Cross-Platform Considerations

### 1. Conditional Compilation
```haxe
// Use sparingly and document clearly
#if js
    // JavaScript-specific code
    js.Browser.window.console.log("Frontend logging");
#elseif cpp
    // C++-specific code
    Sys.println("Backend logging");
#else
    // Fallback for other targets
    trace("Generic logging");
#end
```

### 2. Platform-Agnostic Code
```haxe
// Prefer platform-neutral implementations
class Logger {
    public static function log(message: String): Void {
        #if js
            js.Browser.console.log(message);
        #elseif cpp
            Sys.println(message);
        #else
            trace(message);
        #end
    }
}
```

## Error Handling

### 1. Exception Handling
```haxe
// Use proper exception handling
try {
    var result = processApiRequest(data);
    return result;
} catch (e: Dynamic) {
    Logger.log('Error processing request: $e');
    throw new Exception('Failed to process API request');
}
```

### 2. Return Types for Error Cases
```haxe
// Use Result/Option types when appropriate
enum Result<T, E> {
    Success(value: T);
    Error(error: E);
}

public function parseApiResponse(json: String): Result<ApiResponse, String> {
    try {
        var parsed = Json.parse(json);
        return Success(new ApiResponse(parsed));
    } catch (e: Dynamic) {
        return Error('Invalid JSON format: $e');
    }
}
```

## Documentation Standards

### 1. Class Documentation
```haxe
/**
 * Handles communication with OpenRouter API
 * 
 * This class provides a gateway interface for LLM requests,
 * managing authentication and request/response formatting.
 * 
 * @example
 * ```haxe
 * var gateway = new LlmGateway();
 * var response = gateway.sendRequest(userMessage);
 * ```
 */
class LlmGateway {
    // Implementation
}
```

### 2. Method Documentation
```haxe
/**
 * Processes incoming API request and forwards to OpenRouter
 * 
 * @param request The incoming API request data
 * @param apiKey The OpenRouter API key for authentication
 * @return The processed response from the LLM service
 * @throws Exception When API key is invalid or request fails
 */
public function processRequest(request: ApiRequest, apiKey: String): ApiResponse {
    // Implementation
}
```

### 3. Inline Comments
```haxe
// Single-line comments for brief explanations
var timeout = 30000; // 30 seconds in milliseconds

/* Multi-line comments for complex logic */
/*
 * Complex algorithm explanation:
 * 1. Parse incoming request
 * 2. Validate against schema
 * 3. Forward to external API
 * 4. Transform response format
 */
```

## Performance Guidelines

### 1. Memory Management
```haxe
// Avoid creating unnecessary objects in loops
var results = new Array<String>();
for (item in items) {
    // Reuse objects when possible
    results.push(processItem(item));
}
```

### 2. String Handling
```haxe
// Use StringBuf for multiple concatenations
var buffer = new StringBuf();
for (line in lines) {
    buffer.add(line);
    buffer.add("\n");
}
var result = buffer.toString();
```

### 3. Target-Specific Optimizations
```haxe
// Consider target-specific performance characteristics
#if js
    // JavaScript-optimized approach
    untyped __js__("// Direct JS when needed");
#elseif cpp
    // C++-optimized approach using native types
    var nativeArray: cpp.NativeArray<Int> = cpp.NativeArray.alloc(size);
#end
```

## Testing Patterns

### 1. Unit Test Structure
```haxe
package tests;

class ApiModelsTest {
    public function new() {}
    
    public function testRequestSerialization(): Void {
        var request = new ApiRequest("test message");
        var json = request.toJson();
        
        // Assertions
        Assert.isTrue(json.indexOf("test message") != -1);
    }
    
    public function testResponseDeserialization(): Void {
        var jsonString = '{"response": "test reply"}';
        var response = ApiResponse.fromJson(jsonString);
        
        // Assertions
        Assert.equals("test reply", response.message);
    }
}
```

### 2. Cross-Platform Testing
```haxe
// Test shared code across all targets
#if test
class CrossPlatformTest {
    public function testSharedFunctionality(): Void {
        var model = new SharedModel();
        var result = model.processData("test");
        
        // Should work identically across all targets
        Assert.equals("processed: test", result);
    }
}
#end
```

## Security Best Practices

### 1. Input Validation
```haxe
public function validateApiKey(key: String): Bool {
    if (key == null || key.length == 0) {
        return false;
    }
    
    // Validate format (example)
    var keyPattern = ~/^sk-[a-zA-Z0-9]+$/;
    return keyPattern.match(key);
}
```

### 2. Sensitive Data Handling
```haxe
// Never log sensitive information
public function processApiKey(key: String): Void {
    if (!validateApiKey(key)) {
        Logger.log("Invalid API key format"); // Don't log the actual key
        throw new Exception("Invalid API key");
    }
    
    // Use key for authentication
}
```

## Common Anti-Patterns to Avoid

### 1. Overuse of Dynamic Types
```haxe
// Avoid
var data: Dynamic = getData();
var value = data.someField; // No type safety

// Prefer
var data: ApiResponse = getData();
var value: String = data.message; // Type-safe access
```

### 2. Platform-Specific Code in Shared Modules
```haxe
// Avoid in shared code
#if js
    // JavaScript-specific implementation
#end

// Prefer: Keep shared code platform-neutral
// Use dependency injection for platform-specific behavior
```

### 3. Inconsistent Error Handling
```haxe
// Avoid mixed error handling styles
public function method1(): String {
    return null; // Indicates error
}

public function method2(): String {
    throw new Exception("Error"); // Throws exception
}

// Prefer consistent approach across the project
```