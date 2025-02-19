# Recovery Services Vault Replication Fabrics `[Microsoft.RecoveryServices/vaults/replicationFabrics]`

This module deploys a Replication Fabric for Azure to Azure disaster recovery scenario of Azure Site Recovery.

> Note: this module currently support only the `instanceType: 'Azure'` scenario.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.RecoveryServices/vaults/replicationFabrics` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2022-10-01/vaults/replicationFabrics) |
| `Microsoft.RecoveryServices/vaults/replicationFabrics/replicationProtectionContainers` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2022-10-01/vaults/replicationFabrics/replicationProtectionContainers) |
| `Microsoft.RecoveryServices/vaults/replicationFabrics/replicationProtectionContainers/replicationProtectionContainerMappings` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2022-10-01/vaults/replicationFabrics/replicationProtectionContainers/replicationProtectionContainerMappings) |

## Parameters

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`recoveryVaultName`](#parameter-recoveryvaultname) | string | The name of the parent Azure Recovery Service Vault. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`location`](#parameter-location) | string | The recovery location the fabric represents. |
| [`name`](#parameter-name) | string | The name of the fabric. |
| [`replicationContainers`](#parameter-replicationcontainers) | array | Replication containers to create. |

### Parameter: `recoveryVaultName`

The name of the parent Azure Recovery Service Vault. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

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
