package domain.ports;

/**
 * Clock interface for cross-platform time operations
 */
interface IClock {
    function nowMs(): Float;
    function nowSeconds(): Float;
    function formatTimestamp(timestamp: Float): String;
}