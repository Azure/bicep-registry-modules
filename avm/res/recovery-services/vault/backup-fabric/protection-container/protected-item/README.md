# Recovery Service Vaults Protection Container Protected Item `[Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems]`

This module deploys a Recovery Services Vault Protection Container Protected Item.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2023-01-01/vaults/backupFabrics/protectionContainers/protectedItems) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the resource. |
| [`policyId`](#parameter-policyid) | string | ID of the backup policy with which this item is backed up. |
| [`protectedItemType`](#parameter-protecteditemtype) | string | The backup item type. |
| [`sourceResourceId`](#parameter-sourceresourceid) | string | Resource ID of the resource to back up. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`protectionContainerName`](#parameter-protectioncontainername) | string | Name of the Azure Recovery Service Vault Protection Container. Required if the template is used in a standalone deployment. |
| [`recoveryVaultName`](#parameter-recoveryvaultname) | string | The name of the parent Azure Recovery Service Vault. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`location`](#parameter-location) | string | Location for all resources. |

### Parameter: `name`

Name of the resource.

- Required: Yes
- Type: string

### Parameter: `policyId`

ID of the backup policy with which this item is backed up.

- Required: Yes
- Type: string

### Parameter: `protectedItemType`

The backup item type.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureFileShareProtectedItem'
    'AzureVmWorkloadSAPAseDatabase'
    'AzureVmWorkloadSAPHanaDatabase'
    'AzureVmWorkloadSQLDatabase'
    'DPMProtectedItem'
    'GenericProtectedItem'
    'MabFileFolderProtectedItem'
    'Microsoft.ClassicCompute/virtualMachines'
    'Microsoft.Compute/virtualMachines'
    'Microsoft.Sql/servers/databases'
  ]
  ```

### Parameter: `sourceResourceId`

Resource ID of the resource to back up.

- Required: Yes
- Type: string

### Parameter: `protectionContainerName`

Name of the Azure Recovery Service Vault Protection Container. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `recoveryVaultName`

The name of the parent Azure Recovery Service Vault. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The Name of the protected item. |
| `resourceGroupName` | string | The name of the Resource Group the protected item was created in. |
| `resourceId` | string | The resource ID of the protected item. |
