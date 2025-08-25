package platform.cpp;

import domain.ports.IClock;
import cpp.vm.Thread;

/**
 * C++ implementation of IClock port.
 * Uses C++ standard library time functions.
 */
class PlatformClockCpp implements IClock {
    public function new() {}
    
    public function nowMs(): Float {
        return Sys.time() * 1000.0;
    }
    
    public function now(): Date {
        return Date.now();
    }
    
    public function delay(ms: Int): Promise<Void> {
        return new Promise<Void>((resolve, reject) -> {
            Thread.create(() -> {
                Sys.sleep(ms / 1000.0);
                resolve(null);
            });
        });
    }
}