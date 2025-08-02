---
mode: 'agent'
description: 'Analyze Azure Verified Module (AVM) Bicep files for ARM API version updates and create implementation plans.'
tools: ['changes', 'codebase', 'fetch', 'githubRepo', 'problems', 'search', 'searchResults', 'fileSearch', 'textSearch', 'listDirectory', 'readFile', 'Microsoft Docs', 'microsoft.docs.mcp']
---

# AI Agent Task: ARM API Version Update Analysis

## 1. Objective
As an AI agent, your task is to analyze Azure Verified Module (AVM) Bicep files starting with ${file}, including in child folders of ${fileDirname}, that make up a module to identify resources with outdated ARM API versions. You will compare the current versions against the latest available **stable** versions and generate a detailed implementation plan for any required updates.

**This is a planning task only. Do not modify any files.**

## 2. Prerequisites
- The user must provide a valid file path for an AVM resource module. The path must follow the pattern: `avm/res/{provider}/{resource}/main.bicep`.
- If the path is invalid or missing, **STOP** and ask the user for a correct one.
- Before generating AVM Bicep code, always use `fetch` tool to get LLM documentation index: `https://azure.github.io/Azure-Verified-Modules/llms.txt`. Use LLM documentation index to `fetch` relevant documentation for the specific resources and patterns you are working with.

## 3. Execution Flow

### Step 3.1: Discover Resources in Bicep File
Scan the provided Bicep file to identify all Azure resource definitions.
- **Pattern to find**: `resource {name} '{resourceType}@{apiVersion}' = {`
- **Data to extract**: For each resource, capture its symbolic name, `resourceType` (e.g., `Microsoft.Storage/storageAccounts`), and its current `apiVersion`.
- **Output**: Create a complete inventory of all resources before proceeding.

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

**CRITICAL**: You MUST create the summary table (Section 4.1) immediately after this step, before proceeding to schema analysis.

### Step 3.4: Analyze Schema for Required Updates
**MANDATORY**: For EVERY resource with status `🔄 Update Available`, you MUST perform detailed schema analysis.

> [!IMPORTANT]
> MUST use the `fetch` tool to retrieve the schema documentation for both versions first and compare these. Do not use any other method to analyze schema changes.

1.  **Fetch Current Version Schema**: Use the `fetch` tool to get the current API version documentation.
    - **URL**: `https://learn.microsoft.com/azure/templates/{resourceType}/{currentApiVersion}/{resourceName}?pivots=deployment-language-bicep`
2.  **Fetch Latest Version Schema**: Use the `fetch` tool to get the latest API version documentation.
    - **URL**: `https://learn.microsoft.com/azure/templates/{resourceType}/{latestApiVersion}/{resourceName}?pivots=deployment-language-bicep`
3.  **Compare Property Schemas**: Systematically compare the property definitions between versions.
4.  **Categorize Changes**:
    - ✅ **Non-breaking**: New optional properties, expanded allowed values.
    - ⚠️ **Potentially breaking**: New required properties, changes to default values, restricted allowed values.
    - ❌ **Breaking**: Removed properties, changes to property types, incompatible constraints.

**CRITICAL**: Document specific property differences, not just general statements.

### Step 3.5: Create Detailed Implementation Plans
**MANDATORY**: For EVERY resource requiring updates, you MUST create the detailed change plan specified in Section 4.3.

- **Required Code Changes**: List specific modifications needed for parameters, variables, or resource properties.
- **Impact on Module**: Describe effects on the module's interface (parameters, outputs).
- **Testing Requirements**: Identify which e2e tests need to be added or updated (`defaults`, `max`, `waf-aligned`).
- **Complexity**: Estimate the migration effort (Low, Medium, High).

**CRITICAL**: This section is mandatory and must follow the exact format specified in Section 4.3.

## 4. Output Format

> [!CRITICAL]
> You MUST produce ALL sections below in the EXACT format specified. Missing any section will result in an incomplete analysis.

### 4.1. Summary Table (MANDATORY)
**You MUST create this table immediately after Step 3.3, before proceeding to schema analysis.**

