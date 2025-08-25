package platform.frontend;

import domain.ports.IClock;
import js.Browser;

/**
 * JavaScript-specific clock implementation for frontend
 * Uses browser's Date API and performance timing
 */
class PlatformClockJs implements IClock {
    private var startTime: Float;
    
    public function new() {
        this.startTime = getHighResolutionTime();
    }
    
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
    
    public function formatDuration(milliseconds: Float): String {
        if (milliseconds < 1000) {
            return Math.round(milliseconds) + "ms";
        } else if (milliseconds < 60000) {
            return Math.round(milliseconds / 1000 * 100) / 100 + "s";
        } else {
            var minutes = Math.floor(milliseconds / 60000);
            var seconds = Math.round((milliseconds % 60000) / 1000);
            return minutes + "m " + seconds + "s";
        }
    }
    
    public function sleep(milliseconds: Int): Void {
        // JavaScript doesn't have synchronous sleep
        // This is a placeholder - in real usage, use async/await patterns
        Browser.console.warn("Synchronous sleep not supported in JavaScript. Use async patterns instead.");
    }
    
    public function createTimer(intervalMs: Int, callback: Void -> Void): Int {
        return Browser.window.setInterval(callback, intervalMs);
    }
    
    public function cancelTimer(timerId: Int): Void {
        Browser.window.clearInterval(timerId);
    }
    
    public function createTimeout(delayMs: Int, callback: Void -> Void): Int {
        return Browser.window.setTimeout(callback, delayMs);
    }
    
    public function cancelTimeout(timeoutId: Int): Void {
        Browser.window.clearTimeout(timeoutId);
    }
    
    private function getHighResolutionTime(): Float {
        // Use performance.now() if available, fallback to Date.now()
        if (js.Syntax.code("typeof performance !== 'undefined' && performance.now")) {
            return js.Syntax.code("performance.now()");
        } else {
            return Date.now().getTime();
        }
    }
}