# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/search/search-service/CHANGELOG.md).

## 0.11.0

### Changes

- Added secure outputs of the module's main resource's secrets formerly only exported to a key vault via the `secretsExportConfiguration` parameter
- Added the output `privateEndpoints` alongside its type to allow the output's discovery
- Bugfix: Added the missing pass-thru of the `privateEndpoints` parameter's property `resourceGroupResourceId` which allows to optionally deploy a private endpoint into a different resource group in the same or different subscription

### Breaking Changes

- Introduced a type for the parameter `tags`

## 0.10.0

### Changes

- Initial version

### Breaking Changes

- None
