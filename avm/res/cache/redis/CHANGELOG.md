# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/cache/redis/CHANGELOG.md).

## 0.16.4

### Changes

- Fixed an incorrect parameter description
- Added types for the `geoReplicationObject` & `firewallRules` parameters
- Updated the references to the 'avm-common-types' module to it's latest version `0.6.1`

### Breaking Changes

- None

## 0.16.3

### Changes

- Updated `privateEndpoints` parameter type to 'avm-common-types' `0.6.1`, adding a type to its `tags` property

### Breaking Changes

- None

## 0.16.2

### Changes

- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.
- Added type for `tags` parameter
- Removed empty allowed value from `publicNetworkAccess` parameter in favor of nullable

### Breaking Changes

- None

## 0.16.0

### Changes

- Added allowed set `[1,2,3]` to `availabilityZones` parameter.
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- Renamed `zones` parameter to `availabilityZones`

## 0.15.0

### Changes

- Initial version

### Breaking Changes

- None
