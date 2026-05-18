# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/network/virtual-network/CHANGELOG.md).

## 0.9.0

### Changes

- Added support for `subnet.ipAllocations` & `subnet.serviceGateway`
- Added support for `peering.enableOnlyIPv6Peering`
- Added diverse types
- Updated references of `avm-common-types` to `0.7.0`

### Breaking Changes

- None

## 0.8.1

### Changes

- Publishing child module `avm/res/network/virtual-network/virtual-network-peering`

### Breaking Changes

- None

## 0.8.0

### Changes

- Added support for private endpoint virtual network policies (parameter `enablePrivateEndpointVNetPolicies`). These are used to enable virtual networks to support more than 1000 private endpoints or more than 4000 private endpoints in peered virtual networks.

### Breaking Changes

- Set default value for private endpoint virtual network policies (parameter `enablePrivateEndpointVNetPolicies`) to 'Disabled'. Any virtual networks deployed before this version which enabled high scale private endpoints need to add a parameter or risk that feature being disabled by this new default value.

## 0.7.2

### Changes

- Updated child module deployment names to use stable identifiers instead of `deployment().name` to prevent deployment history accumulation when using Azure Deployment Stacks.

### Breaking Changes

- None

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
