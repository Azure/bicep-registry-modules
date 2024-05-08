# SQL Managed Instance Database Backup Short-Term Retention Policies `[Microsoft.Sql/managedInstances/databases/backupShortTermRetentionPolicies]`

This module deploys a SQL Managed Instance Database Backup Short-Term Retention Policy.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Sql/managedInstances/databases/backupShortTermRetentionPolicies` | [2023-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/managedInstances/databases/backupShortTermRetentionPolicies) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the Short Term Retention backup policy. For example "default". |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`databaseName`](#parameter-databasename) | string | The name of the parent SQL managed instance database. Required if the template is used in a standalone deployment. |
| [`managedInstanceName`](#parameter-managedinstancename) | string | The name of the parent SQL managed instance. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`retentionDays`](#parameter-retentiondays) | int | The backup retention period in days. This is how many days Point-in-Time Restore will be supported. |

### Parameter: `name`

The name of the Short Term Retention backup policy. For example "default".

- Required: Yes
- Type: string

### Parameter: `databaseName`

The name of the parent SQL managed instance database. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `managedInstanceName`

The name of the parent SQL managed instance. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `retentionDays`

The backup retention period in days. This is how many days Point-in-Time Restore will be supported.

- Required: No
- Type: int
- Default: `35`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed database backup short-term retention policy. |
| `resourceGroupName` | string | The resource group of the deployed database backup short-term retention policy. |
| `resourceId` | string | The resource ID of the deployed database backup short-term retention policy. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
