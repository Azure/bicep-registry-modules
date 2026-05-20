---
name: avm-create-pull-request
description: "Create a GitHub pull request for AVM module changes with standard formatting, pipeline badges, and PR template. Example prompt: create a PR for my changes. USE FOR: create PR, open pull request, submit for review, create draft PR, open PR for module changes. DO NOT USE FOR: reviewing PRs, merging PRs, addressing PR comments."
---

# AVM Create Pull Request

> **Standard PR workflow for Azure Verified Modules.**
>
> Follow these steps exactly when creating a pull request for AVM module changes.

---

## Prerequisites

Before creating a PR, verify:

1. **GitHub authentication**: The user must be authenticated to GitHub via the VS Code GitHub extension (the same authentication that powers the `github-pull-request_create_pull_request` tool).
2. All changes are **committed**. The branch can be a feature branch or `main` on a fork.
3. The branch is **pushed** to the remote (must exist on `Azure/bicep-registry-modules` or a fork that can target it).
4. The `github-pull-request_create_pull_request` tool is available. If unavailable, use the `gh` CLI fallback (see Step 3).

If any prerequisite is not met, fix it before proceeding.

---

## Step 1 — Determine PR Metadata

### Title

Use **conventional commit** prefix based on change type:

| Change Type | Prefix |
|---|---|
| New feature, new module, new capability | `feat:` |
| Bug fix | `fix:` |
| Documentation only | `docs:` |
| CI/tooling/infrastructure (non-module) | `chore:` |
| Refactor (no functional change) | `refactor:` |

**Title format**: `<prefix> <concise description>`

**Module name rules**:
- If the PR relates to a specific module, include the module name in the title.
- For well-known abbreviations (VM, AKS, APIM, NSG, VNET, ACR, AKV, SQL, etc.), use the abbreviation.
- Otherwise, use the full module path wrapped in backticks: e.g. `` `avm/res/network/dns-zone` ``.
- Keep the title under 72 characters when possible.

**Examples**:
- `feat: Publish all child modules of `avm/res/operational-insights/workspace``
- `fix: Correct NSG rule priority in `avm/res/network/network-security-group``
- `feat: Add private endpoint support to AKS module`
- `chore: Update CI pipeline for `avm/utl/types/avm-common-types``

### Draft Status

**Always create as draft** (`draft: true`).

---

## Step 2 — Build the PR Body

Use the PR template from `.github/pull_request_template.md` as the base structure. Fill in each section as described below.

### Description Section

Write a concise summary of what changed and why. Include:
- Which module(s) are affected. Note for "child module publishing" PRs: don't add "(new, version 0.1.0)" as all newly published child modules are automatically versioned 0.1.0, and the key change is the publication itself.
- What the change does (high-level)
- Reference to related issues if any (e.g., `Fixes #123`, `Closes #456`)

### Pipeline Reference Section

Add a pipeline badge for each **top-level module** that has a workflow file. Only top-level parent modules have workflow files in `.github/workflows/` — child modules do not have their own workflows. When a PR affects child modules, include only the badge for their top-level parent.

**How to derive the badge**:

1. **Find the workflow file**: Convert the top-level module path to a workflow filename.
   - Module path: `avm/res/operational-insights/workspace`
   - Workflow file: `.github/workflows/avm.res.operational-insights.workspace.yml`
   - Pattern: replace `/` with `.` in the module path → `avm.res.operational-insights.workspace.yml`

2. **Verify the workflow file exists** in `.github/workflows/`. If it does not exist, skip the badge for that module.

3. **URL-encode the branch name**: Replace `/` with `%2F` in the branch name. For other special characters, apply standard URL encoding (e.g., spaces → `%20`).
   - Branch: `users/krbar/cmp-log-analytics`
   - Encoded: `users%2Fkrbar%2Fcmp-log-analytics`

4. **Construct the badge markdown**:

```markdown
| [![<workflow-name>](https://github.com/Azure/bicep-registry-modules/actions/workflows/<workflow-file>/badge.svg?branch=<encoded-branch>)](https://github.com/Azure/bicep-registry-modules/actions/workflows/<workflow-file>) |
```

**Example** for module `avm/res/operational-insights/workspace` on branch `users/krbar/cmp-log-analytics`:

```markdown
| [![avm.res.operational-insights.workspace](https://github.com/Azure/bicep-registry-modules/actions/workflows/avm.res.operational-insights.workspace.yml/badge.svg?branch=users%2Fkrbar%2Fcmp-log-analytics)](https://github.com/Azure/bicep-registry-modules/actions/workflows/avm.res.operational-insights.workspace.yml) |
```

### Type of Change Section

Check the appropriate boxes based on the changes:

| Scenario | Checkbox to check |
|---|---|
| Bug fix, no MAJOR/MINOR version bump | `Bugfix containing backwards-compatible bug fixes...` |
| New feature, MINOR version bumped | `Feature update backwards compatible feature updates...` |
| Breaking change, MAJOR version bumped | `Breaking changes and I have bumped the MAJOR version...` |
| Documentation only | `Update to documentation` |
| CI/tooling changes (no module changes) | `Update to CI Environment or utilities` |

For child module publishing PRs, check **Feature update** (MINOR version bump).

### Checklist Section

Check items that are true at the time of PR creation:
- `[x]` No other open PRs for the same change
- `[x]` `Set-AVMModule` has been run locally
- `[ ]` Pipelines run clean (leave unchecked — update to `[x]` after pipeline passes)
- `[x]` CHANGELOG.md updated

---

## Step 3 — Create the PR

Use the `github-pull-request_create_pull_request` tool (internal tool name, not user-facing) with:

```
{
  title: "<prefix>: <description>",
  head: "<branch-name>",
  base: "main",
  draft: true,
  body: "<filled PR template>",
  repo: { owner: "Azure", name: "bicep-registry-modules" }
}
```

**Fork-based contributions**: If the head branch is on a fork (not on `Azure/bicep-registry-modules` directly), also set `headOwner` to the fork owner's GitHub username.

**Fallback**: If the `github-pull-request_create_pull_request` tool is unavailable, use the GitHub CLI instead:

```bash
gh pr create --repo Azure/bicep-registry-modules --base main --head "<branch-name>" --title "<prefix>: <description>" --body "<filled PR template>" --draft
```

---

## Step 4 — Confirm Result

After the PR is created, report to the user:
- PR number and link
- Draft status reminder
- Pipeline badge status (if workflows exist)

---

## Labels and Reviewers

Do **NOT** manually set labels or reviewers. These are assigned automatically by the repository's CI automation.
