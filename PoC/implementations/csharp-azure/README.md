# PoC 05: C# Azure Microservices Implementation

## Overview
Haxe C# target for .NET AI microservices with Azure cloud deployment and enterprise integration.

## Directory Structure
```
csharp-azure/
├── src/                    # Haxe source code
│   ├── CSharpAIService.hx # Main .NET service
│   ├── AzureIntegration.hx# Azure services integration
│   └── DotNetCore.hx      # .NET Core optimization
├── build/                  # Compiled C# output
├── tests/                  # Test files
├── *.csproj               # .NET project file
└── README.md              # This file
```

## Setup
1. Install .NET dependencies: `dotnet restore`
2. Compile to C#: `haxe -cs build/ -main CSharpAIService -cp src`
3. Run: `dotnet run --project build/`

## Target Platforms
- Azure App Service
- Azure Container Instances
- Azure Kubernetes Service
- Azure Functions

## Key Features
- .NET 6+ compatibility
- Azure Active Directory integration
- Azure Cognitive Services
- Microservices architecture
- Azure DevOps CI/CD
- Enterprise security

## Dependencies
- .NET 6.0+
- Azure SDK
- Entity Framework Core
- ASP.NET Core

## Performance Targets
- Cold start: <2 seconds
- Throughput: >500 requests/second
- Memory usage: <256MB baseline
- Azure scaling: 0-100 instances