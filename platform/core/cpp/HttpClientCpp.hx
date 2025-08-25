package platform.core.cpp;

import domain.ports.IHttp;
import haxe.Http;

/**
 * C++ implementation of IHttp port.
 * Uses Haxe's built-in Http class with C++ backend.
 */
class HttpClientCpp implements IHttp {
    private var headers: Map<String, String>;
    
    public function new() {
        headers = new Map<String, String>();
    }
    
    public function get(url: String): String {
        var http = new Http(url);
        setRequestHeaders(http);
        var result = "";
        http.onData = function(data) result = data;
        http.onError = function(error) result = "Error: " + error;
        http.request(false);
        return result;
    }
    
    public function post(url: String, data: String): String {
        var http = new Http(url);
        setRequestHeaders(http);
        var result = "";
        http.onData = function(response) result = response;
        http.onError = function(error) result = "Error: " + error;
        http.setPostData(data);
        http.request(true);
        return result;
    }
    
    public function put(url: String, data: String): String {
        var http = new Http(url);
        setRequestHeaders(http);
        http.setHeader("X-HTTP-Method-Override", "PUT");
        var result = "";
        http.onData = function(response) result = response;
        http.onError = function(error) result = "Error: " + error;
        http.setPostData(data);
        http.request(true);
        return result;
    }
    
    public function delete(url: String): String {
        var http = new Http(url);
        setRequestHeaders(http);
        http.setHeader("X-HTTP-Method-Override", "DELETE");
        var result = "";
        http.onData = function(response) result = response;
        http.onError = function(error) result = "Error: " + error;
        http.request(true);
        return result;
    }
    
    public function setHeader(name: String, value: String): Void {
        headers.set(name, value);
    }
    
    private function setRequestHeaders(http: Http): Void {
        for (name in headers.keys()) {
            http.setHeader(name, headers.get(name));
        }
    }
}