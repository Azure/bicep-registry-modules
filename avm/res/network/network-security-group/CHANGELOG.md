# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/network/network-security-group/CHANGELOG.md).

## 0.5.4

### Changes

- Updated `Microsoft.Network/networkSecurityGroups` API version from `2025-05-01` to `2025-09-01`
- Updated the telemetry deployment (`Microsoft.Resources/deployments`) API version from `2024-03-01` to `2025-04-01`
- Telemetry ID prefix is now sourced from the module's `metadata.json`
- Corrected parameter descriptions, including documenting that `securityRules` replaces all custom rules of the Network Security Group and that `flushConnection` fails in regions where connection flushing is not available
- Added diagnostic settings to the WAF-aligned test
- Extended the max test to cover explicit diagnostic log categories, a role assignment by the `Network Contributor` role name, and custom lock notes

### Breaking Changes

- None

## 0.5.3

### Changes

- Updated `Microsoft.Network/networkSecurityGroups` API version from `2023-11-01` to `2025-05-01`
- Updated `avm-common-types` imports to `0.7.0`

### Breaking Changes

- None

## 0.5.2

### Changes

- Added type for `tags` parameter
- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.

### Breaking Changes

- None

## 0.5.1

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
