# Recovery Services Vault Backup Storage Config `[Microsoft.RecoveryServices/vaults/backupstorageconfig]`

This module deploys a Recovery Service Vault Backup Storage Configuration.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.RecoveryServices/vaults/backupstorageconfig` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2023-01-01/vaults/backupstorageconfig) |

## Parameters

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`recoveryVaultName`](#parameter-recoveryvaultname) | string | The name of the parent Azure Recovery Service Vault. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`crossRegionRestoreFlag`](#parameter-crossregionrestoreflag) | bool | Opt in details of Cross Region Restore feature. |
| [`name`](#parameter-name) | string | The name of the backup storage config. |
| [`storageModelType`](#parameter-storagemodeltype) | string | Change Vault Storage Type (Works if vault has not registered any backup instance). |

### Parameter: `recoveryVaultName`

The name of the parent Azure Recovery Service Vault. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `crossRegionRestoreFlag`

Opt in details of Cross Region Restore feature.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `name`

The name of the backup storage config.

- Required: No
- Type: string
- Default: `'vaultstorageconfig'`

### Parameter: `storageModelType`

Change Vault Storage Type (Works if vault has not registered any backup instance).

- Required: No
- Type: string
- Default: `'GeoRedundant'`
- Allowed:
  ```Bicep
  [
    'GeoRedundant'
    'LocallyRedundant'
    'ReadAccessGeoZoneRedundant'
    'ZoneRedundant'
  ]
  ```


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the backup storage config. |
| `resourceGroupName` | string | The name of the Resource Group the backup storage configuration was created in. |
| `resourceId` | string | The resource ID of the backup storage config. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
