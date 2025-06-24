# Azure NetApp Files Volume Backup Vault `[Microsoft.NetApp/netAppAccounts/backupVaults]`

This module deploys a NetApp Files Backup Vault.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.NetApp/netAppAccounts/backupVaults` | [2025-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2025-01-01/netAppAccounts/backupVaults) |
| `Microsoft.NetApp/netAppAccounts/backupVaults/backups` | [2025-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2025-01-01/netAppAccounts/backupVaults/backups) |

## Parameters

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`netAppAccountName`](#parameter-netappaccountname) | string | The name of the parent NetApp account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`backups`](#parameter-backups) | array | The list of backups to create. |
| [`location`](#parameter-location) | string | Location of the backup vault. |
| [`name`](#parameter-name) | string | The name of the backup vault. |

### Parameter: `netAppAccountName`

The name of the parent NetApp account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `backups`

The list of backups to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`capacityPoolName`](#parameter-backupscapacitypoolname) | string | The name of the capacity pool containing the volume. |
| [`volumeName`](#parameter-backupsvolumename) | string | The name of the volume to backup. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`label`](#parameter-backupslabel) | string | Label for backup. |
| [`name`](#parameter-backupsname) | string | The name of the backup. |
| [`snapshotName`](#parameter-backupssnapshotname) | string | The name of the snapshot. |

### Parameter: `backups.capacityPoolName`

The name of the capacity pool containing the volume.

- Required: Yes
- Type: string

### Parameter: `backups.volumeName`

The name of the volume to backup.

- Required: Yes
- Type: string

### Parameter: `backups.label`

Label for backup.

- Required: No
- Type: string

### Parameter: `backups.name`

The name of the backup.

- Required: No
- Type: string

### Parameter: `backups.snapshotName`

The name of the snapshot.

- Required: No
- Type: string

### Parameter: `location`

Location of the backup vault.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `name`

The name of the backup vault.

- Required: No
- Type: string
- Default: `'vault'`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the backup vault. |
| `resourceGroupName` | string | The name of the Resource Group the backup vault was created in. |
| `resourceId` | string | The Resource ID of the backup vault. |
