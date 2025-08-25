<div align="center">
  <img src="../assets/logo.png" alt="Agentic Haxe Logo" width="200" height="200">
</div>

# PoC 02: Haxe WebAssembly for Browser-Based AI

## Overview
Explore Haxe WebAssembly (WASM) compilation for high-performance browser-based AI inference without JavaScript overhead.

## Target Platforms

### Primary: Cloudflare Pages
- **Platform**: Edge computing with global CDN
- **Runtime**: WebAssembly in browser + Cloudflare Workers
- **Deployment**: Git-based continuous deployment
- **Scaling**: Automatic edge scaling worldwide

### Secondary: GitHub Pages
- **Platform**: Static site hosting with WASM support
- **Runtime**: Client-side WebAssembly execution
- **Deployment**: GitHub Actions CI/CD
- **Scaling**: CDN distribution via GitHub

## Technical Goals

### Core Features
- Compile Haxe AI logic to WebAssembly
- Client-side model inference
- Real-time processing without server calls
- Memory-efficient WASM modules
- JavaScript interop for UI integration

### Performance Targets
- < 50ms inference latency
- < 5MB WASM bundle size
- 60fps real-time processing
- Cross-browser compatibility

## Implementation Plan

### Phase 1: WASM Compilation Setup
```bash
# Build configuration for WASM
haxe -D js-es=6 -D wasm -js bin/wasm/ai_inference.js -cp src -main AIInference
```

### Phase 2: AI Model Integration
```haxe
// Haxe code that compiles to WASM
class WASMInference {
    @:expose
    public static function processImage(imageData: js.lib.Uint8Array): js.lib.Float32Array {
        // High-performance image processing in WASM
        return performInference(imageData);
    }
}
```

### Phase 3: Browser Integration
- JavaScript wrapper for WASM module
- Web Workers for background processing
- Progressive loading strategies

## Deployment Workflows

### Cloudflare Pages Deployment
```yaml
# .github/workflows/cloudflare-pages.yml
name: Deploy to Cloudflare Pages
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Build Haxe to WASM
        run: haxe build-wasm.hxml
      - name: Deploy to Cloudflare Pages
        uses: cloudflare/pages-action@v1
        with:
          apiToken: ${{ secrets.CLOUDFLARE_API_TOKEN }}
          accountId: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
          projectName: haxe-wasm-ai
          directory: bin/wasm
```

### GitHub Pages Deployment
```yaml
# .github/workflows/github-pages.yml
name: Deploy to GitHub Pages
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Build WASM
        run: |
          haxe build-wasm.hxml
          cp -r bin/wasm/* docs/
      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./docs
```

## Expected Benefits
- Near-native performance in browser
- No server dependency for inference
- Global edge distribution
- Privacy-preserving local processing

## Success Metrics
- Successful Haxe → WASM compilation
- Working browser AI inference
- Performance < 50ms latency
- Successful edge deployment

## Next Steps
1. Set up WASM compilation target
2. Create browser AI inference examples
3. Optimize WASM bundle size
4. Implement edge deployment
5. Performance benchmarking