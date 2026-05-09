# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/network/private-link-service/CHANGELOG.md).

## 0.4.0

### Changes

- Updated `Microsoft.Network/privateLinkServices` API version from `2024-05-01` to `2025-05-01`
- Updated `avm-common-types` imports to `0.7.0`
- Updated telemetry deployment API version to `2025-04-01`
- Added `accessMode` parameter (`'Default' | 'Restricted'`)
- Added `destinationIPAddress` parameter
- Introduced strong user-defined types: `ipConfigurationType`, `loadBalancerFrontendIpConfigurationType`, `extendedLocationType`, `autoApprovalType`, `visibilityType` (all `@export()`-ed)
- Replaced untyped `array` / `object` parameters with the new typed shapes

### Breaking Changes

- `ipConfigurations[].properties.subnet.id` is now `ipConfigurations[].subnetResourceId`
- `loadBalancerFrontendIpConfigurations[].id` is now `loadBalancerFrontendIpConfigurations[].resourceId`

## 0.3.1

### Changes

- Added type for `tags` parameter
- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.

### Breaking Changes

- None

## 0.3.0

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
