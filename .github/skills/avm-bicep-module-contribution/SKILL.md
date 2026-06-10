---
name: avm-bicep-module-contribution
description: "End-to-end workflow for fixing an issue or implementing a change in an existing AVM Bicep module in this repository (Azure/bicep-registry-modules), up to a review-ready pull request. Covers: branch, implement per AVM Bicep specs, regenerate module files with Set-AVMModule, get local static unit (Pester) tests green, update e2e tests and CHANGELOG/version.json, prepare the module's e2e workflow run, and attach the pipeline status badge to the PR. USE FOR: fix AVM Bicep module bug, implement AVM Bicep module feature, resolve an assigned BRM issue, prepare a BRM module pull request, run Set-AVMModule, get local Bicep unit tests green, attach pipeline status badge to PR. DO NOT USE FOR: publishing a child module (use avm-child-module-publishing), creating a brand-new module from scratch, Terraform modules, changes outside avm/ (CI/utilities only)."
---

# AVM Bicep Module Contribution (Issue -> Review-ready PR)

> **AUTHORITATIVE GUIDANCE - MANDATORY COMPLIANCE**
>
> This skill implements the official AVM Bicep contribution flow for changing an
> existing module. Follow the steps in order. Do not skip or reorder them. This
> skill is the operational companion to [.github/copilot-instructions.md](../../copilot-instructions.md);
> all rules in that file still apply.

---

## Scope

Use this when an issue is assigned that asks for a bugfix or feature in an existing
Bicep module under `avm/res/`, `avm/ptn/`, or `avm/utl/`. The goal is a pull
request that a reviewer can validate, with local static tests green and the module's
e2e pipeline either run green (badge attached) or fully prepared for the human to run.

> **Environment reality**: The coding agent environment has no AVM fork CI and no
> Azure subscription. It therefore **cannot** execute the e2e deployment workflow
> (that needs OIDC + an Azure test subscription). The agent MUST do everything up
> to and including local static validation, then prepare the PR so the e2e run and
> badge can be completed. See Step 7.

### Two supported contribution models

Detect which model applies before branching (check the `origin` remote:
`git remote get-url origin`):

- **Maintainer (no fork)**: `origin` is `Azure/bicep-registry-modules`. You have
  write access and push feature branches directly to upstream. On upstream, the
  module e2e workflow triggers automatically on `push` to your branch (when module
  paths change) and can also be dispatched manually. Badge URLs use `Azure`.
- **Fork contributor**: `origin` is `<your-org>/bicep-registry-modules`. You push
  to the fork and open a PR to upstream. In a fork the workflow only runs via
  manual `workflow_dispatch`. Badge URLs use `<fork-owner>`.

Every step below works for both models; differences are called out where they exist.

---

## Workflow

### Step 1: Identify the target module and branch

1. From the issue, determine the exact module folder path, e.g. `avm/res/network/virtual-network`.
2. Determine your contribution model: `git remote get-url origin` (see *Two supported contribution models* above).
3. Start from an up-to-date base and create a feature branch:

   ```bash
   git checkout main
   git pull
   git checkout -b fix/<issue-number>-<short-description>
   ```

   - **Maintainer (no fork)**: this branch lives on `Azure/bicep-registry-modules`; you will push it directly to `origin`. Do **not** create a fork.
   - **Fork contributor**: ensure your fork's `main` is synced with upstream first (e.g. `gh repo sync <fork-owner>/bicep-registry-modules`), then branch.

### Step 2: Implement the change per AVM Bicep specifications

1. Read the relevant module files: `main.bicep`, nested `*/main.bicep`, `main.test.bicep` test cases under `tests/e2e/*`, `version.json`, `CHANGELOG.md`.
2. Make the change in `main.bicep` (and child `main.bicep` files) only. **Never** hand-edit `main.json` or `README.md` - they are generated (Step 4).
3. Comply with the AVM Bicep specs and interfaces. When in doubt, fetch the spec index: `https://azure.github.io/Azure-Verified-Modules/llms.txt`.
4. For schemas / API versions, prefer the Bicep VS Code extension tools (`#list_az_resource_types_for_provider`, `#get_az_resource_type_schema`, `#list_avm_metadata`); fall back to `#fetch` against `https://learn.microsoft.com/azure/templates/`.

### Step 3: Version and changelog

Pick exactly one, based on the change, and bump `version.json` accordingly:

- Backwards-compatible **bugfix**: do **not** bump MAJOR/MINOR (patch handled at release).
- Backwards-compatible **feature**: bump the **MINOR** version.
- **Breaking change**: bump the **MAJOR** version (and prefer deprecation over removal where possible).

