# SQL Managed Instance Security Alert Policies `[Microsoft.Sql/managedInstances/securityAlertPolicies]`

This module deploys a SQL Managed Instance Security Alert Policy.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

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

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
