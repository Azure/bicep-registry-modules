# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/network/virtual-network/CHANGELOG.md).

## 0.8.0

### Breaking Changes

- Updated `Microsoft.Network/virtualNetworks` API version from `2024-05-01` to `2025-01-01`
- Introduced discriminated union types for address space configuration:
  - `ipAddressesType` - For Virtual Network address space (supports `ipam` or `addressPrefixes`)
  - `subnetIpAddressesType` - For Subnet address space (supports `ipam`, `addressPrefixes`, or `addressPrefix`)
  - `ipamAddressPrefixesType` - Type for IPAM-based allocation with pool resource ID and CIDR prefix
  - `addressPrefixesType` - Type for manually specified address prefixes as array
  - `addressPrefixType` - Type for single manually specified address prefix
- Added `cidrPrefixType` string literal union type for type-safe CIDR prefix selection (`/1` through `/31`)
- Added `getCidrHostCount()` and `getCidrHostCounts()` exported functions for CIDR to number-of-addresses conversion
- Added `keyValuePairType` exported type for generic key-value pairs
- Improved type safety and IntelliSense support for IPAM pool allocations
- **Parameter `addressPrefixes`**: Changed from `array` to `ipAddressesType` discriminated union. Now requires `by: 'addressPrefixes'` discriminator with `addressPrefixes` array, or `by: 'ipam'` with `ipamPoolPrefixAllocations`
- **Parameter `ipamPoolNumberOfIpAddresses`**: Removed. IPAM allocations now use `cidr` property (e.g., `/24`) which automatically converts to number of addresses
- **Subnet type `addressPrefix`, `addressPrefixes`, `ipamPoolPrefixAllocations`**: Replaced by single `addressSpace` property using `subnetIpAddressesType` discriminated union

## 0.7.1

### Changes

- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.
- Export peeringType and subnetType to enable intellisense formatting
- Introduced [`avm/res/network/virtual-network/virtual-network-peering`](/Azure/bicep-registry-modules/blob/main/avm/res/network/virtual-network/virtual-network-peering) as child module

### Breaking Changes

- None

## 0.7.0

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
