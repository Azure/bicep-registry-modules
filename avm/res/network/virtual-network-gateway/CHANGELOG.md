# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/network/virtual-network-gateway/CHANGELOG.md).

## 0.8.0

### Changes

- Added support for the Maintenance Configuration extension via the `maintenanceConfiguration` parameter. Recommended for WAF-reliability alignment

### Breaking Changes

- Renamed `publicIpZones` parameter to `publicIpAvailabilityZones`, added a type and an allowed set only allowing `[1,2,3]`

## 0.7.0

### Changes

- Initial version

### Breaking Changes

- None
