# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/container-service/managed-cluster/CHANGELOG.md).

## 0.11.1

### Changes

- Update `discEncryptionSetResourceId` parameter description

### Breaking Changes

- None

## 0.11.0

### Changes

- Updated ARM API versions:
  - Updated `Microsoft.ContainerService/managedClusters` from previous version to `2025-05-02-preview`
  - Updated `Microsoft.ContainerService/managedClusters/agentPools` to `2025-05-02-preview`
  - Updated `Microsoft.ContainerService/managedClusters/maintenanceConfigurations` to `2025-05-01`
- Updated some parameter types to reference newer API versions for better type safety
- Updated resource templates and JSON output to use the latest API versions
- Adding Linux and Windows profile config to `Microsoft.ContainerService/managedClusters/agentPools`

### Breaking Changes

- API version updates may introduce new required parameters or behavior changes in the underlying Azure Resource Manager API
- Some parameter schemas may have changed due to the updated API versions

## 0.10.1

### Changes

- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.
- Added types to `tags`, `httpProxyConfig` & `identityProfile` parameters
- Updated version of referenced `avm/res/kubernetes-configuration/extension` module to `0.3.6` and adding a pass-thru of the `targetNamespace` parameter

### Breaking Changes

- None

## 0.10.0

### Changes

- Adding load balancer configuration options
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None

## 0.9.0

### Changes

- Initial version

### Breaking Changes

- None
