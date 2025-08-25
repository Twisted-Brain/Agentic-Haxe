package wiring;

/**
 * Typedef binding for HttpClient - maps to platform-specific implementations
 * This provides compile-time dependency injection without runtime overhead
 */
#if js
typedef HttpClient = platform.frontend.HttpClientJs;
#elseif cpp
typedef HttpClient = platform.core.cpp.HttpClientCpp;
#elseif java
typedef HttpClient = platform.core.java.HttpClientJava;
#elseif python
typedef HttpClient = platform.core.python.HttpClientPython;
#elseif php
typedef HttpClient = platform.core.php.HttpClientPhp;
#elseif cs
typedef HttpClient = platform.core.csharp.HttpClientCsharp;
#elseif neko
typedef HttpClient = platform.core.neko.HttpClientNeko;
#else
#error "HttpClient: Unsupported target platform"
#end