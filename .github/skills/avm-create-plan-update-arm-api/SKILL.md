---
name: avm-create-plan-update-arm-api
description: "Analyze AVM Bicep modules for outdated ARM API versions and create implementation plans with schema diffs. USE FOR: update API version, ARM API, outdated API, api version plan, schema diff, AVM update plan, check API versions, plan API upgrade, API version analysis. DO NOT USE FOR: actual file modifications or code changes (use bicep-implement agent), creating new modules, Terraform modules."
---

# AVM ARM API Version Update Planner

> **AUTHORITATIVE GUIDANCE — MANDATORY COMPLIANCE**
>
> This skill analyzes Azure Verified Module (AVM) Bicep files for outdated ARM API versions and produces detailed implementation plans. Follow these steps exactly. Do not skip or reorder steps.

> [!IMPORTANT]
> This is a **planning task only**. Do not modify any files unless the user explicitly asks you to.

---

## Triggers

Activate this skill when user wants to:

- Check if an AVM module's ARM API versions are up to date
- Plan API version updates for a Bicep resource module
- Compare current vs latest ARM API schemas
- Get a schema diff for ARM API version changes
- Create an implementation plan for updating API versions

---

## Context

Azure resource providers regularly release new API versions with new properties, behavioral changes, and occasionally breaking changes. AVM modules must track stable API versions to remain current. This skill automates the comparison of current vs latest versions and produces actionable plans with schema-level detail.

---

## Rules

1. **Planning only** — Do not edit any files unless the user explicitly requests it.
2. **AVM compliance** — All recommendations must align with AVM specifications. Fetch the AVM docs index at `https://azure.github.io/Azure-Verified-Modules/llms.txt` during analysis.
3. **Stable versions only** — Prioritize stable API versions. Only recommend preview versions when no stable alternative exists.
4. **Schema validation required** — For every resource with an update available, fetch **both** current and latest schemas before producing the change plan.
5. **Complete output** — All four mandatory output sections (Summary Table, Status Icons, Detailed Change Plans, Versioning Recommendations) must be present.
6. **Use available tools** — If `#list_az_resource_types_for_provider`, `#get_az_resource_type_schema`, or `#list_avm_metadata` tools are available, prefer them. Fall back to `#fetch` with Microsoft Learn URLs when they are not.

---

## Workflow

### PHASE 0: Skill Version Output

Output the version block for traceability:

```json
{
  "skill": "avm-api-version-planner",
  "version": "0.1"
}
```

### PHASE 1: Validation & Setup

#### Step 1.1 — Validate Module Path

Verify the user's target file follows the AVM resource module pattern: `avm/res/{provider}/{resource}/main.bicep`. If the path does not match, stop and inform the user.

#### Step 1.2 — AVM Compliance Context (Non-blocking)

AVM compliance context is available from `https://azure.github.io/Azure-Verified-Modules/llms.txt`. However, this file is very large and fetching it can stall execution. **Do not block on this fetch.** Instead:

1. **Skip the fetch** if the skill file, user memory, or repository memory already contains sufficient AVM conventions (versioning rules, CHANGELOG format, parameter patterns, etc.).
2. **Attempt the fetch only if** the user explicitly requests it or the analysis encounters an AVM compliance question that cannot be resolved from local context.
3. If attempted, set a short timeout — if the fetch does not return promptly, continue without it.

#### Step 1.3 — Track Progress

If a task/todo tracking tool is available, create a task list and update it throughout execution.

### PHASE 2: Discovery & Analysis

#### Step 2.1 — Discover All Resource Definitions

Search the module directory (the target file and all child folders) for Azure resource definitions using the pattern `resource.*@.*=` in `*.bicep` files.

Build a complete inventory of:
- Symbolic resource name
- Resource type (e.g., `Microsoft.Storage/storageAccounts`)
- Current API version

#### Step 2.2 — Fetch Latest Stable API Versions

For each discovered resource type, determine the latest stable API version:

1. **Preferred**: Use `#list_az_resource_types_for_provider` or `#get_az_resource_type_schema` tools if available.
2. **Fallback**: Fetch from Microsoft Learn at `https://learn.microsoft.com/azure/templates/{resourceType}?pivots=deployment-language-bicep`

#### Step 2.3 — Classify Update Status

Compare current vs latest versions and assign a status to each resource:

