---
description: "Azure Verified Modules (AVM) and Bicep"
applyTo: "**/*.bicep, **/*.bicepparam, **/main.json, **/version.json"
---

# Azure Verified Modules (AVM) Bicep

This repository (`Azure/bicep-registry-modules`, "BRM") is the official home of the
Azure Verified Modules (AVM) for **Bicep** - pre-built, tested, validated modules
that follow Azure best practices. Modules live under `avm/res/` (resource),
`avm/ptn/` (pattern), and `avm/utl/` (utility).

Authoritative rules live in
[.github/copilot-instructions.md](.github/copilot-instructions.md). For step-by-step
workflows, use the skills under [.github/skills/](.github/skills/). This file is the
high-level orientation for any agent working in this repo.

## AVM Specifications

The authoritative source for every AVM rule (Bicep, shared) is the spec index:

- **Index of all specs and docs (raw markdown URLs):** `https://azure.github.io/Azure-Verified-Modules/llms.txt`
- **Rendered docs site:** `https://azure.github.io/Azure-Verified-Modules/`

When a spec ID is mentioned (e.g. `BCPNFR23`, `RMFR4`, `SNFR1`), fetch `llms.txt`
once, look up the raw markdown URL for that ID, and read the current text. Do not
cite a spec from memory.

## Module Discovery

- **Bicep Resource Modules Index:** `https://raw.githubusercontent.com/Azure/Azure-Verified-Modules/refs/heads/main/docs/static/module-indexes/BicepResourceModules.csv`
- **Bicep Pattern Modules Index:** `https://raw.githubusercontent.com/Azure/Azure-Verified-Modules/refs/heads/main/docs/static/module-indexes/BicepPatternModules.csv`
- **Bicep Utility Modules Index:** `https://raw.githubusercontent.com/Azure/Azure-Verified-Modules/refs/heads/main/docs/static/module-indexes/BicepUtilityModules.csv`
- **Published versions (MCR):** `https://mcr.microsoft.com/v2/bicep/{moduleName}/tags/list` (tags are not version-ordered; sort them).

## Module Naming Conventions

- **Resource Modules:** `avm/res/{service}/{resource}` -> registry `br/public:avm/res/{service}/{resource}`
- **Pattern Modules:** `avm/ptn/{group}/{name}` -> registry `br/public:avm/ptn/{group}/{name}`
- **Utility Modules:** `avm/utl/{group}/{name}` -> registry `br/public:avm/utl/{group}/{name}`
- Use kebab-case for services and resources; `camelCase` for parameters and variables.
- Each module folder maps to a workflow `avm.<res|ptn|utl>.<...>.yml` (path `/` replaced by `.`).

## Module Usage

When consuming AVM Bicep modules:

1. Pin to a specific version: `br/public:avm/res/{service}/{resource}:1.2.3`.
2. Map telemetry to a root parameter: `enableTelemetry: enableTelemetry`.
3. Start from the official examples in the module's `README.md` / `tests/e2e`.
4. Discover available versions via the MCR tags list (see Module Discovery).

## Module Sources

- **Public registry:** `br/public:avm/{res|ptn|utl}/{...}:{version}`
- **Source code:** `https://github.com/Azure/bicep-registry-modules/tree/main/avm/{res|ptn|utl}/{...}`
- **Generated files:** `main.json` and `README.md` are produced by `Set-AVMModule`; never hand-edit them.

## Contributing (issue -> review-ready PR)

For fixing an issue or implementing a change in an existing module, follow
[avm-bicep-module-contribution](.github/skills/avm-bicep-module-contribution/SKILL.md)
end to end; an ordered checklist also lives in
[.github/copilot-instructions.md](.github/copilot-instructions.md). To publish a
child module, follow
[avm-child-module-publishing](.github/skills/avm-child-module-publishing/SKILL.md).

Non-negotiable gates:

- Edit `main.bicep` only; regenerate `main.json` + `README.md` via `Set-AVMModule`.
- Run PowerShell by dot-sourcing (`. ./script.ps1`); never use the `&` call operator.
- Local static (Pester) validation must be green, and the module's e2e pipeline must
  run green with its status badge attached to the PR before merge.

**Contribution models** (detect via `git remote get-url origin`):

- **Maintainer (no fork):** `origin` is `Azure/bicep-registry-modules`; push feature
  branches directly to upstream and open the PR within the same repo. No fork required.
- **Fork contributor:** `origin` is your fork; push there and open a PR to upstream.
