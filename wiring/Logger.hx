package wiring;

/**
 * Typedef binding for Logger - maps to platform-specific implementations
 * Provides unified logging interface across all targets
 */
#if js
typedef Logger = platform.js.LoggerJs;
#elseif cpp
typedef Logger = platform.cpp.LoggerCpp;
#elseif java
typedef Logger = platform.java.LoggerJava;
#elseif python
typedef Logger = platform.python.LoggerPython;
#elseif php
typedef Logger = platform.php.LoggerPhp;
#elseif cs
typedef Logger = platform.csharp.LoggerCsharp;
#elseif neko
typedef Logger = platform.neko.LoggerNeko;
#else
#error "Logger: Unsupported target platform"
#end