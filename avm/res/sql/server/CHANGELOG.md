# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/sql/server/CHANGELOG.md).

## 0.21.1

### Changes

- Fixed typo in HSM CMK schema implementation

### Breaking Changes

- None

## 0.21.0

### Changes

- Added support for managed HSM customer-managed key encryption for both server and database
- Updated all 'avm-common-types' references to version `0.6.1`
- Updated `avm/res/network/private-endpoint` cross-referenced module to version `0.11.1`

### Breaking Changes

- None

## 0.20.3

### Changes

- Enabling child module `avm/res/sql/server/database` for publishing (added telemetry option)

### Breaking Changes

- None

## 0.20.2

### Changes

- Updated `privateEndpoints` parameter type to 'avm-common-types' `0.6.1`, adding a type to its `tags` property

### Breaking Changes

- None

## 0.20.1

### Changes

- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.

### Breaking Changes

- None

## 0.20.0

### Changes

- `tags` parameters are now properly typed instead of using `object` type.
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- Renamed `partnerServers` array to `partnerServerResourceIds` in the failover group module to make it possible to use SQL servers from different resource groups.

## 0.19.1

### Changes

- Initial version

### Breaking Changes

- None
