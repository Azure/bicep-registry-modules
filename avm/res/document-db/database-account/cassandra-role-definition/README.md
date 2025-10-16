# DocumentDB Database Account Cassandra Role Definitions. `[Microsoft.DocumentDB/databaseAccounts/cassandraRoleDefinitions]`

This module deploys a Cassandra Role Definition in a CosmosDB Account.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.DocumentDB/databaseAccounts/cassandraRoleAssignments` | 2025-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_cassandraroleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2025-05-01-preview/databaseAccounts/cassandraRoleAssignments)</li></ul> |
| `Microsoft.DocumentDB/databaseAccounts/cassandraRoleDefinitions` | 2025-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_cassandraroledefinitions.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2025-05-01-preview/databaseAccounts/cassandraRoleDefinitions)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`roleName`](#parameter-rolename) | string | A user-friendly name for the Role Definition. Must be unique for the database account. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`databaseAccountName`](#parameter-databaseaccountname) | string | The name of the parent Database Account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`assignableScopes`](#parameter-assignablescopes) | array | A set of fully qualified Scopes at or below which Role Assignments may be created using this Role Definition. This will allow application of this Role Definition on the entire database account or any underlying Database / Keyspace. Must have at least one element. Scopes higher than Database account are not enforceable as assignable Scopes. Note that resources referenced in assignable Scopes need not exist. Defaults to the current account. |
| [`cassandraRoleAssignments`](#parameter-cassandraroleassignments) | array | An array of Cassandra Role Assignments to be created for the Cassandra Role Definition. |
| [`dataActions`](#parameter-dataactions) | array | An array of data actions that are allowed. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`name`](#parameter-name) | string | The unique identifier of the Role Definition. |
| [`notDataActions`](#parameter-notdataactions) | array | An array of data actions that are denied. |

### Parameter: `roleName`

A user-friendly name for the Role Definition. Must be unique for the database account.

- Required: Yes
- Type: string

### Parameter: `databaseAccountName`

The name of the parent Database Account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `assignableScopes`

A set of fully qualified Scopes at or below which Role Assignments may be created using this Role Definition. This will allow application of this Role Definition on the entire database account or any underlying Database / Keyspace. Must have at least one element. Scopes higher than Database account are not enforceable as assignable Scopes. Note that resources referenced in assignable Scopes need not exist. Defaults to the current account.

- Required: No
- Type: array

### Parameter: `cassandraRoleAssignments`

An array of Cassandra Role Assignments to be created for the Cassandra Role Definition.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-cassandraroleassignmentsprincipalid) | string | The unique identifier for the associated AAD principal. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-cassandraroleassignmentsname) | string | The unique identifier of the role assignment. |
| [`scope`](#parameter-cassandraroleassignmentsscope) | string | The data plane resource path for which access is being granted. Defaults to the current account. |

### Parameter: `cassandraRoleAssignments.principalId`

The unique identifier for the associated AAD principal.

- Required: Yes
- Type: string

### Parameter: `cassandraRoleAssignments.name`

The unique identifier of the role assignment.

- Required: No
- Type: string

### Parameter: `cassandraRoleAssignments.scope`

The data plane resource path for which access is being granted. Defaults to the current account.

- Required: No
- Type: string

### Parameter: `dataActions`

An array of data actions that are allowed.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `name`

The unique identifier of the Role Definition.

- Required: No
- Type: string

### Parameter: `notDataActions`

An array of data actions that are denied.

- Required: No
- Type: array
- Default: `[]`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the cassandra role definition. |
| `resourceGroupName` | string | The name of the resource group the cassandra role definition was created in. |
| `resourceId` | string | The resource ID of the cassandra role definition. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `avm/res/document-db/database-account/cassandra-role-assignment` | Local reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
