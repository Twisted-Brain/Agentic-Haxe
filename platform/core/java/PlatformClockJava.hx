package platform.java;

import domain.ports.IClock;

/**
 * Java implementation of IClock port.
 * Uses Java System.currentTimeMillis() and Thread.sleep().
 */
class PlatformClockJava implements IClock {
    public function new() {}
    
    public function nowMs(): Float {
        return java.lang.System.currentTimeMillis();
    }
    
    public function now(): Date {
        return Date.fromTime(java.lang.System.currentTimeMillis());
    }
    
    public function delay(ms: Int): Promise<Void> {
        return new Promise<Void>((resolve, reject) -> {
            try {
                java.lang.Thread.sleep(ms);
                resolve(null);
            } catch (e: java.lang.InterruptedException) {
                reject(e);
            }
        });
    }
}