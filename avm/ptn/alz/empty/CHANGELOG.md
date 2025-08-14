# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/ptn/alz/empty/CHANGELOG.md).

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
