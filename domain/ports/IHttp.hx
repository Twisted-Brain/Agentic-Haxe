package domain.ports;

/**
 * HTTP client interface for cross-platform HTTP operations
 */
interface IHttp {
    function get(url: String): String;
    function post(url: String, data: String): String;
    function put(url: String, data: String): String;
    function delete(url: String): String;
    function setHeader(name: String, value: String): Void;
}