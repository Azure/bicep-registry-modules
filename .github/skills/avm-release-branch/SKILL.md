---
name: avm-release-branch
description: Use for Bicep external fork PRs that need credentialed E2E tests, same-repository release-branch handoffs, avm release-branch, and recovery from an interrupted handoff.
---

# Bicep fork PR release-branch handoff

Credentialed E2E testing of external fork PRs requires a same-repository release branch. Labels on a fork PR never grant deployment credentials; ordinary fork checks do not require this handoff.

## Review before invoking

An authorized Microsoft FTE with write access to `Azure/bicep-registry-modules` must first review all code, workflows, and dependencies on the current fork PR head that could access credentials. Do not infer review or authorization from labels. The command cannot verify which commit a human reviewed. Restrict write access to the release branch and re-review later changes before allowing them to use credentials.

Use the MAR-installed `Avm.Authoring` module from the [Bicep prerequisites](https://azure.github.io/Azure-Verified-Modules/contributing/bicep/prerequisites/) and the existing authenticated `gh` session for github.com. The external fork PR must be open and ready for review; the upstream repository must be a non-fork with default branch `main`.

## Run the handoff

Replace `123` with the reviewed fork PR number:

```pwsh
avm release-branch `
    --repository 'Azure/bicep-registry-modules' `
    --pull-request 123
```

This command changes GitHub state. It creates `release/fork-pr-<number>-<sha-prefix>` from upstream `main`, retargets the original fork PR, merges its captured head into that release branch, and opens a follow-up PR back to `main`. It refuses to merge if the fork head changes during handoff. It does not merge the follow-up, publish a release, approve reviews, or bypass branch protections and required checks.

For `Azure/bicep-registry-modules`, the command automatically adds `PR: Run Required E2E Tests` to the follow-up PR. Review must therefore be complete before invocation, not deferred until after the label is added. Use `PR: Run All E2E Tests` on the follow-up when optional scenarios are also needed. Inspect actual selected test results and merge gates before merging to `main`; a label or skipped job is not proof of passing E2E tests.

## Interrupted handoffs

A failure can leave a created branch or a retargeted or merged PR behind. Inspect the original PR, release branch, and any follow-up PR before manual recovery; do not blindly rerun.

See the [command reference](https://github.com/Azure/azure-verified-modules-tools/blob/main/docs/reference/Invoke-AvmReleaseBranch.md) for parameters and preview support.
