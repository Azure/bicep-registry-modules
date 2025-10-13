# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/document-db/database-account/CHANGELOG.md).

## 0.17.0

### Changes

- Added user- and resource-derived types for all module parameters
- Added support for the parameters
  - `enableBurstCapacity`
  - `defaultIdentity`
  - `cors`
  - `connectorOffer`
  - `enableCassandraConnector`
  - `enablePartitionMerge`
  - `enablePerRegionPerPartitionAutoscale`
  - `analyticalStorageConfiguration`
  - `networkRestrictions.networkAclBypassResourceIds`
- Added support for an explicit `dataPlaneRoleAssignments.scope` definition, to also allow a scoping to a specific container or database. Continues to default to the account root.


### Breaking Changes

- Renamed `automaticFailover` to API-aligned `enableAutomaticFailover`
- Renamed `nosqlRoleAssignment` to `noSqlRoleAssignment`
- Adjusted `dataPlaneRoleAssignments.roleDefinitionId` to `roleDefinitionIdOrName` that supports full definition Ids, only the GUIDs and selected built-in roles

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
