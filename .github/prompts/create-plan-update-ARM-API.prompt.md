---
mode: 'agent'
description: 'Analyze Azure Verified Module (AVM) Bicep files for ARM API version updates and create implementation plans.'
tools: ['search', 'runCommands', 'runTasks', 'usages', 'think', 'problems', 'changes', 'testFailure', 'openSimpleBrowser', 'fetch', 'githubRepo', 'todos', 'runTests', 'documentation', 'search']
---

# Analyze ARM API Version Updates for Resource Module

## 1. Objective
As an AI agent, your task is to analyze Azure Verified Module (AVM) Bicep files starting with `${file}`, including child folders of `${fileDirname}`, to identify resources with outdated ARM API versions. Compare current versions against latest **stable** versions and generate detailed implementation plans for required updates.

> [!IMPORTANT]
> This is a planning task only. Do not modify any files, unless the user asks you to.

## 2. Prerequisites

- Valid file path for AVM resource module following pattern: `avm/res/{provider}/{resource}/main.bicep`.
- Module must exist in the workspace.
- Access to `#fetch` tool for schema validation.

> [!CRITICAL]
> If any prerequisites are not met, you must stop and inform the user clearly, indicating what they must do.

## 3. Tool Use

- If the `#todos` tool is available, you must use that to track progress, updating it regularly.

## 4. Execution Flow

Here is a ReAct-style Thought–Action–Observation execution flow that you MUST follow:

- Thought: Validate file path and confirm module exists. Get AVM documentation index for compliance.
  - Action: todos.write → Track progress; codebase.stat(path=${file}); fetch(url=`https://azure.github.io/Azure-Verified-Modules/llms.txt`)
  - Observation: File exists and AVM documentation available (or not). If missing, stop and report per prerequisites.

- Thought: Discover all Azure resource definitions in the Bicep file and child modules.
  - Action: codebase.search(pattern=`resource.*@.*=`) OR grep_search(query=`resource.*@.*=`, isRegexp=true, includePattern=${fileDirname}/**/*.bicep)
  - Observation: Complete inventory of resources with symbolic names, resourceTypes, and current apiVersions.

- Thought: For each discovered resource, fetch latest stable API version from Microsoft Learn.
  - Action: For each resource → fetch(url=`https://learn.microsoft.com/azure/templates/{resourceType}?pivots=deployment-language-bicep`)
  - Observation: Latest stable API versions available for comparison.

- Thought: Compare current vs latest versions and categorize update status.
  - Action: Analyze version differences; assign status: 🔄 Update Available, ✅ Current, 🟡 Current (preview), 🔍 Investigation Needed
  - Observation: Status assigned to each resource with update priority.

- Thought: Create summary table immediately before deeper analysis.
  - Action: Compile summary table with all resources, current/latest versions, status, and complexity estimates
  - Observation: Complete overview ready for detailed analysis phase.

- Thought: For resources needing updates, perform detailed schema analysis.
  - Action: For each 🔄 resource → fetch current schema: `https://learn.microsoft.com/azure/templates/{resourceType}/{currentApiVersion}/{resourceName}?pivots=deployment-language-bicep`; fetch latest schema: `https://learn.microsoft.com/azure/templates/{resourceType}/{latestApiVersion}/{resourceName}?pivots=deployment-language-bicep`
  - Observation: Detailed schema differences between current and latest versions available.

- Thought: Categorize schema changes and assess breaking change risk.
  - Action: Compare property schemas; categorize as ✅ Non-breaking, ⚠️ Potentially breaking, ❌ Breaking
  - Observation: Risk assessment completed with specific property changes documented.

- Thought: Create detailed implementation plans for each resource requiring updates.
  - Action: think(thoughts=`Implementation plan for ${resourceName}: code changes, module impact, testing requirements, migration complexity`)
  - Observation: Comprehensive implementation plan including specific steps and risk mitigation.

- Thought: Produce final outputs with validation checklist.
  - Action: Compile detailed change plans, validate completeness against checklist
  - Observation: Complete analysis ready for user review and implementation.

## 5. Output Format

> [!CRITICAL]
> You MUST produce ALL sections below in the EXACT format specified. Missing any section will result in an incomplete analysis.

### 5.1. Summary Table (MANDATORY)

| Resource Name | Resource Type | Current API | Latest API | Status | Complexity | Breaking Changes |
|---------------|---------------|-------------|------------|--------|------------|------------------|
| `storageAccount` | `Microsoft.Storage/storageAccounts` | `2023-01-01` | `2023-05-01` | 🔄 Update Available | Low | None |

### 5.2. Status Icons

- 🔄 **Update Available**: Newer stable version is available.
- ✅ **Current**: Already on the latest stable version.
- ⚠️ **Review Required**: Update is available but may have breaking changes.
- ❌ **Breaking Changes**: Update has known breaking changes.
- 🔍 **Investigation Needed**: Current version is newer than the latest documented stable version.
- 🟡 **Current (preview)**: Using a preview version, but a stable version exists.

### 5.3. Detailed Change Plans (MANDATORY)

For each resource requiring an update, provide the following details:

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
1. **Module Updates**: Detail specific required changes to parameters, variables, and outputs.
2. **Test Updates**: Specify which e2e test scenarios need modification (defaults/max/waf-aligned).
3. **Documentation**: Note specific required updates for the README file.
4. **Validation**: Mention any PSRule or linter considerations.

**Risk Assessment:**
- **Breaking Risk**: {Low | Medium | High} - with specific justification
- **Migration Effort**: {Low | Medium | High} - with time estimate if possible
- **Testing Complexity**: {Low | Medium | High} - with specific test scenarios needed

## 6. Execution Validation

> [!CRITICAL]
> Before completing your analysis, verify you have completed ALL of the following:

### Checklist for Complete Analysis:
- [ ] **Step 4**: Complete execution of all ReAct steps
- [ ] **Step 5.1**: Summary table created with ALL resources and their status
- [ ] **Step 5.2**: Status icons legend included
- [ ] **Schema Analysis**: For EVERY resource with "Update Available" status, fetched BOTH current and latest schemas
- [ ] **Step 5.3**: Created detailed change plans for EVERY resource requiring updates
- [ ] **Implementation Plans**: Provided specific code changes, testing requirements, and risk assessments

### Failure Conditions:
- **INCOMPLETE**: If you skip any mandatory section (5.1, 5.2, or 5.3)
- **INSUFFICIENT**: If you don't fetch schemas for both current AND latest versions
- **VAGUE**: If you provide general statements instead of specific property differences
- **MISSING**: If you don't create detailed implementation plans for resources requiring updates

> [!WARNING]
> If any of the above conditions are met, the analysis is considered incomplete and must be redone.

## 7. Constraints
- ⚠️ **No File Modifications**: This is a planning task only. Do not edit any files.
- ⚠️ **AVM Compliance**: All recommendations must align with AVM specifications.
- ⚠️ **Stable Versions Only**: Prioritize stable API versions unless a preview is explicitly required.
- ⚠️ **Schema Validation Required**: Use `fetch` tool only for API version and schema retrieval.
