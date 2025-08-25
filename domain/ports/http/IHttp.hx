package domain.ports;

/**
 * HTTP client interface for making web requests.
 * This is the shared contract that all platform implementations must follow.
 */
interface IHttp {
    function get(url: String, ?headers: Map<String, String>): Promise<HttpResponse>;
    function post(url: String, body: String, ?headers: Map<String, String>): Promise<HttpResponse>;
    function put(url: String, body: String, ?headers: Map<String, String>): Promise<HttpResponse>;
    function delete(url: String, ?headers: Map<String, String>): Promise<HttpResponse>;
}

typedef HttpResponse = {
    status: Int,
    headers: Map<String, String>,
    body: String
}