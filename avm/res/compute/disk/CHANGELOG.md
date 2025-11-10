# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/compute/disk/CHANGELOG.md).

## 0.6.0

### Changes

- Added support for encryption-at-rest via existing Disk Encryption Set.
- Updated all 'avm-common-types' references to version `0.6.1`

### Breaking Changes

- None

## 0.5.1

### Changes

- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.
- Added type for `tags` parameter
- Changed diverse parameter defaults from empty to null

### Breaking Changes

- None

## 0.5.0

### Changes

- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- Changed `availabilityZones` allowed set from `[0,1,2,3]` to `[-1,1,2,3]`. `-1` works in the same way as the previous `0` to specify that no zone is to be set

## 0.4.3

### Changes

- Initial version

### Breaking Changes

- None
