# Bicep Module Workflows

Module-specific workflows and [`avm.module.yml`](./avm.module.yml) are registry-owned callers. This migration prepares shared workflows and actions in [Azure/azure-verified-modules-tools](https://github.com/Azure/azure-verified-modules-tools), with common validation supplied by a qualified `Avm.Authoring` release. The cutover prerequisites below must be completed before replacing the current local workflow implementation.

| Tools workflow                  | Purpose                                                                                                                  |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------ |
| `bicep-module.yml`              | Module-specific static, PSRule and deployment validation, followed by release-tag creation when its existing gates pass. |
| `bicep-module-deployment.yml`   | One selected deployment test, including assertions and cleanup under its subscription lock.                              |
| `bicep-module-preview.yml`      | Generic automatic validation and release-tag preview.                                                                    |
| `bicep-module-static.yml`       | Secret-free static validation for fork contributions.                                                                    |
| `bicep-module-publish.yml`      | Generic manual validation and approved release-tag creation.                                                             |
| `bicep-module-publish-only.yml` | Approved release-tag creation without deployment or OIDC access.                                                         |

The registry retains module files, tests and configuration. The shared workflow implementation must not load validation code from the caller's `utilities` or `.github/actions/templates` folders. Release tags are consumed by the Azure DevOps publishing pipeline; these workflows do not publish directly to MCR.

## Cutover prerequisites

1. Publish a qualified `Avm.Authoring` release containing the complete packaged Bicep static validation route and canonical README template, existing end-to-end handling of the root required-feature manifest, required policy selectors, and unit/policy version-check forwarding. Its manifest must advertise `PrivateData.AvmCapabilities.BicepPackagedCompliance = 1`; intermediate packages without that capability are rejected.
1. Make the reviewed tools workflows and actions available at one immutable commit. Every tools `uses` reference and `tools-ref` input must identify that same commit. A candidate branch commit is for draft qualification only; select a merged tools commit before registry cutover.
1. Separately approve and apply the tools-owned federation configuration for the exact tools deployment workflow revision and allowed registry callers, together with the matching repository OIDC subject configuration. Verify the existing module identity mapping, tenant and subscription pool before changing callers. Source changes alone do not authorize this step.
1. Configure the registry's `AVM_AUTHORING_VERSION` variable to that exact qualified release before merging the caller migration. It has no fallback; unset or invalid versions must fail rather than select `latest`.

Each module workflow includes its own file in its main-branch push filter. Merging a caller migration can therefore start validation for every affected module; approve and schedule that rollout separately.

Tools revision updates must change all `uses` pins and `tools-ref` inputs together and use a compatible qualified `Avm.Authoring` release. Rerun the caller regression tests and obtain separate approval for the rollout. Dependabot updates `uses` declarations but not the matching inputs, so these tools dependencies use coordinated manual upgrades. Other action updates remain enabled.

## Module identities

Tools deployment workflows select the client from `vars.VALIDATE_MODULE_CLIENT_IDS`, a flat JSON object mapping canonical root module paths to unique, nonzero client GUIDs. Child paths resolve through the existing canonical-root rules and use their root's entry. Missing, malformed or invalid mappings must fail before login; there is no fallback to `VALIDATE_CLIENT_ID` or `AZURE_CREDENTIALS`. Caller workflows do not need an additional identity input or their own mapping parser.

`VALIDATE_TENANT_ID` and `VALIDATE_SUBSCRIPTION_IDS` remain separate settings. The tools workflow enables both Azure CLI and PowerShell login contexts and explicitly forwards the subscription pool through `TestSubscriptionIds`; `UseCiInputs` does not read that plural variable implicitly. The selected client, tenant and subscription remain consistent through deployment, retries and final cleanup.

Ordinary runs keep `workflow_ref` as `Azure/bicep-registry-modules/.github/workflows/avm.<kind>.<namespace>.<module>.yml@refs/heads/main`. Generic and bulk runs use `Azure/bicep-registry-modules/.github/workflows/avm.module.yml@refs/heads/main`. The tools deployment job uses `job_workflow_ref` at `Azure/azure-verified-modules-tools/.github/workflows/bicep-module-deployment.yml@<tools commit>`. Federation source is owned by the tools repository and restricts the registry repository/owner, `avm-validation` environment and approved workflow references. A Tools-repository credential cannot substitute for a registry caller.

Generic deployment remains supported. Module/client selection is a workflow-code convention, **not a per-module federated security boundary**: approved generic code can select any identity in the mapping. No dispatcher or secret-auth exception list is introduced. The old shared Bicep identity is a deferred cleanup item; this change does not delete it, alter deployed permissions or apply federation.

The root [`.required-features.json`](../../.required-features.json) remains caller-owned configuration, read by native end-to-end execution without a separate workflow registration stage or manifest parser. Do not move module-specific decisions into shared implementation.

Packaged validation reads child-module publishing approvals from [`.avm/child-module-publish-allowed-list.json`](../../.avm/child-module-publish-allowed-list.json). Keep it identical to the legacy `utilities/pipelines/staticValidation/compliance/helper/child-module-publish-allowed-list.json` while local tools and current releases still consume that file. The caller tests enforce parity; this migration does not add or remove approvals.

## Retained compatibility entry points

The following consumers prevent wholesale removal of registry utilities:

| Entry point                                                | Remaining consumers                                                                                                                     |
| ---------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| `avm-getWorkflowInput` local action                        | `platform.check.psrule.yml`, `platform.ci-tests.yml`, `platform.deployment.history.cleanup.yml`, `platform.rerun-failed-workflows.yml`. |
| `avm-setEnvironment` local action                          | `platform.check.psrule.yml`, `platform.ci-tests.yml`, `platform.deployment.history.cleanup.yml`, `copilot-setup-steps.yml`.             |
| `utilities/pipelines/staticValidation`                     | Local module validation, the standalone metadata gate, platform PSRule checks and their regression tests.                               |
| `utilities/pipelines/sharedScripts`                        | Module generation, metadata module selection, platform setup and local tools.                                                           |
| `utilities/pipelines/e2eValidation` and publishing helpers | Supported local script entry points and their regression tests.                                                                         |
| `docs/templates/avm-readme-v1.scriban`                     | The explicit `documentation.template` override in root `bicepconfig.json`, used by tooling that reads this documentation configuration. |

Retire these only after their consumers use qualified packaged APIs and equivalent regression coverage is available. Moving the module workflow callers does not by itself complete that retirement.

Recheck the retirement map after merging newer registry changes. Current deployment cleanup, regional retry, preflight and response-contract tests stay with their supported local entry points until published replacements are qualified. Host and image-builder helpers and their tests are outside this workflow migration; no image build is required for caller qualification.

The existing `documentation.template.file` and `includeRoot` continue to select the legacy Scriban copy; a packaged default does not override explicit configuration. Once the compatible release and remaining documentation consumers are qualified, remove only `documentation.template` to select the packaged canonical template. Preserve `documentation.examples.reassignments`, the Microsoft Graph extension and analyzer/compiler settings. Keep the existing asset until its consumers are retired; do not add another shared template copy for the workflow migration.

## Generic Check and Publish Workflow

> [!WARNING]
> This workflow is a work in progress to test whether workflow consolidation is possible.
> It should not be used yet.

The `.Module - Check and Publish [EXPERIMENTAL]` workflow provides a generic way to validate and publish one or more AVM modules. It is implemented by [`avm.module.yml`](./avm.module.yml).

## Automatic checks

Pushes to `main` that change files under `avm/`, excluding module `README.md` and `metadata.json` files, automatically:

1. Discover the affected top-level modules.
1. Run static, PSRule, and deployment validation.
1. Calculate and log the release tags that would be created.

Automatic runs cannot create tags. The preview path has read-only repository permissions and invokes the release logic with `WhatIf`.

The generic workflow runs alongside module-specific workflows during its initial validation period. Generic deployments retain the `gci` name prefix. Deployment locks are shared with module-specific workflows for the same module and selected subscription, with an additional module-wide lock for shared scopes.

Pull-request checks require `PR: Run Checks`. Deployment validation additionally requires `PR: Run E2E Tests` and an internal branch. Fork contributions use only the secret-free static workflow.

## Manual runs

Use **Actions** > **.Module - Check and Publish [EXPERIMENTAL]** > **Run workflow**.

`modulePaths` accepts one module path or a comma-separated list:

```text
avm/res/storage/storage-account
```

```text
avm/res/storage/storage-account, avm/res/network/virtual-network
```

Child module paths are accepted but resolve to their top-level module workflow.

| Input                  | Default  | Purpose                                                                                              |
| ---------------------- | -------- | ---------------------------------------------------------------------------------------------------- |
| `modulePaths`          | Required | One module path or comma-separated module paths.                                                     |
| `staticValidation`     | `true`   | Run static and PSRule validation.                                                                    |
| `deploymentValidation` | `true`   | Run deployment validation.                                                                           |
| `removeDeployment`     | `true`   | Remove resources created by deployment validation.                                                   |
| `customLocation`       | Empty    | Override the default deployment location.                                                            |
| `createReleaseTag`     | `false`  | Approve and create the next top-level module release tag, including when no publishable diff exists. |
| `publishOnly`          | `false`  | Skip validation and only create the release tag. Requires `createReleaseTag`.                        |

Selecting `createReleaseTag` requires approval through the `publish-approval` environment. Without it, a manual run performs validation only.

## Reusable workflows

After cutover, the entry workflow will use these separate tools workflows to preserve the existing permission boundaries:

| Workflow                        | Used for                                             | Repository permissions                                   |
| ------------------------------- | ---------------------------------------------------- | -------------------------------------------------------- |
| `bicep-module-preview.yml`      | Automatic validation and release-tag preview.        | Read, plus OIDC for deployment validation.               |
| `bicep-module-static.yml`       | Static validation for fork contributions.            | Read only; no secrets or OIDC.                           |
| `bicep-module-publish.yml`      | Manual validation followed by approved tag creation. | Read and OIDC for validation; write only for publishing. |
| `bicep-module-publish-only.yml` | Approved tag creation without validation.            | Write only; no OIDC or deployment access.                |

These workflows are intentionally separate because GitHub validates permissions for every job in a reusable workflow, including jobs that would be skipped.

Module-specific callers will use `bicep-module.yml` with their existing dispatch defaults, upstream/manual guards and main-only push filters. The SQL instance-pool cleanup default and the current FinOps hub location input must be preserved.
