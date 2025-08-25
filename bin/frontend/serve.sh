#!/bin/bash
echo "Starting simple HTTP server for Haxe WebApp..."
echo "Open http://localhost:8000 in your browser"
echo "Press Ctrl+C to stop"
cd "$(dirname "$0")"
python3 -m http.server 8000 2>/dev/null || python -m SimpleHTTPServer 8000
