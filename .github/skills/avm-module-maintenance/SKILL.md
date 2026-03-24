---
name: avm-module-maintenance
description: "Comprehensive maintenance analysis for Azure Verified Module (AVM) Bicep modules. Checks ARM API versions, module versions, Bicep diagnostics, Azure Resource Reference gaps, open issues, test coverage, type safety, and AVM spec compliance. USE FOR: module maintenance, tech debt analysis, API version update, AVM compliance check, test coverage audit, module health check, outdated ARM API, missing properties, module quality review. DO NOT USE FOR: creating new modules, publishing child modules (use AVM-Child-Module-Publishing), implementing fixes (this is analysis only)."
argument-hint: "Provide the path to the module's main.bicep file"
---

# AVM Module Maintenance Analysis

> **Read-only analysis skill.** Do not modify any files unless the user explicitly asks you to.

## When to Use

- Periodic health check of an AVM Bicep module
- Before starting a maintenance or update PR
- Triaging technical debt in a module
- Reviewing a module for AVM compliance gaps

## Prerequisites

- A valid AVM module path following the pattern: `avm/res/{provider}/{resource}/main.bicep` (resource modules), `avm/ptn/{...}/main.bicep` (pattern modules), or `avm/utl/{...}/main.bicep` (utility modules).
- The module must exist in the workspace.
- Access to the tools listed in the Tools section below.

> **STOP** if any prerequisites are not met. Inform the user what is missing and what they need to do.

## Tools

Use these tools throughout the analysis. If a tool is unavailable, note the gap in your output and continue with alternatives.

| Tool                                            | Purpose                                                                   |
| ----------------------------------------------- | ------------------------------------------------------------------------- |
| `mcp_bicep_list_az_resource_types_for_provider` | List resource types and their API versions for a provider                 |
| `mcp_bicep_get_az_resource_type_schema`         | Get the full schema for a resource type at a specific API version         |
| `mcp_bicep_list_avm_metadata`                   | List published AVM module metadata (names, versions, docs)                |
| `mcp_bicep_get_bicep_file_diagnostics`          | Get Bicep compiler errors, warnings, and info diagnostics                 |
| `mcp_bicep_get_file_references`                 | List all files referenced by a Bicep file                                 |
| `mcp_github_github_search_issues`               | Search for open GitHub issues related to the module                       |
| `mcp_github_github_issue_read`                  | Read full details and comments on a specific issue                        |
| `fetch_webpage`                                 | Fetch AVM documentation, Azure Resource Reference pages, and spec content |
| `manage_todo_list`                              | Track progress through the analysis steps                                 |
| `get_errors`                                    | Get compile/lint errors reported by the Bicep extension in VS Code        |

## Procedure

Work through each step in order. Use `manage_todo_list` to track progress. Each step produces findings that feed into the final report.

---

### Step 1: Validate Module and Gather Context

1. Confirm the module path exists and identify the module type (`res`, `ptn`, or `utl`) from the path.
2. List all files in the module directory tree (Bicep files, tests, docs, metadata).
3. Read the module's `main.bicep` to understand its structure: parameters, variables, resources, outputs, and child module references.
4. Fetch the AVM documentation index from `https://azure.github.io/Azure-Verified-Modules/llms.txt` for spec compliance checking in later steps.

---

### Step 2: Check ARM API Versions

> Run this check **first** — outdated API versions can cascade into missing properties and schema mismatches.

1. Scan all `.bicep` files in the module tree for resource declarations (pattern: `resource ... 'ResourceType@ApiVersion'`).
2. For each resource provider found, call `mcp_bicep_list_az_resource_types_for_provider` to get the latest available API versions.
3. Compare each resource's current API version against the latest **stable** version. If no stable version exists, a preview version is acceptable.
4. Record findings in a table:

| Resource Name | Resource Type                 | Current API  | Latest Stable API | Status           |
| ------------- | ----------------------------- | ------------ | ----------------- | ---------------- |
| `example`     | `Microsoft.Example/resources` | `2023-01-01` | `2024-06-01`      | Update Available |

Status values:

- **Up to date** — Already on latest stable version
- **Update Available** — A newer stable version exists
- **Preview Only** — Using preview; no stable alternative
- **Review Required** — Update exists but may have breaking changes

5. For each resource with **Update Available** status, fetch the schema for both current and latest versions using `mcp_bicep_get_az_resource_type_schema`, and document schema differences (new, modified, removed, or deprecated properties).

---

### Step 3: Check Module Versions

1. Call `mcp_bicep_list_avm_metadata` to get the list of all published AVM modules.
2. Read the module's `version.json` file.
3. Check if the module references other AVM modules (via `br/public:avm/...` references in Bicep files). For each referenced module, verify it is using the latest published version.
4. Record any outdated module references.

---

### Step 4: Check Bicep Diagnostics

1. Run `mcp_bicep_get_bicep_file_diagnostics` on the module's `main.bicep` file.
2. Also run `get_errors` on the module directory to catch any additional problems flagged by the VS Code Bicep extension.
3. Run diagnostics on each child module's `main.bicep` if any exist.
4. Record all errors, warnings, and informational diagnostics with their codes, messages, and locations.

---

### Step 5: Check Azure Resource Reference for Gaps

1. For each resource type declared in the module, fetch the full schema at the **latest stable API version** using `mcp_bicep_get_az_resource_type_schema`.
2. Compare the schema properties against what the module currently exposes as parameters and configuration options. Look for:
   - **Missing properties**: Important resource properties not exposed by the module.
   - **Discrepancies**: Module parameter types or allowed values that don't match the schema.
   - **New features**: Recently added properties that users may want to configure.
