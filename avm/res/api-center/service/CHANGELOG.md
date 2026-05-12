# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/api-center/service/CHANGELOG.md).

## 0.1.1

### Changes

- Fixed managed identity default behavior: `systemAssigned` no longer defaults to `true` when `managedIdentities` parameter is provided without specifying `systemAssigned`

### Breaking Changes

- The `managedIdentities` parameter behavior has changed: previously, omitting `systemAssigned` within `managedIdentities` would default to `true` (enabling system-assigned identity). It now defaults to `false`, consistent with all other AVM modules.

## 0.1.0

### Changes

- Initial version

### Breaking Changes

- None
