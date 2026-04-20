# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/ptn/authorization/policy-assignment/CHANGELOG.md).

## 0.5.3

### Changes

- Updated deployment names to remove usage of `deployment().name` to avoid reduce the number of deployments and improve performance in redeploys and when used in a deployment stack. No functional changes to the module.

### Breaking Changes

- None

## 0.5.2

### Changes

- Fixed bug where management groups for RBAC assignments were not being correctly processed and only those management groups specified in the `additionalManagementGroupsIDsToAssignRbacTo` parameter were being used instead of combining them with the management group scope of the policy assignment.

### Breaking Changes

- None

## 0.5.1

### Changes

- Fixed bug where `parameterOverrides` was not being correctly passed to the policy assignment module for some scopes (subscription & resource group).

### Breaking Changes

- None

## 0.5.0

### Changes

- Added new parameter called `parameterOverrides` to allow overriding parameters when passing in parameters via a JSON or YAML file using the `loadJsonContent`, `loadYamlContent`, or `loadTextContent` functions that may pass the values via the `parameters` parameter of this module.
  - Useful for Azure Landing Zones (ALZ) scenarios where the parameters are passed in via a JSON or YAML file.

### Breaking Changes

- None

## 0.4.0

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
