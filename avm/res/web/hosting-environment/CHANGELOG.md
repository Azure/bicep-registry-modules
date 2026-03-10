# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/web/hosting-environment/CHANGELOG.md).

## 0.5.0

### Changes

- Upgraded API version from `2023-12-01` to `2025-03-01` for `Microsoft.Web/hostingEnvironments`
- Upgraded child module API versions from `2022-03-01`/`2023-12-01` to `2025-03-01` for `Microsoft.Web/hostingEnvironments/configurations`
- Upgraded AVM common type imports (`managedIdentityAllType`, `diagnosticSettingLogsOnlyType`) from `0.4.1` to `0.6.1`
- Converted `internalLoadBalancingMode` parameter to use resource-derived type
- Converted `upgradePreference` parameter to use resource-derived type
- Converted `networkConfiguration` parameter to use resource-derived type
- Updated `tags` and `clusterSettings` RDT references to `2025-03-01`
- Added new parameter `ipsslAddressCount` for IP SSL address reservation
- Added new parameter `multiSize` for front-end VM size configuration
- Added `location` output per AVM best practices

### Breaking Changes

- Parameters `internalLoadBalancingMode`, `upgradePreference`, and `networkConfiguration` now use resource-derived types instead of `@allowed` annotations or `object?`

## 0.4.1

### Changes

- Updated LockType to 'avm-common-types version' `0.6.1`, enabling custom notes for locks.
- Added type for `tags` & `clusterSettings` parameters

### Breaking Changes

- None

## 0.4.0

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
