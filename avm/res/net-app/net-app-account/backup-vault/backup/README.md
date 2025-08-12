# Azure NetApp Files Volume Backup `[Microsoft.NetApp/netAppAccounts/backupVaults/backups]`

This module deploys a backup of a NetApp Files Volume.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.NetApp/netAppAccounts/backupVaults/backups` | [2025-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2025-01-01/netAppAccounts/backupVaults/backups) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`capacityPoolName`](#parameter-capacitypoolname) | string | The name of the capacity pool containing the volume. |
| [`volumeName`](#parameter-volumename) | string | The name of the volume to backup. |

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

### Parameter: `capacityPoolName`

The name of the capacity pool containing the volume.

- Required: Yes
- Type: string

### Parameter: `volumeName`

The name of the volume to backup.

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

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the backup. |
| `resourceGroupName` | string | The name of the Resource Group the backup was created in. |
| `resourceId` | string | The Resource ID of the backup. |
