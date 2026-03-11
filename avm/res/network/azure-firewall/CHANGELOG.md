# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/network/azure-firewall/CHANGELOG.md).

## 0.10.0

### New Features

- Added `maintenanceConfiguration` parameter to support scheduling maintenance windows for Azure Firewall via `Microsoft.Maintenance/configurationAssignments` extension resource. Closes [#6570](https://github.com/Azure/bicep-registry-modules/issues/6570).
- Added `additionalProperties` parameter for DNS proxy configuration (e.g., `Network.DNS.EnableProxy`).
- Added `extendedLocation` parameter to support extended location scenarios.
- Added `@minLength(1)` and `@maxLength(56)` constraints on the `name` parameter.

### Changes

- Upgraded Azure Firewall API version from `2024-10-01` to `2025-05-01`.
- Upgraded Public IP Address module reference from `0.9.1` to `0.12.0`.
- Migrated 12+ parameters to Bicep resource-derived types (`resourceInput<'Microsoft.Network/azureFirewalls@2025-05-01'>`) for schema-accurate type validation, including: `azureSkuTier`, `threatIntelMode`, `autoscaleMaxCapacity`, `autoscaleMinCapacity`, `applicationRuleCollections`, `networkRuleCollections`, `natRuleCollections`, `hubIPAddresses`, `additionalPublicIpConfigurations`, `additionalProperties`, `extendedLocation`, and `tags`.
- Updated rule collection outputs (`applicationRuleCollections`, `networkRuleCollections`, `natRuleCollections`) to use resource-derived types instead of untyped `array`.
- Removed ~200 lines of hand-written user-defined types (`natRuleCollectionType`, `applicationRuleCollectionType`, `networkRuleCollectionType`, `hubIPAddressesType`) in favor of resource-derived types.
- Removed the `additionalPublicIpConfigurationsVar` transform variable; input is now passed directly in schema-aligned shape.
- Updated all test dependency networking resource API versions from `2024-05-01` to `2025-05-01` across all 11 e2e test scenarios (virtualNetworks, publicIPAddresses, virtualWans, virtualHubs, firewallPolicies, publicIPPrefixes).
- Updated `publicIPPrefixes` API version in `publicipprefix` test from `2023-11-01` to `2025-05-01`.
- Updated `managedIdentity` API version in `waf-aligned` test from `2023-01-31` to `2024-11-30`.
- Added maintenance configuration test coverage in `max` test scenario.

### Breaking Changes

- **Parameter type changes**: Multiple parameters now use resource-derived types instead of manual type definitions. While values remain compatible, consumers importing exported types (`natRuleCollectionType`, `applicationRuleCollectionType`, `networkRuleCollectionType`, `hubIPAddressesType`) will need to update their references as these types have been removed.
- **`additionalPublicIpConfigurations` shape change**: The parameter now expects the schema-aligned shape `{ name, properties: { publicIPAddress: { id } } }` instead of the previous `{ name, publicIPAddressResourceId }`.

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
