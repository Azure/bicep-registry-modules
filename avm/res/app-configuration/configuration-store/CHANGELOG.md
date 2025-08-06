# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/app-configuration/configuration-store/CHANGELOG.md).

## 0.7.0

### Changes

- Upgraded to version `0.11.0` of Private-Endpoint module
- Updated interface of `privateEndpoints` parameter to avm-common-types version `0.5.1` which allows defining the additional scope parameter `resourceGroupResourceId` to optionally deploy a private endpoint into a different resource group in the same or different subscription

### Breaking Changes

- Added type for Private Endpoint output to allow discovery
  - Changed the contained property name `customDnsConfig` to `customDnsConfigs` and  `networkInterfaceIds` to `networkInterfaceResourceIds`
- Introduced a type for the `tags` parameter

## 0.6.3

### Changes

- Initial version

### Breaking Changes

- None
