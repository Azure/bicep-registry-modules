# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/document-db/database-account/CHANGELOG.md).

## 0.17.0

### Changes

- Introduced [`cassandra-keyspace`](/Azure/bicep-registry-modules/blob/main/avm/res/document-db/database-account/cassandra-keyspace) as child module
- Introduced [`cassandra-keyspace/table`](/Azure/bicep-registry-modules/blob/main/avm/res/document-db/database-account/cassandra-keyspace/table) as child module
- Introduced [`cassandra-keyspace/view`](/Azure/bicep-registry-modules/blob/main/avm/res/document-db/database-account/cassandra-keyspace/view) as child module
- Introduced [`cassandra-role-definition`](/Azure/bicep-registry-modules/blob/main/avm/res/document-db/database-account/cassandra-role-definition) as child module
- Introduced [`cassandra-role-assignment`](/Azure/bicep-registry-modules/blob/main/avm/res/document-db/database-account/cassandra-role-assignment) as child module
- Added `cassandraKeyspaces` parameter to support Azure Cosmos DB Cassandra API
- Added `cassandraRoleDefinitions` parameter to support Azure Cosmos DB for Apache Cassandra native data plane role-based access control definitions
- Added `cassandraRoleAssignments` parameter to support Azure Cosmos DB for Apache Cassandra native data plane role-based access control assignments
- Added support for Cassandra table schemas with partition keys, cluster keys, and column definitions
- Added support for Cassandra views (materialized views) with CQL view definitions and throughput settings
- Added support for analytical storage TTL and default TTL on Cassandra tables
- Added support for configurable scope in Cassandra role assignments (account-level, keyspace-level)
- Added `EnableCassandra` capability support

> **Note on Cassandra RBAC Testing**: While Cassandra role definition and role assignment modules are fully implemented and functional, comprehensive testing is deferred due to undocumented valid Cassandra data actions in the Azure API (2025-05-01-preview). The API does not support `notDataActions`, and valid data action strings for Cassandra are not documented in Azure template references. Basic functionality tests (cassandrakeyspaces) include Views testing.

### Breaking Changes

- None

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
