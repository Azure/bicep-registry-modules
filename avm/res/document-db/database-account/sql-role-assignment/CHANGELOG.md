# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/document-db/database-account/sql-role-assignment/CHANGELOG.md).

## 0.2.0

### Changes

- Added user- and resource-derived types for all module parameters
- Added support for a custom `scope` definition, to also allow a scoping to a specific container or database. The provided resource ID will be automatically translated to the DB internal naming using `dbs` & `colls` for databases & containers respectively.

### Breaking Changes

- Adjusted `roleDefinitionId` to `roleDefinitionIdOrName` that supports full definition Ids, only the GUIDs and selected built-in roles

## 0.1.0

### Changes

- Initial release

### Breaking Changes

- None
