---
mode: 'agent'
description: 'Analyze Azure Verified Module (AVM) Bicep files for ARM API version updates and create implementation plans.'
tools: ['changes', 'codebase', 'editFiles', 'extensions', 'fetch', 'findTestFiles', 'githubRepo', 'new', 'openSimpleBrowser', 'problems', 'runCommands', 'runInTerminal2', 'runNotebooks', 'runTasks', 'runTests', 'search', 'searchResults', 'terminalLastCommand', 'terminalSelection', 'testFailure', 'usages', 'vscodeAPI', 'microsoft.docs.mcp', 'github']
---

# AI Agent Task: ARM API Version Update Analysis

## 1. Objective
As an AI agent, your task is to analyze an Azure Verified Module (AVM) Bicep files, including in child folders, that make up a module to identify resources with outdated ARM API versions. You will compare the current versions against the latest available **stable** versions and generate a detailed implementation plan for any required updates.

**This is a planning task only. Do not modify any files.**

## 2. Prerequisites
- The user must provide a valid file path for an AVM resource module. The path must follow the pattern: `avm/res/{provider}/{resource}/main.bicep`.
- If the path is invalid or missing, **STOP** and ask the user for a correct one.

## 3. Execution Flow

### Step 3.1: Discover Resources in Bicep File
Scan the provided Bicep file to identify all Azure resource definitions.
- **Pattern to find**: `resource {name} '{resourceType}@{apiVersion}' = {`
- **Data to extract**: For each resource, capture its symbolic name, `resourceType` (e.g., `Microsoft.Storage/storageAccounts`), and its current `apiVersion`.

### Step 3.2: Find the Latest Stable API Version
For each discovered resource, you must find its latest **stable** API version by querying the official Microsoft Learn documentation.

- **Tool**: Use the `fetch` tool.
- **URL Format**: `https://learn.microsoft.com/azure/templates/{resourceType}?pivots=deployment-language-bicep`
- **Example**: For `Microsoft.Storage/storageAccounts`, the URL is `https://learn.microsoft.com/azure/templates/Microsoft.Storage/storageAccounts?pivots=deployment-language-bicep`.

> [!IMPORTANT]
> The `fetch` tool is the **only** approved method for this step. Do not use any other tool to find API versions, as they may provide inaccurate or non-stable versions.

### Step 3.3: Compare Versions and Set Status
Compare the `current` API version from the file with the `latest` stable version found in the documentation. Assign a status to each resource:

- 🔄 **Update Available**: `latest` is newer than `current`.
- ✅ **Current**: `current` and `latest` are identical.
- 🟡 **Current (preview)**: `current` is a preview version (e.g., `2023-01-01-preview`), and `latest` is an older, stable version. No update is needed unless specified.
- 🔍 **Investigation Needed**: `current` is newer than `latest`. This may indicate a documentation lag.

### Step 3.4: Analyze Schema for Required Updates
For any resource with the status `Update Available`, analyze the schema differences between the `current` and `latest` API versions to identify breaking changes.

> [!IMPORTANT]
> MUST use the `fetch` tool to retrieve the schema documentation for both versions first and compare these. Do not use any other method to analyze schema changes.

1.  **Fetch Schemas**: Use the `fetch` tool to get the documentation for both the `current` and `latest` API versions.
    - **URL for specific version**: `https://learn.microsoft.com/azure/templates/{resourceType}/{apiVersion}/{resourceName}`
    - **Example**: `https://learn.microsoft.com/azure/templates/Microsoft.Storage/2023-01-01/storageAccounts`
2.  **Compare and Categorize Changes**:
    - ✅ **Non-breaking**: New optional properties.
    - ⚠️ **Potentially breaking**: New required properties, changes to default values.
    - ❌ **Breaking**: Removed properties, changes to property types.

### Step 3.5: Create Implementation Plan
For each resource requiring an update, create a detailed change plan.
- **Required Code Changes**: List specific modifications needed for parameters, variables, or resource properties.
- **Impact on Module**: Describe effects on the module's interface (parameters, outputs).
- **Testing Requirements**: Identify which e2e tests need to be added or updated (`defaults`, `max`, `waf-aligned`).
- **Complexity**: Estimate the migration effort (Low, Medium, High).

## 4. Output Format

### 4.1. Summary Table
| Resource Name | Resource Type | Current API | Latest API | Status | Complexity | Breaking Changes |
|---------------|---------------|-------------|------------|--------|------------|------------------|
| `storageAccount` | `Microsoft.Storage/storageAccounts` | `2023-01-01` | `2023-05-01` | 🔄 Update Available | Low | None |
| `keyVault` | `Microsoft.KeyVault/vaults` | `2023-02-01` | `2023-07-01` | ⚠️ Review Required | Medium | New required property |

### 4.2. Status Icons
- 🔄 **Update Available**: Newer stable version is available.
- ✅ **Current**: Already on the latest stable version.
- ⚠️ **Review Required**: Update is available but may have breaking changes.
- ❌ **Breaking Changes**: Update has known breaking changes.
- 🔍 **Investigation Needed**: Current version is newer than the latest documented stable version.
- 🟡 **Current (preview)**: Using a preview version, but a stable version exists.

### 4.3. Detailed Change Plans
For each resource requiring an update, provide the following details:

#### Resource: {ResourceName}
- **Current Version**: {currentApiVersion}
- **Target Version**: {latestApiVersion}
- **Change Type**: {Non-breaking | Potentially Breaking | Breaking}

**Schema Changes:**
- ➕ **New**: List new properties.
- 🔄 **Modified**: List properties with changed types or constraints.
- ➖ **Removed**: List removed or deprecated properties.
- ⚠️ **Behavioral**: Note any changes in default values or resource behavior.

**Implementation Plan:**
1.  **Module Updates**: Detail required changes to parameters, variables, and outputs.
2.  **Test Updates**: Specify which e2e test scenarios need modification.
3.  **Documentation**: Note required updates for the README file.
4.  **Validation**: Mention any PSRule or linter considerations.

**Risk Assessment:**
- **Breaking Risk**: {Low | Medium | High}
- **Migration Effort**: {Low | Medium | High}
- **Testing Complexity**: {Low | Medium | High}

## 5. Constraints
- ⚠️ **No File Modifications**: This is a planning task only. Do not edit any files.
- ⚠️ **AVM Compliance**: All recommendations must align with AVM specifications.
- ⚠️ **Stable Versions Only**: Prioritize stable API versions unless a preview is explicitly required.

## 6. Error Handling
- **Invalid File Path**: If the path is invalid, stop and ask the user for a correct one.
- **Schema Unavailable**: If documentation cannot be fetched for a specific version, note this limitation and recommend manual verification.
- **Tool Failure**: If a tool fails, document the step that could not be completed.
