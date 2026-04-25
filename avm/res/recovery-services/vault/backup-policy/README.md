# Recovery Services Vault Backup Policies `[Microsoft.RecoveryServices/vaults/backupPolicies]`

This module deploys a Recovery Services Vault Backup Policy.

You can reference the module as follows:
```bicep
module vault 'br/public:avm/res/recovery-services/vault/backup-policy:<version>' = {
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
| `Microsoft.RecoveryServices/vaults/backupPolicies` | 2024-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.recoveryservices_vaults_backuppolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2024-10-01/vaults/backupPolicies)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Azure Recovery Service Vault Backup Policy. |
| [`properties`](#parameter-properties) | object | Configuration of the Azure Recovery Service Vault Backup Policy. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`recoveryVaultName`](#parameter-recoveryvaultname) | string | The name of the parent Azure Recovery Service Vault. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |

### Parameter: `name`

Name of the Azure Recovery Service Vault Backup Policy.

- Required: Yes
- Type: string

### Parameter: `properties`

Configuration of the Azure Recovery Service Vault Backup Policy.

- Required: Yes
- Type: object

### Parameter: `recoveryVaultName`

The name of the parent Azure Recovery Service Vault. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the backup policy. |
| `resourceGroupName` | string | The name of the resource group the backup policy was created in. |
| `resourceId` | string | The resource ID of the backup policy. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
