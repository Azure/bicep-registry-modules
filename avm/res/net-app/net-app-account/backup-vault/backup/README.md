#  `[Microsoft.NetApp/netAppAccounts/backupVaults/backups]`


## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.NetApp/netAppAccounts/backupVaults/backups` | [2024-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2024-03-01/netAppAccounts/backupVaults/backups) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`volumeName`](#parameter-volumename) | string | The name used to identify the volume. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`backupVaultName`](#parameter-backupvaultname) | string | The name of the parent backup vault. Required if the template is used in a standalone deployment. |
| [`netAppAccountName`](#parameter-netappaccountname) | string | The name of the parent NetApp account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`label`](#parameter-label) | string | Label for backup. |
| [`name`](#parameter-name) | string | The name of the backup. |
| [`snapshotName`](#parameter-snapshotname) | string | The name of the snapshot. |
| [`useExistingSnapshot`](#parameter-useexistingsnapshot) | bool | Manual backup an already existing snapshot. This will always be false for scheduled backups and true/false for manual backups. |

### Parameter: `volumeName`

The name used to identify the volume.

- Required: Yes
- Type: string

### Parameter: `backupVaultName`

The name of the parent backup vault. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `netAppAccountName`

The name of the parent NetApp account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `label`

Label for backup.

- Required: No
- Type: string

### Parameter: `name`

The name of the backup.

- Required: No
- Type: string
- Default: `'backup'`

### Parameter: `snapshotName`

The name of the snapshot.

- Required: No
- Type: string
- Default: `'snapshot'`

### Parameter: `useExistingSnapshot`

Manual backup an already existing snapshot. This will always be false for scheduled backups and true/false for manual backups.

- Required: No
- Type: bool
- Default: `False`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the backup. |
| `resourceGroupName` | string | The name of the Resource Group the backup was created in. |
| `resourceId` | string | The Resource ID of the backup. |
