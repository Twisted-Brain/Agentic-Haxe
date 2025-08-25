package platform.core.cpp;

import domain.ports.IClock;

/**
 * C++ implementation of IClock port.
 * Uses C++ standard library time functions.
 */
class PlatformClockCpp implements IClock {
    public function new() {}
    
    public function nowMs(): Float {
        return Sys.time() * 1000.0;
    }
    
    public function nowSeconds(): Float {
        return Sys.time();
    }
    
    public function formatTimestamp(timestamp: Float): String {
        var date = Date.fromTime(timestamp);
        return date.toString();
    }
}