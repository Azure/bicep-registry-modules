# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/network/azure-firewall/CHANGELOG.md).

## 0.8.2

### Changes

- Added `enableDnsProxy` parameter to support DNS proxy functionality on Azure Firewall. When enabled, the firewall acts as a DNS proxy and forwards DNS requests to configured DNS servers, which is required for network rules using FQDN destinations.

### Breaking Changes

- None

## 0.8.1

### Changes

- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.

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
