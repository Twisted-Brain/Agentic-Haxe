package domain.ports;

/**
 * Clock interface for time-related operations across all platforms.
 * This is the shared contract that all platform implementations must follow.
 */
interface IClock {
    function nowMs(): Float;
    function now(): Date;
    function delay(ms: Int): Promise<Void>;
}