# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/cognitive-services/account/CHANGELOG.md).

## 0.15.1

### Changes

- Fixed intermittent private endpoint deployment failures (`AccountProvisioningStateInvalid` - account in state `Accepted`) by making private endpoints depend on the account's model deployments and commitment plans, so they are only created once the account has returned to a `Succeeded` provisioning state (fixes [#5957](https://github.com/Azure/bicep-registry-modules/issues/5957))

### Breaking Changes

- None

## 0.15.0

### Changes

- Added `bypass` property to `networkAcls` so callers can allow trusted Microsoft services (`AzureServices`) through the Cognitive Services firewall (fixes [#7062](https://github.com/Azure/bicep-registry-modules/issues/7062))
- Replaced the untyped `networkAcls object?` parameter with the strongly-typed `networkAclsType` user-defined type, exposing `bypass`, `defaultAction`, `ipRules` and `virtualNetworkRules`
- Bumped the AVM telemetry deployment API version from `Microsoft.Resources/deployments@2024-03-01` to `@2025-04-01` to satisfy the `use-recent-api-versions` linter

### Breaking Changes

- The `networkAcls` parameter is now strongly typed via `networkAclsType`. Consumers passing properties outside of `bypass`, `defaultAction`, `ipRules` or `virtualNetworkRules` (which were previously silently dropped) will now receive a validation error.
## 0.14.3

### Changes

- Fixed invalid default `sku` for model deployments. The fallback previously used the account-level SKU name (e.g. `S0`), which is not a valid deployment SKU and caused `The deployment sku name 'S0' is invalid.` errors. The default is now `{ name: 'Standard', capacity: 1 }`.

### Breaking Changes

- None

## 0.14.2

### Changes

- Updated `model.version` in `deploymentType` to be a conditional parameter.

### Breaking Changes

- None

## 0.14.1

### Changes

- Added `primaryKey` and `primaryKey` outputs

### Breaking Changes

- None

## 0.14.0

### Changes

- Added support for managed HSM customer-managed key encryption
- Updated all 'avm-common-types' references to version `0.6.1`
- Updated `avm/res/network/private-endpoint` cross-referenced module to version `0.11.1`

### Breaking Changes

- None

## 0.13.2

### Changes

- Updated `privateEndpoints` parameter type to 'avm-common-types' `0.6.1`, adding a type to its `tags` property

### Breaking Changes

- None

## 0.13.1

### Changes

- Recompiled template with latest Bicep version 0.37.4

### Breaking Changes

- None

## 0.13.0

### Changes

- Added support for `networkInjections` to supply private networking options for agent services
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None

## 0.12.0

### Changes

- Added support for deploying commitment plans via the new `commitmentPlans` parameter, enabling Disconnected Container and other hosting models (e.g., NTTS, STT, CUSTOMSTT, ADDON).
- Introduced type commitmentPlanType to define plan configuration including autoRenew, hostingModel, and tiered instance count.
- Updated main.bicep to provision `Microsoft.CognitiveServices/accounts/commitmentPlans` resources under the account.
- Added support for the DC0 SKU, enabling Disconnected Container provisioning for Speech Services.
- Updated API versions

### Breaking Changes

- None

## 0.11.0

### Changes

- Initial version

### Breaking Changes

- None
