# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/compute/virtual-machine-scale-set/CHANGELOG.md).

## 0.9.1

### Changes

- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.

### Breaking Changes

- None

## 0.9.0

### Changes

- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- Changed type of `availabilityZones` parameter from `array` to `int[]`, i.e., zones must be provided as integers, not strings
- Added allowed set [1,2,3] to availabilityZones parameter.

## 0.8.1

### Changes

- Initial version

### Breaking Changes

- None
