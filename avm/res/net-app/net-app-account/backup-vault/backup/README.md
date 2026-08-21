# Azure NetApp Files Volume Backup `[Microsoft.NetApp/netAppAccounts/backupVaults/backups]`

This module deploys a backup of a NetApp Files Volume.

You can reference the module as follows:
```bicep
module netAppAccount 'br/public:avm/res/net-app/net-app-account/backup-vault/backup:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.NetApp/netAppAccounts/backupVaults/backups` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.netapp_netappaccounts_backupvaults_backups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2025-01-01/netAppAccounts/backupVaults/backups)</li></ul> |

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
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
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

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

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

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