Add a matching entry to the module's `CHANGELOG.md`.

### Step 4: Regenerate module files with Set-AVMModule (MANDATORY)

Always run this after editing `main.bicep` so `main.json` and `README.md` are regenerated. Dot-source first; never use the `&` call operator.

```powershell
. ./utilities/tools/Set-AVMModule.ps1
Set-AVMModule -ModuleFolderPath 'avm/res/<provider>/<type>' -Recurse
```

- Readme-only refresh (no `main.bicep` change): add `-SkipBuild`.
- If the module has child modules, keep `-Recurse` so nested files regenerate too.

### Step 5: Update or add e2e tests

If the change affects module behavior (new parameter, new output, changed default), update an existing test under `tests/e2e/<scenario>/main.test.bicep` or add a new scenario per `BCPRMNFR1`. Resource modules must keep the minimum required test set. Re-run Step 4 after touching test files if needed.

### Step 6: Get local static unit tests green (MANDATORY)

Run the offline static (Pester) validation locally - no Azure access required. Dot-source first.

```powershell
. ./utilities/tools/Test-ModuleLocally.ps1
Test-ModuleLocally -TemplateFilePath 'avm/res/<provider>/<type>/main.bicep' -PesterTest
```

Fix every failure until the static tests pass clean (no errors or warnings). Do not proceed while red.

### Step 7: Prepare the e2e pipeline run and the PR badge

The agent cannot deploy to Azure, so prepare everything the reviewer/human needs:

1. Ensure the module workflow file exists: `.github/workflows/avm.<res|ptn|utl>.<provider>.<type>.yml` (module path with `/` replaced by `.`). For a new module, create it from another `avm.*` workflow or the template, but for an existing module it should already exist - do not edit it unless required.
2. In the PR description's **Pipeline Reference** table, add the module's e2e status badge pointing at the PR branch. Use the owner that matches your contribution model (`<owner>` = `Azure` for maintainers, `<fork-owner>` for fork contributors):

   ```markdown
   | Pipeline |
   | -------- |
   | [![avm.<res|ptn|utl>.<provider>.<type>](https://github.com/<owner>/bicep-registry-modules/actions/workflows/avm.<res|ptn|utl>.<provider>.<type>.yml/badge.svg?branch=<branch>)](https://github.com/<owner>/bicep-registry-modules/actions/workflows/avm.<res|ptn|utl>.<provider>.<type>.yml) |
   ```

3. Trigger / note the e2e run per model:
   - **Maintainer (no fork)**: pushing the branch to `Azure/bicep-registry-modules` triggers the module workflow automatically when module paths changed; it can also be dispatched manually from the `Actions` tab against the branch. Confirm it is running/green.
   - **Fork contributor**: the workflow runs only via `workflow_dispatch`, so it must be dispatched from the fork's `Actions` tab against this branch.
   - In both cases, if the agent cannot trigger or observe the run, say so plainly in the PR - do not claim e2e passed when it was not run. The run must complete green before merge.

### Step 8: Commit, push, open the PR

```bash
git add .
git commit -m "fix: <module name> - <meaningful description>"
git push -u origin HEAD
```

- **Maintainer (no fork)**: `origin` is upstream, so the branch is pushed directly to `Azure/bicep-registry-modules`; open the PR from this branch into `main` of the same repo.
- **Fork contributor**: `origin` is your fork; open the PR from `<fork-owner>:<branch>` into `Azure/bicep-registry-modules:main`.

Open the PR and follow `.github/pull_request_template.md`:

- Title in the form `fix: <module name>` or `feat: <module name>` (Semantic PR check).
- Link the issue with `Fixes #<issue-number>`.
- Fill the **Pipeline Reference** badge (Step 7).
- Tick the checklist: no duplicate PRs, `Set-AVMModule` run, checks green, `CHANGELOG.md` updated.
- If you are the sole module owner, note that the AVM core team must review and apply the `Needs: Core Team` label.

---

## Definition of done

- Change implemented in `main.bicep` only; `main.json` + `README.md` regenerated via `Set-AVMModule`.
- `version.json` and `CHANGELOG.md` updated to match the change type.
- e2e tests updated/added when behavior changed.
- Local static Pester tests pass clean.
- PR opened from a feature branch with issue linked, semantic title, checklist ticked, and the e2e pipeline badge present (with a clear note if the e2e run still needs to be dispatched by a human).
