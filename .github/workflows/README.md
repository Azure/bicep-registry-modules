# Module Check and Publish Workflow

The `.Module - Check and Publish` workflow provides a generic way to validate and publish one or more AVM modules. It is implemented by [`avm.module.yml`](./avm.module.yml).

## Automatic checks

Pushes to `main` that change files under `avm/`, excluding module `README.md` files, automatically:

1. Discover the affected top-level modules.
1. Run static, PSRule, and deployment validation.
1. Calculate and log the release tags that would be created.

Automatic runs cannot create tags. The preview path has read-only repository permissions and invokes the release logic with `WhatIf`.

The generic workflow runs alongside the existing module-specific workflows during its initial validation period. Generic deployments use the `gci` name prefix, process one module at a time, and use concurrency groups that are isolated from existing workflows.

## Manual runs

Use **Actions** > **.Module - Check and Publish** > **Run workflow**.

`modulePaths` accepts one module path or a comma-separated list:

```text
avm/res/storage/storage-account
```

```text
avm/res/storage/storage-account, avm/res/network/virtual-network
```

Child module paths are accepted but resolve to their top-level module workflow.

| Input | Default | Purpose |
| --- | --- | --- |
| `modulePaths` | Required | One module path or comma-separated module paths. |
| `staticValidation` | `true` | Run static and PSRule validation. |
| `deploymentValidation` | `true` | Run deployment validation. |
| `removeDeployment` | `true` | Remove resources created by deployment validation. |
| `customLocation` | Empty | Override the default deployment location. |
| `createReleaseTag` | `false` | Approve and create the next top-level module release tag, including when no publishable diff exists. |
| `publishOnly` | `false` | Skip validation and only create the release tag. Requires `createReleaseTag`. |

Selecting `createReleaseTag` requires approval through the `publish-approval` environment. Without it, a manual run performs validation only.

## Reusable workflows

The entry workflow uses separate reusable workflows to enforce distinct permission boundaries:

| Workflow | Used for | Repository permissions |
| --- | --- | --- |
| [`avm.template.module.preview.yml`](./avm.template.module.preview.yml) | Automatic validation and release-tag preview. | Read, plus OIDC for deployment validation. |
| [`avm.template.module.publish.yml`](./avm.template.module.publish.yml) | Manual validation followed by approved tag creation. | Read and OIDC for validation; write only for publishing. |
| [`avm.template.module.publish-only.yml`](./avm.template.module.publish-only.yml) | Approved tag creation without validation. | Write only; no OIDC or deployment access. |

These workflows are intentionally separate because GitHub validates permissions for every job in a reusable workflow, including jobs that would be skipped.

The existing [`avm.template.module.yml`](./avm.template.module.yml) remains unchanged and continues to support the module-specific workflows.
