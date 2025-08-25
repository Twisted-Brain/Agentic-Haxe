package platform.core.js;

import domain.ports.IClock;

/**
 * JavaScript implementation of IClock port.
 * Uses browser/Node.js Date API for time operations.
 */
class PlatformClockJs implements IClock {
    public function new() {}
    
    public function nowMs(): Float {
        return js.lib.Date.now();
    }
    
    public function nowSeconds(): Float {
        return js.lib.Date.now() / 1000;
    }
    
    public function formatTimestamp(timestamp: Float): String {
        var date = new js.lib.Date(timestamp);
        return date.toISOString();
    }
}