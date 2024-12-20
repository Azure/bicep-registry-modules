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
| [`replicationContainerMappings`](#parameter-replicationcontainermappings) | array | Replication containers mappings to create. |

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

### Parameter: `replicationContainerMappings`

Replication containers mappings to create.

- Required: No
- Type: array
- Default: `[]`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the replication container. |
| `resourceGroupName` | string | The name of the resource group the replication container was created in. |
| `resourceId` | string | The resource ID of the replication container. |
