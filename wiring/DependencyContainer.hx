package wiring;

import domain.ports.IHttp;
import domain.ports.ILogger;
import domain.ports.IClock;

/**
 * Central dependency container that provides clean access to all platform adapters
 * Uses compile-time typedef bindings for zero runtime overhead
 */
class DependencyContainer {
    private static var _httpClient: IHttp;
    private static var _logger: ILogger;
    private static var _clock: IClock;
    
    /**
     * Get HTTP client instance (lazy initialization)
     */
    public static function getHttpClient(): IHttp {
        if (_httpClient == null) {
            _httpClient = new HttpClient();
        }
        return _httpClient;
    }
    
    /**
     * Get logger instance (lazy initialization)
     */
    public static function getLogger(): ILogger {
        if (_logger == null) {
            _logger = new Logger();
        }
        return _logger;
    }
    
    /**
     * Get clock instance (lazy initialization)
     */
    public static function getClock(): IClock {
        if (_clock == null) {
            _clock = new PlatformClock();
        }
        return _clock;
    }
    
    /**
     * Reset all dependencies (useful for testing)
     */
    public static function reset(): Void {
        _httpClient = null;
        _logger = null;
        _clock = null;
    }
    
    /**
     * Inject custom dependencies (useful for testing)
     */
    public static function inject(httpClient: IHttp = null, logger: ILogger = null, clock: IClock = null): Void {
        if (httpClient != null) _httpClient = httpClient;
        if (logger != null) _logger = logger;
        if (clock != null) _clock = clock;
    }
}