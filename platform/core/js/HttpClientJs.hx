package platform.js;

import domain.ports.IHttp;
import js.html.XMLHttpRequest;

/**
 * JavaScript implementation of IHttp port.
 * Uses XMLHttpRequest or fetch API for HTTP operations.
 */
class HttpClientJs implements IHttp {
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
            var xhr = new XMLHttpRequest();
            
            xhr.onreadystatechange = function() {
                if (xhr.readyState == 4) {
                    var responseHeaders = new Map<String, String>();
                    var headerString = xhr.getAllResponseHeaders();
                    if (headerString != null) {
                        var headerLines = headerString.split("\r\n");
                        for (line in headerLines) {
                            var parts = line.split(": ");
                            if (parts.length == 2) {
                                responseHeaders.set(parts[0], parts[1]);
                            }
                        }
                    }
                    
                    var response: domain.ports.IHttp.HttpResponse = {
                        status: xhr.status,
                        headers: responseHeaders,
                        body: xhr.responseText
                    };
                    
                    if (xhr.status >= 200 && xhr.status < 300) {
                        resolve(response);
                    } else {
                        reject(new js.lib.Error('HTTP ${xhr.status}: ${xhr.statusText}'));
                    }
                }
            };
            
            xhr.open(method, url, true);
            
            if (headers != null) {
                for (key in headers.keys()) {
                    xhr.setRequestHeader(key, headers.get(key));
                }
            }
            
            xhr.send(body);
        });
    }
}