# Recovery Services Vault Protection Container `[Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers]`

This module deploys a Recovery Services Vault Protection Container.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2023-01-01/vaults/backupFabrics/protectionContainers) |
| `Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2023-01-01/vaults/backupFabrics/protectionContainers/protectedItems) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Azure Recovery Service Vault Protection Container. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`recoveryVaultName`](#parameter-recoveryvaultname) | string | The name of the parent Azure Recovery Service Vault. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`backupManagementType`](#parameter-backupmanagementtype) | string | Backup management type to execute the current Protection Container job. |
| [`containerType`](#parameter-containertype) | string | Type of the container. |
| [`friendlyName`](#parameter-friendlyname) | string | Friendly name of the Protection Container. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`protectedItems`](#parameter-protecteditems) | array | Protected items to register in the container. |
| [`sourceResourceId`](#parameter-sourceresourceid) | string | Resource ID of the target resource for the Protection Container. |

### Parameter: `name`

Name of the Azure Recovery Service Vault Protection Container.

- Required: Yes
- Type: string

### Parameter: `recoveryVaultName`

The name of the parent Azure Recovery Service Vault. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `backupManagementType`

Backup management type to execute the current Protection Container job.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureBackupServer'
    'AzureIaasVM'
    'AzureSql'
    'AzureStorage'
    'AzureWorkload'
    'DefaultBackup'
    'DPM'
    'Invalid'
    'MAB'
  ]
  ```

### Parameter: `containerType`

Type of the container.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureBackupServerContainer'
    'AzureSqlContainer'
    'GenericContainer'
    'Microsoft.ClassicCompute/virtualMachines'
    'Microsoft.Compute/virtualMachines'
    'SQLAGWorkLoadContainer'
    'StorageContainer'
    'VMAppContainer'
    'Windows'
  ]
  ```

### Parameter: `friendlyName`

Friendly name of the Protection Container.

- Required: No
- Type: string

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `protectedItems`

Protected items to register in the container.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `sourceResourceId`

Resource ID of the target resource for the Protection Container.

- Required: No
- Type: string


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The Name of the Protection Container. |
| `resourceGroupName` | string | The name of the Resource Group the Protection Container was created in. |
| `resourceId` | string | The resource ID of the Protection Container. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
