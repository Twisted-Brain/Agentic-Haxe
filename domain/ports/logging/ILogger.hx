package domain.ports;

/**
 * Logger interface for structured logging across all platforms.
 * This is the shared contract that all platform implementations must follow.
 */
interface ILogger {
    function debug(message: String, ?context: Dynamic): Void;
    function info(message: String, ?context: Dynamic): Void;
    function warn(message: String, ?context: Dynamic): Void;
    function error(message: String, ?context: Dynamic): Void;
    function fatal(message: String, ?context: Dynamic): Void;
}

enum LogLevel {
    DEBUG;
    INFO;
    WARN;
    ERROR;
    FATAL;
}