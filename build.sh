#!/bin/bash

# Haxe Project Build Script
# This script builds all targets: JavaScript frontend, C++ backend, and shared library

set -e  # Exit on any error

echo "🚀 Starting Haxe build process..."
echo "======================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Haxe is installed
if ! command -v haxe &> /dev/null; then
    print_error "Haxe is not installed. Please install Haxe first."
    exit 1
fi

print_status "Haxe version: $(haxe -version)"

# Create bin directories if they don't exist
print_status "Creating output directories..."
mkdir -p bin/frontend bin/backend bin/shared

# Install required haxelibs if not already installed
print_status "Checking and installing required libraries..."

# List of required libraries
libraries=("hxcpp" "haxe-crypto")

for lib in "${libraries[@]}"; do
    if ! haxelib list | grep -q "$lib"; then
        print_status "Installing $lib..."
        haxelib install "$lib" || print_warning "Failed to install $lib (might not exist in haxelib)"
    else
        print_status "$lib is already installed"
    fi
done

# Build shared library first (dependency for others)
print_status "Building shared library..."
if haxe --js bin/shared/shared.js --main shared.SharedMain --class-path src --dce full; then
    print_success "Shared library built successfully"
else
    print_error "Failed to build shared library"
    exit 1
fi

# Build JavaScript frontend
print_status "Building JavaScript frontend..."
if haxe --js bin/frontend/webapp.js --main frontend.WebAppMain --class-path src --dce full; then
    print_success "JavaScript frontend built successfully"
    
    # Copy HTML and CSS files to frontend bin
    print_status "Copying frontend assets..."
    cp src/frontend/index.html bin/frontend/ 2>/dev/null || print_warning "index.html not found"
    cp src/frontend/webapp-styles.css bin/frontend/ 2>/dev/null || print_warning "webapp-styles.css not found"
    
else
    print_error "Failed to build JavaScript frontend"
    exit 1
fi

# Build C++ backend
print_status "Building C++ backend..."
if haxe --cpp bin/backend --main backend.LlmGatewayMain --class-path src --library hxcpp --library haxe-crypto --define HXCPP_QUIET --define static_link; then
    print_success "C++ backend built successfully"
else
    print_error "Failed to build C++ backend"
    exit 1
fi

# Create a simple launcher script for the backend
print_status "Creating backend launcher..."
cat > bin/backend/run_gateway.sh << 'EOF'
#!/bin/bash
echo "Starting Haxe C++ LLM Gateway..."
echo "Set OPENROUTER_API_KEY environment variable to use real API"
echo "Set LLM_MODEL environment variable to specify model (default: openai/gpt-3.5-turbo)"
echo "Press Ctrl+C to stop"
./LlmGatewayMain
EOF

chmod +x bin/backend/run_gateway.sh

# Create a simple web server script for frontend
print_status "Creating frontend server script..."
cat > bin/frontend/serve.sh << 'EOF'
#!/bin/bash
echo "Starting simple HTTP server for Haxe WebApp..."
echo "Open http://localhost:8000 in your browser"
echo "Press Ctrl+C to stop"
cd "$(dirname "$0")"
python3 -m http.server 8000 2>/dev/null || python -m SimpleHTTPServer 8000
EOF

chmod +x bin/frontend/serve.sh

# Build summary
echo ""
echo "======================================"
print_success "🎉 Build completed successfully!"
echo ""
echo "📁 Output files:"
echo "   Frontend: bin/frontend/webapp.js"
echo "   Backend:  bin/backend/LlmGatewayMain"
echo "   Shared:   bin/shared/shared.js"
echo ""
echo "🚀 To run:"
echo "   Frontend: cd bin/frontend && ./serve.sh"
echo "   Backend:  cd bin/backend && ./run_gateway.sh"
echo ""
echo "💡 Tips:"
echo "   - Set OPENROUTER_API_KEY for real LLM API access"
echo "   - Set LLM_MODEL to specify which model to use"
echo "   - Check logs for any warnings or errors"
echo "======================================"