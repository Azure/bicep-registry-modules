# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/sql/server/elastic-pool/CHANGELOG.md).

## 0.2.0

### Changes

- Added the `diagnosticSettings` parameter
- Updated the `tags` type to API version `2025-01-01`
- Updated `avm-common-types` to version `0.7.0`

### Breaking Changes

- The default name of role assignments is now derived from the elastic pool resource ID instead of the server resource ID, avoiding conflicts when assigning the same role to the same principal on multiple elastic pools of a server. When upgrading existing assignments created with the previous default, explicitly set each assignment's `name` to its existing GUID, or delete the old assignment before deploying the new default; otherwise deployment fails with `RoleAssignmentExists`.

## 0.1.0

### Changes

- Initial version

### Breaking Changes

- None