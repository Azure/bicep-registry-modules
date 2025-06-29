# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/data-factory/factory/CHANGELOG.md).

## 0.10.2

### Changes

- Initial version

### Breaking Changes

- None

## 0.10.3

### Changes

- Changed the /managed-virtual-network `module managedVirtualNetwork_managedPrivateEndpoint` to so that when referencing properties of resources within the same template, to always use the resource reference (managedVirtualNetwork.name) rather than parameters (previously it was calling the "name" parameter)

### Breaking Changes

- None