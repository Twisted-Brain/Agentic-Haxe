package platform.js;

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
    
    public function now(): Date {
        return Date.now();
    }
    
    public function delay(ms: Int): Promise<Void> {
        return new Promise<Void>((resolve, reject) -> {
            js.Browser.window.setTimeout(() -> {
                resolve(null);
            }, ms);
        });
    }
}