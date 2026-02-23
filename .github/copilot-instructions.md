# Azure Verified Modules (AVM) - Bicep Instructions

## Overview

Azure Verified Modules (AVM) are pre-built, tested, and validated Bicep modules that follow Azure best practices. Use these modules to create, update, or review Azure Infrastructure as Code (IaC) with confidence.

This repository contains **Azure Verified Modules (AVM)** for Bicep - the official Microsoft standard for reusable Azure infrastructure modules. The codebase follows strict AVM specifications and is organized into three main module types:

- **`avm/res/`** - Resource modules (individual Azure resources)
- **`avm/ptn/`** - Pattern modules (multi-resource solutions)
- **`avm/utl/`** - Utility modules (shared types and functions)

## Critical Compliance Requirements

** ‼️ CRITICAL REQUIREMENTS FOR AVM BICEP MODULES ‼️**: All changes MUST comply with Azure Verified Modules (AVM) standards. Failure to comply will result in pull request rejections. Fetch `https://azure.github.io/Azure-Verified-Modules/llms.txt` for detailed guidelines.

**⚠️ MANDATORY for GitHub Copilot Agents**: When GitHub Copilot Agent or GitHub Copilot Coding Agent is working on AVM Bicep repositories, the following local validation tests MUST be executed before any pull request is created or updated:

```powershell
# Load the local testing script
. './utilities/tools/Test-ModuleLocally.ps1'

# Run Pester tests (mandatory)
Test-ModuleLocally -TemplateFilePath './avm/res/{service}/{resource}' -PesterTest

# Run validation test - dry-run (recommended)
Test-ModuleLocally -TemplateFilePath './avm/res/{service}/{resource}' -ValidationTest -ValidateOrDeployParameters @{subscriptionId='xxx'; managementGroupId='xxx'}
```

**Failure to run these tests will cause PR validation failures and prevent successful merges.**

### On Updating README.md Documentation

**🛑 NEVER update README.md documentation or Markdowns directly**: Always run the [utilities/tools/Set-AVMModule.ps1](utilities/tools/Set-AVMModule.ps1) script to update the module README.md and compile the Bicep files. You must first use `#fetch` tool to get `https://azure.github.io/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/generate-bicep-module-files/` and read it carefully first.

> [!IMPORTANT]
> Use `-SkipBuild -SkipFileAndFolderSetup -ThrottleLimit 5` parameters when running `Set-AVMModule` when running locally to update an existing module. You must run this prior to committing any changes to a module.

## Module Discovery

### Official AVM Index
- **Bicep Resources**: `https://azure.github.io/Azure-Verified-Modules/indexes/bicep/bicep-resource-modules/`
- **Bicep Patterns**: `https://azure.github.io/Azure-Verified-Modules/indexes/bicep/bicep-pattern-modules/`
- **Bicep Utilities**: `https://azure.github.io/Azure-Verified-Modules/indexes/bicep/bicep-utility-modules/`

### Microsoft Container Registry (MCR)
- Search for published AVM modules: `mcr.microsoft.com/bicep/avm/`
- **Resource modules**: `mcr.microsoft.com/bicep/avm/res/{service}/{resource}:{version}`
- **Pattern modules**: `mcr.microsoft.com/bicep/avm/ptn/{pattern}:{version}`
- **Utility modules**: `mcr.microsoft.com/bicep/avm/utl/{utility}:{version}`

## Bicep Module Usage

### From MCR (Recommended)
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

### From Local Path (Development)
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

## Naming Conventions

### Module Types
- **Resource Modules**: `avm/res/{service}/{resource}/`
  - Example: `avm/res/storage/storage-account/`
- **Pattern Modules**: `avm/ptn/{pattern}/`
  - Example: `avm/ptn/aca-lza/`
- **Utility Modules**: `avm/utl/{utility}/`
  - Example: `avm/utl/types/`

### Service Naming
- Use kebab-case for services and resources
- Follow Azure resource provider naming (e.g., `storage/storage-account`, `network/virtual-network`)
- Match Azure resource provider hierarchy when possible

