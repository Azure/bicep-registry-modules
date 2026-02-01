# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/network/nat-gateway/CHANGELOG.md).

## 2.0.1

### Changes

- Made NAT Gateway SKU configurable to support `StandardV2` for zone-redundant deployments
- Added `natGatewaySku` parameter with allowed values: `'Standard'` (default) and `'StandardV2'`
- Public IP addresses created by the module now automatically inherit the NAT Gateway SKU value when not explicitly specified
- Updated `publicIpType` definition to support `'StandardV2'` SKU option

### Breaking Changes

- None

## 2.0.0

### Changes

- Updated LockType to 'avm-common-types version' `0.6.1`, enabling custom notes for locks.
- Updated `avm/res/network/public-ip-prefix` module reference to `0.7.0`, exposing additional other parameters
- Added type for parameters `publicIPPrefixes`, `publicIPAddresses`, `publicIpResourceIds` & `publicIPPrefixResourceIds`

### Breaking Changes

- Updated `avm/res/network/public-ip-address` module reference to `0.9.0`, renaming its property `zones` to `availabilityZones` and exposing additional other parameters
- Renamed parameter `publicIPPrefixObjects` to `publicIPPrefixes`
- Renamed parameter `publicIPAddressObjects` to `publicIPAddresses`

## 1.4.0

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
