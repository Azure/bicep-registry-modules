# Recovery Services Vault Replication Policies `[Microsoft.RecoveryServices/vaults/replicationPolicies]`

This module deploys a Recovery Services Vault Replication Policy for Disaster Recovery scenario.

> **Note**: this version of the module only supports the `instanceType: 'A2A'` scenario.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.RecoveryServices/vaults/replicationPolicies` | [2023-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2023-06-01/vaults/replicationPolicies) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the replication policy. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`recoveryVaultName`](#parameter-recoveryvaultname) | string | The name of the parent Azure Recovery Service Vault. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appConsistentFrequencyInMinutes`](#parameter-appconsistentfrequencyinminutes) | int | The app consistent snapshot frequency (in minutes). |
| [`crashConsistentFrequencyInMinutes`](#parameter-crashconsistentfrequencyinminutes) | int | The crash consistent snapshot frequency (in minutes). |
| [`multiVmSyncStatus`](#parameter-multivmsyncstatus) | string | A value indicating whether multi-VM sync has to be enabled. |
| [`recoveryPointHistory`](#parameter-recoverypointhistory) | int | The duration in minutes until which the recovery points need to be stored. |

### Parameter: `name`

The name of the replication policy.

- Required: Yes
- Type: string

### Parameter: `recoveryVaultName`

The name of the parent Azure Recovery Service Vault. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `appConsistentFrequencyInMinutes`

The app consistent snapshot frequency (in minutes).

- Required: No
- Type: int
- Default: `60`

### Parameter: `crashConsistentFrequencyInMinutes`

The crash consistent snapshot frequency (in minutes).

- Required: No
- Type: int
- Default: `5`

### Parameter: `multiVmSyncStatus`

A value indicating whether multi-VM sync has to be enabled.

- Required: No
- Type: string
- Default: `'Enable'`
- Allowed:
  ```Bicep
  [
    'Disable'
    'Enable'
  ]
  ```

### Parameter: `recoveryPointHistory`

The duration in minutes until which the recovery points need to be stored.

- Required: No
- Type: int
- Default: `1440`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the replication policy. |
| `resourceGroupName` | string | The name of the resource group the replication policy was created in. |
| `resourceId` | string | The resource ID of the replication policy. |
