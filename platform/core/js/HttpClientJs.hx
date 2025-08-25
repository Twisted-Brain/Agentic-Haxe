package platform.core.js;

import domain.ports.IHttp;
import js.html.XMLHttpRequest;

/**
 * JavaScript implementation of IHttp port.
 * Uses XMLHttpRequest for HTTP operations.
 */
class HttpClientJs implements IHttp {
    private var headers: Map<String, String>;
    
    public function new() {
        headers = new Map<String, String>();
    }
    
    public function get(url: String): String {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", url, false);
        setRequestHeaders(xhr);
        xhr.send();
        return xhr.responseText;
    }
    
    public function post(url: String, data: String): String {
        var xhr = new XMLHttpRequest();
        xhr.open("POST", url, false);
        setRequestHeaders(xhr);
        xhr.send(data);
        return xhr.responseText;
    }
    
    public function put(url: String, data: String): String {
        var xhr = new XMLHttpRequest();
        xhr.open("PUT", url, false);
        setRequestHeaders(xhr);
        xhr.send(data);
        return xhr.responseText;
    }
    
    public function delete(url: String): String {
        var xhr = new XMLHttpRequest();
        xhr.open("DELETE", url, false);
        setRequestHeaders(xhr);
        xhr.send();
        return xhr.responseText;
    }
    
    public function setHeader(name: String, value: String): Void {
        headers.set(name, value);
    }
    
    private function setRequestHeaders(xhr: XMLHttpRequest): Void {
        for (name in headers.keys()) {
            xhr.setRequestHeader(name, headers.get(name));
        }
    }
}