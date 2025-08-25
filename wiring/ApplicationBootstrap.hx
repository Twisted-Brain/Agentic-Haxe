package wiring;

import domain.ports.ILogger;
import domain.ports.IClock;
import domain.ports.IHttp;

/**
 * Application bootstrap that handles initialization and configuration
 * Provides clean startup sequence with proper dependency wiring
 */
class ApplicationBootstrap {
    private static var _isInitialized: Bool = false;
    private static var _logger: ILogger;
    
    /**
     * Initialize the application with all dependencies
     */
    public static function initialize(): Void {
        if (_isInitialized) {
            return;
        }
        
        // Initialize logger first for startup logging
        _logger = DependencyContainer.getLogger();
        _logger.info("ApplicationBootstrap: Starting initialization...");
        
        // Initialize core dependencies
        var clock = DependencyContainer.getClock();
        var httpClient = DependencyContainer.getHttpClient();
        
        // Log successful initialization
        _logger.info("ApplicationBootstrap: Dependencies initialized successfully");
        _logger.info('ApplicationBootstrap: Clock timestamp: ${clock.nowMs()}');
        
        _isInitialized = true;
        _logger.info("ApplicationBootstrap: Application ready");
    }
    
    /**
     * Shutdown the application gracefully
     */
    public static function shutdown(): Void {
        if (!_isInitialized) {
            return;
        }
        
        if (_logger != null) {
            _logger.info("ApplicationBootstrap: Shutting down application...");
        }
        
        // Reset all dependencies
        DependencyContainer.reset();
        
        _isInitialized = false;
        
        if (_logger != null) {
            _logger.info("ApplicationBootstrap: Shutdown complete");
        }
    }
    
    /**
     * Check if application is initialized
     */
    public static function isInitialized(): Bool {
        return _isInitialized;
    }
    
    /**
     * Get application info for debugging
     */
    public static function getApplicationInfo(): String {
        var info = "Application Status: " + (_isInitialized ? "Initialized" : "Not Initialized");
        
        if (_isInitialized) {
            var clock = DependencyContainer.getClock();
            info += '\nCurrent Time: ${clock.nowMs()}';
            info += '\nPlatform: ${getPlatformName()}';
        }
        
        return info;
    }
    
    /**
     * Get current platform name for debugging
     */
    private static function getPlatformName(): String {
        #if js
        return "JavaScript";
        #elseif cpp
        return "C++";
        #elseif java
        return "Java";
        #elseif python
        return "Python";
        #elseif php
        return "PHP";
        #elseif cs
        return "C#";
        #elseif neko
        return "Neko";
        #else
        return "Unknown";
        #end
    }
}