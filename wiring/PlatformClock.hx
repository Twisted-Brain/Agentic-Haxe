package wiring;

/**
 * Typedef binding for PlatformClock - maps to platform-specific implementations
 * Provides unified time/clock interface across all targets
 */
#if js
typedef PlatformClock = platform.js.PlatformClockJs;
#elseif cpp
typedef PlatformClock = platform.cpp.PlatformClockCpp;
#elseif java
typedef PlatformClock = platform.java.PlatformClockJava;
#elseif python
typedef PlatformClock = platform.python.PlatformClockPython;
#elseif php
typedef PlatformClock = platform.php.PlatformClockPhp;
#elseif cs
typedef PlatformClock = platform.csharp.PlatformClockCsharp;
#elseif neko
typedef PlatformClock = platform.neko.PlatformClockNeko;
#else
#error "PlatformClock: Unsupported target platform"
#end