package platform.java;

import domain.ports.ILogger;
import java.util.logging.Logger;
import java.util.logging.Level;

/**
 * Java implementation of ILogger port.
 * Uses Java's built-in logging framework.
 */
class LoggerJava implements ILogger {
    private var logger: Logger;
    
    public function new(?name: String) {
        this.logger = Logger.getLogger(name != null ? name : "HaxeAI");
    }
    
    public function debug(message: String, ?context: Dynamic): Void {
        var logMessage = formatMessage(message, context);
        logger.log(Level.FINE, logMessage);
    }
    
    public function info(message: String, ?context: Dynamic): Void {
        var logMessage = formatMessage(message, context);
        logger.log(Level.INFO, logMessage);
    }
    
    public function warn(message: String, ?context: Dynamic): Void {
        var logMessage = formatMessage(message, context);
        logger.log(Level.WARNING, logMessage);
    }
    
    public function error(message: String, ?context: Dynamic): Void {
        var logMessage = formatMessage(message, context);
        logger.log(Level.SEVERE, logMessage);
    }
    
    public function fatal(message: String, ?context: Dynamic): Void {
        var logMessage = formatMessage(message, context);
        logger.log(Level.SEVERE, "[FATAL] " + logMessage);
    }
    
    private function formatMessage(message: String, ?context: Dynamic): String {
        if (context != null) {
            return message + " | Context: " + haxe.Json.stringify(context);
        }
        return message;
    }
}