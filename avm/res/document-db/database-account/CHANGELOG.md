# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/document-db/database-account/CHANGELOG.md).

## 0.18.0

### Changes

- **Added support for Cassandra API resources** - First version to include Cassandra keyspaces, tables, views, role assignments, and role definitions for Azure Cosmos DB
- Import `tableType` and `viewType` from `cassandra-keyspace` module to eliminate code duplication
- Reduced template size by approximately 85 lines through type import architecture
- Established single source of truth for Cassandra resource types across modules

### Breaking Changes

- Renamed parameter `dataPlaneRoleAssignments` to `sqlRoleAssignments` to clarify it is specific to SQL (NoSQL API) resources and distinguish it from Cassandra role assignments
- Removed custom Cassandra schema type definitions (`cassandraColumnType`, `cassandraPartitionKeyType`, `cassandraClusterKeyType`, `cassandraSchemaType`, `cassandraTableType`, `cassandraViewType`)
- Cassandra table and view types now imported from `cassandra-keyspace` module instead of being defined locally
- Users upgrading to this version must update Cassandra configurations to use Azure API schema format (`resourceInput<...>.properties.resource.schema`) instead of the previous custom schema object format

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
- Added support for an explicit `dataPlaneRoleAssignments.scope` definition, to also allow a scoping to a specific container or database. Continues to default to the account root. For a reference, please refer to the `/tests/e2e/sqlroles` deployment test template. The provided resource ID will be automatically translated to the DB internal naming using `dbs` & `colls` for databases & containers respectively.
- Added support for `mongodbDatabases.autoscaleSettings`

### Breaking Changes

- Renamed `automaticFailover` to API-aligned `enableAutomaticFailover`
- Renamed `nosqlRoleAssignment` to `noSqlRoleAssignment`
- Adjusted `dataPlaneRoleAssignments.roleDefinitionId` to `roleDefinitionIdOrName` that supports full definition Ids, only the GUIDs and selected built-in roles. For a reference, please refer to the `/tests/e2e/sqlroles` deployment test template.
- Fixed a bug where the a static string is used for the `dataPlaneRoleDefinitions.name`, as opposed to being dependent on a dynamic component like the `roleName`. Now, if no explicit `name` is given, its identifier will use the `roleName` instead of set static string to ensure roles don't overwrite each other
- Changed default of `sqlDatabases.containers.defaultTtl` to nullable instead of `-1` to allow passing no value (which would translate to 'Off' in the portal)
- Added a `minLength` of 1 to `dataPlaneRoleDefinitions.dataActions` as you cannot create a role with 0 permissions

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
