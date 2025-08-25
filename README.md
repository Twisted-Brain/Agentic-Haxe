# Haxe LLM Gateway PoC

Et Proof of Concept projekt der demonstrerer hvordan Haxe kan bruges til at bygge både frontend og backend applikationer i et enkelt projekt.

## 🎯 Projektbeskrivelse

Dette projekt viser:
- **Frontend**: JavaScript webapp bygget med Haxe
- **Backend**: C++ LLM gateway til OpenRouter API
- **Shared**: Fælles kode bibliotek mellem frontend og backend
- **100% Haxe**: Hele projektet er skrevet i Haxe og kompileret til forskellige targets

## 🏗️ Projektstruktur

```
Agentic-Haxe/
├── src/
│   ├── frontend/           # JavaScript webapp kode
│   │   ├── WebAppMain.hx   # Hovedklasse for webapp
│   │   ├── index.html      # HTML template
│   │   └── webapp-styles.css # CSS styling
│   ├── backend/            # C++ backend kode
│   │   └── LlmGatewayMain.hx # LLM gateway hovedklasse
│   └── shared/             # Fælles kode
│       ├── ApiModels.hx    # API data modeller
│       └── SharedMain.hx   # Shared bibliotek
├── bin/                    # Kompilerede filer
│   ├── frontend/           # JavaScript webapp
│   ├── backend/            # C++ eksekverbar
│   └── shared/             # Shared bibliotek
├── tests/                  # Test filer
├── build.hxml             # Haxe build konfiguration
├── build.sh               # Build script
├── Makefile               # Make kommandoer
└── haxelib.json           # Projekt metadata
```

## 🚀 Kom i gang

### Forudsætninger

1. **Haxe**: Installer Haxe fra [haxe.org](https://haxe.org/download/)
2. **C++ Compiler**: For backend (GCC eller Clang)
3. **Python**: For development server (Python 3 anbefales)

### Installation

1. **Klon projektet**:
   ```bash
   git clone <repository-url>
   cd Agentic-Haxe
   ```

2. **Installer Haxe biblioteker**:
   ```bash
   make install
   ```

3. **Byg projektet**:
   ```bash
   make build
   ```

## 🔧 Build Process

### Alle targets
```bash
# Byg alt
make build
# eller
./build.sh
```

### Individuelle targets
```bash
# Kun frontend
make frontend

# Kun backend
make backend

# Kun shared bibliotek
make shared
```

## 🌐 Kørsel

### Frontend WebApp
```bash
# Start development server
make serve-frontend
# Åbn http://localhost:8000 i browser
```

### Backend Gateway
```bash
# Kør C++ gateway
make run-backend

# Med rigtig API key
OPENROUTER_API_KEY="your-key-here" make run-backend
```

## ⚙️ Konfiguration

### Environment Variables

- `OPENROUTER_API_KEY`: Din OpenRouter API nøgle
- `LLM_MODEL`: LLM model at bruge (default: `openai/gpt-3.5-turbo`)

### Eksempel
```bash
export OPENROUTER_API_KEY="sk-or-v1-..."
export LLM_MODEL="anthropic/claude-3-sonnet"
```

## 🧪 Test

```bash
# Kør alle tests
make test

# Ryd build artifacts
make clean
```

## 📋 Tilgængelige Kommandoer

| Kommando | Beskrivelse |
|----------|-------------|
| `make build` | Byg alle targets |
| `make frontend` | Byg kun frontend |
| `make backend` | Byg kun backend |
| `make shared` | Byg kun shared bibliotek |
| `make install` | Installer Haxe biblioteker |
| `make clean` | Ryd build artifacts |
| `make test` | Kør tests |
| `make serve-frontend` | Start frontend server |
| `make run-backend` | Kør backend gateway |
| `make dev` | Development mode |
| `make check` | Tjek installation |
| `make help` | Vis hjælp |

## 🔍 Hvordan det virker

### Frontend (JavaScript)
- Haxe kode kompileres til JavaScript
- Moderne webapp med chat interface
- Kommunikerer med backend via HTTP
- Bruger shared API modeller

### Backend (C++)
- Haxe kode kompileres til C++
- HTTP server til API requests
- Integration med OpenRouter API
- Håndterer LLM kommunikation

### Shared Library
- Fælles data modeller
- API strukturer
- Utility funktioner
- Bruges af både frontend og backend

## 🎨 Features

- ✅ **Cross-platform**: Virker på macOS, Linux, Windows
- ✅ **Type-safe**: Haxe's type system sikrer kode kvalitet
- ✅ **Code sharing**: Fælles kode mellem frontend og backend
- ✅ **Modern UI**: Responsive webapp med moderne design
- ✅ **LLM Integration**: Direkte integration med OpenRouter API
- ✅ **Build automation**: Automatiseret build process
- ✅ **Development tools**: Hot reload og development server

## 🐛 Fejlfinding

### Almindelige problemer

1. **Haxe ikke fundet**:
   ```bash
   # Installer Haxe
   brew install haxe  # macOS
   ```

2. **Biblioteker mangler**:
   ```bash
   make install
   ```

3. **C++ compiler fejl**:
   ```bash
   # Installer build tools
   xcode-select --install  # macOS
   ```

4. **Port allerede i brug**:
   ```bash
   # Find og dræb proces på port 8000
   lsof -ti:8000 | xargs kill -9
   ```

## 📚 Læring

Dette projekt demonstrerer:
- Haxe's cross-platform capabilities
- Code sharing mellem forskellige targets
- Modern webapp udvikling med Haxe
- C++ backend udvikling
- API integration og HTTP kommunikation
- Build process automation

## 🤝 Bidrag

Bidrag er velkomne! Åbn en issue eller send en pull request.

## 📄 Licens

MIT License - se LICENSE fil for detaljer.