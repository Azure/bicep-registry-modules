# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/recovery-services/vault/CHANGELOG.md).

## 0.12.0

### Changes

- Updated `backup-config` child module API version from `2023-01-01` to `2026-01-01`
- Added `'AlwaysON'` and `'Invalid'` to the allowed values for `softDeleteFeatureState` in `backup-config`
- Added new optional parameter `softDeleteRetentionPeriodInDays` to `backup-config`

### Breaking Changes

- None

## 0.11.1

### Changes

- Fixed typo in the CMK interface when retrieving the latest keyUri version with auto-rotation enabled

### Breaking Changes

- None

## 0.11.0

### Changes

- Added support for managed HSM customer-managed key encryption
- Updated all 'avm-common-types' references to version `0.6.1`
- Updated `avm/res/network/private-endpoint` cross-referenced module to version `0.11.1`

### Breaking Changes

- None

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
