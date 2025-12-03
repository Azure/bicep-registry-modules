---
description: 'Create, update, or review Azure IaC in Bicep using Azure Verified Modules (AVM).'
tools: ['edit', 'search', 'new', 'runCommands', 'runTasks', 'usages', 'think', 'problems', 'changes', 'testFailure', 'openSimpleBrowser', 'fetch', 'githubRepo', 'extensions', 'todos', 'runTests', 'documentation', 'search', 'github', 'Bicep (EXPERIMENTAL)/*']
---
# Azure AVM Bicep Mode

> [!IMPORTANT]
> Always start by telling the user they are in `💭 Azure AVM Bicep Mode`

## MANDATORY: Always Fetch First (AI Required Steps)
1. **AVM Process**: `https://azure.github.io/Azure-Verified-Modules/contributing/process/`
2. **LLM Index**: `https://azure.github.io/Azure-Verified-Modules/llms.txt`
3. **Resource Docs**: Fetch specific documentation for target resource types using LLM index
4. **Quick Starts**: Search Azure Quick Start templates repo for Bicep examples via `githubRepo` tool
5. **Microsoft Docs**: Use `documentation` and `search` tools when available for latest info

## Repository Structure

- `avm/res/` - Resource modules
- `avm/ptn/` - Pattern modules
- `avm/utl/` - Utility modules

## Module Structure

```text
avm/{res|ptn|utl}/{service}/{resource}/
├── main.bicep
├── version.json
└── tests/e2e/{defaults,max,waf-aligned}/
```

## Discovery
- Index: `https://azure.github.io/Azure-Verified-Modules/indexes/bicep/`
- Resources: `/bicep-resource-modules/`
- Patterns: `/bicep-pattern-modules/`

## Usage Pattern

```bicep
module example 'br/public:avm/res/storage/storage-account:0.25.0' = {
  name: 'deployment'
  params: {
    name: 'storageAccount'
    location: location
    enableTelemetry: true
    lock: { kind: 'CanNotDelete' }
    roleAssignments: [{ principalId: id, roleDefinitionIdOrName: 'Contributor' }]
    diagnosticSettings: [{ workspaceResourceId: logWorkspace.outputs.resourceId }]
  }
}
```

## MANDATORY Standards

### On Updating README.md Documentation

**🛑 NEVER update README.md documentation or Markdowns directly**: Always run the [tools/Set-AVMModule.ps1](tools/Set-AVMModule.ps1) script to update the module README.md and compile the Bicep files. You must first use `#fetch` tool to get `https://azure.github.io/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/generate-bicep-module-files/` and read it carefully first.

> [!IMPORTANT]
> Use `-SkipBuild -SkipFileAndFolderSetup -ThrottleLimit 5` parameters when running `Set-AVMModule` when running locally to update an existing module. You must run this prior to committing any changes to a module.

### Module Header
```bicep
metadata name = 'Module Name'
metadata description = 'Module description'

@description('Required. Resource name.')
param name string
@description('Optional. Location.')
param location string = resourceGroup().location
@description('Optional. Tags.')
param tags object?
@description('Optional. Enable telemetry.')
param enableTelemetry bool = true

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.3.0'
import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.3.0'
import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.3.0'
```

### Telemetry Resource
```bicep
#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.{service}-{resource}.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: { telemetry: { type: 'String', value: 'For more information, see https://aka.ms/avm/TelemetryInfo' } }
    }
  }
}
```

### Test Pattern
```bicep
@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: { name: '${namePrefix}${serviceShort}${iteration}', location: resourceLocation }
  }
]
```

## Validation Commands
```powershell
# Test module
. './utilities/tools/Test-ModuleLocally.ps1'
Test-ModuleLocally -TemplateFilePath './avm/res/{service}/{resource}' -PesterTest

# Update module files
Set-AVMModule -ModuleFolderPath './avm/res/{service}/{resource}'
```

## Rules
- camelCase: parameters, variables, outputs
- ALL parameters/outputs need `@description()`
- Use `?.` for optional properties
- Pin module versions
- Enable telemetry
- Include lock/RBAC/diagnostics where applicable

## Schema URLs
- General: `https://learn.microsoft.com/azure/templates/{resourceType}/{resourceName}?pivots=deployment-language-bicep`
- Versioned: `https://learn.microsoft.com/azure/templates/{resourceType}/{apiVersion}/{resourceName}?pivots=deployment-language-bicep`

## Tools
- `azure_get_deployment_best_practices` - deployment guidance
- `microsoft.docs.mcp` - Azure service docs
- `fetch` - schemas and documentation

## Naming
- Resources: `avm/res/{service}/{resource}`
- Patterns: `avm/ptn/{category}/{solution}`
- Registry: `br/public:avm/res/{service}/{resource}:{version}`

## GitHub Copilot Requirements
**CRITICAL WORKFLOW**:
1. Fetch: `https://azure.github.io/Azure-Verified-Modules/contributing/process/`
2. Fetch: `https://azure.github.io/Azure-Verified-Modules/llms.txt`
3. Test: `Test-ModuleLocally.ps1`
4. Update: `Set-AVMModule.ps1`
5. Validate: PSRule + idempotency tests mandatory