## Version Management

### Check Available Versions
Use the `fetch` tool to get published AVM module versions from MCR:
- **URL Pattern**: `https://mcr.microsoft.com/v2/bicep/avm/res/{service}/{resource}/tags/list`
- **Example**: `https://mcr.microsoft.com/v2/bicep/avm/res/storage/storage-account/tags/list`

### Version Pinning Best Practices
- Use specific versions for production: `br/public:avm/res/storage/storage-account:0.9.1`
- Use latest for development: `br/public:avm/res/storage/storage-account:latest`
- Always review changelog before upgrading major versions

> [!IMPORTANT]
> The tags list returned by MCR is not in version order. It will need to be ordered correctly when checking for latest versions.

## Module Structure (Mandatory)

```
avm/{res|ptn|utl}/{service}/{resource}/
├── main.bicep         # Primary module
├── version.json       # {"version": "0.x"}
├── tests/e2e/         # Required test scenarios
│   ├── defaults/      # Minimal params
│   ├── max/           # Full params
│   └── waf-aligned/   # Security-focused
```

## Validation Requirements

- All modules auto-generate workflows in `.github/workflows/`
- Tests must validate idempotency (`init` + `idem` iterations)
- Must pass PSRule Azure Well-Architected Framework checks
- Use `uniqueString()` for resource naming in tests
- Follow AVM interface specifications (RMFR4, RMFR5) for optional features
- All parameters and outputs require `@description()` decorators

## Development Best Practices

### Module Usage
- ✅ **Always** use published AVM modules from MCR when available
- ✅ **Start** with official examples from AVM documentation
- ✅ **Pin** module versions for production deployments
- ✅ **Use** `uniqueString()` for resource naming to avoid conflicts
- ✅ **Follow** AVM interface specifications for optional features
- ✅ **Include** proper `@description()` decorators for all parameters and outputs

### Code Quality
- ✅ **Always** validate Bicep syntax before committing
- ✅ **Use** meaningful parameter and variable names
- ✅ **Add** proper metadata and descriptions
- ✅ **Follow** Azure naming conventions and constraints
- ✅ **Test** with all required test scenarios (defaults/max/waf-aligned)

### Validation Requirements
Before creating or updating any pull request:

```powershell
# Load validation script
. './utilities/tools/Test-ModuleLocally.ps1'

# Run Pester tests (MANDATORY)
Test-ModuleLocally -TemplateFilePath './avm/res/{service}/{resource}' -PesterTest

# Run validation test - dry-run (RECOMMENDED)
Test-ModuleLocally -TemplateFilePath './avm/res/{service}/{resource}' -ValidationTest -ValidateOrDeployParameters @{subscriptionId='xxx'; managementGroupId='xxx'}
```

## Local Validation

Use `utilities/tools/Test-ModuleLocally.ps1` for local testing:
```powershell
# Load the script (dot-source)
. './utilities/tools/Test-ModuleLocally.ps1'

# Run Pester tests only
Test-ModuleLocally -TemplateFilePath './avm/res/storage/storage-account' -PesterTest

# Run validation test (dry-run)
Test-ModuleLocally -TemplateFilePath './avm/res/storage/storage-account' -ValidationTest -ValidateOrDeployParameters @{subscriptionId='xxx'; managementGroupId='xxx'}
```
**Critical**: Use unique `namePrefix` values to avoid token replacement conflicts with module content.

## Common Patterns

### Storage Account Module
```bicep
module storageAccount 'br/public:avm/res/storage/storage-account:0.9.1' = {
  name: 'storageAccountDeployment'
  params: {
    name: 'mystorageaccount${uniqueString(resourceGroup().id)}'
    location: location
    skuName: 'Standard_LRS'
    enableTelemetry: true
  }
}
```

### Virtual Network Module
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

### Key Vault Module
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

## Fetching Schemas, API versions and existing Published AVM Modules
You have two options:
1. Use tools from Bicep VS Code extension: `#list_az_resource_types_for_provider`, `#get_az_resource_type_schema`, `#list_avm_metadata`.
2. Use the `fetch` tool to get information from related URLs.

