# Recovery Service Vaults Protection Container Protected Item `[Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems]`

This module deploys a Recovery Services Vault Protection Container Protected Item.

You can reference the module as follows:
```bicep
module vault 'br/public:avm/res/recovery-services/vault/backup-fabric/protection-container/protected-item:<version>' = {
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
| `Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems` | 2024-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.recoveryservices_vaults_backupfabrics_protectioncontainers_protecteditems.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2024-10-01/vaults/backupFabrics/protectionContainers/protectedItems)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the resource. |
| [`policyName`](#parameter-policyname) | string | The backup policy with which this item is backed up. |
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
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location for all resources. |

### Parameter: `name`

Name of the resource.

- Required: Yes
- Type: string

### Parameter: `policyName`

The backup policy with which this item is backed up.

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

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

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

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
