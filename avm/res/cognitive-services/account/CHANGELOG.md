# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/cognitive-services/account/CHANGELOG.md).

## 0.15.0

### Changes

- Added a user-defined type `networkAclsType` for the `networkAcls` parameter, exposing the previously hidden `bypass` property (allowed values: `AzureServices`, `None`). This resolves [#5893](https://github.com/Azure/bicep-registry-modules/issues/5893) and allows callers to set `bypass` to `None` as recommended when using private endpoints.

### Breaking Changes

- None. The `networkAcls` parameter remains optional and the new `bypass` property defaults to the Azure Resource Provider behavior (`AzureServices`) when not specified, preserving the prior behavior.

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
