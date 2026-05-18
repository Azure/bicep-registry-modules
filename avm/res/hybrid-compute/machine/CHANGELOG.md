# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/hybrid-compute/machine/CHANGELOG.md).

## 0.5.1

### Changes

- Publishing child modules: `extension`

### Breaking Changes

- None

## 0.5.0

### Changes

- Upgraded `Microsoft.HybridCompute/machines` API version from `2024-07-10` to `2025-01-13`
- Upgraded `Microsoft.HybridCompute/machines/extensions` API version from `2024-07-10` to `2025-01-13`
- Upgraded `Microsoft.GuestConfiguration/guestConfigurationAssignments` API version from `2020-06-25` to `2024-04-05`
- Upgraded `Microsoft.HybridCompute/privateLinkScopes` (test dependency) from `2023-10-03-preview` to `2025-01-13`
- Updated `Microsoft.Resources/deployments` API version from `2023-07-01` to `2024-03-01`
- No breaking changes — all new fields in newer APIs are optional

### Breaking Changes

- None

## 0.4.2

### Changes

- Added type for `tags` parameter
- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.

### Breaking Changes

- None

## 0.4.1

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
