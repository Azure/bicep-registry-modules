# Recovery Services Vault Replication Fabric Replication Protection Containers `[Microsoft.RecoveryServices/vaults/replicationFabrics/replicationProtectionContainers]`

This module deploys a Recovery Services Vault Replication Protection Container.

> **Note**: this version of the module only supports the `instanceType: 'A2A'` scenario.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.RecoveryServices/vaults/replicationFabrics/replicationProtectionContainers` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2022-10-01/vaults/replicationFabrics/replicationProtectionContainers) |
| `Microsoft.RecoveryServices/vaults/replicationFabrics/replicationProtectionContainers/replicationProtectionContainerMappings` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2022-10-01/vaults/replicationFabrics/replicationProtectionContainers/replicationProtectionContainerMappings) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the replication container. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`recoveryVaultName`](#parameter-recoveryvaultname) | string | The name of the parent Azure Recovery Service Vault. Required if the template is used in a standalone deployment. |
| [`replicationFabricName`](#parameter-replicationfabricname) | string | The name of the parent Replication Fabric. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`mappings`](#parameter-mappings) | array | Replication containers mappings to create. |

### Parameter: `name`

The name of the replication container.

- Required: Yes
- Type: string

### Parameter: `recoveryVaultName`

The name of the parent Azure Recovery Service Vault. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `replicationFabricName`

The name of the parent Replication Fabric. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `mappings`

Replication containers mappings to create.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-mappingsname) | string | The name of the replication container mapping. If not provided, it will be automatically generated as `<source_container_name>-<target_container_name>`. |
| [`policyName`](#parameter-mappingspolicyname) | string | Name of the replication policy. Will be ignored if policyResourceId is also specified. |
| [`policyResourceId`](#parameter-mappingspolicyresourceid) | string | Resource ID of the replication policy. If defined, policyName will be ignored. |
| [`targetContainerFabricName`](#parameter-mappingstargetcontainerfabricname) | string | Name of the fabric containing the target container. If targetProtectionContainerResourceId is specified, this parameter will be ignored. |
| [`targetContainerName`](#parameter-mappingstargetcontainername) | string | Name of the target container. Must be specified if targetProtectionContainerResourceId is not. If targetProtectionContainerResourceId is specified, this parameter will be ignored. |
| [`targetProtectionContainerResourceId`](#parameter-mappingstargetprotectioncontainerresourceid) | string | Resource ID of the target Replication container. Must be specified if targetContainerName is not. If specified, targetContainerFabricName and targetContainerName will be ignored. |

### Parameter: `mappings.name`

The name of the replication container mapping. If not provided, it will be automatically generated as `<source_container_name>-<target_container_name>`.

- Required: No
- Type: string

### Parameter: `mappings.policyName`

Name of the replication policy. Will be ignored if policyResourceId is also specified.

- Required: No
- Type: string

### Parameter: `mappings.policyResourceId`

Resource ID of the replication policy. If defined, policyName will be ignored.

- Required: No
- Type: string

### Parameter: `mappings.targetContainerFabricName`

Name of the fabric containing the target container. If targetProtectionContainerResourceId is specified, this parameter will be ignored.

- Required: No
- Type: string

### Parameter: `mappings.targetContainerName`

Name of the target container. Must be specified if targetProtectionContainerResourceId is not. If targetProtectionContainerResourceId is specified, this parameter will be ignored.

- Required: No
- Type: string

### Parameter: `mappings.targetProtectionContainerResourceId`

Resource ID of the target Replication container. Must be specified if targetContainerName is not. If specified, targetContainerFabricName and targetContainerName will be ignored.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the replication container. |
| `resourceGroupName` | string | The name of the resource group the replication container was created in. |
| `resourceId` | string | The resource ID of the replication container. |