3. Check whether child resource types exist for the provider that should be implemented as child modules but are not. Use `mcp_bicep_list_az_resource_types_for_provider` and compare against the module's existing child module folders.
4. Document all gaps with the property name, type, and a brief description of what it controls.

---

### Step 6: Check Open Issues

1. Search for open GitHub issues related to the module using `mcp_github_github_search_issues`:
   - Query: `repo:Azure/bicep-registry-modules state:open "{module path}"` (e.g., `avm/res/storage/storage-account`).
   - Also search by the resource provider name for broader matches.
2. For each relevant issue, read its details using `mcp_github_github_issue_read` and categorize it:
   - **Bug** — Reported defect in the module
   - **Feature Request** — Request for new functionality
   - **API Update** — Request to update API versions
   - **Documentation** — Documentation improvement needed
   - **Critical** — Requires immediate attention
3. Record issues in a summary table with issue number, title, category, and relevance assessment.

---

### Step 7: Audit Test Coverage

1. List all test scenario directories under the module's `tests/e2e/` folder.
2. Read the module's `main.bicep` and extract every input parameter (name, type, whether it's required or optional, and its default value).
3. For each test scenario, read the `main.test.bicep` file and record which parameters it sets.
4. Build a coverage matrix: for each parameter, identify which test scenarios exercise it. Flag any parameter with **zero test coverage** (not used in any test scenario).
5. Verify the standard test scenarios exist:
   - `defaults` — Deploys with only required parameters
   - `max` — Deploys with all (or most) parameters set
   - `waf-aligned` — Deploys with Well-Architected Framework–aligned settings
6. Record findings as a parameter coverage table:

| Parameter | Type   | Required | defaults | max | waf-aligned | Other Tests | Covered |
| --------- | ------ | -------- | -------- | --- | ----------- | ----------- | ------- |
| `name`    | string | Yes      | Yes      | Yes | Yes         | —           | Yes     |
| `sku`     | string | No       | —        | Yes | Yes         | —           | Yes     |
| `tags`    | object | No       | —        | —   | —           | —           | **No**  |

---

### Step 8: Audit Type Safety

1. Review every parameter and output in `main.bicep` and all child modules.
2. Flag any parameter typed as a generic `object` or `array` without further type constraints.
3. For each flagged parameter, recommend one of:
   - **Resource-derived type** (preferred) — Use the type from the resource schema directly (e.g., `resource<'Microsoft.Storage/storageAccounts@2023-05-01'>.properties.networkAcls`).
   - **User-defined type** (fallback) — Define a `type` alias with explicit property definitions.
4. Record each finding with the parameter name, current type, and recommended replacement.

---

### Step 9: Check AVM Specification Compliance

1. Determine the module class from the path: `res` → Resource, `ptn` → Pattern, `utl` → Utility.
2. Fetch the relevant AVM specifications. Use the documentation index from Step 1 (`llms.txt`) to find the spec URLs. The applicable specs for each module class are determined by the `tags` in their front matter:
   - **Resource modules**: Specs tagged with `Class-Resource` AND `Language-Bicep`
   - **Pattern modules**: Specs tagged with `Class-Pattern` AND `Language-Bicep`
   - **Utility modules**: Specs tagged with `Class-Utility` AND `Language-Bicep`
3. For each applicable specification (especially `Severity-MUST` specs), verify the module complies. Key areas to check include:
   - **Naming and composition** (SFR specs, RMFR/PMFR specs)
   - **Inputs and outputs** (parameter naming, required outputs like `resourceId`, `name`, `resourceGroupName`, `systemAssignedMIPrincipalId`)
   - **Documentation** (README generation, parameter descriptions)
   - **Telemetry** (AVM telemetry resource block present and correct)
   - **Testing** (required test directories and scenarios per BCPRMNFR specs)
   - **Code style** (Bicep linting rules, decorators, descriptions)
   - **Release/publishing** (version.json, CHANGELOG.md)
4. Record each violation or gap with the spec ID, spec title, severity, and what needs to change.

---

## Output Format

Produce a single consolidated report with all sections below.

### Executive Summary

A brief (3–5 sentence) overview of the module's health, highlighting the most critical findings and recommended priority actions.

### Findings by Category

For each analysis step above, include one section with:

1. A summary table of findings.
2. Detailed findings for issues requiring action, using this format:

#### Finding: {Title}

- **Category**: {API Versions | Module Versions | Bicep Diagnostics | Resource Gaps | Open Issues | Test Coverage | Type Safety | Spec Compliance}
- **Severity**: {Low | Medium | High | Critical}
- **File(s)**: {affected file paths}
- **Location**: {specific line numbers or sections}

**Problem**: What is wrong and what impact it has.

**Recommended Fix**: Specific corrective actions with code snippets or configuration changes where applicable.

**Validation**: How to verify the fix is correct.

### Priority Action List

A numbered list of recommended actions sorted by priority (Critical → High → Medium → Low), with estimated complexity (Low / Medium / High) for each.

---

## Completion Checklist

Before finalizing the report, verify all steps were completed:

- [ ] Step 1: Module validated and context gathered
- [ ] Step 2: ARM API versions checked against latest stable
- [ ] Step 3: Referenced AVM module versions checked
- [ ] Step 4: Bicep diagnostics collected
- [ ] Step 5: Azure Resource Reference gaps identified
- [ ] Step 6: Open GitHub issues reviewed
- [ ] Step 7: Test coverage audited for all parameters
- [ ] Step 8: Type safety audited (no untyped objects/arrays)
- [ ] Step 9: AVM specification compliance verified

> If any step could not be completed (e.g., tool unavailable), note it explicitly in the report rather than skipping silently.