> [!IMPORTANT]
> Use only the tools above to retrieve the schema documentation for Bicep for specific versions. Do not use any other method or tool to do this, because `azure_get_schema_for_Bicep` tool does not reliably return the latest stable version.

### Use Bicep VS Code Extension Tools (Preferred)
- `#list_az_resource_types_for_provider` takes a resource provider (e.g. `Microsoft.Storage`) as input and outputs a list of resource types including their API versions.
- `#get_az_resource_type_schema` takes a resource type (e.g. `Microsoft.Storage/storageAccounts`) and an API version (e.g. `2023-01-01`) as input and outputs the schema for that resource type and API version.
- `#list_avm_metadata` lists up-to-date metadata for all published AVM modules. The return value is a newline-separated list of AVM metadata. Each line includes the module name, description, versions, and documentation URI for a specific module.

### Use Fetch Tool (When Bicep VS Code Extension Tools Are Not Available)
#### Fetching Bicep Schemas
Use the `fetch` tool to get the Bicep schema for specific resources:

- **URL for specific version**: `https://learn.microsoft.com/azure/templates/{resourceType}/{resourceName}?pivots=deployment-language-bicep`
- **Example**: `https://learn.microsoft.com/azure/templates/Microsoft.Storage/storageAccounts?pivots=deployment-language-bicep`

#### Fetching Bicep Schemas with API Version
Use the `fetch` tool to get the Bicep schema for specific resources and explicit API version:

- **URL for specific version**: `https://learn.microsoft.com/azure/templates/{resourceType}/{apiVersion}/{resourceName}`
- **Example**: `https://learn.microsoft.com/azure/templates/Microsoft.Storage/2023-01-01/storageAccounts?pivots=deployment-language-bicep`

#### Fetching AVM Resource Module Versions
Use the `fetch` tool to get the AVM Resource module versions published in the MCR:

- **URL for specific module**: `https://mcr.microsoft.com/v2/bicep/avm/res/{service}/{resource}/tags/list`
- **Example**: `https://mcr.microsoft.com/v2/bicep/avm/res/Microsoft.Storage/storageAccounts/tags/list`

> [!IMPORTANT]
> The tags list returned by `https://mcr.microsoft.com/v2/bicep/avm/res/` is not in version order. It will need to be ordered correctly.

## Troubleshooting

### Common Issues
1. **Module Resolution**: Ensure MCR paths are correct and module versions exist
2. **Parameter Validation**: Check required parameters and data types in module documentation
3. **Naming Conflicts**: Use `uniqueString()` for globally unique resource names
4. **API Version Compatibility**: Verify ARM API versions match module requirements
5. **Validation Failures**: Run local Pester tests before committing changes

### Support Resources
- **AVM Documentation**: `https://azure.github.io/Azure-Verified-Modules/`
- **Bicep Documentation**: `https://docs.microsoft.com/azure/azure-resource-manager/bicep/`
- **GitHub Issues**: Report issues in the bicep-registry-modules repository
- **Community**: Azure Bicep GitHub discussions

## Tool Integration

### Use Available Tools
**⚠️ MANDATORY if tool available**:Always use these tools if available:

- `#azure_get_deployment_best_practices` to ensure meeting deployment best practices.
- `#microsoft.docs.mcp` to fetch Microsoft documentation.
- `#list_az_resource_types_for_provider` to list resource types for an Azure resource provider.
- `#get_az_resource_type_schema` to get the schema for a resource type.
- `#list_avm_metadata` to list AVM module metadata.
- `#fetch` to get related documentation from a URL.
- `#todos` to track outstanding tasks.
- `#think` to think more deeply about the problem at hand (especially when making breaking changes or security-related changes).

### GitHub Copilot Integration
When working with AVM Bicep repositories:
1. Always check for existing modules before creating new resources
2. Use the official examples as starting points
3. Run all validation tests before committing
4. Document any customizations or deviations from examples

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
