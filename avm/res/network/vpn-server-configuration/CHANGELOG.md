# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/network/vpn-server-configuration/CHANGELOG.md).

## 0.2.0

### Changes

- Updated `Microsoft.Network/vpnServerConfigurations` API version from `2023-11-01` to `2025-05-01`
- Updated `Microsoft.Resources/deployments` (telemetry) API version from `2024-03-01` to `2025-04-01`
- Updated `Microsoft.Resources/resourceGroups` API version from `2021-04-01` to `2025-04-01` in test files
- Updated `Microsoft.Network/virtualWans` API version from `2023-04-01` to `2025-05-01` in test dependency files
- Added `radiusServersType` user-defined type for `radiusServers` parameter with `@secure()` decorator on `radiusServerSecret`
- Fixed `radiusServerScore` test values from string to integer to match the new typed parameter

### Breaking Changes

- None

## 0.1.2

### Changes

- Added type for `tags` parameter
- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.

### Breaking Changes

- None

## 0.1.1

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
