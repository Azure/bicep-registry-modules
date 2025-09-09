# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/virtual-machine-images/image-template/CHANGELOG.md).

## 0.6.1

### Changes

- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.
- Minor change to metadata

### Breaking Changes

- None

## 0.6.0

### Changes

- Added types for object/array parameters
- Added exported user-defined type `vnetConfigType`
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- Refactored `subnetResourceId` parameter to `vnetConfig` resource ID which contains (in addition to other, new parameters) the original `subnetResourceId` parameter

## 0.5.2

### Changes

- Initial version

### Breaking Changes

- None
