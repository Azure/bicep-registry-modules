# SQL Managed Instance Database Backup Long-Term Retention Policies `[Microsoft.Sql/managedInstances/databases/backupLongTermRetentionPolicies]`

This module deploys a SQL Managed Instance Database Backup Long-Term Retention Policy.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Sql/managedInstances/databases/backupLongTermRetentionPolicies` | [2024-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2024-05-01-preview/managedInstances/databases/backupLongTermRetentionPolicies) |

## Parameters

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`databaseName`](#parameter-databasename) | string | The name of the parent managed instance database. Required if the template is used in a standalone deployment. |
| [`managedInstanceName`](#parameter-managedinstancename) | string | The name of the parent managed instance. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`backupStorageAccessTier`](#parameter-backupstorageaccesstier) | string | The BackupStorageAccessTier for the LTR backups. |
| [`monthlyRetention`](#parameter-monthlyretention) | string | The monthly retention policy for an LTR backup in an ISO 8601 format. |
| [`name`](#parameter-name) | string | The name of the Long Term Retention backup policy. |
| [`weeklyRetention`](#parameter-weeklyretention) | string | The weekly retention policy for an LTR backup in an ISO 8601 format. |
| [`weekOfYear`](#parameter-weekofyear) | int | The week of year to take the yearly backup in an ISO 8601 format. |
| [`yearlyRetention`](#parameter-yearlyretention) | string | The yearly retention policy for an LTR backup in an ISO 8601 format. |

### Parameter: `databaseName`

The name of the parent managed instance database. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `managedInstanceName`

The name of the parent managed instance. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `backupStorageAccessTier`

The BackupStorageAccessTier for the LTR backups.

- Required: No
- Type: string
- Default: `'Hot'`
- Allowed:
  ```Bicep
  [
    'Archive'
    'Hot'
  ]
  ```

### Parameter: `monthlyRetention`

The monthly retention policy for an LTR backup in an ISO 8601 format.

- Required: No
- Type: string
- Default: `'P1Y'`

### Parameter: `name`

The name of the Long Term Retention backup policy.

- Required: No
- Type: string
- Default: `'default'`

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
