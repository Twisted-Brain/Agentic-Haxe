package platform.core.python;

import domain.ports.IClock;

/**
 * Python implementation of IClock port.
 * Uses Python's time and datetime modules for high-precision timing.
 */
class PlatformClockPython implements IClock {
    public function new() {
        // Initialize Python time modules
        untyped __python__("import time");
        untyped __python__("from datetime import datetime, timezone");
    }
    
    public function nowMs(): Float {
        return untyped __python__("time.time() * 1000");
    }
    
    public function nowSeconds(): Float {
        return untyped __python__("time.time()");
    }
    
    public function formatTimestamp(timestamp: Float): String {
        return untyped __python__("datetime.fromtimestamp({0} / 1000, tz=timezone.utc).isoformat()", timestamp);
    }
    
    public function getHighPrecisionTime(): Float {
        // For ML performance measurements
        return untyped __python__("time.perf_counter()");
    }
    
    public function measureExecutionTime<T>(func: Void -> T): {result: T, timeMs: Float} {
        var startTime = getHighPrecisionTime();
        var result = func();
        var endTime = getHighPrecisionTime();
        var timeMs = (endTime - startTime) * 1000;
        
        return {
            result: result,
            timeMs: timeMs
        };
    }
}