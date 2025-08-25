package platform.js;

import domain.ports.ILogger;

/**
 * JavaScript implementation of ILogger port.
 * Uses browser console API for logging operations.
 */
class LoggerJs implements ILogger {
    public function new() {}
    
    public function debug(message: String, ?context: Dynamic): Void {
        if (context != null) {
            js.Browser.console.debug(message, context);
        } else {
            js.Browser.console.debug(message);
        }
    }
    
    public function info(message: String, ?context: Dynamic): Void {
        if (context != null) {
            js.Browser.console.info(message, context);
        } else {
            js.Browser.console.info(message);
        }
    }
    
    public function warn(message: String, ?context: Dynamic): Void {
        if (context != null) {
            js.Browser.console.warn(message, context);
        } else {
            js.Browser.console.warn(message);
        }
    }
    
    public function error(message: String, ?context: Dynamic): Void {
        if (context != null) {
            js.Browser.console.error(message, context);
        } else {
            js.Browser.console.error(message);
        }
    }
    
    public function fatal(message: String, ?context: Dynamic): Void {
        if (context != null) {
            js.Browser.console.error('[FATAL]', message, context);
        } else {
            js.Browser.console.error('[FATAL]', message);
        }
    }
}