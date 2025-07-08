# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/ptn/lz/sub-vending/CHANGELOG.md).

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
