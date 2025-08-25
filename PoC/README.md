# Haxe AI Proof of Concepts (PoC) Structure

<div align="center">
  <img src="../assets/logo.png" alt="Haxe AI PoC Logo" width="150" height="150">
</div>

This directory contains multiple Proof of Concept implementations demonstrating Haxe's capabilities across different server targets and deployment platforms for AI applications.

**Key Concept**: PoC 00 establishes the foundation with shared components that are reused across all other PoCs, proving Haxe's "Write Once, Deploy Everywhere" philosophy.

## Project Structure

```
PoC/
├── README.md                           # This file
├── 00-Baseline-NodeJS-CPP.md          # FOUNDATION: Node.js/C++ baseline with shared components
├── 01-Python-ML-Integration.md         # Python target (reuses 80%+ from PoC 00)
├── 02-WebAssembly-Browser-AI.md        # WASM target for browser AI
├── 03-PHP-Traditional-Hosting.md       # PHP target for traditional hosting
├── 04-Java-Enterprise-Cloud.md         # Java target for enterprise cloud
├── 05-CSharp-Azure-Microservices.md    # C# target for Azure microservices
├── 06-Multi-Target-Universal-Deploy.md # Multi-target deployment system
├── 07-Performance-Benchmarks.md        # Performance comparison across targets
├── 08-Neko-Rapid-Prototyping.md       # Neko target for rapid prototyping
├── implementations/                     # Actual PoC implementations
│   ├── baseline-nodejs-cpp/            # PoC 00 implementation (FOUNDATION)
│   │   ├── src/
│   │   │   ├── shared/                  # Shared API models and types
│   │   │   ├── frontend/                # Universal frontend components
│   │   │   └── platform/                # Node.js and C++ backends
│   │   ├── build/
│   │   ├── tests/
│   │   ├── package.json
│   │   ├── build-nodejs.hxml
│   │   ├── build-cpp.hxml
│   │   └── README.md
│   ├── python-ml/                      # PoC 01 implementation (reuses PoC 00)
│   │   ├── src/
│   │   ├── build/
│   │   ├── tests/
│   │   ├── requirements.txt
│   │   └── README.md
│   ├── wasm-browser/                    # PoC 02 implementation
│   │   ├── src/
│   │   ├── build/
│   │   ├── tests/
│   │   ├── package.json
│   │   └── README.md
│   ├── php-hosting/                     # PoC 03 implementation
│   │   ├── src/
│   │   ├── build/
│   │   ├── tests/
│   │   ├── composer.json
│   │   └── README.md
│   ├── java-enterprise/                 # PoC 04 implementation
│   │   ├── src/
│   │   ├── build/
│   │   ├── tests/
│   │   ├── pom.xml
│   │   └── README.md
│   ├── csharp-azure/                    # PoC 05 implementation
│   │   ├── src/
│   │   ├── build/
│   │   ├── tests/
│   │   ├── *.csproj
│   │   └── README.md
│   ├── multi-target/                    # PoC 06 implementation
│   │   ├── src/
│   │   ├── build/
│   │   ├── tests/
│   │   ├── build-configs/
│   │   └── README.md
│   ├── benchmarks/                      # PoC 07 implementation
│   │   ├── src/
│   │   ├── results/
│   │   ├── scripts/
│   │   ├── docker/
│   │   └── README.md
│   └── neko-prototyping/               # PoC 08 implementation
│       ├── src/
│       ├── build/
│       ├── tests/
│       ├── scripts/
│       └── README.md
└── shared/                             # Shared code and utilities
    ├── ai-core/                        # Core AI functionality
    ├── api-interfaces/                 # Common API interfaces
    ├── utils/                          # Utility functions
    └── types/                          # Shared type definitions
```

## PoC Overview

### 00. Baseline Node.js/C++ Implementation (FOUNDATION)
- **Target Platform**: Node.js + C++ (dual backend)
- **Focus**: Establish reusable foundation for all other PoCs
- **Key Components**: 
  - ✅ Shared API Models (`LlmRequest`, `LlmResponse`)
  - ✅ Universal Frontend (platform-agnostic JavaScript)
  - ✅ Configuration System (`FrontendConfig`)
  - ✅ Build System & Docker Support
- **Deployment**: Local development, Docker containers
- **Status**: **Critical foundation - all other PoCs depend on this**

### 01. Python ML Integration (Reuses PoC 00 Foundation)
- **Target Platform**: VPS + Cloud (AWS/GCP/Azure)
- **Focus**: OpenRouter integration + Python ML libraries
- **Reuses from PoC 00**: Frontend (100%), API models (100%), configuration system (100%)
- **New Components**: Python backend, ML library integration
- **Deployment**: Docker containers, Python virtual environments
- **Code Reuse**: 80%+ from PoC 00 foundation

### 02. WebAssembly Browser AI (Reuses PoC 00 Foundation)
- **Target Platform**: Cloudflare Pages + GitHub Pages
- **Focus**: Browser-based AI inference without JavaScript overhead
- **Reuses from PoC 00**: Frontend (100%), API models (100%), configuration system (100%)
- **New Components**: WASM backend compilation
- **Deployment**: Static site hosting, CDN distribution
- **Code Reuse**: 80%+ from PoC 00 foundation

