# Recovery Services Vault Backup Storage Config `[Microsoft.RecoveryServices/vaults/backupstorageconfig]`

This module deploys a Recovery Service Vault Backup Storage Configuration.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

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
