# SQL Managed Instances Administrator `[Microsoft.Sql/managedInstances/administrators]`

This module deploys a SQL Managed Instance Administrator.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Sql/managedInstances/administrators` | [2023-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/managedInstances/administrators) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`login`](#parameter-login) | string | Login name of the managed instance administrator. |
| [`sid`](#parameter-sid) | string | SID (object ID) of the managed instance administrator. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`managedInstanceName`](#parameter-managedinstancename) | string | The name of the parent SQL managed instance. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`tenantId`](#parameter-tenantid) | string | Tenant ID of the managed instance administrator. |

### Parameter: `login`

Login name of the managed instance administrator.

- Required: Yes
- Type: string

### Parameter: `sid`

SID (object ID) of the managed instance administrator.

- Required: Yes
- Type: string

### Parameter: `managedInstanceName`

The name of the parent SQL managed instance. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `tenantId`

Tenant ID of the managed instance administrator.

- Required: No
- Type: string
- Default: `''`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed managed instance administrator. |
| `resourceGroupName` | string | The resource group of the deployed managed instance administrator. |
| `resourceId` | string | The resource ID of the deployed managed instance administrator. |
