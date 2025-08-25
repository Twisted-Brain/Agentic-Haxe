# Agentic-Haxe Project Guidelines

## Project Overview
This is a Proof of Concept (PoC) demonstrating Haxe's cross-platform capabilities by building both frontend (JavaScript) and backend (C++) components from a single codebase, with shared models and utilities.

## Core Architecture Principles

### 1. Multi-Target Compilation Strategy
- **Frontend**: Haxe → JavaScript (browser execution)
- **Backend**: Haxe → C++ (native HTTP server)
- **Shared Code**: Common models and utilities across all targets
- Always maintain type safety across compilation targets

### 2. Code Organization
- `src/frontend/`: Web application components (compile to JS)
- `src/backend/`: Server-side logic (compile to C++)
- `src/shared/`: Cross-platform models and utilities
- `bin/`: Compiled output directory
- `tests/`: Test files for shared components

### 3. Shared Kernel Pattern
- All shared models must be defined in `src/shared/`
- Use `ApiModels.hx` for common data structures
- Ensure type definitions work across all compilation targets
- Shared code should be target-agnostic

## Development Workflow

### 1. DevOps Collaboration Cycle
**Team Structure**:
- **Illia (AI Dev)**: Sole coder responsible for all code implementation
- **Lars (Ops)**: System designer responsible for architecture and operations
- **Team Language**: Danish (internal communication)

**Development Cycle**: Reflect → Code → Try → Correct → Next Reflection

1. **Reflect**: Lars and Illia collaborate on system design, requirements analysis, and architectural decisions
2. **Code**: Illia implements the solution following established guidelines and specifications
3. **Try**: Test the implementation across all compilation targets (frontend JS, backend C++, shared)
4. **Correct**: Illia fixes any issues found during testing phase
5. **Next Reflection**: Review results, learn from implementation, plan next iteration

This cycle ensures continuous improvement and maintains alignment between system design (Ops) and implementation (Dev).

### 2. Environment Setup
```bash
# Install dependencies
make install

# Full build
make build

# Development with auto-serve
make dev
```

### 3. Build Process
- Use `make build` for full project compilation
- Use target-specific builds: `make frontend`, `make backend`, `make shared`
- Always verify builds before committing code
- Run `make test` to validate shared components

### 4. Development Server
- Frontend development: `make serve-frontend` (port 8000)
- Backend requires `OPENROUTER_API_KEY` environment variable
- Use `make dev` for integrated frontend development

## Code Quality Standards

### 1. Haxe Coding Conventions
- Use PascalCase for classes and interfaces
- Use camelCase for methods and variables
- Use UPPER_CASE for constants
- Always specify types explicitly where possible
- Use proper access modifiers (public, private, etc.)

### 2. Cross-Platform Compatibility
- Avoid platform-specific APIs in shared code
- Use conditional compilation only when necessary
- Test shared code across all target platforms
- Document any platform-specific limitations

### 3. Error Handling
- Use proper exception handling in backend code
- Validate all external API inputs
- Provide meaningful error messages
- Log errors appropriately for debugging

## Architecture Guidelines

### 1. Separation of Concerns
- Frontend handles UI/UX and user interactions
- Backend acts as API gateway to external services
- Shared code contains only business logic and models
- No UI logic in backend or shared modules

### 2. API Design
- RESTful endpoints for frontend-backend communication
- Consistent request/response formats using shared models
- Proper HTTP status codes and error responses
- API versioning considerations for future expansion

### 3. Performance Considerations
- Backend compiled to C++ for optimal performance
- Minimize frontend bundle size
- Efficient data serialization between targets
- Consider caching strategies for external API calls

## Security Guidelines

### 1. Environment Variables
- Never commit API keys or secrets
- Use `.env.example` for documentation
- Validate all environment variables at startup
- Secure handling of OpenRouter API credentials

### 2. Input Validation
- Sanitize all user inputs
- Validate API request formats
- Implement rate limiting considerations
- Secure external API communications

## Testing Strategy

### 1. Shared Code Testing
- Run `make test` for shared component validation
- Test cross-platform compatibility
- Validate type safety across targets
- Unit tests for critical business logic

### 2. Integration Testing
- Test frontend-backend communication
- Validate OpenRouter API integration
- End-to-end workflow testing
- Error handling scenarios

## Maintenance and Operations

### 1. Dependency Management
- Keep `haxelib.json` updated
- Document version requirements
- Test with updated dependencies
- Monitor for security updates

### 2. Build Automation
- Use provided Makefile commands
- Maintain build script (`build.sh`) functionality
- Clean builds when switching branches: `make clean`
- Verify all targets compile successfully

### 3. Documentation
- Update README.md for significant changes
- Document API changes and additions
- Maintain inline code comments
- Keep project guidelines current

## Common Issues and Solutions

### 1. Port Conflicts
```bash
# Kill processes on port 8000
lsof -ti:8000 | xargs kill -9
```

### 2. Build Issues
- Run `make clean` before troubleshooting
- Verify Haxe and C++ toolchain installation
- Check dependency versions with `haxelib list`

### 3. Environment Issues
- Ensure all required environment variables are set
- Verify Python 3 and Node.js availability
- Check C++ compiler configuration

## Contributing Guidelines

### 1. Code Changes
- Test all compilation targets before committing
- Maintain backward compatibility in shared models
- Follow established coding conventions
- Update tests for new functionality

### 2. Documentation Updates
- Update relevant documentation for changes
- Include examples for new features
- Maintain accuracy of setup instructions
- Update project guidelines as needed

### 3. Performance Considerations
- Profile changes that might affect performance
- Consider impact on all compilation targets
- Optimize for the most constraining target
- Document performance implications