# Recovery Services Vault Backup Config `[Microsoft.RecoveryServices/vaults/backupconfig]`

This module deploys a Recovery Services Vault Backup Config.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.RecoveryServices/vaults/backupconfig` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2023-01-01/vaults/backupconfig) |

## Parameters

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`recoveryVaultName`](#parameter-recoveryvaultname) | string | The name of the parent Azure Recovery Service Vault. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enhancedSecurityState`](#parameter-enhancedsecuritystate) | string | Enable this setting to protect hybrid backups against accidental deletes and add additional layer of authentication for critical operations. |
| [`isSoftDeleteFeatureStateEditable`](#parameter-issoftdeletefeaturestateeditable) | bool | Is soft delete feature state editable. |
| [`name`](#parameter-name) | string | Name of the Azure Recovery Service Vault Backup Policy. |
| [`resourceGuardOperationRequests`](#parameter-resourceguardoperationrequests) | array | ResourceGuard Operation Requests. |
| [`softDeleteFeatureState`](#parameter-softdeletefeaturestate) | string | Enable this setting to protect backup data for Azure VM, SQL Server in Azure VM and SAP HANA in Azure VM from accidental deletes. |
| [`storageModelType`](#parameter-storagemodeltype) | string | Storage type. |
| [`storageType`](#parameter-storagetype) | string | Storage type. |
| [`storageTypeState`](#parameter-storagetypestate) | string | Once a machine is registered against a resource, the storageTypeState is always Locked. |

### Parameter: `recoveryVaultName`

The name of the parent Azure Recovery Service Vault. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `enhancedSecurityState`

Enable this setting to protect hybrid backups against accidental deletes and add additional layer of authentication for critical operations.

- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `isSoftDeleteFeatureStateEditable`

Is soft delete feature state editable.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `name`

Name of the Azure Recovery Service Vault Backup Policy.

- Required: No
- Type: string
- Default: `'vaultconfig'`

### Parameter: `resourceGuardOperationRequests`

ResourceGuard Operation Requests.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `softDeleteFeatureState`

Enable this setting to protect backup data for Azure VM, SQL Server in Azure VM and SAP HANA in Azure VM from accidental deletes.

- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `storageModelType`

Storage type.

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

### Parameter: `storageType`

Storage type.

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

### Parameter: `storageTypeState`

Once a machine is registered against a resource, the storageTypeState is always Locked.

- Required: No
- Type: string
- Default: `'Locked'`
- Allowed:
  ```Bicep
  [
    'Locked'
    'Unlocked'
  ]
  ```

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the backup config. |
| `resourceGroupName` | string | The name of the resource group the backup config was created in. |
| `resourceId` | string | The resource ID of the backup config. |
