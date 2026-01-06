# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/network/virtual-network-gateway/CHANGELOG.md).

## 0.10.1

### Changes

- Fixed hardcoded Public IP `dnsSettings.domainNameLabelScope` (preview feature) by making it optional/configurable to avoid deployment failures in regions where the feature isn't available.
- Updated existing `Microsoft.Network/publicIPAddresses` API version to `2025-01-01`.
- Updated referenced `br/public:avm/res/network/public-ip-address` module version to `0.10.0`.

### Breaking Changes

- None

## 0.10.0

### Changes

- Fixed ExpressRoute gateway deployments by setting publicIPAddress to null when gatewayType is ExpressRoute, as Azure now manages these IPs automatically.

### Breaking Changes

- Updated referenced `avm/res/network/public-ip-address` module version to `0.9.0` which uses `availabilityZones` instead of `zones`.

## 0.9.0

### Changes

- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.

### Breaking Changes

- Changed `vpnType` calculatation from `PolicyBased` to `RouteBased` for ExpressRouteGateways. If not an ExpressRouteGateway, the specified `vpnType` will be used

## 0.8.0

### Changes

- Added support for the Maintenance Configuration extension via the `maintenanceConfiguration` parameter. Recommended for WAF-reliability alignment
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- Renamed `publicIpZones` parameter to `publicIpAvailabilityZones`, added a type and an allowed set only allowing `[1,2,3]`

## 0.7.0

### Changes

- Initial version

### Breaking Changes

- None
