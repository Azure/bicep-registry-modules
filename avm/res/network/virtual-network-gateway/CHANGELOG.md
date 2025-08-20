# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/network/virtual-network-gateway/CHANGELOG.md).

## 0.8.1

### Changes

- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.

### Breaking Changes

- None

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
