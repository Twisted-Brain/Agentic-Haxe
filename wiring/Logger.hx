package wiring;

/**
 * Typedef binding for Logger - maps to platform-specific implementations
 * Provides unified logging interface across all targets
 */
#if js
typedef Logger = platform.frontend.js.LoggerJs;
#elseif cpp
typedef Logger = platform.core.cpp.LoggerCpp;
#elseif java
typedef Logger = platform.core.java.LoggerJava;
#elseif python
typedef Logger = platform.core.python.LoggerPython;
#elseif php
typedef Logger = platform.core.php.LoggerPhp;
#elseif cs
typedef Logger = platform.core.csharp.LoggerCsharp;
#elseif neko
typedef Logger = platform.core.neko.LoggerNeko;
#else
#error "Logger: Unsupported target platform"
#end