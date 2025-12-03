---
description: "Instructions for working with Azure Verified Modules (AVM) Bicep repository"
---

# Azure Verified Modules (AVM) - General Instructions

## Overview

Azure Verified Modules (AVM) are pre-built, tested, and validated Bicep modules that follow Azure best practices. Use these modules to create, update, or review Azure Infrastructure as Code (IaC) with confidence.

This repository contains **Azure Verified Modules (AVM)** for Bicep - the official Microsoft standard for reusable Azure infrastructure modules. The codebase follows strict AVM specifications and is organized into three main module types:

- **`avm/res/`** - Resource modules (individual Azure resources)
- **`avm/ptn/`** - Pattern modules (multi-resource solutions)
- **`avm/utl/`** - Utility modules (shared types and functions)

## Critical Compliance Requirements

### Parsing ALL module specifications

** ‼️ CRITICAL REQUIREMENTS FOR AVM BICEP MODULES ‼️**: All changes MUST comply with Azure Verified Modules (AVM) standards. Failure to comply will result in pull request rejections. Before reviewing or generating any Bicep code, always use `#fetch` tool to get LLM documentation index: `https://azure.github.io/Azure-Verified-Modules/llms.txt` for the list of all AVM specifications and detailed guidelines. **READ AND ADHERE TO ALL OF THESE SPECIFICATIONS!**
For additional guidance, follow this logic: if Microsoft Learn (Microsoft Docs) tools `documentation` and `search` are available, you MUST use them to get the most up-to-date information, otherwise use `#fetch` to get documentation from Microsoft Learn (Microsoft Docs).

## Use Available Tools

**⚠️ MANDATORY if tool available**:Always use these tools if available:

- `#azure_get_deployment_best_practices` to ensure meeting deployment best practices.
- `#microsoft.docs.mcp` to fetch Microsoft documentation.
- `#list_az_resource_types_for_provider` to list resource types for an Azure resource provider.
- `#get_az_resource_type_schema` to get the schema for a resource type.
- `#list_avm_metadata` to list AVM module metadata.
- `#fetch` to get related documentation from a URL.
- `#todos` to track outstanding tasks.

## Module Discovery

### Official AVM Module Index

Start here to understand which modules are published (with the ModuleStatus being "Available" or "Orphaned"):

- **Bicep Resources**: `https://raw.githubusercontent.com/Azure/Azure-Verified-Modules/refs/heads/main/docs/static/module-indexes/BicepResourceModules.csv`
- **Bicep Patterns**: `https://raw.githubusercontent.com/Azure/Azure-Verified-Modules/refs/heads/main/docs/static/module-indexes/BicepPatternModules.csv`
- **Bicep Utilities**: `https://raw.githubusercontent.com/Azure/Azure-Verified-Modules/refs/heads/main/docs/static/module-indexes/BicepUtilityModules.csv`

### Use Microsoft Container Registry (MCR) to fetch AVM Module versions

Use the `#fetch` tool to search for published AVM modules and check available versions:
- **URL Pattern**: `https://mcr.microsoft.com/v2/bicep/{ModuleName as per the AVM Module index}/tags/list`
- **Example**: `https://mcr.microsoft.com/v2/bicep/avm/res/storage/storage-account/tags/list`

> [!IMPORTANT]
> The tags list returned by `https://mcr.microsoft.com/v2/bicep/avm/res/` is not in version order. It will need to be ordered correctly.

### Use Fetch Tool (When Bicep VS Code Extension Tools Are Not Available)

For the list of resource providers or resource types available, latest API versions, and Bicep schema for specific resources, use the `#microsoft_docs_fetch` tool to fetch information from Azure Resource Reference page, available at **https://learn.microsoft.com/en-us/azure/templates/**.

#### Fetching Bicep Schemas

Use the `#fetch` tool to get the Bicep schema for specific resources - use this to find the latest available API version:

- **URL for specific version**: `https://learn.microsoft.com/azure/templates/{resourceType}/{resourceName}?pivots=deployment-language-bicep`
- **Example**: `https://learn.microsoft.com/azure/templates/Microsoft.Storage/storageAccounts?pivots=deployment-language-bicep`

#### Fetching Bicep Schemas with API Version

Use the `#fetch` tool to get the Bicep schema for specific resources and explicit API version:

- **URL for specific version**: `https://learn.microsoft.com/azure/templates/{resourceType}/{apiVersion}/{resourceName}`
- **Example**: `https://learn.microsoft.com/azure/templates/Microsoft.Storage/2023-01-01/storageAccounts?pivots=deployment-language-bicep`

## Fetching Schemas, API versions and existing Published AVM Modules

You have two options:
1. Use tools from Bicep VS Code extension: `#list_az_resource_types_for_provider`, `#get_az_resource_type_schema`, `#list_avm_metadata`.
2. Use the `#fetch` tool to get information from related URLs.

> [!IMPORTANT]
> Use only the tools above to retrieve the schema documentation for Bicep for specific versions. Do not use any other method or tool to do this, because `azure_get_schema_for_Bicep` tool does not reliably return the latest stable version.

### Use Bicep VS Code Extension Tools (Preferred)
- `#list_az_resource_types_for_provider` takes a resource provider (e.g. `Microsoft.Storage`) as input and outputs a list of resource types including their API versions.
- `#get_az_resource_type_schema` takes a resource type (e.g. `Microsoft.Storage/storageAccounts`) and an API version (e.g. `2023-01-01`) as input and outputs the schema for that resource type and API version.
- `#list_avm_metadata` lists up-to-date metadata for all published AVM modules. The return value is a newline-separated list of AVM metadata. Each line includes the module name, description, versions, and documentation URI for a specific module.

## Module File-System Structure (Mandatory)

This repository follows a strict folder and file structure for AVM Bicep modules. Each module must adhere to the following structure:

```
avm/{res|ptn|utl}/{service}/{resource}/
├── main.bicep         # Primary module
├── version.json       # {"version": "0.x"}
├── tests/e2e/         # Required test scenarios
│   ├── defaults/      # Minimal params
│   ├── max/           # Full params
│   └── waf-aligned/   # Security-focused
```

> [!IMPORTANT]
> Ignore all files under the `./modules/` folder. Files under this folder are not compliant with AVM and should never be used as examples, nor should they ever be modified!
