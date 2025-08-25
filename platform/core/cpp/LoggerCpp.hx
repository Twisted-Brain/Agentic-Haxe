package platform.cpp;

import domain.ports.ILogger;
import cpp.Lib;

/**
 * C++ implementation of ILogger port.
 * Uses C++ standard output and Haxe trace for logging.
 */
class LoggerCpp implements ILogger {
    public function new() {}
    
    public function debug(message: String, ?context: Dynamic): Void {
        var logMessage = '[DEBUG] $message';
        if (context != null) {
            logMessage += ' | Context: ${haxe.Json.stringify(context)}';
        }
        trace(logMessage);
    }
    
    public function info(message: String, ?context: Dynamic): Void {
        var logMessage = '[INFO] $message';
        if (context != null) {
            logMessage += ' | Context: ${haxe.Json.stringify(context)}';
        }
        trace(logMessage);
    }
    
    public function warn(message: String, ?context: Dynamic): Void {
        var logMessage = '[WARN] $message';
        if (context != null) {
            logMessage += ' | Context: ${haxe.Json.stringify(context)}';
        }
        trace(logMessage);
    }
    
    public function error(message: String, ?context: Dynamic): Void {
        var logMessage = '[ERROR] $message';
        if (context != null) {
            logMessage += ' | Context: ${haxe.Json.stringify(context)}';
        }
        Lib.println(logMessage); // Use Lib.println for errors to ensure they're visible
    }
    
    public function fatal(message: String, ?context: Dynamic): Void {
        var logMessage = '[FATAL] $message';
        if (context != null) {
            logMessage += ' | Context: ${haxe.Json.stringify(context)}';
        }
        Lib.println(logMessage);
        // In a real implementation, you might want to exit the application here
    }
}