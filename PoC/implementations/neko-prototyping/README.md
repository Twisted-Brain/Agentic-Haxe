<div align="center">
  <img src="../../../assets/logo.png" alt="Agentic Haxe Logo" width="200" height="200">
</div>

# PoC 08: Neko Rapid Prototyping Implementation

## Overview
Lightweight Haxe Neko target for ultra-fast AI workflow prototyping and experimental development.

## Directory Structure
```
neko-prototyping/
├── src/                    # Haxe source code
│   ├── NekoAIRuntime.hx   # Main Neko runtime
│   ├── WorkflowEngine.hx  # AI workflow scripting
│   └── RapidDevTools.hx   # Development utilities
├── build/                  # Compiled Neko output
├── tests/                  # Test files
├── scripts/                # Development scripts
│   ├── hot-reload.sh      # Hot reload setup
│   ├── benchmark.sh       # Quick benchmarking
│   └── interactive.sh     # Interactive mode
└── README.md              # This file
```

## Setup
1. Install Neko VM: `brew install neko` (macOS) or `apt install neko` (Linux)
2. Compile: `haxe -neko build/ai-runtime.n -main NekoAIRuntime -cp src`
3. Run: `neko build/ai-runtime.n`
4. Interactive mode: `./scripts/interactive.sh`

## Target Platforms
- Local development environment
- Lightweight VPS deployment
- Development containers
- CI/CD pipeline testing

## Key Features
- Ultra-fast compilation (<1 second)
- Hot reload development
- Interactive AI scripting
- Rapid algorithm prototyping
- Workflow automation
- Performance profiling

## Development Workflow
1. **Prototype**: Quick algorithm implementation
2. **Test**: Immediate execution and feedback
3. **Iterate**: Hot reload for instant changes
4. **Benchmark**: Built-in performance measurement
5. **Export**: Convert to production targets

## Use Cases
- AI algorithm experimentation
- Workflow script development
- Quick integration testing
- Educational AI programming
- Proof-of-concept validation

## Dependencies
- Neko VM
- Haxe 4.3+
- File system watcher (for hot reload)

## Performance Targets
- Compilation: <1 second
- Cold start: <100ms
- Hot reload: <500ms
- Memory footprint: <50MB
- Development cycle: <10 seconds