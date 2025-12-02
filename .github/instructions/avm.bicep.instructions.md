---
description: "Rules of generating and maintaining Bicep modules with AVM best practices and formatting guidelines with GitHub Copilot"
applyTo: "avm/**/*.bicep"
---

# Bicep with AVM Best Practices for AI Code Generation

Azure Verified Modules (AVM) provides and defines the definition of what a good Infrastructure as Code (IaC) module is.

**You MUST ALWAYS adhere to ALL AVM Bicep best practices, naming conventions, version management, development guidelines, and validation requirements described or referenced in these instructions when generating or modifying Bicep code in this repository.**

## Critical Compliance Requirements

### Running local validation tests

**⚠️ MANDATORY for GitHub Copilot Agents**: When GitHub Copilot Agent or GitHub Copilot Coding Agent is working on AVM Bicep repositories and any of the files in the `./avm/**` folder are changed, the following local validation tests MUST be executed before any pull request is created or updated: `./utilities/tools/Test-ModuleLocally.ps1`. **Failure to run these tests will cause PR validation failures and prevent successful merges.**

### Updating README.md Documentation

**🛑 NEVER update README.md documentation or Markdowns directly**: After making changes to any Bicep code, you must always run the [./utilities/tools/Set-AVMModule.ps1](./utilities/tools/Set-AVMModule.ps1) script to update the module README.md and compile the Bicep files. You must first use the `#fetch` tool to get `https://azure.github.io/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/generate-bicep-module-files/` and read it carefully first.

> [!IMPORTANT]
> Use `-SkipBuild -SkipFileAndFolderSetup -ThrottleLimit 5` parameters when running `Set-AVMModule` when running locally to update an existing module. You must run this prior to committing any changes to a module.

#### Usage Example

```powershell
Set-AVMModule -ModuleFolderPath 'C:\avm\res\key-vault\vault'
```

### Always Use Quick Starts

When generating AVM Bicep code and no relevant examples are found in this repository, refer to the Bicep Quick Starts in the https://github.com/Azure/azure-quickstart-templates repo. Use the `githubRepo` tool to search for relevant Bicep Quick Starts as examples of how to deploy specific resources.

## Required Template Structure

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

## Naming Conventions

### Module Types

- **Resource Modules**: `avm/res/{resource provider}/{resource type in singular form}/`
  - Example: `avm/res/storage/storage-account`
- **Pattern Modules**: `avm/ptn/{category or group name}/{pattern name}`
  - Example: `avm/ptn/ai-ml/ai-foundry`
- **Utility Modules**: `avm/utl/{category or group name}/{utility name}`
  - Example: `avm/utl/types/avm-common-types`

### Module Naming

- Use kebab-case for separating words in module names (e.g., `storage-account`, `virtual-network`).
- When creating new modules, follow Azure resource provider naming (e.g., `storage/storage-account`, `network/virtual-network`) and match Azure resource provider hierarchy when possible
- When referencing existing modules, follow the module indexes

## Version Management

### Version Pinning Best Practices

- Prefer using the latest API versions
- Use specific versions for production: `br/public:avm/res/storage/storage-account:0.9.1`
- Always use the latest available version for development: `br/public:avm/res/storage/storage-account:latest`
- Always review changelog before upgrading major versions

> [!IMPORTANT]
> The tags list returned by MCR is not in version order. You must order the list first when checking for latest versions!

## Development Best Practices

When creating or updating AVM Bicep modules, ALWAYS follow these best practices:

### Referencing (Using) existing AVM Bicep Modules
- ✅ **Always** use published AVM modules from MCR when available
- ✅ **Start** with official examples from AVM documentation
- ✅ **Pin** module versions for production deployments
- ✅ **Use** `uniqueString()` for resource naming to avoid conflicts
- ✅ **Follow** AVM interface specifications for optional features
- ✅ **Include** proper `@description()` decorators for all parameters and outputs

#### Referencing modules from the public Registry (MCR) - Recommended

1. Usage Example - Storage Account Module

```bicep
// Reference published AVM module from MCR
module storageAccount 'br/public:avm/res/storage/storage-account:0.9.1' = {
  name: 'storageAccountDeployment'
  params: {
    name: 'mystorageaccount${uniqueString(resourceGroup().id)}'
    location: location
    skuName: 'Standard_LRS'
    // Additional configuration...
  }
}
```

2. Usage Example - Virtual Network Module

```bicep
module virtualNetwork 'br/public:avm/res/network/virtual-network:0.8.0' = {
  name: 'virtualNetworkDeployment'
  params: {
    name: 'myVnet'
    location: location
    addressPrefixes: ['10.0.0.0/16']
    enableTelemetry: true
  }
}
```

3. Usage Example - Key Vault Module

```bicep
module keyVault 'br/public:avm/res/key-vault/vault:0.7.1' = {
  name: 'keyVaultDeployment'
  params: {
    name: 'myKeyVault${uniqueString(resourceGroup().id)}'
    location: location
    enableTelemetry: true
  }
}
```

#### Referencing modules from local path - For Development purposes only

1. Usage Example -  Storage Account Module

