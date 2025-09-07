# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/compute/virtual-machine/CHANGELOG.md).

## 0.19.0

### Changes

- Adjusted the usage of the `ecryptionAtHost` property to only pass it to the resource provider if enabled

### Breaking Changes

- Changing default value of `encryptionAtHost` from `true` to `false` to improve usability for subscription where the feature is or cannot be enabled

## 0.18.0

### Changes

- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.
- Added type to `tags` parameter
- Changed default of `licenseType` parameter to nullable

### Breaking Changes

- Renamed parameter `dedicatedHostId` to `dedicatedHostResourceId`

## 0.17.0

### Changes

- The `capacityReservationGroupId, extensionGuestConfigurationExtension, networkAccessPolicy (disk), publicNetworkAccess (disk)` parameters were added.
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None

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
