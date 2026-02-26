# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/ptn/lz/sub-vending/CHANGELOG.md).

## 0.5.4

### Changes

- Add defaultOutboundAccess property to subnets

### Breaking Changes

- None

## 0.5.3

### Changes

- Fix networkPolicies property
- Bump old modules' versions

### Breaking Changes

- None

## 0.5.2

### Changes

- Updated `avm/ptn/authorization/role-assignment` module reference from version `0.2.2` to `0.2.4` to include fix for management group scoped role definitions
- Updated `avm/ptn/authorization/pim-role-assignment` module reference from version `0.1.1` to `0.1.2` to include fix for management group scoped role definitions

### Breaking Changes

- None

## 0.5.1

### Changes

- Fixed deployment failures when `deployment().location` contains spaces (e.g., 'West Europe', 'East US 2') by implementing location normalization for resource names
- Added 73-region mapping dictionary to convert display names with spaces to short names without spaces
- Normalized 8 resource name parameters that use `deployment().location` in their default values
- Resource names now use lowercase names without spaces while respecting user-provided custom values

### Breaking Changes

- **None** - Changes are backward compatible and only affect default parameter values when `deployment().location` contains spaces

## 0.5.0

### Changes

- Added support for Azure Virtual Network Manager IPAM (IP Address Management) pools for automatic IP address allocation
- Added new parameter `virtualNetworkIpamPoolNumberOfIpAddresses` to specify the number of IP addresses to allocate from an IPAM pool
- Updated `virtualNetworkAddressSpace` parameter to accept either CIDR notation or IPAM pool resource IDs
- Added IPAM support for both primary virtual network and additional virtual networks
- Added IPAM support for subnet address allocation via `ipamPoolPrefixAllocations` property in subnet definitions
- Updated IPAM test scenario to demonstrate automatic subnet IP allocation from IPAM pools
- Clarified `resourceProviders` parameter documentation to accurately reflect default behavior

### Breaking Changes

- **None**

## 0.4.1

### Changes

- Fixed routingConfiguration when creating additional virtual Wan connection to use correct vHub resource Id when virtualNetworkVwanAssociatedRouteTableResourceId is not provided.

### Breaking Changes

- **None**

## 0.4.0

### Changes

- Added functionality to create a standalone network security group instead of associating a network security group to each subnet created by the module.

### Breaking Changes

- **None**

## 0.3.8

### Changes

- Updated additional vNet to virtual WAN hub connection name suffix expression to align with expression used for primary vNet to virtual WAN hub connection name

### Breaking Changes

- None

## 0.3.7

### Changes

- Added tag assignments to resource groups
- Added output for virtual WAN hub connection name
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None

## 0.3.6

### Changes

- Fixed bug where delegation if specified not applied to created subnets

### Breaking Changes

- None

## 0.3.5

### Changes

- Added new child parameters inside of the `additionalVirtualNetworks` complex parameter to allow peering or connecting to a different hub virtual network or virtual WAN hub for additional virtual networks that the module creates instead of defaulting to what is specified in `hubNetworkResourceId`.
  - `alternativeHubVnetResourceId` for traditional hub virtual networks.
  - `alternativeVwanHubResourceId` for virtual WAN hubs.

### Breaking Changes

- None

## 0.3.4

### Changes

- Initial version

### Breaking Changes

- None
