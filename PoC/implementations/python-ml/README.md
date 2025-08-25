# PoC 01: Python ML Integration Implementation

<div align="center">
  <img src="../../../assets/logo.png" alt="Python ML Integration Logo" width="100" height="100">
</div>

## Overview
Haxe Python target implementation for direct ML model integration with NumPy/TensorFlow interoperability.

## Directory Structure
```
python-ml/
├── src/                    # Haxe source code
│   ├── PythonAIServer.hx  # Main server implementation
│   ├── MLModelWrapper.hx  # ML model integration
│   └── NumpyInterface.hx  # NumPy interoperability
├── build/                  # Compiled Python output
├── tests/                  # Test files
├── requirements.txt        # Python dependencies
└── README.md              # This file
```

## Setup
1. Install Python dependencies: `pip install -r requirements.txt`
2. Compile Haxe to Python: `haxe -python build/main.py -main PythonAIServer -cp src`
3. Run: `python build/main.py`

## Target Platforms
- VPS deployment
- Cloud platforms (AWS/GCP/Azure)
- Docker containers

## Key Features
- Direct NumPy array manipulation
- TensorFlow model integration
- Scikit-learn compatibility
- High-performance ML inference

## Dependencies
- numpy>=1.21.0
- tensorflow>=2.8.0
- scikit-learn>=1.0.0
- flask>=2.0.0

## Performance Targets
- ML inference: <50ms per request
- Memory usage: <500MB baseline
- Throughput: >100 requests/second