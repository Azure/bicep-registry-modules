# Recovery Services Vault Replication Fabric Replication Protection Container Replication Protection Container Mappings `[Microsoft.RecoveryServices/vaults/replicationFabrics/replicationProtectionContainers/replicationProtectionContainerMappings]`

This module deploys a Recovery Services Vault (RSV) Replication Protection Container Mapping.

> **Note**: this version of the module only supports the `instanceType: 'A2A'` scenario.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.RecoveryServices/vaults/replicationFabrics/replicationProtectionContainers/replicationProtectionContainerMappings` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2022-10-01/vaults/replicationFabrics/replicationProtectionContainers/replicationProtectionContainerMappings) |

## Parameters

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`recoveryVaultName`](#parameter-recoveryvaultname) | string | The name of the parent Azure Recovery Service Vault. Required if the template is used in a standalone deployment. |
| [`replicationFabricName`](#parameter-replicationfabricname) | string | The name of the parent Replication Fabric. Required if the template is used in a standalone deployment. |
| [`sourceProtectionContainerName`](#parameter-sourceprotectioncontainername) | string | The name of the parent source Replication container. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`name`](#parameter-name) | string | The name of the replication container mapping. If not provided, it will be automatically generated as `<source_container_name>-<target_container_name>`. |
| [`policyId`](#parameter-policyid) | string | Resource ID of the replication policy. If defined, policyName will be ignored. |
| [`policyName`](#parameter-policyname) | string | Name of the replication policy. Will be ignored if policyId is also specified. |
| [`targetContainerFabricName`](#parameter-targetcontainerfabricname) | string | Name of the fabric containing the target container. If targetProtectionContainerId is specified, this parameter will be ignored. |
| [`targetContainerName`](#parameter-targetcontainername) | string | Name of the target container. Must be specified if targetProtectionContainerId is not. If targetProtectionContainerId is specified, this parameter will be ignored. |
| [`targetProtectionContainerId`](#parameter-targetprotectioncontainerid) | string | Resource ID of the target Replication container. Must be specified if targetContainerName is not. If specified, targetContainerFabricName and targetContainerName will be ignored. |

### Parameter: `recoveryVaultName`

The name of the parent Azure Recovery Service Vault. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `replicationFabricName`

The name of the parent Replication Fabric. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `sourceProtectionContainerName`

The name of the parent source Replication container. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).

- Required: No
- Type: bool
- Default: `True`

### Parameter: `name`

The name of the replication container mapping. If not provided, it will be automatically generated as `<source_container_name>-<target_container_name>`.

- Required: No
- Type: string
- Default: `''`

### Parameter: `policyId`

Resource ID of the replication policy. If defined, policyName will be ignored.

- Required: No
- Type: string
- Default: `''`

### Parameter: `policyName`

Name of the replication policy. Will be ignored if policyId is also specified.

- Required: No
- Type: string
- Default: `''`

### Parameter: `targetContainerFabricName`

Name of the fabric containing the target container. If targetProtectionContainerId is specified, this parameter will be ignored.

- Required: No
- Type: string
- Default: `[parameters('replicationFabricName')]`

### Parameter: `targetContainerName`

Name of the target container. Must be specified if targetProtectionContainerId is not. If targetProtectionContainerId is specified, this parameter will be ignored.

- Required: No
- Type: string
- Default: `''`

### Parameter: `targetProtectionContainerId`

Resource ID of the target Replication container. Must be specified if targetContainerName is not. If specified, targetContainerFabricName and targetContainerName will be ignored.

- Required: No
- Type: string
- Default: `''`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the replication container. |
| `resourceGroupName` | string | The name of the resource group the replication container was created in. |
| `resourceId` | string | The resource ID of the replication container. |

## Cross-referenced modules

_None_
