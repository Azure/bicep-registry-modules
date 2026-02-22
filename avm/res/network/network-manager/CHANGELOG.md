# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/network/network-manager/CHANGELOG.md).

## 0.6.0

### Changes

- Bumped API version from `2024-05-01` to `2025-05-01`
- Added `connectivityCapabilities` property to connectivity configurations
- Added `routeTableUsageMode` property to routing configurations, defaults to `ManagedOnly` per the template reference
- Added `memberType` property to network groups, enabling subnet-level group membership
- Consolidated `avm-common-types` imports to version `0.6.1`

### Breaking Changes

- None

## 0.5.3

### Changes

- Added type for `tags` parameter
- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.

### Breaking Changes

- None

## 0.5.2

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
