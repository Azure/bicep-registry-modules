# Azure NetApp Files Backup Policy `[Microsoft.NetApp/netAppAccounts/backupPolicies]`

This module deploys a Backup Policy for Azure NetApp File.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.NetApp/netAppAccounts/backupPolicies` | [2024-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2024-03-01/netAppAccounts/backupPolicies) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`backupPolicyLocation`](#parameter-backuppolicylocation) | string | The location of the backup policy. Required if the template is used in a standalone deployment. |
| [`dailyBackupsToKeep`](#parameter-dailybackupstokeep) | int | The daily backups to keep. |
| [`monthlyBackupsToKeep`](#parameter-monthlybackupstokeep) | int | The monthly backups to keep. |
| [`weeklyBackupsToKeep`](#parameter-weeklybackupstokeep) | int | The weekly backups to keep. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`netAppAccountName`](#parameter-netappaccountname) | string | The name of the parent NetApp account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`backupEnabled`](#parameter-backupenabled) | bool | Indicates whether the backup policy is enabled. |
| [`backupPolicyName`](#parameter-backuppolicyname) | string | The name of the backup policy. |

### Parameter: `backupPolicyLocation`

The location of the backup policy. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `dailyBackupsToKeep`

The daily backups to keep.

- Required: Yes
- Type: int

### Parameter: `monthlyBackupsToKeep`

The monthly backups to keep.

- Required: Yes
- Type: int

### Parameter: `weeklyBackupsToKeep`

The weekly backups to keep.

- Required: Yes
- Type: int

### Parameter: `netAppAccountName`

The name of the parent NetApp account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `backupEnabled`

Indicates whether the backup policy is enabled.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `backupPolicyName`

The name of the backup policy.

- Required: No
- Type: string
- Default: `'backupPolicy'`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Backup Policy. |
| `resourceGroupName` | string | The name of the Resource Group the Backup Policy was created in. |
| `resourceId` | string | The resource IDs of the backup Policy created within volume. |
