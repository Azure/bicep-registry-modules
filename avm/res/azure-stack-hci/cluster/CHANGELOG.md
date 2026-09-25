# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/azure-stack-hci/cluster/CHANGELOG.md).

## 0.6.0

### Changes

- Updated API version for `Microsoft.AzureStackHCI/clusters` to `2026-04-30`.
- Updated API version for `Microsoft.AzureStackHCI/clusters/deploymentSettings` to `2026-04-30`.
- Updated API version for `Microsoft.AzureStackHCI/edgeDevices` to `2026-04-30`.
- Updated API version for `Microsoft.HybridCompute/machines` to `2026-07-15`.
- Updated API version for `Microsoft.KeyVault/vaults` and `Microsoft.KeyVault/vaults/secrets` to `2026-02-01`, moving off the previously used preview API version.
- Updated API version for `Microsoft.Storage/storageAccounts` to `2026-04-01`.
- Updated the AVM telemetry deployment to API version `2025-04-01`.
- Aligned the API versions used in `reference()` functions for Arc machines and edge devices with the corresponding resource declarations.
- Implemented resource-derived types for the `tags`, `azureStackLCMUserCredentialTags`, `localAdminCredentialTags`, `witnessStoragekeyTags` and `defaultARBApplicationTags` parameters to comply with [BCPNFR1](https://azure.github.io/Azure-Verified-Modules/spec/BCPNFR1), providing IntelliSense support for these inputs.

### Breaking Changes

- None (external module interface unchanged; all parameters and outputs remain the same)

## 0.5.0

### Changes

- Added a phase-derived `forceUpdateTag` to the cluster deployment script so a `Validate` -> `Deploy` transition reliably re-runs the script, while repeated deployments with identical inputs remain idempotent.

### Breaking Changes

- None (external module interface unchanged; all parameters and outputs remain the same)

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
