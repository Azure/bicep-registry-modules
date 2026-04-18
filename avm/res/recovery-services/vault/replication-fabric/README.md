# Recovery Services Vault Replication Fabrics `[Microsoft.RecoveryServices/vaults/replicationFabrics]`

This module deploys a Replication Fabric for Azure to Azure disaster recovery scenario of Azure Site Recovery.

> Note: this module currently support only the `instanceType: 'Azure'` scenario.

You can reference the module as follows:
```bicep
module vault 'br/public:avm/res/recovery-services/vault/replication-fabric:<version>' = {
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
| `Microsoft.RecoveryServices/vaults/replicationFabrics` | 2022-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.recoveryservices_vaults_replicationfabrics.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2022-10-01/vaults/replicationFabrics)</li></ul> |
| `Microsoft.RecoveryServices/vaults/replicationFabrics/replicationProtectionContainers` | 2022-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.recoveryservices_vaults_replicationfabrics_replicationprotectioncontainers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2022-10-01/vaults/replicationFabrics/replicationProtectionContainers)</li></ul> |
| `Microsoft.RecoveryServices/vaults/replicationFabrics/replicationProtectionContainers/replicationProtectionContainerMappings` | 2022-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.recoveryservices_vaults_replicationfabrics_replicationprotectioncontainers_replicationprotectioncontainermappings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2022-10-01/vaults/replicationFabrics/replicationProtectionContainers/replicationProtectionContainerMappings)</li></ul> |

## Parameters

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`recoveryVaultName`](#parameter-recoveryvaultname) | string | The name of the parent Azure Recovery Service Vault. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | The recovery location the fabric represents. |
| [`name`](#parameter-name) | string | The name of the fabric. |
| [`replicationContainers`](#parameter-replicationcontainers) | array | Replication containers to create. |

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

The recovery location the fabric represents.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `name`

The name of the fabric.

- Required: No
- Type: string
- Default: `[parameters('location')]`

### Parameter: `replicationContainers`

Replication containers to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-replicationcontainersname) | string | The name of the replication container. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`mappings`](#parameter-replicationcontainersmappings) | array | Replication containers mappings to create. |

### Parameter: `replicationContainers.name`

The name of the replication container.

- Required: Yes
- Type: string

### Parameter: `replicationContainers.mappings`

Replication containers mappings to create.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-replicationcontainersmappingsname) | string | The name of the replication container mapping. If not provided, it will be automatically generated as `<source_container_name>-<target_container_name>`. |
| [`policyName`](#parameter-replicationcontainersmappingspolicyname) | string | Name of the replication policy. Will be ignored if policyResourceId is also specified. |
| [`policyResourceId`](#parameter-replicationcontainersmappingspolicyresourceid) | string | Resource ID of the replication policy. If defined, policyName will be ignored. |
| [`targetContainerFabricName`](#parameter-replicationcontainersmappingstargetcontainerfabricname) | string | Name of the fabric containing the target container. If targetProtectionContainerResourceId is specified, this parameter will be ignored. |
| [`targetContainerName`](#parameter-replicationcontainersmappingstargetcontainername) | string | Name of the target container. Must be specified if targetProtectionContainerResourceId is not. If targetProtectionContainerResourceId is specified, this parameter will be ignored. |
| [`targetProtectionContainerResourceId`](#parameter-replicationcontainersmappingstargetprotectioncontainerresourceid) | string | Resource ID of the target Replication container. Must be specified if targetContainerName is not. If specified, targetContainerFabricName and targetContainerName will be ignored. |

### Parameter: `replicationContainers.mappings.name`

The name of the replication container mapping. If not provided, it will be automatically generated as `<source_container_name>-<target_container_name>`.

- Required: No
- Type: string

### Parameter: `replicationContainers.mappings.policyName`

Name of the replication policy. Will be ignored if policyResourceId is also specified.

- Required: No
- Type: string

### Parameter: `replicationContainers.mappings.policyResourceId`

Resource ID of the replication policy. If defined, policyName will be ignored.

- Required: No
- Type: string

### Parameter: `replicationContainers.mappings.targetContainerFabricName`

Name of the fabric containing the target container. If targetProtectionContainerResourceId is specified, this parameter will be ignored.

- Required: No
- Type: string

### Parameter: `replicationContainers.mappings.targetContainerName`

Name of the target container. Must be specified if targetProtectionContainerResourceId is not. If targetProtectionContainerResourceId is specified, this parameter will be ignored.

- Required: No
- Type: string

### Parameter: `replicationContainers.mappings.targetProtectionContainerResourceId`

Resource ID of the target Replication container. Must be specified if targetContainerName is not. If specified, targetContainerFabricName and targetContainerName will be ignored.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the replication fabric. |
| `resourceGroupName` | string | The name of the resource group the replication fabric was created in. |
| `resourceId` | string | The resource ID of the replication fabric. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
