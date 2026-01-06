# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/ptn/authorization/role-assignment/CHANGELOG.md).

## 0.2.4

### Changes

- Replaced `subscriptionResourceId()` with `managementGroupResourceId()` for built-in role definitions in management group scope module to align with deployment context

### Breaking Changes

- None

## 0.2.3

### Changes

- Updated deployment names to remove usage of `deployment().name` to avoid reduce the number of deployments and improve performance in redeploys and when used in a deployment stack. No functional changes to the module.

### Breaking Changes

- None

## 0.2.2

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
