#  `[Microsoft.NetApp/netAppAccounts/backupVaults]`


## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.NetApp/netAppAccounts/backupVaults` | [2024-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2024-03-01/netAppAccounts/backupVaults) |
| `Microsoft.NetApp/netAppAccounts/backupVaults/backups` | [2024-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2024-03-01/netAppAccounts/backupVaults/backups) |

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
| [`volumeName`](#parameter-backupsvolumename) | string | The name used to identify the volume. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`label`](#parameter-backupslabel) | string | Label for backup. |
| [`name`](#parameter-backupsname) | string | The name of the backup. |
| [`snapshotName`](#parameter-backupssnapshotname) | string | The name of the snapshot. |
| [`useExistingSnapshot`](#parameter-backupsuseexistingsnapshot) | bool | Manual backup an already existing snapshot. This will always be false for scheduled backups and true/false for manual backups. |

### Parameter: `backups.volumeName`

The name used to identify the volume.

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

### Parameter: `backups.useExistingSnapshot`

Manual backup an already existing snapshot. This will always be false for scheduled backups and true/false for manual backups.

- Required: No
- Type: bool

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
