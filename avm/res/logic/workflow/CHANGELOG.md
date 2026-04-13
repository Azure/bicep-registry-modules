# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/logic/workflow/CHANGELOG.md).

## 0.5.4

### Changes

- Fixed managed identity configuration to support mixed identity type (`SystemAssigned,UserAssigned`)
- Resolved bug where providing both `systemAssigned = true` and `userAssignedResourceIds` caused deployment validation error: "The identity ids are only supported for 'UserAssigned' identity type."
- Updated identity logic to correctly handle all four supported scenarios: None, SystemAssigned, UserAssigned, and SystemAssigned,UserAssigned

### Breaking Changes

- None

## 0.5.3

### Changes

- Added type for parameters `actionsAccessControlConfiguration`, `connectorEndpointsConfiguration`, `contentsAccessControlConfiguration`, `definitionParameters`, `integrationAccount`, `tags`, `triggersAccessControlConfiguration`, `workflowEndpointsConfiguration`, `workflowManagementAccessControlConfiguration`
- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.

### Breaking Changes

- None

## 0.5.2

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
