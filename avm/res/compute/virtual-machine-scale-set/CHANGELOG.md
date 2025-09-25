# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/compute/virtual-machine-scale-set/CHANGELOG.md).

## 0.11.0

### Changes

- Introduced user-defined type for `extensionCustomScriptConfig` parameter that is aligned with its [official documentation](https://learn.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-windows).
- Added parameters `provisionAfterExtensions` & `provisionAfterExtensions`  to 'extension' child module.
- Added types for parameters `osDisk`, `dataDisks`, `nicConfigurations`, `extensionHealthConfig`, `winRM` & `publicKeys`
- Fixed incorrect default value of `extensionHealthConfig` parameter
- Added optional `name` property to `nicConfigurations` parameter
- Added `provisionAfterExtensions` property support to all extensions

### Breaking Changes

- Merged `extensionCustomScriptProtectedSetting` parameter into `extensionCustomScriptConfig`
- Removed support for the CustomScriptExtension extension to automatically append SAS-Keys to file specified via the `extensionCustomScriptConfig.fileData` property. Instead, the SAS token must either be pre-provided with the URL, or either the settings `extensionCustomScriptConfig.protectedSettings.storageAccountKey` & `extensionCustomScriptConfig.protectedSettings.storageAccountName` or (recommended) `extensionCustomScriptConfig.protectedSettings.managedIdentityResourceId`. For the latter, you can provide either the full resource ID - or set it to `''` if you want it to use the VM's system-assigned identity (if enabled) instead. Note, in either case, the Identity must be granted access to correct Storage Account scope.
- The updated `osDisk` parameter requires an integer for its `diskSizeGB` property
- The updated `dataDisks` parameter requires an integer for its `diskSizeGB` property & the `lun` property (which specifies the logical unit number of the data disk. Can be an incremental number)

## 0.10.0

### Changes

- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.
- Added type to `tags`, `additionalUnattendContent`, `secrets`, `scheduledEventsProfile`, `scaleInPolicy` & `plan` parameters
- Changed diverse parameter defaults to nullable
- Addressed diverse warnings

### Breaking Changes

- Removed `''`  from allowed set of `licenseType` parameter in favor of nullable

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
