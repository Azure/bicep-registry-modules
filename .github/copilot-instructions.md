# AVM Bicep Registry - AI Agent Instructions

**Purpose**: Ensure all AI-generated code follows Azure Verified Modules (AVM) best practices for this official Microsoft Bicep registry.

## Repository Overview

This repository contains **Azure Verified Modules (AVM)** for Bicep - the official Microsoft standard for reusable Azure infrastructure modules. The codebase follows strict AVM specifications and is organized into three main module types:

- **`avm/res/`** - Resource modules (individual Azure resources)
- **`avm/ptn/`** - Pattern modules (multi-resource solutions)
- **`avm/utl/`** - Utility modules (shared types and functions)

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

## Fetching Schemas and API versions
Use the `fetch` tool to get the Bicep schema for specific resources:

- **URL for specific version**: `https://learn.microsoft.com/azure/templates/{resourceType}/{resourceName}?pivots=deployment-language-bicep`
- **Example**: `https://learn.microsoft.com/azure/templates/Microsoft.Storage/storageAccounts?pivots=deployment-language-bicep`

Use the `fetch` tool to get the Bicep schema for specific resources and explicit API version:

- **URL for specific version**: `https://learn.microsoft.com/azure/templates/{resourceType}/{apiVersion}/{resourceName}`
- **Example**: `https://learn.microsoft.com/azure/templates/Microsoft.Storage/2023-01-01/storageAccounts?pivots=deployment-language-bicep`

> [!IMPORTANT]
> Use the `fetch` tool to retrieve the schema documentation for Bicep for specific versions. Do not use any other method or tool to do this, because `azure_get_schema_for_Bicep` tool does not reliably return the latest stable version.

## Tool Use
- Use `azure_get_deployment_best_practices` tool if available to ensure meeting deployment best practices.
- Use `microsoft.docs.mcp` tool for fetching Microsoft documentation.
