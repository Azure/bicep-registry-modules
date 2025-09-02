---
description: "Bicep with AVM best practices and formatting guidelines for AI code generation"
applyTo: "**/*.bicep"
---

# Bicep with AVM Best Practices for AI Code Generation

Azure Verified Modules (AVM) provides and define the single definition of what a good Infrastructure as Code (IaC) module is.

## Documentation (Always Review)

Before generating AVM Bicep code, always use `fetch` tool to get LLM documentation index: `https://azure.github.io/Azure-Verified-Modules/llms.txt`. Use LLM documentation index to `fetch` relevant documentation for the specific resources and patterns you are working with. If Microsoft Docs tools `documentation` and `search` are available, you MUST use them to get the most up-to-date information, otherwise use `fetch` to get documentation from Microsoft Learn.

## Always Use Quick Starts

When generating AVM Bicep code, always refer to the Bicep Quick Starts in the https://github.com/Azure/azure-quickstart-templates repo. Use the `githubRepo` tool to search for relevant Bicep Quick Starts as examples of how to deploy specific resources.

## After Making Changes

After making changes to any Bicep code, you must always run the [tools/Set-AVMModule.ps1](tools/Set-AVMModule.ps1) script to update the module README.md and compile the Bicep files.

```powershell
Set-AVMModule -ModuleFolderPath 'C:\avm\res\key-vault\vault'
```

## Required File Structure

### 1. Metadata Block (Always First)

Every main.bicep file MUST start with metadata:
```bicep
metadata name = 'Descriptive Module Name'
metadata description = 'This module deploys a [resource/pattern] with [key features].'
```

### 2. Parameter Organization (Required Order)

Parameters must follow this exact order:
1. **Required parameters** (`@description('Required. ...')`)
2. **Optional core parameters** (name, location, basic config)
3. **AVM common type imports** (see below)
4. **Optional advanced parameters** (features, configurations)

### 3. Standard Parameters (Every Module)

```bicep
@description('Required. The name of the [resource].')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true
```

### 4. Type Imports (Always Required)

```bicep
import { lockType } from 'br/public:avm/utl/types/avm-common-types:<latest-version>'
import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:<latest-version>'
import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:<latest-version>'
import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:<latest-version>'
import { privateEndpointSingleServiceType } from 'br/public:avm/utl/types/avm-common-types:<latest-version>'
```

### 5. Built-in Role Names Variable (When Using RBAC)

```bicep
var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f58310d9-a9f6-439a-9e8d-f62e7b41a168')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
}
```

### 6. Formatted Role Assignments Variable (When Using RBAC)

```bicep
var formattedRoleAssignments = [
  for (roleAssignment, index) in (roleAssignments ?? []): union(roleAssignment, {
    roleDefinitionId: builtInRoleNames[?roleAssignment.roleDefinitionIdOrName] ?? (contains(
        roleAssignment.roleDefinitionIdOrName,
        '/providers/Microsoft.Authorization/roleDefinitions/'
      )
      ? roleAssignment.roleDefinitionIdOrName
      : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName))
  })
]
```

### 7. AVM Telemetry Resource (Always Required)

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
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}
```

## Code Styling (Mandatory)
- Use `camelCasing` for all parameters, variables, and outputs
- Add `@description()` decorators to ALL parameters and outputs
- Follow AVM interface specifications for consistent optional features
- Resource modules: `avm/res/{provider}/{resource}`
- Pattern modules: `avm/ptn/{category}/{solution}`
- Module names: kebab-case, parameters: camelCase
- Use safe-dereference operator `?.` for optional nested properties

## Test Pattern (Mandatory for All Modules)
```bicep
@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: { /* test params */ }
  }
]
```

## Deprecation Pattern (When Breaking Changes)
```bicep
// Mark deprecated parameters with clear guidance
@description('Optional. Note: This is a deprecated property, please use `newProperty` instead.')
param oldProperty string?

// Use coalesce operator for backward compatibility
someValue: newProperty ?? oldProperty ?? 'defaultValue'
```

## Registry References
```bicep
module example 'br/public:avm/res/storage/storage-account:0.25.0' = {
  // Always use public registry for dependencies
}
```
