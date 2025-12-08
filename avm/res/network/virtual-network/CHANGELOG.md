# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/network/virtual-network/CHANGELOG.md).

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
