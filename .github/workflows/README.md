# Bicep Module Workflows

Module-specific workflows and [`avm.module.yml`](./avm.module.yml) are registry-owned callers. General module validation pins shared workflows and actions in [Azure/azure-verified-modules-tools](https://github.com/Azure/azure-verified-modules-tools), with common validation supplied by a qualified `Avm.Authoring` release. Reserved module validation retains the local compatibility workflows described below. Draft caller changes do not authorize execution or retire the retained local implementation. Complete the cutover prerequisites before merging or enabling the new route.

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

1. Publish a qualified `Avm.Authoring` release containing the complete packaged Bicep static validation route and canonical README template, approved native deployment retries and final post-hook/cleanup behavior, end-to-end handling of the root required-feature and resource-provider manifests, reservation-aware subscription selection and policy tokens, required policy selectors, package-download recovery, and unit/policy version-check forwarding. Its manifest must advertise `PrivateData.AvmCapabilities.BicepPackagedCompliance = 1`; intermediate packages without that capability are rejected.
1. Make the reviewed tools workflows and actions available at one immutable commit. Every tools `uses` reference and `tools-ref` input must identify that same commit. A candidate branch commit is for draft qualification only; select a merged tools commit before registry cutover.
1. Verify the module identity mapping, tenant and subscription pool. Separately approve any required live application of stable module credentials matching the existing owner/repository/environment subject. This preparation does not change the repository subject template or remove existing credentials.
1. Configure the registry's `AVM_AUTHORING_VERSION` variable to that exact qualified release before merging the caller migration. It has no fallback; unset or invalid versions must fail rather than select `latest`.

Each module workflow includes its own file in its main-branch push filter. Merging a caller migration can therefore start validation for every affected module; approve and schedule that rollout separately.

Tools revision updates must change all `uses` pins and `tools-ref` inputs together and use a compatible qualified `Avm.Authoring` release. Rerun the caller regression tests and obtain separate approval for the rollout. Dependabot updates `uses` declarations but not the matching inputs, so these tools dependencies use coordinated manual upgrades. Other action updates remain enabled.

The tools commit supplies orchestration and support code; it does not select or install its own native source as the runtime package. All shared-workflow callers and the generic selection action forward `vars.AVM_AUTHORING_VERSION`, which must identify the separately qualified PowerShell Gallery release. The retained local workflows keep their existing tooling setup; they do not load native source from the tools checkout. A published tools revision or an open runtime change does not establish package readiness.

The release must also provide `BicepRequiredResourceProviders = 1` for deployment and `PowerShellModuleArchiveRecovery = 1` for policy validation. These package-capability checks are additional requirements, not evidence that a release has been selected or qualified.

## Module identities

Tools deployment workflows and retained module-validation workflows select the client from `vars.VALIDATE_MODULE_CLIENT_IDS`, a flat JSON object mapping canonical root module paths to unique, nonzero client GUIDs. Child paths resolve through the existing canonical-root rules and use their root's entry. Missing, malformed or invalid mappings must fail before login; there is no fallback to `VALIDATE_CLIENT_ID` or `AZURE_CREDENTIALS`. Caller workflows do not need an additional identity input or their own mapping parser.

`VALIDATE_TENANT_ID` and `VALIDATE_SUBSCRIPTION_IDS` remain separate settings. The tools workflow enables both Azure CLI and PowerShell login contexts and explicitly supplies the pool to workflow selection, then passes the selected `SubscriptionId` and `TenantId` to native execution. `UseCiInputs` does not read the plural pool implicitly. The selected client, tenant and subscription remain consistent through deployment, retries and final cleanup.

The current GitHub subject configuration in both repositories uses exactly `repository_owner_id`, `repository_id` and `context`. For deployment jobs, the context is `environment:avm-validation`. Stable federation source is owned by the tools repository and matches the registry owner, repository and environment. A Tools-repository credential cannot substitute for a registry caller because its repository ID differs.

Neither `workflow_ref` nor `job_workflow_ref` is included in the current subject. The immutable tools SHA pins executable code; it is not part of federation and does not require credential restaging when it changes. Workflow-reference restrictions are deferred follow-up work, not a migration prerequisite. No pull-request-ref preview credential, subject-template change or new base-branch gate is introduced.

Generic deployment remains supported. Module/client selection is a workflow-code convention, **not a per-module federated security boundary**: approved generic code can select any identity in the mapping. No dispatcher or secret-auth exception list is introduced. The old shared Bicep identity is a deferred cleanup item; this change does not delete it, alter deployed permissions or apply federation.

The root [`.required-features.json`](../../.required-features.json) and optional [`.required-resource-providers.json`](../../.required-resource-providers.json) remain caller-owned configuration. Native end-to-end execution reads them without a caller registration stage or manifest parser. Required features run before required providers, using the selected subscription and login tenant; either failure prevents deployment validation. Static checks, policy checks and discovery do not register providers.

Provider requirements use exact module paths and do not inherit a parent's entry for a child. Preserve the declared namespaces without inferring extra providers or expanding permissions. Registration persists beyond test cleanup; any live run that can register providers requires separate approval. The retained local deployment action keeps the same feature-before-provider order and its regression tests.

Packaged validation reads child-module publishing approvals from [`.avm/child-module-publish-allowed-list.json`](../../.avm/child-module-publish-allowed-list.json). Keep it identical to the legacy `utilities/pipelines/staticValidation/compliance/helper/child-module-publish-allowed-list.json` while local tools and current releases still consume that file. The caller tests enforce parity; this migration does not add or remove approvals.

## Reserved subscription compatibility

The caller-owned [`.reserved-test-subscriptions.json`](../../.reserved-test-subscriptions.json) maps exact module paths to case-sensitive subscription tags. Unmapped paths use `General`; reservations do not inherit from a parent path. This differs from identity selection, where descendants use their canonical module root's identity. Generic module selection must resolve its canonical root before consulting the reservation map.

Subscription pool records contain only `id`, `name` and optional `tag`. An omitted tag means `General`. Selection rejects invalid or duplicate IDs and malformed tags, filters by the module's required tag, and preserves the original pool index and subscription digest. Reserved modules cannot fall back to a legacy singleton or borrow a `General` subscription. Ordinary modules must not consume a reserved subscription. Policy token selection must apply the same reservation rules without authenticating or registering providers.

Azure Local consumers retain a separate environment lock, `avm-hci-<subscription digest>`, outside the module/subscription deployment lock; neither lock permits cancellation of an active deployment. Dedicated manual preparation, ordinary test consumption and reserved history maintenance share that environment lock. A consumer requires cleanup and an already prepared environment; it must not start preparation as a fallback.

The shared lifecycle supplies runner-local `parameterOverrides` and `protectedResourceIds` through the neutral deployment-data contract. Overrides use the existing ARM parameter conversions and take precedence over CI inputs. Protected IDs apply to intermediate retry cleanup and final teardown. Opt-in complete final cleanup requires authoritative attempt, remaining-deployment, preflight-rejection and pending-deletion tracking; only confirmed teardown can release the prepared environment. Successful terminal roots are eligible for final teardown, not failed-attempt retry relocation. Ordinary best-effort cleanup must not claim complete confirmation.

The seven currently reserved module-specific callers retain their main-branch local initializer actions and `avm.template.module.yml` entry point. Generic selection partitions the selected matrix using the existing reservation resolver: exact `General` entries use shared workflows, and every other tag uses local preview or manual-validation workflows. The original full matrix remains available for secret-free fork validation and publish-only operation. Partitioning does not change dispatch defaults, overrides, release approvals or pull-request opt-ins.

Both local deployment branches invoke the pinned `bicep-module-identity` action before authentication. This includes non-General tags other than `Azure Local`, which use the ordinary local deployment job rather than the prepared-environment consumer. Every reachable local route must use validated mapping outputs or fail before login. The legacy-named internal `VALIDATE_CLIENT_ID` environment slot receives only the selected action output; it is not read from legacy configuration. Initial login, renewal, retries, cleanup and fixture release retain the selected client, tenant and locked subscription.

Dedicated Azure Local preparation resolves the existing `avm/res/azure-stack-hci/logical-network` selector; reserved history maintenance resolves the existing `avm/res/azure-stack-hci/cluster` selector. Preparation binds later stages to the initial identity digest and fails before authentication if that binding changes or is unavailable. These are authentication-only adaptations: preparation, ownership, operation recovery, cleanup and release logic remain local and unchanged. Unrelated ordinary and management-group history maintenance remain outside the module-routing migration.

Retaining these workflows is not evidence that the shared native route supports prepared-environment execution. The identity action uses pinned orchestration support without a native package dependency; it does not install a release or apply credentials. Passing source tests does not establish identity permissions, a compatible package release, effective runtime configuration or live environment readiness. Verify these separately before cutover.

## Retained compatibility entry points

The following consumers prevent wholesale removal of registry utilities:

| Entry point                                                | Remaining consumers                                                                                                                     |
| ---------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| `avm.template.module*.yml` local workflows                 | Reserved module-specific and generic validation, plus deployment/publication regression coverage; retirement still requires qualified replacements. |
| `avm.template.hci*.yml` and Azure Local lifecycle helpers   | Reserved test consumers, dedicated manual preparation and coordinated history maintenance; preserve lifecycle and lock semantics.       |
| `avm-getWorkflowInput` local action                        | Reserved module-specific callers, `platform.check.psrule.yml`, `platform.ci-tests.yml`, `platform.deployment.history.cleanup.yml`, `platform.rerun-failed-workflows.yml`. |
| `avm-setEnvironment` local action                          | `platform.check.psrule.yml`, `platform.ci-tests.yml`, `platform.deployment.history.cleanup.yml`, `copilot-setup-steps.yml`.             |
| `utilities/pipelines/staticValidation`                     | Local module validation, the standalone metadata gate, platform PSRule checks and their regression tests.                               |
| `utilities/pipelines/sharedScripts`                        | Module generation, metadata module selection, platform setup and local tools.                                                           |
| `utilities/pipelines/e2eValidation` and publishing helpers | Supported local script entry points and their regression tests.                                                                         |
| `docs/templates/avm-readme-v1.scriban`                     | The explicit `documentation.template` override in root `bicepconfig.json`, used by tooling that reads this documentation configuration. |

Retire these only after their consumers use qualified packaged APIs and equivalent regression coverage is available. Moving the module workflow callers does not by itself complete that retirement.

Recheck the retirement map after merging newer registry changes. Current deployment cleanup, regional retry, preflight, provider registration, package recovery and response-contract tests stay with their supported local entry points until published replacements are qualified. Reservation selection, policy tokens, neutral deployment data and cleanup confirmation are shared contracts even when their consumers are Azure Local workflows. Host provisioning and image-builder implementation remain outside this workflow migration; no image build or live preparation is required for caller qualification.

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

The initializer retains its original selection outputs and adds disjoint shared/local matrices with explicit nonempty flags. Separate jobs consume those matrices without referencing a matrix value in a job-level condition. Mixed requests run each selected module once; an empty selection stays empty, and malformed selection or reservation data cannot silently fall back to shared execution.

Pull-request checks require `PR: Run Checks`. Deployment validation additionally requires `PR: Run E2E Tests` and an internal branch. Fork contributions use only the secret-free static workflow.

Generic selection checks out `github.sha` and passes it as `targetCommit`, with `pullRequestHeadCommit` from the event's head SHA. For a pull request, tools must require an exact two-parent tested merge whose second parent matches that head, then compare against its first parent. The event's mutable base SHA is not used. Missing or invalid history must fail before matrix outputs, without falling back to all modules.

Pushes pass `github.event.before` as `baseCommit`; an unavailable push base retains the all-module preview fallback with deployment disabled. Manual selection does not inspect pull-request history. Caller tests enforce these input bindings; the tools repository's `tests/Pester/Component/BicepWorkflowMatrix.Component.Tests.ps1` covers real-Git selection and whole-action failures in place of the former inline matrix tests. Local module-selection helpers and their tests remain supported. This does not change labels, internal-fork handling or branch gates.

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

The entry workflow references these separate tools workflows to preserve the existing permission boundaries:

| Workflow                        | Used for                                             | Repository permissions                                   |
| ------------------------------- | ---------------------------------------------------- | -------------------------------------------------------- |
| `bicep-module-preview.yml`      | Automatic validation and release-tag preview.        | Read, plus OIDC for deployment validation.               |
| `bicep-module-static.yml`       | Static validation for fork contributions.            | Read only; no secrets or OIDC.                           |
| `bicep-module-publish.yml`      | Manual validation followed by approved tag creation. | Read and OIDC for validation; write only for publishing. |
| `bicep-module-publish-only.yml` | Approved tag creation without validation.            | Write only; no OIDC or deployment access.                |

These workflows are intentionally separate because GitHub validates permissions for every job in a reusable workflow, including jobs that would be skipped.

General module-specific callers reference `bicep-module.yml`; reserved callers retain `avm.template.module.yml`. Both preserve existing dispatch defaults, upstream/manual guards and main-only push filters. The SQL instance-pool cleanup default and the current FinOps hub location input are preserved.
