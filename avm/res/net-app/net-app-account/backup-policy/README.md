# Azure NetApp Files Backup Policy `[Microsoft.NetApp/netAppAccounts/backupPolicies]`

This module deploys a Backup Policy for Azure NetApp File.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.NetApp/netAppAccounts/backupPolicies` | [2025-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2025-01-01/netAppAccounts/backupPolicies) |

## Parameters

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`netAppAccountName`](#parameter-netappaccountname) | string | The name of the parent NetApp account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dailyBackupsToKeep`](#parameter-dailybackupstokeep) | int | The daily backups to keep. Note, the maximum hourly, daily, weekly, and monthly backup retention counts _combined_ is 1019 (this parameter's max). |
| [`enabled`](#parameter-enabled) | bool | Indicates whether the backup policy is enabled. |
| [`location`](#parameter-location) | string | The location of the backup policy. |
| [`monthlyBackupsToKeep`](#parameter-monthlybackupstokeep) | int | The monthly backups to keep. Note, the maximum hourly, daily, weekly, and monthly backup retention counts _combined_ is 1019 (this parameter's max). |
| [`name`](#parameter-name) | string | The name of the backup policy. |
| [`weeklyBackupsToKeep`](#parameter-weeklybackupstokeep) | int | The weekly backups to keep. Note, the maximum hourly, daily, weekly, and monthly backup retention counts _combined_ is 1019 (this parameter's max). |

### Parameter: `netAppAccountName`

The name of the parent NetApp account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `dailyBackupsToKeep`

The daily backups to keep. Note, the maximum hourly, daily, weekly, and monthly backup retention counts _combined_ is 1019 (this parameter's max).

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

### Parameter: `location`

The location of the backup policy.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `monthlyBackupsToKeep`

The monthly backups to keep. Note, the maximum hourly, daily, weekly, and monthly backup retention counts _combined_ is 1019 (this parameter's max).

- Required: No
- Type: int
- Default: `0`
- MinValue: 0
- MaxValue: 1019

### Parameter: `name`

The name of the backup policy.

- Required: No
- Type: string
- Default: `'backupPolicy'`

### Parameter: `weeklyBackupsToKeep`

The weekly backups to keep. Note, the maximum hourly, daily, weekly, and monthly backup retention counts _combined_ is 1019 (this parameter's max).

- Required: No
- Type: int
- Default: `0`
- MinValue: 0
- MaxValue: 1019

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Backup Policy. |
| `resourceGroupName` | string | The name of the Resource Group the Backup Policy was created in. |
| `resourceId` | string | The resource IDs of the backup Policy created within volume. |
