# Azure Managed Redis Database Access Policy Assignment `[Microsoft.Cache/redisEnterprise/databases/accessPolicyAssignments]`

This module deploys an access policy assignment for an Azure Managed Redis database.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Cache/redisEnterprise/databases/accessPolicyAssignments` | [2025-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cache/2025-05-01-preview/redisEnterprise/databases/accessPolicyAssignments) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`userObjectId`](#parameter-userobjectid) | string | Object ID to which the access policy will be assigned. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clusterName`](#parameter-clustername) | string | The name of the grandparent Azure Managed Redis cluster. Required if the template is used in a standalone deployment. |
| [`databaseName`](#parameter-databasename) | string | The name of the parent Azure Managed Redis database. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`accessPolicyName`](#parameter-accesspolicyname) | string | Name of the access policy to be assigned. |
| [`name`](#parameter-name) | string | Name of the access policy assignment. |

### Parameter: `userObjectId`

Object ID to which the access policy will be assigned.

- Required: Yes
- Type: string

### Parameter: `clusterName`

The name of the grandparent Azure Managed Redis cluster. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `databaseName`

The name of the parent Azure Managed Redis database. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `accessPolicyName`

Name of the access policy to be assigned.

- Required: No
- Type: string
- Default: `'default'`
- Allowed:
  ```Bicep
  [
    'default'
  ]
  ```

### Parameter: `name`

Name of the access policy assignment.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the access policy assignment. |
| `resourceGroupName` | string | The resource group the access policy assignment was deployed into. |
| `resourceId` | string | The resource ID of the access policy assignment. |
| `userObjectId` | string | The object ID of the user associated with the access policy. |
