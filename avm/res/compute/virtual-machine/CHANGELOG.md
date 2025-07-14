# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/compute/virtual-machine/CHANGELOG.md).

## 0.16.0

### Changes

- None

### Breaking Changes

- Renamed `zone` parameter to `availabilityZone`
- Changed 'availabilityZone' allowed set from [0,1,2,3] to [-1,1,2,3]. -1 works in the same way as the previous 0 to specify that no zone is to be set

## 0.15.1

### Changes

- Break fix issue where the `resourceId` is incorrect when the recovery services vault is in another resource group.

### Breaking Changes

- None

## 0.15.0

### Changes

- Initial version

### Breaking Changes

- None
