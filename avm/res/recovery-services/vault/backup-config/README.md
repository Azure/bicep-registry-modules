# Recovery Services Vault Backup Config `[Microsoft.RecoveryServices/vaults/backupconfig]`

This module deploys a Recovery Services Vault Backup Config.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

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

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
