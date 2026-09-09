# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/recovery-services/vault/backup-config/CHANGELOG.md).

## 0.1.2

### Changes

- Added `'Invalid'` to the allowed values for `enhancedSecurityState` to align with the `Microsoft.RecoveryServices/vaults/backupconfig` API. [#7289](https://github.com/Azure/bicep-registry-modules/issues/7289)
- The soft delete related properties (`enhancedSecurityState`, `softDeleteFeatureState`, `isSoftDeleteFeatureStateEditable` and `softDeleteRetentionPeriodInDays`) are now only sent to the API if a value is provided, instead of being sent as `null`. [#7289](https://github.com/Azure/bicep-registry-modules/issues/7289)
- Changed the `isSoftDeleteFeatureStateEditable` parameter from `bool` (default `true`) to nullable `bool?`. If the parameter is not provided, the property is no longer sent to the API and the service-side value is left untouched. [#7289](https://github.com/Azure/bicep-registry-modules/issues/7289)

### Breaking Changes

- None

## 0.1.1

### Changes

- Added `'Invalid'` to the allowed values for `softDeleteFeatureState` in `backup-config`
- Added new optional parameter `softDeleteRetentionPeriodInDays` to `backup-config`

### Breaking Changes

- None

## 0.1.0

### Changes

- Initial version

### Breaking Changes

- None
