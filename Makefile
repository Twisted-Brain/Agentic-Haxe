# Haxe Project Makefile
# Provides convenient commands for building and testing the project

.PHONY: all build clean test frontend backend shared install serve-frontend run-backend help

# Default target
all: build

# Build all targets
build:
	@echo "Building all Haxe targets..."
	./build.sh

# Build only frontend
frontend:
	@echo "Building JavaScript frontend..."
	mkdir -p bin/frontend
	haxe --js bin/frontend/webapp.js --main frontend.WebAppMain --class-path src --dce full
	@cp src/frontend/index.html bin/frontend/ 2>/dev/null || echo "Warning: index.html not found"
	@cp src/frontend/webapp-styles.css bin/frontend/ 2>/dev/null || echo "Warning: webapp-styles.css not found"
	@echo "Frontend build completed"

# Build only backend
backend:
	@echo "Building C++ backend..."
	@mkdir -p bin/backend
	@haxe --cpp bin/backend --main backend.LlmGatewayMain --class-path src --library hxcpp --library haxe-crypto --define HXCPP_QUIET
	@echo "Backend build completed"

# Build only shared library
shared:
	@echo "Building shared library..."
	mkdir -p bin/shared
	haxe --js bin/shared/shared.js --main shared.SharedMain --class-path src --dce full
	@echo "Shared library build completed"

# Install required haxelibs
install:
	@echo "Installing required Haxe libraries..."
	@haxelib install haxe-js-kit || echo "Warning: Could not install haxe-js-kit"
	@haxelib install coconut.ui || echo "Warning: Could not install coconut.ui"
	@haxelib install hxcpp || echo "Warning: Could not install hxcpp"
	@haxelib install haxe-crypto || echo "Warning: Could not install haxe-crypto"
	@echo "Library installation completed"

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	rm -rf bin/
	rm -rf .haxelib/
	@echo "Clean completed"

# Run tests
test: build
	@echo "Running tests..."
	@echo "Testing shared library..."
	node bin/shared/shared.js
	@echo "Tests completed"

# Serve frontend webapp
serve-frontend: frontend
	@echo "Starting frontend web server..."
	@echo "Open http://localhost:8000 in your browser"
	cd bin/frontend && python3 -m http.server 8000

# Run backend gateway
run-backend: backend
	@echo "Starting C++ LLM Gateway..."
	@echo "Set OPENROUTER_API_KEY environment variable for real API access"
	cd bin/backend && ./LlmGatewayMain

# Development mode - build and serve frontend
dev: frontend
	@echo "Starting development server..."
	@echo "Frontend will be available at http://localhost:8000"
	cd bin/frontend && python3 -m http.server 8000

# Check Haxe installation and version
check:
	@echo "Checking Haxe installation..."
	@haxe -version || echo "Error: Haxe not found. Please install Haxe first."
	@echo "Checking installed libraries:"
	@haxelib list | grep -E "(haxe-js-kit|coconut|hxcpp|haxe-crypto|haxe-json)" || echo "Some libraries may be missing"

# Show project structure
struct:
	@echo "Project structure:"
	@tree -I 'bin|node_modules|.git' . || find . -type f -name '*.hx' -o -name '*.html' -o -name '*.css' -o -name '*.json' -o -name '*.sh' -o -name 'Makefile' | grep -v bin | sort

# Show help
help:
	@echo "Available commands:"
	@echo "  make build        - Build all targets (frontend, backend, shared)"
	@echo "  make frontend     - Build only JavaScript frontend"
	@echo "  make backend      - Build only C++ backend"
	@echo "  make shared       - Build only shared library"
	@echo "  make install      - Install required Haxe libraries"
	@echo "  make clean        - Clean build artifacts"
	@echo "  make test         - Run tests"
	@echo "  make serve-frontend - Build and serve frontend webapp"
	@echo "  make run-backend  - Build and run C++ backend"
	@echo "  make dev          - Development mode (build and serve frontend)"
	@echo "  make check        - Check Haxe installation and libraries"
	@echo "  make struct       - Show project structure"
	@echo "  make help         - Show this help message"
	@echo ""
	@echo "Environment variables:"
	@echo "  OPENROUTER_API_KEY - API key for OpenRouter (required for real LLM access)"
	@echo "  LLM_MODEL         - LLM model to use (default: openai/gpt-3.5-turbo)"