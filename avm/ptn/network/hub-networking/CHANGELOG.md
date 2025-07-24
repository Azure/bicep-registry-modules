# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/ptn/network/hub-networking/CHANGELOG.md).

## 0.5.0

### Changes

- Changed incorrect type of `hub.azureFirewallSettings.diagnosticSettings` from object to array
- Removed numerous redundant fallback values (as they're anyways the default in the referenced module)
- Updated API & referenced module versions
- Small type changes

### Breaking Changes

- Renamed input parameter `hub.azureFirewallSettings.virtualHub` to `virtualHubResourceId`

## 0.4.0

### Changes

- Initial version

### Breaking Changes

- None
