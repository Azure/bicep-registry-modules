# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/batch/batch-account/CHANGELOG.md).

## 0.11.0

### Changes

- Upgraded to version `0.11.0` of Private-Endpoint module
- Updated interface of `privateEndpoints` parameter to avm-common-types version `0.5.1` which allows defining the additional scope parameter `resourceGroupResourceId` to optionally deploy a private endpoint into a different resource group in the same or different subscription

### Breaking Changes

- Added type for Private Endpoint output to allow discovery
  - Changed the contained property name `customDnsConfig` to `customDnsConfigs` and  `networkInterfaceIds` to `networkInterfaceResourceIds`
- Renamed parameter `storageAccountId` to `storageAccountResourceId` in alignment with AVM specs
- Introduced type for `tags` parameter
- Introduced type for `allowedAuthenticationModes` parameter

## 0.10.3

### Changes

- Initial version

### Breaking Changes

- None
