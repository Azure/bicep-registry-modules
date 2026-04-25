# Recovery Services Vault Replication Policies `[Microsoft.RecoveryServices/vaults/replicationPolicies]`

This module deploys a Recovery Services Vault Replication Policy for Disaster Recovery scenario.

> **Note**: this version of the module only supports the `instanceType: 'A2A'` scenario.

You can reference the module as follows:
```bicep
module vault 'br/public:avm/res/recovery-services/vault/replication-policy:<version>' = {
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
| `Microsoft.RecoveryServices/vaults/replicationPolicies` | 2023-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.recoveryservices_vaults_replicationpolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2023-06-01/vaults/replicationPolicies)</li></ul> |

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
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
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

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

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

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
