# Log Analytics Workspace Tables `[Microsoft.OperationalInsights/workspaces/tables]`

This module deploys a Log Analytics Workspace Table.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.OperationalInsights/workspaces/tables` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2022-10-01/workspaces/tables) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the table. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`workspaceName`](#parameter-workspacename) | string | The name of the parent workspaces. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`plan`](#parameter-plan) | string | Instruct the system how to handle and charge the logs ingested to this table. |
| [`restoredLogs`](#parameter-restoredlogs) | object | Restore parameters. |
| [`retentionInDays`](#parameter-retentionindays) | int | The table retention in days, between 4 and 730. Setting this property to -1 will default to the workspace retention. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`schema`](#parameter-schema) | object | Table's schema. |
| [`searchResults`](#parameter-searchresults) | object | Parameters of the search job that initiated this table. |
| [`totalRetentionInDays`](#parameter-totalretentionindays) | int | The table total retention in days, between 4 and 2555. Setting this property to -1 will default to table retention. |

### Parameter: `name`

The name of the table.

- Required: Yes
- Type: string

### Parameter: `workspaceName`

The name of the parent workspaces. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `plan`

Instruct the system how to handle and charge the logs ingested to this table.

- Required: No
- Type: string
- Default: `'Analytics'`
- Allowed:
  ```Bicep
  [
    'Analytics'
    'Basic'
  ]
  ```

### Parameter: `restoredLogs`

Restore parameters.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`endRestoreTime`](#parameter-restoredlogsendrestoretime) | string | The timestamp to end the restore by (UTC). |
| [`sourceTable`](#parameter-restoredlogssourcetable) | string | The table to restore data from. |
| [`startRestoreTime`](#parameter-restoredlogsstartrestoretime) | string | The timestamp to start the restore from (UTC). |

### Parameter: `restoredLogs.endRestoreTime`

The timestamp to end the restore by (UTC).

- Required: No
- Type: string

### Parameter: `restoredLogs.sourceTable`

The table to restore data from.

- Required: No
- Type: string

### Parameter: `restoredLogs.startRestoreTime`

The timestamp to start the restore from (UTC).

- Required: No
- Type: string

### Parameter: `retentionInDays`

The table retention in days, between 4 and 730. Setting this property to -1 will default to the workspace retention.

- Required: No
- Type: int
- Default: `-1`

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Log Analytics Contributor'`
  - `'Log Analytics Reader'`
  - `'Monitoring Contributor'`
  - `'Monitoring Reader'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-roleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-roleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-roleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `roleAssignments.principalType`

The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Device'
    'ForeignGroup'
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `schema`

Table's schema.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`columns`](#parameter-schemacolumns) | array | A list of table custom columns. |
| [`name`](#parameter-schemaname) | string | The table name. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-schemadescription) | string | The table description. |
| [`displayName`](#parameter-schemadisplayname) | string | The table display name. |

### Parameter: `schema.columns`

A list of table custom columns.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-schemacolumnsname) | string | The column name. |
| [`type`](#parameter-schemacolumnstype) | string | The column type. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypeHint`](#parameter-schemacolumnsdatatypehint) | string | The column data type logical hint. |
| [`description`](#parameter-schemacolumnsdescription) | string | The column description. |
| [`displayName`](#parameter-schemacolumnsdisplayname) | string | Column display name. |

### Parameter: `schema.columns.name`

The column name.

- Required: Yes
- Type: string

### Parameter: `schema.columns.type`

The column type.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'boolean'
    'dateTime'
    'dynamic'
    'guid'
    'int'
    'long'
    'real'
    'string'
  ]
  ```

### Parameter: `schema.columns.dataTypeHint`

The column data type logical hint.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'armPath'
    'guid'
    'ip'
    'uri'
  ]
  ```

### Parameter: `schema.columns.description`

The column description.

- Required: No
- Type: string

### Parameter: `schema.columns.displayName`

Column display name.

- Required: No
- Type: string

### Parameter: `schema.name`

The table name.

- Required: Yes
- Type: string

### Parameter: `schema.description`

The table description.

- Required: No
- Type: string

### Parameter: `schema.displayName`

The table display name.

- Required: No
- Type: string

### Parameter: `searchResults`

Parameters of the search job that initiated this table.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`query`](#parameter-searchresultsquery) | string | The search job query. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-searchresultsdescription) | string | The search description. |
| [`endSearchTime`](#parameter-searchresultsendsearchtime) | string | The timestamp to end the search by (UTC). |
| [`limit`](#parameter-searchresultslimit) | int | Limit the search job to return up to specified number of rows. |
| [`startSearchTime`](#parameter-searchresultsstartsearchtime) | string | The timestamp to start the search from (UTC). |

### Parameter: `searchResults.query`

The search job query.

- Required: Yes
- Type: string

### Parameter: `searchResults.description`

The search description.

- Required: No
- Type: string

### Parameter: `searchResults.endSearchTime`

The timestamp to end the search by (UTC).

- Required: No
- Type: string

### Parameter: `searchResults.limit`

Limit the search job to return up to specified number of rows.

- Required: No
- Type: int

### Parameter: `searchResults.startSearchTime`

The timestamp to start the search from (UTC).

- Required: No
- Type: string

### Parameter: `totalRetentionInDays`

The table total retention in days, between 4 and 2555. Setting this property to -1 will default to table retention.

- Required: No
- Type: int
- Default: `-1`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the table. |
| `resourceGroupName` | string | The name of the resource group the table was created in. |
| `resourceId` | string | The resource ID of the table. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.2.1` | Remote reference |
