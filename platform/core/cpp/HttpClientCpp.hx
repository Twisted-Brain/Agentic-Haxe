package platform.cpp;

import domain.ports.IHttp;
import haxe.Http;

/**
 * C++ implementation of IHttp port.
 * Uses Haxe's built-in Http class with C++ backend.
 */
class HttpClientCpp implements IHttp {
    public function new() {}
    
    public function get(url: String, ?headers: Map<String, String>): Promise<domain.ports.IHttp.HttpResponse> {
        return makeRequest("GET", url, null, headers);
    }
    
    public function post(url: String, body: String, ?headers: Map<String, String>): Promise<domain.ports.IHttp.HttpResponse> {
        return makeRequest("POST", url, body, headers);
    }
    
    public function put(url: String, body: String, ?headers: Map<String, String>): Promise<domain.ports.IHttp.HttpResponse> {
        return makeRequest("PUT", url, body, headers);
    }
    
    public function delete(url: String, ?headers: Map<String, String>): Promise<domain.ports.IHttp.HttpResponse> {
        return makeRequest("DELETE", url, null, headers);
    }
    
    private function makeRequest(method: String, url: String, ?body: String, ?headers: Map<String, String>): Promise<domain.ports.IHttp.HttpResponse> {
        return new Promise<domain.ports.IHttp.HttpResponse>((resolve, reject) -> {
            var http = new Http(url);
            
            // Set headers
            if (headers != null) {
                for (key in headers.keys()) {
                    http.setHeader(key, headers.get(key));
                }
            }
            
            // Set request body for POST/PUT
            if (body != null) {
                http.setPostData(body);
            }
            
            // Configure callbacks
            http.onData = function(data: String) {
                var responseHeaders = new Map<String, String>();
                // Note: Haxe Http doesn't provide easy access to response headers in C++
                // This would need platform-specific implementation for full header support
                
                var response: domain.ports.IHttp.HttpResponse = {
                    status: 200, // Http class doesn't expose status code easily
                    headers: responseHeaders,
                    body: data
                };
                resolve(response);
            };
            
            http.onError = function(error: String) {
                reject(new haxe.Exception(error));
            };
            
            http.onStatus = function(status: Int) {
                if (status >= 400) {
                    reject(new haxe.Exception('HTTP Error: $status'));
                }
            };
            
            // Make the request
            http.request(method == "POST" || method == "PUT");
        });
    }
}