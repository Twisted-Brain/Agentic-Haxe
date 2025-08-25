package platform.frontend;

import domain.ports.ILogger;
import js.Browser;

/**
 * JavaScript-specific logger implementation for frontend
 * Outputs to browser console with different log levels
 */
class LoggerJs implements ILogger {
    private var logLevel: LogLevel;
    
    public function new(logLevel: LogLevel = LogLevel.INFO) {
        this.logLevel = logLevel;
    }
    
    public function debug(message: String, ?context: Dynamic): Void {
        if (shouldLog(LogLevel.DEBUG)) {
            Browser.console.debug(formatMessage("DEBUG", message, context));
        }
    }
    
    public function info(message: String, ?context: Dynamic): Void {
        if (shouldLog(LogLevel.INFO)) {
            Browser.console.info(formatMessage("INFO", message, context));
        }
    }
    
    public function warn(message: String, ?context: Dynamic): Void {
        if (shouldLog(LogLevel.WARN)) {
            Browser.console.warn(formatMessage("WARN", message, context));
        }
    }
    
    public function error(message: String, ?context: Dynamic): Void {
        if (shouldLog(LogLevel.ERROR)) {
            Browser.console.error(formatMessage("ERROR", message, context));
        }
    }
    
    public function fatal(message: String, ?context: Dynamic): Void {
        if (shouldLog(LogLevel.FATAL)) {
            Browser.console.error(formatMessage("FATAL", message, context));
        }
    }
    
    private function shouldLog(level: LogLevel): Bool {
        return getLogLevelValue(level) >= getLogLevelValue(logLevel);
    }
    
    private function getLogLevelValue(level: LogLevel): Int {
        return switch (level) {
            case LogLevel.DEBUG: 0;
            case LogLevel.INFO: 1;
            case LogLevel.WARN: 2;
            case LogLevel.ERROR: 3;
            case LogLevel.FATAL: 4;
        };
    }
    
    private function formatMessage(level: String, message: String, ?context: Dynamic): String {
        var timestamp = Date.now().toString();
        var formatted = '[$timestamp] [$level] $message';
        
        if (context != null) {
            formatted += ' | Context: ' + haxe.Json.stringify(context);
        }
        
        return formatted;
    }
}

enum LogLevel {
    DEBUG;
    INFO;
    WARN;
    ERROR;
    FATAL;
}