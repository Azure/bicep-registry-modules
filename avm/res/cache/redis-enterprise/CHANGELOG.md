# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/cache/redis-enterprise/CHANGELOG.md).

## 0.5.0

### Changes

- Removed deprecated metadata
- Added `publicNetworkAccess` property (defaults to 'Disabled' if `privateEndpoints` is provided, otherwise defaults to 'Enabled')
- Added `@secure()` outputs for primary and secondary access keys and connection strings
- Updated Microsoft.Cache/redisEnterprise API version to 2025-07-01
- Removed preview status from `persistence` database param (now generally available)

### Breaking Changes

- Removed `secretsExportConfiguration` param and `exportedSecrets` output
    - Use the new `@secure()` outputs instead: `primaryAccessKey`, `secondaryAccessKey`, `primaryConnectionString`, `secondaryConnectionString`, etc.

## 0.4.0

### Changes

- Added managed HSM customer-managed key support
- Updated `avm/res/network/private-endpoint` cross-referenced module to version `0.11.1`
- Updated all 'avm-common-types' references to version `0.6.1`

### Breaking Changes

- None

## 0.3.3

### Changes

- Updated `privateEndpoints` parameter type to 'avm-common-types' `0.6.1`, adding a type to its `tags` property

### Breaking Changes

- None

## 0.3.1

### Changes

- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.
- Added type for `tags` parameter

### Breaking Changes

- None

## 0.3.0

### Changes

- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- Renamed `zones` parameter to `availabilityZones`

## 0.2.0

### Changes

- Initial version

### Breaking Changes

- None
