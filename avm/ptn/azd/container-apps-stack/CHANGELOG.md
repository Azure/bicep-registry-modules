# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/ptn/azd/container-apps-stack/CHANGELOG.md).

## 0.2.0

### Changes

- Expose new `publicNetworkAccess` parameter to allow enabling/disabling public network access on the Container Apps environment

### Breaking Changes

- Default value for `publicNetworkAccess` is now `"Disabled"`. In previous version (0.1.1), public network access was enabled by default. You must explicitly set `publicNetworkAccess = "Enabled"` if you want your container apps to be publicly accessible.

## 0.1.1

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
