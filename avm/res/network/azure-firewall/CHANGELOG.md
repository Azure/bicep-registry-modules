# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/network/azure-firewall/CHANGELOG.md).

## 0.9.2

### Changes

- Updated child module deployment names to use stable identifiers instead of `deployment().name` to prevent deployment history accumulation when using Azure Deployment Stacks.

### Breaking Changes

- None

## 0.9.1

### Changes

- Fixed issue [#5816](https://github.com/Azure/bicep-registry-modules/issues/5816) to allow BYOIP scenarios with Azure Firewall in Virtual WAN hubs by adjusting the logic for `hubIPAddresses` and `publicIPResourceID` parameters to ensure correct handling when both are provided.

### Breaking Changes

- None

## 0.9.0

### Changes

- Updated Azure Firewall API version from `2024-05-01` to `2024-10-01`
- Updated Public IP Address module reference from `0.8.0` to `0.9.1`
- Added safer null-safe access patterns for module outputs using optional chaining (`?.`)
- Enhanced Public IP configuration support with additional parameters (`ipTags`, `ddosSettings`, `dnsSettings`, `idleTimeoutInMinutes`, `publicIPAddressVersion`) with new user defined type.
- Replaced `tunneling` test scenario with `managementnic` test scenario for better clarity

### Breaking Changes

- **Renamed parameter**: `enableForcedTunneling` has been renamed to `enableManagementNic` with updated description to "Enable/Disable to support Forced Tunneling and Packet capture scenarios." This provides clearer context about the parameter's purpose for enabling the management NIC functionality.

## 0.8.1

### Changes

- Updated LockType to 'avm-common-types version' `0.6.1`, enabling custom notes for locks.

### Breaking Changes

- None

## 0.8.0

### Changes

- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- Renamed parameter `zones` to `availabilityZones` and added allowed set `[1,2,3]`. As such, users **must** provide zones as integer values

## 0.7.1

### Changes

- Initial version

### Breaking Changes

- None
