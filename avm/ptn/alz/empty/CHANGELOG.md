# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/ptn/alz/empty/CHANGELOG.md).

## 0.3.6

### Changes

- Fixes issues in ALZ Bicep Accelerator templates where the `deployment().name` was being used in the `main.bicep` of the `avm/ptn/alz/empty` module, which caused deployment failures when the management group name was long and exceeded the 64 character limit for deployment names. The deployment names have been updated to use a base name with a reserved suffix for uniqueness instead of relying on `deployment().name`.

### Breaking Changes

- None

## 0.3.5

### Changes

- Updated `avm/ptn/authorization/role-assignment` module reference from version `0.2.3` to `0.2.4` to include fix for management group scoped role definitions

### Breaking Changes

- None

## 0.3.4

### Changes

- Updated deployment names to remove usage of `deployment().name` to avoid reduce the number of deployments and improve performance in redeploys and when used in a deployment stack. No functional changes to the module.

### Breaking Changes

- None

## 0.3.3

### Changes

- Enhanced dependency graph and logic. No actual change to input/output or resource deployment order, just internal improvements to make the module faster, easier to read and to maintain.

### Breaking Changes

- None

## 0.3.2

### Changes

- Updated policy assignment module reference to version `0.5.2` to include fix for management group RBAC assignments to include the management group scope of the policy assignment along with any additional management groups specified.

### Breaking Changes

- None

## 0.3.1

### Changes

- Wrapped deployment names in `take()` to ensure they do not exceed the 64 character limit. This prevents deployment failures when using long management group names. Closing [#5895](https://github.com/Azure/bicep-registry-modules/issues/5895).

### Breaking Changes

- None

## 0.3.0

### Changes

- Add new parameters for handling excluding and setting enforcement modes on policy assignments as requested in [#5602](https://github.com/Azure/bicep-registry-modules/issues/5602)
  - `managementGroupExcludedPolicyAssignments`: Optional. An array of policy assignment names (not display names) to prevent from being assigned (created/updated from a CRUD perspective) at all (not a policy exclusion (`notScope`) or exemption). This is useful if you want to exclude certain policy assignments from being created or updated by the module if included in the `managementGroupPolicyAssignments` parameter via other automation.
  - `managementGroupDoNotEnforcePolicyAssignments`: Optional. An array of policy assignment names (not display names) to set the [`enforcementMode`](https://learn.microsoft.com/azure/governance/policy/concepts/assignment-structure#enforcement-mode) to `DoNotEnforce`.
- Add support for policy assignment parameter overrides by adding a new child parameter `parameterOverrides` to the `managementGroupPolicyAssignments` parameter. This allows you to specify overrides for policy assignment parameters directly in the module. Closing [#5604](https://github.com/Azure/bicep-registry-modules/issues/5604)

### Breaking Changes

- None

## 0.2.0

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
