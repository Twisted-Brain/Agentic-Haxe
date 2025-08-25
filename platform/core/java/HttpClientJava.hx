package platform.java;

import domain.ports.IHttp;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.URI;
import java.time.Duration;

/**
 * Java implementation of IHttp port.
 * Uses Java 11+ HttpClient for HTTP operations.
 */
class HttpClientJava implements IHttp {
    private var client: HttpClient;
    
    public function new() {
        this.client = HttpClient.newBuilder()
            .connectTimeout(Duration.ofSeconds(30))
            .build();
    }
    
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
            try {
                var requestBuilder = HttpRequest.newBuilder()
                    .uri(URI.create(url))
                    .timeout(Duration.ofSeconds(30));
                
                // Set headers
                if (headers != null) {
                    for (key in headers.keys()) {
                        requestBuilder.header(key, headers.get(key));
                    }
                }
                
                // Set method and body
                switch (method) {
                    case "GET":
                        requestBuilder.GET();
                    case "POST":
                        requestBuilder.POST(HttpRequest.BodyPublishers.ofString(body != null ? body : ""));
                    case "PUT":
                        requestBuilder.PUT(HttpRequest.BodyPublishers.ofString(body != null ? body : ""));
                    case "DELETE":
                        requestBuilder.DELETE();
                }
                
                var request = requestBuilder.build();
                
                var response = client.send(request, HttpResponse.BodyHandlers.ofString());
                
                var responseHeaders = new Map<String, String>();
                var headerMap = response.headers().map();
                for (key in headerMap.keySet()) {
                    var values = headerMap.get(key);
                    if (values.size() > 0) {
                        responseHeaders.set(key, values.get(0));
                    }
                }
                
                var httpResponse: domain.ports.IHttp.HttpResponse = {
                    status: response.statusCode(),
                    headers: responseHeaders,
                    body: response.body()
                };
                
                resolve(httpResponse);
            } catch (e: Dynamic) {
                reject(e);
            }
        });
    }
}