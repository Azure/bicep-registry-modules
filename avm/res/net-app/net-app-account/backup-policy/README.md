# Azure NetApp Files Backup Policy `[Microsoft.NetApp/netAppAccounts/backupPolicies]`

This module deploys a Backup Policy for Azure NetApp File.

You can reference the module as follows:
```bicep
module netAppAccount 'br/public:avm/res/net-app/net-app-account/backup-policy:<version>' = {
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
| `Microsoft.NetApp/netAppAccounts/backupPolicies` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.netapp_netappaccounts_backuppolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2025-01-01/netAppAccounts/backupPolicies)</li></ul> |

## Parameters

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`netAppAccountName`](#parameter-netappaccountname) | string | The name of the parent NetApp account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dailyBackupsToKeep`](#parameter-dailybackupstokeep) | int | The daily backups to keep. Note, the maximum hourly, daily, weekly, and monthly backup retention counts _combined_ is 1019 (this parameter's max). |
| [`enabled`](#parameter-enabled) | bool | Indicates whether the backup policy is enabled. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | The location of the backup policy. |
| [`monthlyBackupsToKeep`](#parameter-monthlybackupstokeep) | int | The monthly backups to keep. Note, the maximum hourly, daily, weekly, and monthly backup retention counts _combined_ is 1019 (this parameter's max). |
| [`name`](#parameter-name) | string | The name of the backup policy. |
| [`weeklyBackupsToKeep`](#parameter-weeklybackupstokeep) | int | The weekly backups to keep. Note, the maximum hourly, daily, weekly, and monthly backup retention counts _combined_ is 1019 (this parameter's max). |

### Parameter: `netAppAccountName`

The name of the parent NetApp account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `dailyBackupsToKeep`

The daily backups to keep. Note, the maximum hourly, daily, weekly, and monthly backup retention counts _combined_ is 1019 (this parameter's max).

- Required: No
- Type: int
- Default: `2`
- MinValue: 2
- MaxValue: 1019

### Parameter: `enabled`

Indicates whether the backup policy is enabled.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

The location of the backup policy.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `monthlyBackupsToKeep`

The monthly backups to keep. Note, the maximum hourly, daily, weekly, and monthly backup retention counts _combined_ is 1019 (this parameter's max).

- Required: No
- Type: int
- Default: `0`
- MinValue: 0
- MaxValue: 1019

### Parameter: `name`

The name of the backup policy.

- Required: No
- Type: string
- Default: `'backupPolicy'`

### Parameter: `weeklyBackupsToKeep`

The weekly backups to keep. Note, the maximum hourly, daily, weekly, and monthly backup retention counts _combined_ is 1019 (this parameter's max).

- Required: No
- Type: int
- Default: `0`
- MinValue: 0
- MaxValue: 1019

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Backup Policy. |
| `resourceGroupName` | string | The name of the Resource Group the Backup Policy was created in. |
| `resourceId` | string | The resource IDs of the backup Policy created within volume. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