When developing or testing modules locally, reference them using relative paths:
```bicep
// Reference local AVM module during development
module storageAccount '../../../avm/res/storage/storage-account/main.bicep' = {
  name: 'storageAccountDeployment'
  params: {
    name: 'mystorageaccount${uniqueString(resourceGroup().id)}'
    location: location
    skuName: 'Standard_LRS'
    // Additional configuration...
  }
}
```


### Code Quality

- ✅ **Always** validate Bicep syntax before committing
- ✅ **Use** meaningful parameter and variable names
- ✅ **Add** proper metadata and descriptions
- ✅ **Follow** Azure naming conventions and constraints
- ✅ **Test** with all required test scenarios (defaults/max/waf-aligned)
- ✅ **Document** any customizations or deviations from examples

### Code Styling (Mandatory)

- Use `camelCasing` for all parameters, variables, and outputs
- Add `@description()` decorators to ALL parameters and outputs
- Follow AVM interface specifications for consistent optional features
- Resource modules: `avm/res/{provider}/{resource}`
- Pattern modules: `avm/ptn/{category}/{solution}`
- Module names: kebab-case, parameters: camelCase
- Use safe-dereference operator `?.` for optional nested properties

### Test Pattern (Mandatory for All Modules)

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

### Deprecation Pattern (When Breaking Changes)

```bicep
// Mark deprecated parameters with clear guidance
@description('Optional. Note: This is a deprecated property, please use `newProperty` instead.')
param oldProperty string?

// Use coalesce operator for backward compatibility
someValue: newProperty ?? oldProperty ?? 'defaultValue'
```

## Validation Requirements

- All modules auto-generate workflows in `.github/workflows/`
- Tests must validate idempotency (`init` + `idem` iterations)
- Must pass PSRule Azure Well-Architected Framework checks
- Use `uniqueString()` for resource naming in tests
- Follow AVM interface specifications (RMFR4, RMFR5) for optional features
- All parameters and outputs require `@description()` decorators

Before creating or updating any pull request:

Use `./utilities/tools/Test-ModuleLocally.ps1` for local testing:

```powershell
# Load the script (dot-source)
. './utilities/tools/Test-ModuleLocally.ps1'

# Run Pester tests (MANDATORY)
Test-ModuleLocally -TemplateFilePath './avm/res/{first segment of module name}/{second segment of module name}' -PesterTest

# Run validation test - dry-run (RECOMMENDED)
Test-ModuleLocally -TemplateFilePath './avm/res/{first segment of module name}/{second segment of module name}' -ValidationTest -ValidateOrDeployParameters @{subscriptionId='{subscriptionId}'; managementGroupId='managementGroupId'}
```

#### Example Usage

```powershell
# Load the script (dot-source)
. './utilities/tools/Test-ModuleLocally.ps1'

# Run Pester tests (MANDATORY)
Test-ModuleLocally -TemplateFilePath './avm/res/storage/storage-account' -PesterTest

# Run validation test - dry-run (RECOMMENDED)
Test-ModuleLocally -TemplateFilePath './avm/res/storage/storage-account' -ValidationTest -ValidateOrDeployParameters @{subscriptionId='00000000-0000-0000-0000-DEADBEEFDEAD'; managementGroupId='00000000-0000-0000-0000-DEADBEEFDEAD'}
```
**Critical**: Use unique `namePrefix` values to avoid token replacement conflicts with module content.

## Troubleshooting

### Common Issues
1. **Module Resolution**: Ensure MCR paths are correct and module versions exist
2. **Parameter Validation**: Check required parameters and data types in module documentation
3. **Naming Conflicts**: Use `uniqueString()` for globally unique resource names
4. **API Version Compatibility**: Verify ARM API versions match module requirements
5. **Validation Failures**: Run local Pester tests (validation tests) before committing changes

### Support Resources
- **AVM Documentation**: `https://azure.github.io/Azure-Verified-Modules/` - see `https://azure.github.io/Azure-Verified-Modules/llms.txt` for LLM documentation index
- **Bicep Documentation**: `https://docs.microsoft.com/azure/azure-resource-manager/bicep/`
- **GitHub Issues**: Report issues in the bicep-registry-modules repository - `https://github.com/Azure/bicep-registry-modules/issues`
- **Community**: Azure Bicep GitHub discussions - `https://github.com/Azure/bicep/discussions`

## Compliance Checklist

Before submitting any AVM-related Bicep code - use `#todos` to track outstanding tasks:

- [ ] Module version is pinned or uses appropriate MCR reference
- [ ] All parameters have `@description()` decorators
- [ ] Code passes Bicep linting and validation
- [ ] Pester tests pass (`Test-ModuleLocally -PesterTest`)
- [ ] Validation tests pass (dry-run recommended)
- [ ] PSRule checks pass for Well-Architected Framework
- [ ] Documentation is updated with examples
- [ ] Test scenarios cover defaults, max, and waf-aligned cases
- [ ] `uniqueString()` used for resource naming in tests
- [ ] AVM interface specifications followed (RMFR4, RMFR5)
- [ ] README.md auto-generated using `Set-AVMModule.ps1`
