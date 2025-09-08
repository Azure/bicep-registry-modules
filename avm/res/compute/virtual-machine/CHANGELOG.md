# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/compute/virtual-machine/CHANGELOG.md).

## 0.19.0

### Changes

- Introduced user-defined type for `extensionCustomScriptConfig` parameter that is aligned with its [official documentation](https://learn.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-windows).

### Breaking Changes

- Merged `extensionCustomScriptProtectedSetting` parameter into `extensionCustomScriptConfig`
- Removed support for the CustomScriptExtension extension to automatically append SAS-Keys to file specified via the `extensionCustomScriptConfig.fileData` property. Instead, the SAS token must either be pre-provided with the URL, or either the settings `extensionCustomScriptConfig.protectedSettings.storageAccountKey` & `extensionCustomScriptConfig.protectedSettings.storageAccountName` or (recommended) `extensionCustomScriptConfig.protectedSettings.managedIdentityResourceId`. For the latter, you can provide either the full resource ID - or set it to `''` if you want it to use the VM's system-assigned identity (if enabled) instead. Note, in either case, the Identity must be granted access to correct Storage Account scope.

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
