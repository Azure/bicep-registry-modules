# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/recovery-services/vault/CHANGELOG.md).

## 0.10.1

### Changes

- Updated `privateEndpoints` parameter type to 'avm-common-types' `0.6.1`, adding a type to its `tags` property

### Breaking Changes

- None

## 0.10.0

### Changes

- Introduced a type for the `tags` parameter
- Updated `avm-common-types` which in turn allows the specification of 'Notes' on locks
- Addressed diverse warnings
- Added discriminated type for `redundancySettings` to mimic Portal behavior. `crossRegionRestore` is only available if `standardTierStorageRedundancy` is set to 'GeoRedundant'.
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- Deprecated `backupStorageConfig` parameter in favor of `redundancySettings` only.
  Background: If the `redundancySettings` parameter is not provided to the Resource Provider it automatically configures Geo-Redundant-Storage which conflicts with the `backupStorageConfig` configuration (- API mismatch)

## 0.9.2

### Changes

- Fix bug where API versions are not matched.

### Breaking Changes

- None

## 0.9.1

### Changes

- Initial version

### Breaking Changes

- None
