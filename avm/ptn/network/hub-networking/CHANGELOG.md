# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/ptn/network/hub-networking/CHANGELOG.md).

## 0.5.1

### Changes

- Updated `avm/res/network/virtual-network` to version `0.8.0`
- Updated `avm/res/network/route-table` to version `0.5.0`
- Updated `avm/res/network/bastion-host` to version `0.9.0`
- Updated `avm/res/network/azure-firewall` to version `1.0.0`
- Updated child module deployment names to use stable identifiers instead of `deployment().name` to prevent deployment history accumulation when using Azure Deployment Stacks

### Breaking Changes

- None

## 0.5.0

### Changes

- Changed incorrect type of `hub.azureFirewallSettings.diagnosticSettings` from object to array
- Removed numerous redundant fallback values (as they're anyways the default in the referenced module)
- Updated API & referenced module versions
- Small type changes
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- Renamed input parameter `hub.azureFirewallSettings.virtualHub` to `virtualHubResourceId`

## 0.4.0

### Changes

- Initial version

### Breaking Changes

- None
