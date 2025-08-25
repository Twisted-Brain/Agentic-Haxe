<div align="center">
  <img src="../assets/logo.png" alt="Agentic Haxe Logo" width="200" height="200">
</div>

# PoC 05: Haxe C# Target for Azure Microservices

## Overview
Explore Haxe C# compilation target for .NET AI microservices with Azure cloud deployment and enterprise integration.

## Target Platforms

### Primary: Azure Cloud
- **Platform**: Azure Container Instances / Azure Kubernetes Service
- **Runtime**: .NET 6+ with Azure optimizations
- **Deployment**: Azure DevOps pipelines
- **Scaling**: Azure autoscaling with Application Insights

### Secondary: Enterprise VPS with Windows Server
- **Platform**: Windows Server 2019+ with IIS
- **Runtime**: .NET Framework/Core hybrid
- **Deployment**: Web Deploy / PowerShell DSC
- **Scaling**: Windows Server clustering

## Technical Goals

### Core Features
- Compile Haxe AI logic to C#
- ASP.NET Core Web API development
- Azure Cognitive Services integration
- Enterprise Active Directory authentication
- SignalR real-time AI streaming

### Performance Targets
- < 30ms API response time
- Support for 15,000+ concurrent connections
- 99.95% uptime with Azure SLA
- Enterprise compliance (SOC2, GDPR)

## Implementation Plan

### Phase 1: C# Compilation Setup
```bash
# Build configuration for C#
haxe -cs bin/csharp -cp src -main HaxeAI.Services.AIService
```

### Phase 2: ASP.NET Core Integration
```haxe
// Haxe code that compiles to C#
package haxeai.services;

@:cs.using("Microsoft.AspNetCore.Mvc")
@:cs.using("Microsoft.AspNetCore.Authorization")
class CSharpAIController {
    @:cs.annotation("[ApiController]")
    @:cs.annotation("[Route(\"api/[controller]\")]")
    @:cs.annotation("[Authorize]")
    public function new() {}
    
    @:cs.annotation("[HttpPost(\"process\")]")
    public function processAIRequest(request: AIRequest): Task<AIResponse> {
        // High-performance async AI processing
        return Task.FromResult(performInferenceAsync(request));
    }
}
```

### Phase 3: Azure Integration
- Azure Cognitive Services SDK
- Azure Service Bus messaging
- Azure Application Insights telemetry
- Azure Key Vault secrets management

## Deployment Workflows

### Azure Container Deployment
```yaml
# azure-pipelines.yml
trigger:
- main

pool:
  vmImage: 'ubuntu-latest'

variables:
  buildConfiguration: 'Release'
  containerRegistry: 'haxeairegistry.azurecr.io'
  imageName: 'haxe-csharp-ai'
  tag: '$(Build.BuildId)'

stages:
- stage: Build
  jobs:
  - job: BuildAndPush
    steps:
    - task: UseDotNet@2
      inputs:
        packageType: 'sdk'
        version: '6.x'
    
    - script: |
        haxe build-csharp.hxml
        cd bin/csharp
        dotnet build --configuration $(buildConfiguration)
        dotnet publish --configuration $(buildConfiguration) --output ./publish
      displayName: 'Build Haxe to C# and compile'
    
    - task: Docker@2
      inputs:
        containerRegistry: 'Azure Container Registry'
        repository: '$(imageName)'
        command: 'buildAndPush'
        Dockerfile: 'Dockerfile'
        tags: |
          $(tag)
          latest

- stage: Deploy
  jobs:
  - deployment: DeployToAzure
    environment: 'production'
    strategy:
      runOnce:
        deploy:
          steps:
          - task: AzureContainerInstances@0
            inputs:
              azureSubscription: 'Azure Service Connection'
              resourceGroupName: 'haxe-ai-rg'
              location: 'West Europe'
              containerGroupName: 'haxe-ai-container-group'
              containerName: 'haxe-ai-service'
              image: '$(containerRegistry)/$(imageName):$(tag)'
              ports: '80 443'
              environmentVariables: |
                ASPNETCORE_ENVIRONMENT=Production
                AZURE_CLIENT_ID=$(AZURE_CLIENT_ID)
                AZURE_CLIENT_SECRET=$(AZURE_CLIENT_SECRET)
```

### Azure Kubernetes Service Deployment
```yaml
# k8s-azure-deployment.yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: haxe-csharp-ai-deployment
  namespace: production
spec:
  replicas: 5
  selector:
    matchLabels:
      app: haxe-csharp-ai
  template:
    metadata:
      labels:
        app: haxe-csharp-ai
    spec:
      containers:
      - name: ai-service
        image: haxeairegistry.azurecr.io/haxe-csharp-ai:latest
        ports:
        - containerPort: 80
        env:
        - name: ASPNETCORE_ENVIRONMENT
          value: "Production"
        - name: ConnectionStrings__DefaultConnection
          valueFrom:
            secretKeyRef:
              name: database-secret
              key: connection-string
        resources:
          requests:
            memory: "512Mi"
            cpu: "250m"
          limits:
            memory: "1Gi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /health
            port: 80
          initialDelaySeconds: 30
          periodSeconds: 10
---
apiVersion: v1
kind: Service
metadata:
  name: haxe-csharp-ai-service
  namespace: production
spec:
  selector:
    app: haxe-csharp-ai
  ports:
  - port: 80
    targetPort: 80
  type: LoadBalancer
```

### Enterprise Configuration
```csharp
// Program.cs (generated from Haxe)
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.ApplicationInsights;
using Azure.Identity;
using Azure.Security.KeyVault.Secrets;

var builder = WebApplication.CreateBuilder(args);

// Azure Key Vault integration
var keyVaultUrl = builder.Configuration["KeyVault:Url"];
if (!string.IsNullOrEmpty(keyVaultUrl))
{
    builder.Configuration.AddAzureKeyVault(
        new Uri(keyVaultUrl),
        new DefaultAzureCredential());
}

// Authentication
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.Authority = builder.Configuration["AzureAd:Authority"];
        options.Audience = builder.Configuration["AzureAd:Audience"];
    });

// Application Insights
builder.Services.AddApplicationInsightsTelemetry();

// SignalR for real-time AI streaming
builder.Services.AddSignalR();

// Haxe-generated services
builder.Services.AddScoped<HaxeAI.Services.AIService>();

var app = builder.Build();

app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();
app.MapHub<AIStreamingHub>("/ai-stream");

app.Run();
```

## Expected Benefits
- Native .NET ecosystem integration
- Azure cloud-native features
- Enterprise Active Directory integration
- High-performance async processing
- Advanced monitoring and diagnostics

## Success Metrics
- Successful Haxe → C# compilation
- Working ASP.NET Core integration
- Performance < 30ms response time
- Successful Azure deployment
- Enterprise authentication working

## Next Steps
1. Set up C# compilation target
2. Create ASP.NET Core integration
3. Build Azure deployment pipelines
4. Implement Azure services integration
5. Enterprise security and compliance