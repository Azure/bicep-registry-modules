# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/ptn/dev-ops/cicd-agents-and-runners/CHANGELOG.md).

## 0.3.0

### Changes

- Added two new parameters
- Added a deployment script that whitelists ACR tasks to run

### Breaking Changes

- This version fixes a breaking change introduced in Azure Container registry where tasks needs an explicit script to be able to run. More information can be found [in this article](https://learn.microsoft.com/azure/container-registry/manage-network-bypass-policy-for-tasks)

## 0.2.3

### Changes

- Initial version

### Breaking Changes

- None
