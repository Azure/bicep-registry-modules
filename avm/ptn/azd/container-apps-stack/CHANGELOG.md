# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/ptn/azd/container-apps-stack/CHANGELOG.md).

## 0.3.0

### Changes

- Expose new `publicNetworkAccess` parameter to allow enabling/disabling public network access on the Container Apps environment. The default value is `"Disabled"`.

### Breaking Changes

- Default value for `publicNetworkAccess` is now `"Disabled"`. In the previous version (0.2.0), public network access was **disabled by default** and could not be enabled.
- You can now explicitly set `publicNetworkAccess = "Enabled"` to make your container apps publicly accessible.

## 0.2.0

### Changes

- Fixed CI errors for the `avm/ptn/azd/container-apps-stack` pattern module pipeline.
- Replaced parameter `logAnalyticsWorkspaceResourceId` with `logAnalyticsWorkspaceName` for better compatibility.
- Updated usage of Log Analytics Workspace in resource definitions.

### Breaking Changes

- In the current version, public network access is disabled by default on the CA environment and there's no way to enable it.

## 0.1.1

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
