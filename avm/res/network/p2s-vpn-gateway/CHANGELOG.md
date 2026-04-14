# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/network/p2s-vpn-gateway/CHANGELOG.md).

## 0.1.4

### Changes

- Updated all API versions from `2024-10-01` to `2025-05-01` in the module and associated tests.
- Added support for `configurationPolicyGroupAssociationResourceIds` parameter.
- Added support for `ipamPoolPrefixAllocations` parameter.
- Added `ipamPoolPrefixAllocationType` user-defined type.

### Breaking Changes

- None

## 0.1.3

### Changes

- Added type for `tags` parameter
- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.
- Removed Virtual WAN Route Map from 'max' test, was not necessary for module testing.
- Updated all API versions in the module and associated tests.

### Breaking Changes

- None

## 0.1.2

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
