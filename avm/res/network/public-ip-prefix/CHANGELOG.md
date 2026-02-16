# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/network/public-ip-prefix/CHANGELOG.md).

## 0.8.0

### Changes

- Removed hardcoded `Standard` SKU value and added `skuName` parameter to support configurable SKU selection.
- Added support for `StandardV2` SKU.

### Breaking Changes

- None

## 0.7.2

### Changes

- Update API version to `2025-01-01`.
- Updated `avm-common-types` reference to version `0.6.1`.

### Breaking Changes

- None

## 0.7.1

### Changes

- Updated type for `tags` & `customIPPrefix` parameters
- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.

### Breaking Changes

- None

## 0.7.0

### Changes

- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- Renamed `zones` parameter to `availabilityZones`

## 0.6.0

### Changes

- Initial version

### Breaking Changes

- None
