package platform.frontend;

import domain.ports.IHttp;
import js.html.XMLHttpRequest;
import js.html.Response;
import js.html.RequestInit;
import js.Browser;
import haxe.Json;

/**
 * JavaScript-specific HTTP client implementation for frontend
 * Uses browser's fetch API with XMLHttpRequest fallback
 */
class HttpClientJs implements IHttp {
    private var baseUrl: String;
    private var defaultHeaders: Map<String, String>;
    
    public function new(?baseUrl: String = "") {
        this.baseUrl = baseUrl;
        this.defaultHeaders = new Map<String, String>();
        this.defaultHeaders.set("Content-Type", "application/json");
        this.defaultHeaders.set("Accept", "application/json");
    }
    
    public function get(url: String): String {
        return makeRequest("GET", url, null, null);
    }
    
    public function post(url: String, data: String): String {
        return makeRequest("POST", url, data, null);
    }
    
    public function put(url: String, data: String): String {
        return makeRequest("PUT", url, data, null);
    }
    
    public function delete(url: String): String {
        return makeRequest("DELETE", url, null, null);
    }
    
    public function setHeader(name: String, value: String): Void {
        defaultHeaders.set(name, value);
    }
    
    private function makeRequest(method: String, url: String, ?body: String, ?headers: Map<String, String>): String {
        var fullUrl = baseUrl + url;
        
        // Use synchronous XMLHttpRequest for now (not ideal, but matches interface)
        var xhr = new XMLHttpRequest();
        xhr.open(method, fullUrl, false); // false = synchronous
        
        var mergedHeaders = mergeHeaders(headers);
        
        // Set headers
        for (key in mergedHeaders.keys()) {
            xhr.setRequestHeader(key, mergedHeaders.get(key));
        }
        
        try {
            xhr.send(body);
            
            if (xhr.status >= 200 && xhr.status < 300) {
                return xhr.responseText;
            } else {
                throw new HttpError(xhr.status, xhr.statusText, xhr.responseText);
            }
        } catch (e: Dynamic) {
            throw new HttpError(0, "Network Error", Std.string(e));
        }
    }
    
    private function mergeHeaders(?customHeaders: Map<String, String>): Map<String, String> {
        var merged = new Map<String, String>();
        
        // Add default headers
        for (key in defaultHeaders.keys()) {
            merged.set(key, defaultHeaders.get(key));
        }
        
        // Override with custom headers
        if (customHeaders != null) {
            for (key in customHeaders.keys()) {
                merged.set(key, customHeaders.get(key));
            }
        }
        
        return merged;
    }
    
    // Async version for better JavaScript practices
    public function getAsync(url: String, ?headers: Map<String, String>, callback: String -> Void, ?errorCallback: HttpError -> Void): Void {
        makeRequestAsync("GET", url, null, headers, callback, errorCallback);
    }
    
    public function postAsync(url: String, body: String, ?headers: Map<String, String>, callback: String -> Void, ?errorCallback: HttpError -> Void): Void {
        makeRequestAsync("POST", url, body, headers, callback, errorCallback);
    }
    
    private function makeRequestAsync(method: String, url: String, ?body: String, ?headers: Map<String, String>, callback: String -> Void, ?errorCallback: HttpError -> Void): Void {
        var fullUrl = baseUrl + url;
        var mergedHeaders = mergeHeaders(headers);
        
        var xhr = new XMLHttpRequest();
        xhr.open(method, fullUrl, true); // true = asynchronous
        
        xhr.onreadystatechange = function() {
            if (xhr.readyState == 4) {
                if (xhr.status >= 200 && xhr.status < 300) {
                    callback(xhr.responseText);
                } else {
                    var error = new HttpError(xhr.status, xhr.statusText, xhr.responseText);
                    if (errorCallback != null) {
                        errorCallback(error);
                    } else {
                        Browser.console.error("HTTP Error: " + error.toString());
                    }
                }
            }
        };
        
        // Set headers
        for (key in mergedHeaders.keys()) {
            xhr.setRequestHeader(key, mergedHeaders.get(key));
        }
        
        xhr.send(body);
    }
}

class HttpError {
    public var statusCode: Int;
    public var statusText: String;
    public var responseBody: String;
    
    public function new(statusCode: Int, statusText: String, responseBody: String) {
        this.statusCode = statusCode;
        this.statusText = statusText;
        this.responseBody = responseBody;
    }
    
    public function toString(): String {
        return 'HTTP $statusCode: $statusText - $responseBody';
    }
}