# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/network/public-ip-address/CHANGELOG.md).

## 0.12.0

### Changes

- Switched parameters `publicIPAllocationMethod`, `publicIPAddressVersion`, `skuName`, `skuTier`, and `deleteOption` to use resource input types from `Microsoft.Network/publicIPAddresses@2025-01-01` for consistency with the RP schema and built-in validation. This adds support for the `StandardV2` SKU.

### Breaking Changes

- Parameter types for `publicIPAllocationMethod`, `publicIPAddressVersion`, `skuName`, `skuTier`, and `deleteOption` now use resource input types instead of string literals.

## 0.11.0

### Changes

- Replaced custom types for `ipTags`, `dnsSettings` and `ddosSettings` with direct references to the resource input types from the `Microsoft.Network/publicIPAddresses@2025-01-01` API version.

### Breaking Changes

- Parameters `ipTags`, `dnsSettings`, and `ddosSettings` now use resource input types from the `Microsoft.Network/publicIPAddresses@2025-01-01` API version instead of custom-defined types.

## 0.10.0

### Changes

- Update API version to `2025-01-01`.
- Added parameter `deleteOption` to specify the delete behavior of the Public IP Address when the associated resource is deleted.
- Updated `avm-common-types` reference to version `0.6.1`.

### Breaking Changes

- None

## 0.9.1

### Changes

- Added type for `tags` parameter
- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.

### Breaking Changes

- None

## 0.9.0

### Changes

- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- Renamed parameter `zones` to `availabilityZones`

## 0.8.0

### Changes

- Initial version

### Breaking Changes

- None