- 🔄 **Update Available** — Newer stable version exists
- ✅ **Current** — Already on the latest stable version
- ⚠️ **Review Required** — Update available but may have breaking changes
- ❌ **Breaking Changes** — Update has known breaking changes
- 🔍 **Investigation Needed** — Current version is newer than latest documented stable
- 🟡 **Current (preview)** — Using a preview version when a stable version exists

#### Step 2.4 — Produce Summary Table

Compile the summary table **immediately** before deeper analysis. This gives the user an overview before detailed schema comparison begins.

### PHASE 3: Schema Analysis

> Only execute this phase for resources with status 🔄, ⚠️, or ❌.

#### Step 3.1 — Fetch Current Schema

For each resource needing an update, fetch the current API version schema:
`https://learn.microsoft.com/azure/templates/{resourceType}/{currentApiVersion}/{resourceName}?pivots=deployment-language-bicep`

#### Step 3.2 — Fetch Latest Schema

Fetch the latest API version schema:
`https://learn.microsoft.com/azure/templates/{resourceType}/{latestApiVersion}/{resourceName}?pivots=deployment-language-bicep`

#### Step 3.3 — Categorize Schema Changes

Compare property schemas and categorize each difference:

- ✅ **Non-breaking** — New optional properties, expanded allowed values
- ⚠️ **Potentially breaking** — Changed defaults, type changes for optional properties
- ❌ **Breaking** — Removed properties, narrowed allowed values, required property additions

### PHASE 4: Versioning Recommendations

#### Step 4.1 — Read Current Version State

Read the module's `version.json` and `CHANGELOG.md` files from the same directory as `main.bicep`.

- `version.json` contains the current `major.minor` version (e.g., `"version": "0.10"`).
- `CHANGELOG.md` contains the full release history. The latest entry's `major.minor.patch` version is the current published version.

#### Step 4.2 — Determine Version Bump Type

