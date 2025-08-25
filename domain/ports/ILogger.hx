package domain.ports;

/**
 * Logger interface for cross-platform logging
 */
interface ILogger {
    function debug(message: String, ?context: Dynamic): Void;
    function info(message: String, ?context: Dynamic): Void;
    function warn(message: String, ?context: Dynamic): Void;
    function error(message: String, ?context: Dynamic): Void;
    function fatal(message: String, ?context: Dynamic): Void;
}