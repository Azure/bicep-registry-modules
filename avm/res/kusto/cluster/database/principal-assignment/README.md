# Kusto Cluster Database Principal Assignments `[Microsoft.Kusto/clusters/databases/principalAssignments]`

This module deploys a Kusto Cluster Database Principal Assignment.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Kusto/clusters/databases/principalAssignments` | [2024-04-13](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Kusto/2024-04-13/clusters/databases/principalAssignments) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kustoClusterName`](#parameter-kustoclustername) | string | The name of the Kusto cluster. |
| [`kustoDatabaseName`](#parameter-kustodatabasename) | string | The name of the parent Kusto Cluster Database. Required if the template is used in a standalone deployment. |
| [`principalId`](#parameter-principalid) | string | The principal id assigned to the Kusto Cluster database principal. It can be a user email, application id, or security group name. |
| [`principalType`](#parameter-principaltype) | string | The principal type of the principal id. |
| [`role`](#parameter-role) | string | The Kusto Cluster database role to be assigned to the principal id. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`tenantId`](#parameter-tenantid) | string | The tenant id of the principal. |

### Parameter: `kustoClusterName`

The name of the Kusto cluster.

- Required: Yes
- Type: string

### Parameter: `kustoDatabaseName`

The name of the parent Kusto Cluster Database. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `principalId`

The principal id assigned to the Kusto Cluster database principal. It can be a user email, application id, or security group name.

- Required: Yes
- Type: string

### Parameter: `principalType`

The principal type of the principal id.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'App'
    'Group'
    'User'
  ]
  ```

### Parameter: `role`

The Kusto Cluster database role to be assigned to the principal id.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Admin'
    'Ingestor'
    'Monitor'
    'UnrestrictedViewer'
    'User'
    'Viewer'
  ]
  ```

### Parameter: `tenantId`

The tenant id of the principal.

- Required: No
- Type: string
- Default: `[tenant().tenantId]`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed Kusto Cluster Database Principal Assignment. |
| `resourceGroupName` | string | The resource group name of the deployed Kusto Cluster Database Principal Assignment. |
| `resourceId` | string | The resource id of the deployed Kusto Cluster Database Principal Assignment. |