Apply these rules per [SNFR17](https://azure.github.io/Azure-Verified-Modules/spec/SNFR17/) (pre-`1.0.0` versioning):

| Condition | Bump Type | version.json | CHANGELOG.md |
|-----------|-----------|--------------|--------------|
| API version update with **breaking changes** (removed properties, renamed parameters, changed required fields, type changes) | **Minor** | Increment minor (e.g., `0.10` → `0.11`) | New `## 0.11.0` entry |
| API version update with **new features** (new optional properties, expanded allowed values, new parameters) | **Minor** | Increment minor | New entry at `.0` |
| API version update that is **purely internal** (no consumer-visible schema changes) | **Patch** | No change | Increment patch on current minor |
| Non-API changes (bug fixes, doc updates, dependency bumps) | **Patch** | No change | Increment patch on current minor |

> **Important**: Per SNFR17, before the first `1.0.0` release: Major MUST NOT be bumped, Minor MUST be bumped for breaking changes or feature updates, and Patch MUST be bumped for non-breaking backward-compatible fixes. For Bicep modules, the patch version in `version.json` is **auto-incremented** by the public registry — you only control Major and Minor.

#### Step 4.3 — Draft CHANGELOG Entry

Compose a CHANGELOG entry following the established format:

```markdown
## {newVersion}

### New Features

- {Only include this section if there are genuinely new features/parameters}

### Changes

- {Describe each change concisely}
- {Reference issue numbers where applicable: Fixes [#NNNN](https://github.com/Azure/bicep-registry-modules/issues/NNNN)}

### Breaking Changes

- {List each breaking change, or "None" if there are no breaking changes}
```

Rules for the CHANGELOG entry:
- **New Features** section is optional — only include when new parameters or capabilities are added
- **Changes** section lists all modifications (API version updates, dependency updates, test changes, etc.)
- **Breaking Changes** section is always present; use `- None` if there are no breaking changes
- Start with the most impactful changes
- Be specific: name the parameters, types, API versions, and resources affected
- Reference GitHub issues with full markdown links when applicable

### PHASE 5: Output Generation

Produce all four mandatory output sections as specified below.

---

## Decision Points

| Situation | Action |
|-----------|--------|
| Module path does not match `avm/res/` pattern | Stop — inform user this skill targets AVM resource modules |
| No resources need updates (all ✅) | Output summary table only, skip Phases 3–4 and Detailed Change Plans / Versioning Recommendations |
| Schema fetch fails for a resource | Mark as 🔍 Investigation Needed, note the failure, continue with remaining resources |
| Only preview API version is newer | Mark as 🟡, recommend staying on current stable unless user explicitly wants preview |
| Current version is newer than documented latest | Mark as 🔍, flag for manual investigation |
| Resource type not found on Microsoft Learn | Mark as 🔍, suggest checking the resource provider documentation directly |

---

## Output Format

### Section 1: Summary Table (MANDATORY)

| Resource Name | Resource Type | Current API | Latest API | Status | Complexity | Breaking Changes |
|---------------|---------------|-------------|------------|--------|------------|------------------|
| `storageAccount` | `Microsoft.Storage/storageAccounts` | `2023-01-01` | `2023-05-01` | 🔄 Update Available | Low | None |

### Section 2: Status Icons (MANDATORY)

Include the full legend:

- 🔄 **Update Available**: Newer stable version is available
- ✅ **Current**: Already on the latest stable version
- ⚠️ **Review Required**: Update available but may have breaking changes
- ❌ **Breaking Changes**: Update has known breaking changes
- 🔍 **Investigation Needed**: Current version is newer than latest documented stable
- 🟡 **Current (preview)**: Using a preview version when a stable version exists

### Section 3: Detailed Change Plans (MANDATORY for each resource needing update)

For each resource requiring an update:

#### Resource: {ResourceName}

- **Current Version**: {currentApiVersion}
- **Target Version**: {latestApiVersion}
- **Change Type**: {Non-breaking | Potentially Breaking | Breaking}

**Schema Changes:**
- ➕ **New**: List specific new properties with their types and descriptions
- 🔄 **Modified**: List specific properties with changed types, constraints, or allowed values
- ➖ **Removed**: List specific removed or deprecated properties
- ⚠️ **Behavioral**: Note specific changes in default values or resource behavior

**Implementation Plan:**
1. **Module Updates**: Detail specific required changes to parameters, variables, and outputs
2. **Test Updates**: Specify which e2e test scenarios need modification (defaults/max/waf-aligned)
3. **Documentation**: Note specific required updates (run `Set-AVMModule` — never edit README.md directly)
4. **Validation**: Mention any PSRule or linter considerations

**Risk Assessment:**
- **Breaking Risk**: {Low | Medium | High} — with specific justification
- **Migration Effort**: {Low | Medium | High} — with specific justification
- **Testing Complexity**: {Low | Medium | High} — with specific test scenarios needed

### Section 4: Versioning Recommendations (MANDATORY when updates are needed)

> Only include this section when at least one resource has status 🔄, ⚠️, or ❌.

#### Version Bump

| File | Current Value | Proposed Value | Bump Type |
|------|---------------|----------------|-----------|
| `version.json` | `"version": "{current}"` | `"version": "{proposed}"` | {Minor \| Patch} |
| `CHANGELOG.md` | Latest: `## {currentLatest}` | New: `## {proposedVersion}` | — |

**Reasoning**: {One sentence explaining why this bump type was chosen, e.g., "Minor bump required because ARM API version upgrade changes the underlying API contract" or "Minor bump required due to breaking parameter type changes."}

#### Suggested CHANGELOG Entry

Provide the complete entry to prepend to CHANGELOG.md (after the header and GitHub link):

```markdown
## {proposedVersion}

### New Features

- {list new features, or omit this section entirely if none}

### Changes

- Updated ARM API version for `{resourceType}` from `{oldApi}` to `{newApi}`.
- {additional changes}

### Breaking Changes

- {list breaking changes, or "None"}
```

#### Suggested version.json

```json
{
  "$schema": "https://aka.ms/bicep-registry-module-version-file-schema#",
  "version": "{proposedMinorVersion}"
}
```

---

## Quality Checks

Before completing, verify:

- [ ] All ReAct phases (1–5) executed completely
- [ ] Summary table includes ALL discovered resources with their status
- [ ] Status icons legend is included
- [ ] For EVERY resource with "Update Available" status, BOTH current and latest schemas were fetched
- [ ] Detailed change plans created for EVERY resource requiring updates
- [ ] Implementation plans include specific code changes, testing requirements, and risk assessments
- [ ] No files were modified (unless user explicitly requested it)
- [ ] Versioning recommendations include both `version.json` and `CHANGELOG.md` suggestions for every resource needing updates
- [ ] Version bump type (minor vs patch) is justified based on change analysis
- [ ] Suggested CHANGELOG entry follows the established format with all required sections
- [ ] All recommendations align with AVM specifications