### 03. PHP Traditional Hosting (Reuses PoC 00 Foundation)
- **Target Platform**: Traditional webhosting (Netgiganten) + VPS
- **Focus**: Integration with existing PHP infrastructure
- **Reuses from PoC 00**: Frontend (100%), API models (100%), configuration system (100%)
- **New Components**: PHP backend implementation
- **Deployment**: cPanel, FTP, traditional LAMP stack
- **Code Reuse**: 80%+ from PoC 00 foundation

### 04. Java Enterprise Cloud (Reuses PoC 00 Foundation)
- **Target Platform**: Enterprise Cloud (AWS/GCP/Azure)
- **Focus**: Spring Boot integration, JVM performance
- **Reuses from PoC 00**: Frontend (100%), API models (100%), configuration system (100%)
- **New Components**: Java backend, Spring Boot integration
- **Deployment**: Kubernetes, Docker, enterprise CI/CD
- **Code Reuse**: 80%+ from PoC 00 foundation

### 05. C# Azure Microservices (Reuses PoC 00 Foundation)
- **Target Platform**: Azure Cloud
- **Focus**: .NET microservices, Azure integration
- **Reuses from PoC 00**: Frontend (100%), API models (100%), configuration system (100%)
- **New Components**: C# backend, Azure integration
- **Deployment**: Azure DevOps, Azure Container Instances
- **Code Reuse**: 80%+ from PoC 00 foundation

### 06. Multi-Target Universal Deploy (Orchestrates All PoCs)
- **Target Platform**: All platforms simultaneously
- **Focus**: Universal deployment system using PoC 00 foundation
- **Reuses from PoC 00**: All shared components across multiple backends
- **New Components**: Orchestration and deployment automation
- **Deployment**: GitHub Actions, multi-platform CI/CD
- **Code Reuse**: Maximizes reuse from PoC 00 across all platforms

### 07. Performance Benchmarks
- **Target Platform**: VPS + Multi-cloud
- **Focus**: Performance comparison across all targets
- **Deployment**: Automated benchmarking infrastructure

### 08. Neko Rapid Prototyping (Reuses PoC 00 Foundation)
- **Target Platform**: Local development + VPS
- **Focus**: Ultra-fast development cycles
- **Reuses from PoC 00**: Frontend (100%), API models (100%), configuration system (100%)
- **New Components**: Neko backend implementation
- **Deployment**: Lightweight containers, development servers
- **Code Reuse**: 80%+ from PoC 00 foundation

## Getting Started

### Step 1: Implement Foundation (Required)
1. **Start with PoC 00 (Baseline)** - This is mandatory as all other PoCs depend on it
2. Navigate to `implementations/baseline-nodejs-cpp/`
3. Follow the setup instructions to build the foundation
4. Verify both Node.js and C++ backends work with the same frontend

### Step 2: Choose Additional PoCs
1. Choose additional PoCs based on your target platform and requirements
2. Navigate to the corresponding implementation directory
3. Follow the README.md in each implementation for setup instructions
4. Each PoC reuses 80%+ of the PoC 00 foundation with platform-specific backends

## Development Workflow

1. **Planning**: Review the markdown documentation for each PoC
2. **Implementation**: Work in the corresponding `implementations/` directory
3. **Testing**: Each PoC has its own test suite
4. **Deployment**: Follow platform-specific deployment guides
5. **Benchmarking**: Use PoC 07 to compare performance across implementations

## Shared Components (Established by PoC 00)

All PoCs share common components from the PoC 00 foundation:
- **API Models**: `LlmRequest`, `LlmResponse`, `LlmModel` classes (from PoC 00)
- **Frontend Components**: Universal chat interface (from PoC 00)
- **Configuration System**: `FrontendConfig` with auto-detection (from PoC 00)
- **Build System**: Multi-platform compilation setup (from PoC 00)
- **AI Core**: Common AI functionality and algorithms
- **API Interfaces**: Standardized API definitions
- **Utils**: Utility functions and helpers

## Contributing

When adding new PoCs or modifying existing ones:
1. Update this README.md with the new structure
2. Follow the established directory conventions
3. Ensure each implementation is self-contained
4. Add comprehensive documentation in each PoC's README.md
5. Include performance benchmarks where applicable

## Next Steps

### Phase 1: Foundation (Critical)
1. **Implement PoC 00 (Baseline)** - Highest priority
2. Build shared API models and universal frontend
3. Implement Node.js and C++ backends
4. Validate cross-platform reuse patterns

### Phase 2: Prove Reusability
1. Implement PoC 01 (Python) - Demonstrate 80%+ code reuse
2. Implement PoC 08 (Neko) - Rapid prototyping validation
3. Document reuse patterns and benefits

### Phase 3: Scale Across Platforms
1. Implement remaining platform-specific PoCs
2. Build PoC 06 (Multi-Target) orchestration
3. Establish PoC 07 (Benchmarks) infrastructure
4. Measure and document code reuse percentages