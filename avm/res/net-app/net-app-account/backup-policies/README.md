#  `[Microsoft.NetApp/netAppAccounts/backupPolicies]`


## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.NetApp/netAppAccounts/backupPolicies` | [2024-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2024-03-01/netAppAccounts/backupPolicies) |

## Parameters

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`netAppAccountName`](#parameter-netappaccountname) | string | The name of the parent NetApp account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`backupEnabled`](#parameter-backupenabled) | bool | Indicates whether the backup policy is enabled. |
| [`backupPolicyLocation`](#parameter-backuppolicylocation) | string | The location of the backup policy. |
| [`backupPolicyName`](#parameter-backuppolicyname) | string | The name of the backup policy. |
| [`dailyBackupsToKeep`](#parameter-dailybackupstokeep) | int | The daily backups to keep. |
| [`monthlyBackupsToKeep`](#parameter-monthlybackupstokeep) | int | The monthly backups to keep. |
| [`weeklyBackupsToKeep`](#parameter-weeklybackupstokeep) | int | The weekly backups to keep. |

### Parameter: `netAppAccountName`

The name of the parent NetApp account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `backupEnabled`

Indicates whether the backup policy is enabled.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `backupPolicyLocation`

The location of the backup policy.

- Required: Yes
- Type: string

### Parameter: `backupPolicyName`

The name of the backup policy.

- Required: No
- Type: string
- Default: `'backupPolicy'`

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

## Outputs

| Output | Type |
| :-- | :-- |
| `id` | string |
