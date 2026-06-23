# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/azure-stack-hci/cluster/CHANGELOG.md).

## 0.4.0

### Changes

- Inlined cluster deployment settings into ACI deployment script for improved performance
- Removed separate `clusterDeploymentSettings` Bicep module in favor of single-phase ACI deployment
- Changed ACI cleanup preference to `OnSuccess` with 1-day retention interval

### Breaking Changes

- None (external module interface unchanged; all parameters and outputs remain the same)

## 0.3.0

### Changes

- Upgraded `azCliVersion` from `2.50.0` to `2.67.0` for the deployment script.
- Added `clusterADName`, `createBuiltInRoleAssignments`, and `operationType` parameters.
- Updated API version for `Microsoft.AzureStackHCI/clusters` to `2025-10-01`.
- Updated API version for `Microsoft.AzureStackHCI/edgeDevices` to `2025-10-01`.

### Breaking Changes

- None (external module interface unchanged; all parameters and outputs remain the same)

## 0.2.0

### Changes

- avoid Azure Deployment Script error

### Breaking Changes

- None

## 0.1.13

### Changes

- avoid Azure Deployment Script error

### Breaking Changes

- None

## 0.1.12

### Changes

- handle existing deployment resources based on mode and state
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
