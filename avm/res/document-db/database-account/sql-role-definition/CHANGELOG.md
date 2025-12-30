# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/document-db/database-account/sql-role-definition/CHANGELOG.md).

## 0.2.0

### Changes

- Added user- and resource-derived types for all module parameters
- Added support for the `sqlRoleAssignments.scope` property. Continues to default to the account itself.

### Breaking Changes

- Fixed a bug where the a static string is used for the `name` of a role's default value, as opposed to being dependent on a dynamic component like the `roleName`. Now, if no explicit `name` is given, its identifier will use the `roleName` instead of set static string to ensure roles don't overwrite each other
- Added a `minLength` of 1 to `dataActions` as you cannot create a role with 0 permissions

## 0.1.0

### Changes

- Initial release

### Breaking Changes

- None
