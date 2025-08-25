package shared;

import wiring.ApplicationBootstrap;
import wiring.DependencyContainer;

/**
 * Shared library main entry point
 * Provides common functionality across all platforms
 */
class SharedMain {
    public static function main(): Void {
        trace("Shared library initialized");
        ApplicationBootstrap.initialize();
    }
    
    /**
     * Get shared API version
     */
    public static function getVersion(): String {
        return "1.0.0";
    }
    
    /**
     * Initialize shared services
     */
    public static function initializeServices(): Void {
        ApplicationBootstrap.initialize();
    }
}