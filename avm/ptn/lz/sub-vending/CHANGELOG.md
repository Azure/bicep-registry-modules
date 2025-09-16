# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/ptn/lz/sub-vending/CHANGELOG.md).

## 0.3.9

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
