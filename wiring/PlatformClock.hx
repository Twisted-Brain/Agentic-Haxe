package wiring;

/**
 * Typedef binding for PlatformClock - maps to platform-specific implementations
 * Provides unified time/clock interface across all targets
 */
#if js
typedef PlatformClock = platform.frontend.js.PlatformClockJs;
#elseif cpp
typedef PlatformClock = platform.core.cpp.PlatformClockCpp;
#elseif java
typedef PlatformClock = platform.core.java.PlatformClockJava;
#elseif python
typedef PlatformClock = platform.core.python.PlatformClockPython;
#elseif php
typedef PlatformClock = platform.core.php.PlatformClockPhp;
#elseif cs
typedef PlatformClock = platform.core.csharp.PlatformClockCsharp;
#elseif neko
typedef PlatformClock = platform.core.neko.PlatformClockNeko;
#else
#error "PlatformClock: Unsupported target platform"
#end