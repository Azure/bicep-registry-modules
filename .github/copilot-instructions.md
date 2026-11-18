---
description: "Instructions for working with Azure Verified Modules (AVM) Bicep repository. Rules of generating and maintaining Bicep modules with AVM best practices and formatting guidelines with GitHub Copilot."
---

# Azure Verified Modules (AVM) - General Instructions

## Overview

Azure Verified Modules (AVM) are pre-built, tested, and validated Bicep modules that follow Azure best practices. Use these modules to create, update, or review Azure Infrastructure as Code (IaC) with confidence.

This repository contains **Azure Verified Modules (AVM)** for Bicep - the official Microsoft standard for reusable Azure infrastructure modules. The codebase follows strict AVM specifications and is organized into three main module types:

- **`avm/res/`** - Resource modules (individual Azure resources) - [Resource module index](https://azure.github.io/Azure-Verified-Modules/indexes/bicep/bicep-resource-modules/)
- **`avm/ptn/`** - Pattern modules (multi-resource solutions) - [Pattern module index](https://azure.github.io/Azure-Verified-Modules/indexes/bicep/bicep-pattern-modules/)
- **`avm/utl/`** - Utility modules (shared types and functions) - [Utility module index](https://azure.github.io/Azure-Verified-Modules/indexes/bicep/bicep-utility-modules/)

## Critical Compliance Requirements

### Instruction acknowledgement

After reading these instructions and the relevant skills, but before modifying files, output this block visibly to the user:

```json
{
  "avm-bicep-instructions": "loaded",
  "skills": ["<loaded-skill-name>"]
}
```

List every skill loaded for the task. Use an empty `skills` array when no specialized skill applies.

### Compliance with ALL AVM Bicep and Shared specifications

** ‼️ CRITICAL REQUIREMENTS FOR AVM BICEP MODULES ‼️**: **All changes MUST comply with Azure Verified Modules (AVM) standards, best practices, naming conventions, version management, development guidelines, validation requirements, etc.,described or referenced in these instructions when generating or modifying Bicep code in this repository.** Failure to comply will result in pull request rejections. Before reviewing or generating any Bicep code, always use `#fetch` tool to get LLM documentation index: `https://azure.github.io/Azure-Verified-Modules/llms.txt` for the list of all AVM specifications and detailed guidelines. **READ AND ADHERE TO ALL OF THESE SPECIFICATIONS!**
For additional guidance, follow this logic: if Microsoft Learn (Microsoft Docs) tools `documentation` and `search` are available, you MUST use them to get the most up-to-date information, otherwise use `#fetch` to get documentation from Microsoft Learn (Microsoft Docs).

### Authoring and generated module files

Install `Avm.Authoring` from Microsoft Artifact Registry (MAR) using the [Bicep prerequisites](https://azure.github.io/Azure-Verified-Modules/contributing/bicep/prerequisites/). After changing a module, run `avm pre-commit -Ecosystem bicep -Path '<module-path>'` to validate and regenerate its compiled templates and module READMEs. Do not edit generated module README sections or `main.json` directly. Use `avm docs -Ecosystem bicep -Path '<module-path>'` for README-only generation. See the [authoring guide](https://azure.github.io/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/generate-bicep-module-files/) for authored README notes and child modules.

E2E deployments are label-gated so contributors can open pull requests early and run cloud tests only when changes are ready, reducing deployment cost and feedback time during development. For same-repository pull requests, add `PR: Run Required E2E Tests` to run required deployment scenarios only, or `PR: Run All E2E Tests` to run required and optional scenarios. For fork pull requests, labels do not grant deployment credentials; coordinate an authorized deployment test run with a maintainer.

The planned shared `Avm.Authoring` script using `gh` will hand off fork pull requests to a same-repository release branch when invoked by an authorized Microsoft FTE, without an extra approval or confirmation prompt. Security-review the fork changes before invoking the script with privileged credentials; existing GitHub branch protections, required reviews and checks still apply. Until the script is implemented and released, coordinate the handoff with a maintainer rather than assuming a command exists.

### Fallback to Use Quick Starts as a last resort

When required information or relevant example is not available in the Bicep schema or in the Azure Resource Reference when generating new AVM Bicep code, as a last effort, you can refer to the Bicep Quick Starts in the https://github.com/Azure/azure-quickstart-templates repo. Use the `#github/search_code` tool to search for relevant Bicep Quick Starts as examples of how to deploy specific resources.

## Use Available Tools

**⚠️ MANDATORY if tool available**: Always use these tools if available:

- `#azure_get_deployment_best_practices` to ensure meeting deployment best practices.
- `#microsoft_docs_fetch` to fetch Microsoft documentation.
- `#list_az_resource_types_for_provider` to list resource types for an Azure resource provider.
- `#get_az_resource_type_schema` to get the schema for a resource type.
- `#list_avm_metadata` to list AVM module metadata.
- `#fetch` to get related documentation from a URL.
- `#todos` to track outstanding tasks.

## Module Discovery

### Official AVM Module Catalog

Use the [combined module catalog JSON](https://raw.githubusercontent.com/Azure/Azure-Verified-Modules/refs/heads/main/docs/static/module-indexes/v1/modules.json) to find Bicep modules with `moduleStatus` of `Available` or `Orphaned`. Filter its `bicep` entries by `moduleType` (`resource`, `pattern`, or `utility`).

### Use Microsoft Container Registry (MCR) to fetch AVM Module versions

Use the `#fetch` tool to search for published AVM modules and check available versions:

- **URL Pattern**: `https://mcr.microsoft.com/v2/bicep/{moduleName from the module catalog}/tags/list`
- **Example**: `https://mcr.microsoft.com/v2/bicep/avm/res/storage/storage-account/tags/list`

> [!IMPORTANT]
> The tags list returned by `https://mcr.microsoft.com/v2/bicep/avm/res/` is not in version order. It will need to be ordered correctly.

### Use Fetch Tool (When Bicep VS Code Extension Tools Are Not Available)

For the list of resource providers or resource types available, latest API versions, and Bicep schema for specific resources, use the `#microsoft_docs_fetch` tool to fetch information from Azure Resource Reference page, available at **https://learn.microsoft.com/en-us/azure/templates/**.

## Fetching Schemas, API versions and existing Published AVM Modules

You have exactly these two options (do not use any other method or tool to do this):

1. **Preferred option**: Use tools from Bicep VS Code extension: `#list_az_resource_types_for_provider`, `#get_az_resource_type_schema`, `#list_avm_metadata`.
2. **Alternative option** (if option 1 fails): Use the `#fetch` tool to get information from related URLs.

- **URL for specific version**: `https://learn.microsoft.com/azure/templates/{resourceType}/{resourceName}?pivots=deployment-language-bicep`
- **Example**: `https://learn.microsoft.com/azure/templates/Microsoft.Storage/storageAccounts?pivots=deployment-language-bicep`

### Use Bicep VS Code Extension Tools (Preferred)

- `#list_az_resource_types_for_provider` takes a resource provider (e.g. `Microsoft.Storage`) as input and outputs a list of resource types including their API versions.
- `#get_az_resource_type_schema` takes a resource type (e.g. `Microsoft.Storage/storageAccounts`) and an API version (e.g. `2023-01-01`) as input and outputs the schema for that resource type and API version.
- `#list_avm_metadata` lists up-to-date metadata for all published AVM modules. The return value is a newline-separated list of AVM metadata. Each line includes the module name, description, versions, and documentation URI for a specific module.

## Quality Assurance and Troubleshooting

### Code Quality

- ✅ **Always** validate Bicep syntax before committing
- ✅ **Use** meaningful parameter and variable names
- ✅ **Add** proper metadata and descriptions
- ✅ **Follow** Azure naming conventions and constraints
- ✅ **Test** with all required test scenarios (defaults/max/waf-aligned)
- ✅ **Document** any customizations or deviations from examples

### Common Issues

1. **Module Resolution**: When referencing modules, make sure MCR paths exist with the correct versions
2. **Parameter Validation**: Check required parameters and data types in module documentation
3. **Naming Conflicts**: Use `uniqueString()` for globally unique resource names
4. **API Version Compatibility**: Verify ARM API versions match module requirements
5. **Validation Failures**: Run local checks with `avm pr-check` and unit tests with `avm test unit` before committing changes.

### Support Resources

1. Official documentation:

- **Bicep Documentation**: `https://docs.microsoft.com/azure/azure-resource-manager/bicep/`

2. Community forums - **ALWAYS consult the user** before taking a decision or action based on information you found on the following pages:

- **GitHub Issues**: AVM Bicep issues in the bicep-registry-modules repository - `https://github.com/Azure/bicep-registry-modules/issues`
- **Community**: Azure Bicep GitHub discussions - `https://github.com/Azure/bicep/discussions`

## Output and formatting

### Files Modified (Summary)

Whenever you modify, create or delete any files, you MUST summarize the changes in a table format with three columns: `#` (numbered list of changes), `File` (file path), and `Change` (brief description of the change made).

For example:

| #   | Change type                              | File                                                            | Change                                      |
| --- | ---------------------------------------- | --------------------------------------------------------------- | ------------------------------------------- |
| 1   | 🟢Created <or> 🟡Modified <or> 🔴Deleted | `<path to the file modified, relative to the root of the repo>` | <1-sentence summary of the changes applied> |
| ..  | 🟢Created <or> 🟡Modified <or> 🔴Deleted | `<path to the file modified, relative to the root of the repo>` | <1-sentence summary of the changes applied> |
| n   | 🟢Created <or> 🟡Modified <or> 🔴Deleted | `<path to the file modified, relative to the root of the repo>` | <1-sentence summary of the changes applied> |

## Skills

When a user asks to perform a task that falls within the domain of a skill below, read and follow the full instructions from the file path before proceeding to acquire the full instructions from the file path before proceeding.

| Skill                       | Description                                                                                                                                                           | File                                                  |
| --------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------- |
| avm-child-module-publishing | Publish Bicep child modules to the AVM public registry. USE FOR: publish child module, add child module telemetry, child module version.json, child module CHANGELOG. | `.github/skills/avm-child-module-publishing/SKILL.md` |
