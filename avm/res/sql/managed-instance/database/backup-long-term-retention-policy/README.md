# SQL Managed Instance Database Backup Long-Term Retention Policies `[Microsoft.Sql/managedInstances/databases/backupLongTermRetentionPolicies]`

This module deploys a SQL Managed Instance Database Backup Long-Term Retention Policy.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Sql/managedInstances/databases/backupLongTermRetentionPolicies` | [2022-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-05-01-preview/managedInstances/databases/backupLongTermRetentionPolicies) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the Long Term Retention backup policy. For example "default". |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`databaseName`](#parameter-databasename) | string | The name of the parent managed instance database. Required if the template is used in a standalone deployment. |
| [`managedInstanceName`](#parameter-managedinstancename) | string | The name of the parent managed instance. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`monthlyRetention`](#parameter-monthlyretention) | string | The monthly retention policy for an LTR backup in an ISO 8601 format. |
| [`weeklyRetention`](#parameter-weeklyretention) | string | The weekly retention policy for an LTR backup in an ISO 8601 format. |
| [`weekOfYear`](#parameter-weekofyear) | int | The week of year to take the yearly backup in an ISO 8601 format. |
| [`yearlyRetention`](#parameter-yearlyretention) | string | The yearly retention policy for an LTR backup in an ISO 8601 format. |

### Parameter: `name`

The name of the Long Term Retention backup policy. For example "default".

- Required: Yes
- Type: string

### Parameter: `databaseName`

The name of the parent managed instance database. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `managedInstanceName`

The name of the parent managed instance. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `monthlyRetention`

The monthly retention policy for an LTR backup in an ISO 8601 format.

- Required: No
- Type: string
- Default: `'P1Y'`

### Parameter: `weeklyRetention`

The weekly retention policy for an LTR backup in an ISO 8601 format.

- Required: No
- Type: string
- Default: `'P1M'`

### Parameter: `weekOfYear`

The week of year to take the yearly backup in an ISO 8601 format.

- Required: No
- Type: int
- Default: `5`

### Parameter: `yearlyRetention`

The yearly retention policy for an LTR backup in an ISO 8601 format.

- Required: No
- Type: string
- Default: `'P5Y'`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed database backup long-term retention policy. |
| `resourceGroupName` | string | The resource group of the deployed database backup long-term retention policy. |
| `resourceId` | string | The resource ID of the deployed database backup long-term retention policy. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
