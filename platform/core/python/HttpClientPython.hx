package platform.core.python;

import domain.ports.IHttp;

/**
 * Python implementation of IHttp port.
 * Uses Python's urllib for HTTP operations with ML-optimized configurations.
 */
class HttpClientPython implements IHttp {
    private var headers: Map<String, String>;
    
    public function new() {
        headers = new Map<String, String>();
        // Set default headers for ML API interactions
        headers.set("Content-Type", "application/json");
        headers.set("User-Agent", "Haxe-Python-ML-Client/1.0");
    }
    
    public function get(url: String): String {
        untyped __python__("import urllib.request");
        return untyped __python__("urllib.request.urlopen({0}).read().decode('utf-8')", url);
    }
    
    public function post(url: String, data: String): String {
        untyped __python__("import urllib.request");
        return untyped __python__("urllib.request.urlopen({0}, {1}.encode('utf-8')).read().decode('utf-8')", url, data);
    }
    
    public function put(url: String, data: String): String {
        untyped __python__("import urllib.request");
        return untyped __python__("urllib.request.urlopen({0}, {1}.encode('utf-8')).read().decode('utf-8')", url, data);
    }
    
    public function delete(url: String): String {
        untyped __python__("import urllib.request");
        return untyped __python__("urllib.request.urlopen({0}).read().decode('utf-8')", url);
    }
    
    public function setHeader(name: String, value: String): Void {
        headers.set(name, value);
    }
    
    // Python-specific implementation using urllib
    private function __init__(): Void {
        untyped __python__("import urllib.request");
        untyped __python__("import urllib.parse");
        untyped __python__("import urllib.error");
        untyped __python__("import json");
    }
}