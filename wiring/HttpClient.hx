package wiring;

/**
 * Typedef binding for HttpClient - maps to platform-specific implementations
 * This provides compile-time dependency injection without runtime overhead
 */
#if js
typedef HttpClient = platform.js.HttpClientJs;
#elseif cpp
typedef HttpClient = platform.cpp.HttpClientCpp;
#elseif java
typedef HttpClient = platform.java.HttpClientJava;
#elseif python
typedef HttpClient = platform.python.HttpClientPython;
#elseif php
typedef HttpClient = platform.php.HttpClientPhp;
#elseif cs
typedef HttpClient = platform.csharp.HttpClientCsharp;
#elseif neko
typedef HttpClient = platform.neko.HttpClientNeko;
#else
#error "HttpClient: Unsupported target platform"
#end