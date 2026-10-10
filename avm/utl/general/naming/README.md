# Resource naming `[General/Naming]`

Pure naming functions using the modern [Terraform naming utility](https://github.com/Azure/terraform-azure-avm-utl-naming) catalog. No resources, telemetry, randomness or name-availability checks are performed.

Import `getName`, `getNames` or `getNamesByResourceType` and pass an options object. Use a nonempty `uniqueSeed` for Terraform-compatible exact tokens, `uniqueLength: 0` for no token, or `uniqueIdentity` with optional `uniqueScope` and `uniqueAttempt` for Bicep-derived tokens. Reuse every input and pin the module version for in-place redeployment; change caller-owned identity for a fresh name. Derived tokens use the full, untruncated logical name and are limited to 13 characters. They are not Terraform random seeds. Hashes can collide; length and name availability remain the caller's responsibility.

Default rendering, prefixes/suffixes, casing, slugs, numbered instances, fixed names and property-level catalog overrides follow Terraform for ASCII inputs. Character counting and Unicode casing use native ARM semantics, which differ from Terraform's Unicode handling. Customer files are loaded by the caller with `loadJsonContent` and passed as `customOverrides`; schema_version and snake-case catalog properties stay unchanged. Omitted properties inherit; explicit values replace, including arrays and whole metadata objects.

Templates support `${token}`, `${lower(token)}`, `${upper(token)}`, joining prefix/suffix lists, and `join(separator, [token, ...])` with optional `compact`. Custom token names must be distinct ignoring case; names that collide with built-in tokens are rejected. Arbitrary HCL expressions, directives, indexing, nested function expressions and the frozen Terraform legacy renderer are not supported. Unsupported syntax returns errors and null names. Instance formats support a single `%d` or `%0Nd` with optional literal text, not arbitrary Terraform format expressions.

UUID entries use native Bicep `guid`, whose namespace differs from Terraform `uuidv5("url", ...)`; UUID values are therefore deliberately not cross-language identical. Literal names cannot retain instance or uniqueness tokens. Always inspect the retention flags before relying on them.

`nameAvailable` means rendering succeeded, not that Azure accepts or has the name available. Validation returns null, never true, when catalog constraints or native regex support are incomplete. Supported anchored ASCII character-class patterns and literals are compiled into validation descriptors without editing the upstream rules; other RE2 patterns (including Unicode classes and new customer patterns) remain explicitly unvalidated. `requireValidNames` rejects both invalid and incompletely validated candidates.

Upstream snapshots under `upstream` are byte-identical at the revision in `catalog-source.json`. Run `. .\utilities\tools\Sync-NamingCatalog.ps1; Sync-NamingCatalog -Check` from the repository root to verify hashes and lossless chunk recomposition. The downstream synchronization workflow proposes changes for review and never scrapes Azure rules or merges updates.

This module is under development at the proposed path in [Azure/Azure-Verified-Modules#3059](https://github.com/Azure/Azure-Verified-Modules/issues/3059); proposal filing does not establish program approval.


You can reference the module as follows:
```bicep
import { getCatalog, getName, getNames, getNamesByResourceType } from 'br/public:avm/utl/general/naming:<version>'
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Exported functions](#Exported-functions)
- [Outputs](#Outputs)

## Resource Types

_None_

## Usage examples

The following examples show how to import and use this resource-free function library. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/utl/general/naming:<version>`.

- [Exact tokens and numbered instances](#example-1-exact-tokens-and-numbered-instances)
- [Caller-owned deployment identity](#example-2-caller-owned-deployment-identity)

### Example 1: _Exact tokens and numbered instances_

Import naming functions without deploying a module. An exact seed follows Terraform naming behavior; instance and uniqueness tokens survive truncation.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/defaults]

> **Note**: This test is skipped from the CI deployment validation due to the presence of a `.e2eignore` file in the test folder. The reason for skipping the deployment is:
```text
This export-only utility creates no resources. Native Bicep evaluation and import tests run offline.
```

<details>

<summary>via Bicep import</summary>

```bicep
metadata name = 'Exact tokens and numbered instances'
metadata description = 'Import naming functions without deploying a module. An exact seed follows Terraform naming behavior; instance and uniqueness tokens survive truncation.'

import { getName } from 'br/public:avm/utl/general/naming:<version>'

@description('Required. Caller-owned uniqueness seed, reused for an in-place redeployment.')
param uniqueSeed string = 'a1b2c3d4'

var storage = getName('storage_account', {
  suffix: ['workload', 'dev']
  uniqueSeed: uniqueSeed
  instance: 1
  requireValidNames: true
})

@description('The candidate name and its diagnostics. A null name must not be used for a resource.')
output storageName object = storage
```

</details>
<p>

### Example 2: _Caller-owned deployment identity_

Reuse identity and scope for in-place retries. Change freshAttempt deliberately for a separate deployment. No state or randomness is created by this utility.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/waf-aligned]

> **Note**: This test is skipped from the CI deployment validation due to the presence of a `.e2eignore` file in the test folder. The reason for skipping the deployment is:
```text
This export-only utility creates no resources. Native Bicep evaluation and import tests run offline.
```

<details>

<summary>via Bicep import</summary>

```bicep
metadata name = 'Caller-owned deployment identity'
metadata description = 'Reuse identity and scope for in-place retries. Change freshAttempt deliberately for a separate deployment. No state or randomness is created by this utility.'

import { getName } from 'br/public:avm/utl/general/naming:<version>'

@description('Required. Stable caller-owned identity for this logical deployment.')
param namingIdentity string = 'local-development-001'

@description('Required. Caller-owned scope that separates otherwise identical deployments.')
param namingScope string = 'subscription-001'

@description('Optional. Change deliberately to produce a fresh name; reuse during in-place retries.')
param freshAttempt string = ''

var storage = getName('storage_account', {
  suffix: ['workload', 'dev']
  uniqueIdentity: namingIdentity
  uniqueScope: namingScope
  uniqueAttempt: freshAttempt
  uniqueLength: 13
  requireValidNames: true
})

@description('The candidate name and its diagnostics. Name availability in Azure is not checked.')
output storageName object = storage
```

</details>
<p>

## Parameters

_None_

## Exported functions

| Function | Description |
| :-- | :-- |
| `getCatalog` | Inspect the raw catalog after a version-2 customer overlay, including invalid or incomplete entries. Uses whole-property replacement; getName performs rendering validation. |
| `getName` | Render one catalog key. Inspect nameErrors/nameUniqueErrors, validation and token-retention flags; no Azure availability check is made. |
| `getNames` | Render a selected list of catalog keys independently. Prefer a small selection to avoid copying unnecessary results into consumer templates. |
| `getNamesByResourceType` | Render every matching catalog variant for an exact Azure resource type. Variants remain keyed separately; no arbitrary first-match selection is made. |

## Outputs

_None_
