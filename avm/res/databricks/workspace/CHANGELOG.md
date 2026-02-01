# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/databricks/workspace/CHANGELOG.md).

## 0.12.0

### Changes

- Adding support for managed HSM customer-managed key encryption
- Added the output `managedDiskIdentityPrincipalId` which is available if CMK for the managed disk is configured
- Updated all 'avm-common-types' references to version `0.6.1`

### Breaking Changes

- None

## 0.11.5

### Changes

- Fixed an issue where having separate keys for encryption & disk-encryption in the same vault would not work as expected.

### Breaking Changes

- None

## 0.11.4

### Changes

- Updated `privateEndpoints` parameter type to 'avm-common-types' `0.6.1`, adding a type to its `tags` property

### Breaking Changes

- None

## 0.11.3

### Changes

- Updated LockType to 'avm-common-types` version `0.6.0`, enabling custom notes for locks.
- Added type to `locks` parameter
- Updated `avm-common-types`

### Breaking Changes

- None

## 0.11.2

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
