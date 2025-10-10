# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/document-db/database-account/CHANGELOG.md).

## 0.16.0

### Changes

- Introduced [`sql-role-assignment`](/Azure/bicep-registry-modules/blob/main/avm/res/document-db/database-account/sql-role-assignment) as child module
- Introduced [`sql-role-definition`](/Azure/bicep-registry-modules/blob/main/avm/res/document-db/database-account/sql-role-definition) as child module
- Updated module references
- Unify `avm-common-type` version to 0.6.1

### Breaking Changes

- None

## 0.15.1

### Changes

- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.
- Updated `privateEndpoints` parameter type to 'avm-common-types' `0.6.1`, adding a type to its `tags` property

### Breaking Changes

- None

## 0.15.0

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
