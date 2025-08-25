# Agentic-Haxe Project Rules

## Overview

This directory contains comprehensive project rules and guidelines for the Agentic-Haxe project. These rules ensure consistent development practices, code quality, and successful builds across the multi-target Haxe codebase.

## Rule Categories

### 📋 [Project Guidelines](./project-guidelines.md)
Comprehensive project overview covering:
- **Architecture Principles**: Multi-target compilation strategy, shared kernel pattern
- **Development Workflow**: Environment setup, build process, development server usage
- **Code Quality Standards**: Cross-platform compatibility, error handling, performance
- **Security Guidelines**: Environment variables, input validation, API security
- **Testing Strategy**: Shared code testing, integration testing, error scenarios
- **Maintenance**: Dependency management, build automation, documentation

### 🔧 [Haxe Coding Standards](./haxe-coding-standards.md)
Language-specific development rules including:
- **Code Style**: Naming conventions, file organization, documentation standards
- **Type Safety**: Explicit typing, cross-platform considerations, error handling
- **Performance Guidelines**: Memory management, target-specific optimizations
- **Testing Patterns**: Unit test structure, cross-platform testing
- **Security Best Practices**: Input validation, sensitive data handling
- **Common Anti-Patterns**: What to avoid in Haxe development

### 🚀 [Build & Deployment Rules](./build-deployment-rules.md)
Build system and deployment standards covering:
- **Build Rules**: Mandatory verification, command usage, output standards
- **Dependency Management**: Library installation, version management, compatibility
- **Environment Configuration**: Required variables, setup rules, development environment
- **Testing Requirements**: Pre-deployment testing, execution standards, coverage
- **Deployment Rules**: Checklists, production builds, environment setup
- **Performance & Optimization**: Build performance, runtime optimization, resource management

## Quick Reference

### Essential Commands
```bash
# Initial setup
make install          # Install Haxe dependencies
make build           # Full project build
make test            # Run shared library tests

# Development
make dev             # Build and serve frontend (port 8000)
make clean           # Clean all build artifacts

# Production
OPENROUTER_API_KEY="your-key" make run-backend  # Start backend server
make serve-frontend  # Serve frontend application
```

### Project Structure
```
src/
├── frontend/        # Web application (Haxe → JavaScript)
├── backend/         # HTTP server (Haxe → C++)
└── shared/          # Cross-platform models and utilities

bin/                 # Compiled outputs
tests/               # Test files
.qodo/              # Project rules and guidelines
```

### Key Principles

1. **Type Safety First**: Leverage Haxe's static typing across all targets
2. **Cross-Platform Compatibility**: Shared code must work on all compilation targets
3. **Build Verification**: Always test all targets before committing
4. **Environment Security**: Never commit secrets, use environment variables
5. **Documentation**: Keep inline comments and project docs current

## Compliance Requirements

### Before Committing Code
- [ ] Run `make clean && make build` successfully
- [ ] Execute `make test` with passing results
- [ ] Verify all compilation targets work (frontend JS, backend C++, shared)
- [ ] Follow Haxe coding standards (naming, types, documentation)
- [ ] Update relevant documentation for changes

### Before Deployment
- [ ] Complete pre-deployment testing checklist
- [ ] Validate environment variable configuration
- [ ] Verify API integration with actual credentials
- [ ] Test frontend-backend communication end-to-end
- [ ] Confirm build artifacts are clean and optimized

### Code Review Checklist
- [ ] Code follows established Haxe naming conventions
- [ ] Shared code is platform-agnostic
- [ ] Proper error handling and input validation
- [ ] Adequate documentation and comments
- [ ] Tests included for new functionality
- [ ] Performance implications considered
- [ ] Security best practices followed

## Enforcement

These rules are enforced through:
- **Build System**: Automated compilation verification across targets
- **Testing Pipeline**: Shared code compatibility testing
- **Code Review**: Manual verification of standards compliance
- **Documentation**: Regular updates to maintain accuracy

## Getting Help

For questions about these rules or project development:

1. **Check Documentation**: Review the specific rule category files
2. **Build Issues**: Refer to troubleshooting sections in build rules
3. **Coding Questions**: Consult Haxe coding standards and examples
4. **Architecture Decisions**: Review project guidelines for established patterns

## Updates and Maintenance

These rules should be updated when:
- New development patterns are established
- Build system changes are made
- New libraries or dependencies are added
- Performance or security requirements change
- Project architecture evolves

Keep rules current with actual project practices and ensure they remain practical and enforceable.

---

**Remember**: These rules exist to ensure project success, code quality, and team collaboration. They should be practical guidelines that help rather than hinder development progress.