# Build and Deployment Rules for Agentic-Haxe

## Build System Overview

The project uses a Makefile-based build system that supports multi-target Haxe compilation. All builds should go through the established build pipeline to ensure consistency and reliability.

## Build Rules and Standards

### 1. Mandatory Build Verification
- **Always run `make clean` before major builds** to ensure clean state
- **Test all compilation targets** before committing code changes
- **Verify shared code compatibility** across all targets (JS, C++, test)
- **Run `make test`** to validate shared components before deployment

### 2. Build Command Usage
```bash
# Complete project build (required before deployment)
make build

# Target-specific builds (development use)
make frontend    # Compiles to JavaScript
make backend     # Compiles to C++
make shared      # Compiles shared library for testing

# Development workflow
make dev         # Build and serve frontend on port 8000
make install     # Install required Haxe libraries
make clean       # Remove all build artifacts
```

### 3. Build Output Standards
- All compiled outputs must go to the `bin/` directory
- **Frontend**: `bin/frontend.js` (JavaScript bundle)
- **Backend**: `bin/backend` (C++ executable)
- **Shared**: `bin/shared.js` (Node.js compatible module)
- Build artifacts should not be committed to version control

### 4. Build Configuration
- Use `build.hxml` for Haxe compilation configuration
- Maintain `haxelib.json` for dependency declarations
- Keep build scripts (`build.sh`) executable and documented
- Environment-specific configurations via environment variables only

## Dependency Management Rules

### 1. Library Installation
```bash
# Install all project dependencies
make install

# Manual library management (when needed)
haxelib install <library-name>
haxelib list  # Verify installed libraries
```

### 2. Dependency Guidelines
- **All required libraries** must be declared in `haxelib.json`
- **Version pinning** should be considered for production stability
- **Test dependency compatibility** across all compilation targets
- **Document any special library requirements** in README.md

### 3. Library Updates
- Test thoroughly when updating library versions
- Verify compatibility with all Haxe compilation targets
- Update `haxelib.json` to reflect version changes
- Document breaking changes in upgrade notes

## Environment Configuration

### 1. Required Environment Variables
```bash
# Backend operation (required)
export OPENROUTER_API_KEY="your-openrouter-api-key"

# Optional configurations
export LLM_MODEL="model-name"          # Specify LLM model
export PORT="8080"                     # Backend server port
export FRONTEND_PORT="8000"            # Frontend development server port
```

### 2. Environment Setup Rules
- **Never commit API keys** or sensitive environment variables
- **Use `.env.example`** to document required environment variables
- **Validate environment variables** at application startup
- **Provide clear error messages** for missing required variables

### 3. Development Environment
```bash
# Recommended development setup
make install     # Install dependencies
make dev         # Start development environment

# Environment validation
make test        # Verify shared components work
OPENROUTER_API_KEY="test-key" make run-backend  # Test backend
```

## Testing Requirements

### 1. Pre-Deployment Testing
- **Shared code testing**: `make test` must pass
- **Cross-platform compilation**: All targets must compile successfully
- **Integration testing**: Frontend-backend communication must work
- **Environment testing**: Test with actual API keys (in secure environment)

### 2. Test Execution Standards
```bash
# Required test sequence before deployment
make clean
make build
make test

# Backend testing with environment
OPENROUTER_API_KEY="actual-key" make run-backend

# Frontend testing
make serve-frontend
# Manual verification of web interface
```

### 3. Test Coverage Requirements
- All shared models must have test coverage
- Cross-platform functionality must be tested on all targets
- API integration points must have integration tests
- Error handling scenarios must be covered

## Deployment Rules

### 1. Pre-Deployment Checklist
- [ ] All tests pass (`make test`)
- [ ] All compilation targets build successfully (`make build`)
- [ ] Environment variables are properly configured
- [ ] API keys are validated and working
- [ ] Frontend serves correctly (`make serve-frontend`)
- [ ] Backend starts and responds (`make run-backend`)
- [ ] No build warnings or errors

### 2. Production Build Process
```bash
# Standard production build sequence
make clean
make install
make build

# Verification
make test
OPENROUTER_API_KEY="prod-key" ./bin/backend &
make serve-frontend
```

### 3. Deployment Environment Setup
- Ensure Haxe compiler is available in production environment
- C++ compilation toolchain must be installed for backend
- Python 3 required for frontend serving (development)
- Node.js required for shared library testing

## Performance and Optimization Rules

### 1. Build Performance
- Use incremental builds during development (target-specific make commands)
- Run full clean builds before major deployments
- Monitor build times and optimize for slow compilation targets
- Cache dependencies when possible (`haxelib` local cache)

### 2. Runtime Performance
- **Backend (C++)**: Optimize for low-latency API gateway performance
- **Frontend (JS)**: Minimize bundle size and runtime overhead
- **Shared code**: Avoid performance-heavy operations in cross-platform code
- Profile performance-critical paths regularly

### 3. Resource Management
- Monitor memory usage in C++ backend
- Optimize JavaScript bundle size for frontend
- Clean up build artifacts regularly (`make clean`)
- Monitor disk space usage in build directories

## Troubleshooting and Maintenance

### 1. Common Build Issues
```bash
# Port conflicts (development)
lsof -ti:8000 | xargs kill -9    # Kill frontend server
lsof -ti:8080 | xargs kill -9    # Kill backend server

# Dependency issues
make clean
haxelib list                      # Verify libraries
make install                      # Reinstall dependencies

# Compilation errors
haxe --version                    # Verify Haxe installation
g++ --version                     # Verify C++ compiler
```

### 2. Build System Maintenance
- Regularly update build scripts for new requirements
- Keep Makefile commands documented and consistent
- Verify build system works on fresh environments
- Update dependency lists when adding new libraries

### 3. CI/CD Integration
- Build system should be compatible with continuous integration
- All make commands should be non-interactive
- Environment variables should be configurable externally
- Build status should be clearly indicated (exit codes)

## Security Considerations in Build Process

### 1. Secret Management
- Never include API keys in build scripts
- Use environment variables for all sensitive configuration
- Ensure build artifacts don't contain embedded secrets
- Validate that logs don't expose sensitive information

### 2. Dependency Security
- Regularly audit haxelib dependencies for vulnerabilities
- Use specific versions rather than latest for production
- Verify library integrity when possible
- Monitor for security updates in used libraries

### 3. Build Environment Security
- Ensure build environment is secure and isolated
- Limit network access during builds when possible
- Validate all external dependencies and sources
- Use secure channels for dependency downloads

## Monitoring and Logging

### 1. Build Monitoring
- Log all build steps with timestamps
- Monitor build success/failure rates
- Track build performance metrics
- Alert on build failures in production environments

### 2. Deployment Monitoring
- Verify all services start correctly after deployment
- Monitor API endpoint availability
- Check frontend accessibility
- Validate environment variable loading

### 3. Error Handling
- Provide clear error messages for build failures
- Include troubleshooting information in error output
- Log sufficient detail for debugging without exposing secrets
- Implement graceful degradation for non-critical build steps