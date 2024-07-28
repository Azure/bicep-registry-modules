# SQL Managed Instance Security Alert Policies `[Microsoft.Sql/managedInstances/securityAlertPolicies]`

This module deploys a SQL Managed Instance Security Alert Policy.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Sql/managedInstances/securityAlertPolicies` | [2023-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/managedInstances/securityAlertPolicies) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the security alert policy. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`managedInstanceName`](#parameter-managedinstancename) | string | The name of the parent SQL managed instance. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`emailAccountAdmins`](#parameter-emailaccountadmins) | bool | Specifies that the schedule scan notification will be is sent to the subscription administrators. |
| [`state`](#parameter-state) | string | Enables advanced data security features, like recuring vulnerability assesment scans and ATP. If enabled, storage account must be provided. |

### Parameter: `name`

The name of the security alert policy.

- Required: Yes
- Type: string

### Parameter: `managedInstanceName`

The name of the parent SQL managed instance. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `emailAccountAdmins`

Specifies that the schedule scan notification will be is sent to the subscription administrators.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `state`

Enables advanced data security features, like recuring vulnerability assesment scans and ATP. If enabled, storage account must be provided.

- Required: No
- Type: string
- Default: `'Disabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed security alert policy. |
| `resourceGroupName` | string | The resource group of the deployed security alert policy. |
| `resourceId` | string | The resource ID of the deployed security alert policy. |
