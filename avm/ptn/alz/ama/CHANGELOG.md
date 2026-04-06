# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/ptn/alz/ama/CHANGELOG.md).

## 0.2.0

### Changes

- Give the VM Insights PerfOnly lock a unique name (`-perfonly-lock` suffix) to avoid duplicate lock resource name collision with the PerfAndMap lock during Azure Deployment Stacks validation. Fixes [#6794](https://github.com/Azure/bicep-registry-modules/issues/6794).
- Updated `avm/res/managed-identity/user-assigned-identity` module reference from `0.4.3` to `0.5.0`.
- Updated `Microsoft.Resources/deployments` API version from `2024-03-01` to `2024-07-01`.

### Breaking Changes

- **Lock resource names changed**: The VM Insights PerfAndMap lock name changed from `{lockName|dcrName}-lock` to `{lockName|dcrName}-perfandmap-lock`, and the PerfOnly lock name changed from `{lockName|dcrName}-lock` to `{lockName|dcrName}-perfonly-lock`. This resolves the duplicate name collision in Deployment Stacks. Existing deployments may see old locks deleted and new ones created.

## 0.1.1

### Changes

- Updated `avm/res/managed-identity/user-assigned-identity` to version `0.5.0`
- Updated child module deployment name to use stable identifiers instead of static name to prevent deployment history accumulation when using Azure Deployment Stacks

### Breaking Changes

- None

## 0.1.0

### Changes

- Initial version

### Breaking Changes

- None
