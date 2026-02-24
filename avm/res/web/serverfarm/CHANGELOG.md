# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/web/serverfarm/CHANGELOG.md).

## 0.7.1

### Changes

- Added updates to e2e test cases for Managed Instance deployments to include deployment script resource

### Breaking Changes

- None

## 0.7.0

### Changes

- Updated API version to `2025-03-01` and added resource-derived types for schema-validated parameters
- Added managed identity support (`managedIdentities` param, `systemAssignedMIPrincipalId` output)
- Added VNet integration support (`virtualNetworkSubnetId` param)
- Added Managed Instance support (`isCustomMode`, `rdpEnabled`, `installScripts`, `planDefaultIdentity`, `registryAdapters`, `storageMounts`)
- Converted `appServiceEnvironmentResourceId` and `workerTierName` from empty string defaults to nullable
- Reordered parameters to align with AVM conventions
- Updated `avm-common-types` to `0.6.1`
- Added e2e test cases for Linux, Windows Container, and Managed Instance deployments

### Breaking Changes

- None

## 0.6.0

### Changes

- Added support for `hyperV` parameter to enable or disable Hyper-V container app service plan

### Breaking Changes

- None

## 0.5.0

### Changes

- API Version Updates
- Support for Flexible Consumption SKU
- Documentation enhancements
- Consistency improvements
- Updated avm-common-types references to latest version `0.6.0`, enabling custom notes on locks
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- Renamed parameter `appServiceEnvironmentId` to `appServiceEnvironmentResourceId`

## 0.4.1

### Changes

- Initial version

### Breaking Changes

- None
