# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/search/search-service/CHANGELOG.md).

## 0.12.0

### Changes

- Added `computeType` parameter allowing to configure Azure Confidential Compute for the search service.
- Added `dataExfiltrationProtections` parameter.
- Updated search service API version from `2025-02-01-preview` to `2025-05-01`
- Updated all `avm-common-types` imports to version `0.6.1`
- Updated `hostingMode` parameter values from lowercase ('default', 'highDensity') to PascalCase ('Default', 'HighDensity') following the API specification.
- Updated private endpoint module reference from version `0.11.0` to `0.11.1`

### Breaking Changes

- The `hostingMode` parameter now uses PascalCase values ('Default', 'HighDensity') instead of lowercase ('default', 'highDensity').
- Replaced user-defined types `authOptionsType` and `networkRuleSetType` with resource input types from the search service API version `2025-05-01`.

## 0.11.1

### Changes

- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.
- Updated `privateEndpoints` parameter type to 'avm-common-types' `0.6.1`, adding a type to its `tags` property

### Breaking Changes

- None

## 0.11.0

### Changes

- Added secure outputs of the module's main resource's secrets formerly only exported to a key vault via the `secretsExportConfiguration` parameter
- Added the output `privateEndpoints` alongside its type to allow the output's discovery
- Bugfix: Added the missing pass-thru of the `privateEndpoints` parameter's property `resourceGroupResourceId` which allows to optionally deploy a private endpoint into a different resource group in the same or different subscription
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- Introduced a type for the parameter `tags`

## 0.10.0

### Changes

- Initial version

### Breaking Changes

- None