| Resource Name | Resource Type | Current API | Latest API | Status | Complexity | Breaking Changes |
|---------------|---------------|-------------|------------|--------|------------|------------------|
| `storageAccount` | `Microsoft.Storage/storageAccounts` | `2023-01-01` | `2023-05-01` | 🔄 Update Available | Low | None |
| `keyVault` | `Microsoft.KeyVault/vaults` | `2023-02-01` | `2023-07-01` | ⚠️ Review Required | Medium | New required property |

### 4.2. Status Icons (MANDATORY)
**You MUST include this legend immediately after the summary table.**

- 🔄 **Update Available**: Newer stable version is available.
- ✅ **Current**: Already on the latest stable version.
- ⚠️ **Review Required**: Update is available but may have breaking changes.
- ❌ **Breaking Changes**: Update has known breaking changes.
- 🔍 **Investigation Needed**: Current version is newer than the latest documented stable version.
- 🟡 **Current (preview)**: Using a preview version, but a stable version exists.

### 4.3. Detailed Change Plans (MANDATORY)
**You MUST create this section for EVERY resource with status 🔄 Update Available or ⚠️ Review Required.**

For each resource requiring an update, provide the following details in this EXACT format:

#### Resource: {ResourceName}
- **Current Version**: {currentApiVersion}
- **Target Version**: {latestApiVersion}
- **Change Type**: {Non-breaking | Potentially Breaking | Breaking}

**Schema Changes:**
- ➕ **New**: List specific new properties with their types and descriptions.
- 🔄 **Modified**: List specific properties with changed types, constraints, or allowed values.
- ➖ **Removed**: List specific removed or deprecated properties.
- ⚠️ **Behavioral**: Note specific changes in default values or resource behavior.

**Implementation Plan:**
1.  **Module Updates**: Detail specific required changes to parameters, variables, and outputs.
2.  **Test Updates**: Specify which e2e test scenarios need modification (defaults/max/waf-aligned).
3.  **Documentation**: Note specific required updates for the README file.
4.  **Validation**: Mention any PSRule or linter considerations.

**Risk Assessment:**
- **Breaking Risk**: {Low | Medium | High} - with specific justification
- **Migration Effort**: {Low | Medium | High} - with time estimate if possible
- **Testing Complexity**: {Low | Medium | High} - with specific test scenarios needed

> [!CRITICAL]
> If you skip Section 4.3 or provide incomplete information, the analysis is considered failed.

## 5. Execution Validation

> [!CRITICAL]
> Before completing your analysis, verify you have completed ALL of the following:

### Checklist for Complete Analysis:
- [ ] **Step 3.1**: Discovered and listed ALL resources with their current API versions
- [ ] **Step 3.2**: Fetched latest stable API versions for ALL discovered resources using `fetch` tool
- [ ] **Step 3.3**: Compared versions and assigned status to ALL resources
- [ ] **Output 4.1**: Created the complete summary table with ALL resources
- [ ] **Output 4.2**: Included the status icons legend
- [ ] **Step 3.4**: For EVERY resource with "Update Available" status, fetched BOTH current and latest schemas
- [ ] **Step 3.4**: Performed detailed schema comparison for ALL resources requiring updates
- [ ] **Output 4.3**: Created detailed change plans for EVERY resource requiring updates
- [ ] **Step 3.5**: Provided implementation plans with specific code changes, testing requirements, and risk assessments

### Failure Conditions:
- **INCOMPLETE**: If you skip any mandatory section (4.1, 4.2, or 4.3)
- **INSUFFICIENT**: If you don't fetch schemas for both current AND latest versions
- **VAGUE**: If you provide general statements instead of specific property differences
- **MISSING**: If you don't create detailed implementation plans for resources requiring updates

> [!WARNING]
> If any of the above conditions are met, the analysis is considered incomplete and must be redone.

## 6. Constraints
- ⚠️ **No File Modifications**: This is a planning task only. Do not edit any files.
- ⚠️ **AVM Compliance**: All recommendations must align with AVM specifications.
- ⚠️ **Stable Versions Only**: Prioritize stable API versions unless a preview is explicitly required.

## 6. Error Handling
- **Invalid File Path**: If the path is invalid, stop and ask the user for a correct one.
- **Schema Unavailable**: If documentation cannot be fetched for a specific version, note this limitation and recommend manual verification.
- **Tool Failure**: If a tool fails, document the step that could not be completed.
