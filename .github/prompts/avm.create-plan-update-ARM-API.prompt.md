---
name: 'AVM-Update-module-to-latest-API-versions'
description: 'Analyze Azure Verified Module (AVM) Bicep files for ARM API version updates, schema diffs, and versioning recommendations.'
argument-hint: Provide the path to the AVM module main.bicep you want to analyze
agent: agent
model: Auto (copilot)
tools: ['search', 'runCommands', 'fetch', 'todos']
---

# AVM ARM API Version Update

Analyze `${file}` and all child modules under `${fileDirname}` for outdated ARM API versions.

Follow the skill at `.github/skills/avm-create-plan-update-arm-api/SKILL.md` exactly — it contains the full workflow, output format, versioning rules, and quality checks.
