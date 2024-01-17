# Log Analytics Workspace Tables `[Microsoft.OperationalInsights/workspaces/tables]`

This module deploys a Log Analytics Workspace Table.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

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
- Default: `{}`

### Parameter: `retentionInDays`

The table retention in days, between 4 and 730. Setting this property to -1 will default to the workspace retention.

- Required: No
- Type: int
- Default: `-1`

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

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
- Default: `{}`

### Parameter: `searchResults`

Parameters of the search job that initiated this table.

- Required: No
- Type: object
- Default: `{}`

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

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
