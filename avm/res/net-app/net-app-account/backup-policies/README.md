# Azure NetApp Files Backup Policy `[Microsoft.NetApp/netAppAccounts/backupPolicies]`

This module deploys a Backup Policy for Azure NetApp File.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.NetApp/netAppAccounts/backupPolicies` | [2024-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2024-07-01/netAppAccounts/backupPolicies) |

## Parameters

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`netAppAccountName`](#parameter-netappaccountname) | string | The name of the parent NetApp account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dailyBackupsToKeep`](#parameter-dailybackupstokeep) | int | The daily backups to keep. |
| [`enabled`](#parameter-enabled) | bool | Indicates whether the backup policy is enabled. |
| [`location`](#parameter-location) | string | The location of the backup policy. |
| [`monthlyBackupsToKeep`](#parameter-monthlybackupstokeep) | int | The monthly backups to keep. |
| [`name`](#parameter-name) | string | The name of the backup policy. |
| [`weeklyBackupsToKeep`](#parameter-weeklybackupstokeep) | int | The weekly backups to keep. |

### Parameter: `netAppAccountName`

The name of the parent NetApp account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `dailyBackupsToKeep`

The daily backups to keep.

- Required: No
- Type: int
- Default: `2`
- MinValue: 2
- MaxValue: 1019

### Parameter: `enabled`

Indicates whether the backup policy is enabled.

- Required: No
- Type: bool
- Default: `True`
- MinValue: 2
- MaxValue: 1019

### Parameter: `location`

The location of the backup policy.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`
- MinValue: 2
- MaxValue: 1019

### Parameter: `monthlyBackupsToKeep`

The monthly backups to keep.

- Required: No
- Type: int
- Default: `0`
- MinValue: 2
- MaxValue: 1019

### Parameter: `name`

The name of the backup policy.

- Required: No
- Type: string
- Default: `'backupPolicy'`
- MinValue: 2
- MaxValue: 1019

### Parameter: `weeklyBackupsToKeep`

The weekly backups to keep.

- Required: No
- Type: int
- Default: `0`
- MinValue: 2
- MaxValue: 1019

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Backup Policy. |
| `resourceGroupName` | string | The name of the Resource Group the Backup Policy was created in. |
| `resourceId` | string | The resource IDs of the backup Policy created within volume. |
