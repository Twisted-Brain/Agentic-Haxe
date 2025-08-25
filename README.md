# Haxe LLM Gateway PoC

<div align="center">
  <img src="assets/logo.png" alt="Haxe LLM Gateway Logo" width="200" height="200">
</div>

A Proof of Concept project demonstrating how Haxe can be used to build both frontend and backend applications in a single project.

## 🎯 Project Description

This project demonstrates:
- **Frontend**: JavaScript webapp built with Haxe
- **Backend**: Node.js Express server with OpenRouter API integration
- **Shared**: Common code library between frontend and backend
- **Hybrid Architecture**: Haxe frontend with Node.js backend for optimal performance

## 🏗️ Project Structure

```
Agentic-Haxe/
├── src/
│   ├── frontend/           # JavaScript webapp code
│   │   ├── WebAppMain.hx   # Main class for webapp
│   │   ├── index.html      # HTML template
│   │   └── webapp-styles.css # CSS styling
│   ├── backend/            # Backend code (legacy)
│   │   └── LlmGatewayMain.hx # LLM gateway main class
│   └── shared/             # Shared code
│       ├── ApiModels.hx    # API data models
│       └── SharedMain.hx   # Shared library
├── bin/                    # Compiled files
│   ├── frontend/           # JavaScript webapp
│   ├── backend/            # Backend executable (legacy)
│   └── shared/             # Shared library
├── tests/                  # Test files
├── build.hxml             # Haxe build configuration
├── build.sh               # Build script
├── Makefile               # Make commands
├── package.json           # Node.js dependencies
├── server.js              # Node.js Express server (active backend)
├── .env                   # Environment configuration
└── haxelib.json           # Project metadata
```

## 🚀 Getting Started

### Prerequisites

1. **Haxe**: Install Haxe from [haxe.org](https://haxe.org/download/)
2. **Node.js**: For backend server (Node.js 16+ recommended)
3. **OpenRouter API Key**: Get your API key from [openrouter.ai](https://openrouter.ai/)

### Installation

1. **Clone the project**:
   ```bash
   git clone <repository-url>
   cd Agentic-Haxe
   ```

2. **Install Haxe libraries**:
   ```bash
   make install
   ```

3. **Install Node.js dependencies**:
   ```bash
   npm install
   ```

4. **Configure environment**:
   Create a `.env` file in the project root:
   ```bash
   OPENROUTER_API_KEY=your-openrouter-api-key-here
   OPENROUTER_BASE_URL=https://openrouter.ai/api/v1
   BACKEND_PORT=3000
   ```

5. **Build the project**:
   ```bash
   make build
   ```

## 🔧 Build Process

### All targets
```bash
# Build everything
make build
# or
./build.sh
```

### Individual targets
```bash
# Frontend only
make frontend

# Backend only
make backend

# Shared library only
make shared
```

## 🌐 Running

### Full Application (Recommended)
```bash
# Start the complete application
npm start
# Open http://localhost:3000 in browser
```

This starts:
- Node.js Express server on port 3000
- Serves the Haxe-compiled frontend
- Provides `/api/chat` endpoint for LLM communication
- Integrates with OpenRouter API

### Legacy Backend (C++)
```bash
# Run legacy C++ gateway (optional)
make run-backend

# With real API key
OPENROUTER_API_KEY="your-key-here" make run-backend
```

## ⚙️ Configuration

### Environment Variables

Create a `.env` file in the project root:

```env
OPENROUTER_API_KEY=your-openrouter-api-key-here
OPENROUTER_BASE_URL=https://openrouter.ai/api/v1
BACKEND_PORT=3000
```

- `OPENROUTER_API_KEY`: Your OpenRouter API key (required)
- `OPENROUTER_BASE_URL`: OpenRouter API base URL (default: https://openrouter.ai/api/v1)
- `BACKEND_PORT`: Port for Node.js server (default: 3000)

### API Integration

The application uses a hybrid architecture:
- **Frontend**: Haxe-compiled JavaScript webapp
- **Backend**: Node.js Express server with `/api/chat` endpoint
- **API**: Direct integration with OpenRouter for LLM communication
- **Communication**: Frontend calls local `/api/chat` which proxies to OpenRouter

## 🧪 Testing

```bash
# Run all tests
make test

# Clean build artifacts
make clean
```

## 📋 Available Commands

| Command | Description |
|---------|-------------|
| `make build` | Build all targets |
| `make frontend` | Build frontend only |
| `make backend` | Build backend only |
| `make shared` | Build shared library only |
| `make install` | Install Haxe libraries |
| `make clean` | Clean build artifacts |
| `make test` | Run tests |
| `npm start` | Start Node.js server |
| `make run-backend` | Run backend gateway |
| `make dev` | Development mode |
| `make check` | Check installation |
| `make help` | Show help |

## 🔍 How It Works

### Frontend (JavaScript)
- Haxe code compiles to JavaScript
- Modern webapp with chat interface
- Communicates with Node.js server via HTTP
- Real AI chat functionality through OpenRouter API
- Uses shared API models

### Node.js Server
- Express.js server serving frontend files
- API endpoints for chat functionality
- Integration with OpenRouter API
- CORS enabled for development

### Backend (C++)
- Haxe code compiles to C++
- HTTP server for API requests
- Integration with OpenRouter API
- Handles LLM communication

### Shared Library
- Common data models
- API structures
- Utility functions
- Used by both frontend and backend

## 🎨 Features

- ✅ **Cross-platform**: Works on macOS, Linux, Windows
- ✅ **Type-safe**: Haxe's type system ensures code quality
- ✅ **Code sharing**: Shared code between frontend and backend
- ✅ **Modern UI**: Responsive webapp with modern design
- ✅ **Real LLM Integration**: Direct integration with OpenRouter API
- ✅ **Build automation**: Automated build process
- ✅ **Development tools**: Hot reload and development server
- ✅ **AI Chat**: Functional chat interface with multiple LLM models

## 🐛 Troubleshooting

### Common Issues

1. **Haxe not found**:
   ```bash
   # Install Haxe
   brew install haxe  # macOS
   ```

2. **Libraries missing**:
   ```bash
   make install
   ```

3. **C++ compiler errors**:
   ```bash
   # Install build tools
   xcode-select --install  # macOS
   ```

4. **Port already in use**:
   ```bash
   # Find and kill process on port 3000
   lsof -ti:3000 | xargs kill -9
   ```

5. **OpenRouter API errors**:
   - Check your API key in `.env` file
   - Verify your OpenRouter account has credits
   - Check network connectivity

## 📚 Learning

This project demonstrates:
- Haxe's cross-platform capabilities
- Code sharing between different targets
- Modern webapp development with Haxe
- C++ backend development
- API integration and HTTP communication
- Build process automation
- Real-world AI integration

## 🤝 Contributing

Contributions are welcome! Open an issue or send a pull request.

## 📄 License

MIT License - see LICENSE file for details.

Regards and enjoy,TwistedBrain & AI freinds
