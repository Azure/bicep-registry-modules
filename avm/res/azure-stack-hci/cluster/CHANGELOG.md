# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/azure-stack-hci/cluster/CHANGELOG.md).

## 0.3.0

### Changes

- Moved `deploymentSettings` resource creation from ACI deployment script (`deploy.sh`) to a native Bicep module call in `main.bicep`, bypassing ACI container memory limits.
- Restructured module layout: moved `nested/` to `modules/`, `deploy.sh` to `src/`, `secrets.bicep` to `modules/`.
- `deploy.sh` now only handles Key Vault secret provisioning and idempotency cleanup of stale `deploymentSettings` resources.
- Upgraded `azCliVersion` from `2.50.0` to `2.67.0` for the deployment script.
- Added `clusterADName`, `createBuiltInRoleAssignments`, and `operationType` parameters.
- Updated API version for `Microsoft.AzureStackHCI/clusters` to `2025-10-01`.
- Updated API version for `Microsoft.AzureStackHCI/edgeDevices` to `2025-10-01`.
- Fixed `serviceShort` in test cases to use hardcoded values (`ashclmin`, `ashclwaf`) instead of `#_namePrefix_#` placeholder.
- Updated Azure Stack HCI cluster module defaults and e2e tests for southeastasia region support and marketplace Windows Server 2022 Azure Edition image.

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
