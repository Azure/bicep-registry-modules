# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/network/ip-group/CHANGELOG.md).

## 0.4.0

### Changes

- Updated `Microsoft.Network/ipGroups` API version from `2024-05-01` to `2025-05-01`
- Updated `avm-common-types` imports to `0.7.0`
- Updated `defaults` test to include at least one IP address

### Breaking Changes

- `ipAddresses` parameter changed from optional (default `[]`) to **required** with `@minLength(1)` due to `IPGroupsIPAddressCountZero` error on certain Azure regions.

## 0.3.1

### Changes

- Added type for `tags` parameter
- Updated LockType to 'avm-common-types version' `0.6.1`, enabling custom notes for locks.

### Breaking Changes

- None

## 0.3.0

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
