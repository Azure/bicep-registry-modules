# Data Protection Backup Vault Backup Instances `[Microsoft.DataProtection/backupVaults/backupInstances]`

This module deploys a Data Protection Backup Vault Backup Instance.

You can reference the module as follows:
```bicep
module backupVault 'br/public:avm/res/data-protection/backup-vault/backup-instance:<version>' = {
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
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |
| `Microsoft.DataProtection/backupVaults/backupInstances` | 2024-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.dataprotection_backupvaults_backupinstances.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataProtection/2024-04-01/backupVaults/backupInstances)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataSourceInfo`](#parameter-datasourceinfo) | object | Gets or sets the data source information. |
| [`name`](#parameter-name) | string | The name of the backup instance. |
| [`policyInfo`](#parameter-policyinfo) | object | Gets or sets the policy information. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`backupVaultName`](#parameter-backupvaultname) | string | The name of the parent Backup Vault. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`friendlyName`](#parameter-friendlyname) | string | The friendly name of the backup instance. |

### Parameter: `dataSourceInfo`

Gets or sets the data source information.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`datasourceType`](#parameter-datasourceinfodatasourcetype) | string | The data source type of the resource. |
| [`resourceID`](#parameter-datasourceinforesourceid) | string | The resource ID of the resource. |
| [`resourceLocation`](#parameter-datasourceinforesourcelocation) | string | The location of the data source. |
| [`resourceName`](#parameter-datasourceinforesourcename) | string | Unique identifier of the resource in the context of parent. |
| [`resourceType`](#parameter-datasourceinforesourcetype) | string | The resource type of the data source. |
| [`resourceUri`](#parameter-datasourceinforesourceuri) | string | The Uri of the resource. |

### Parameter: `dataSourceInfo.datasourceType`

The data source type of the resource.

- Required: Yes
- Type: string

### Parameter: `dataSourceInfo.resourceID`

The resource ID of the resource.

- Required: Yes
- Type: string

### Parameter: `dataSourceInfo.resourceLocation`

The location of the data source.

- Required: Yes
- Type: string

### Parameter: `dataSourceInfo.resourceName`

Unique identifier of the resource in the context of parent.

- Required: Yes
- Type: string

### Parameter: `dataSourceInfo.resourceType`

The resource type of the data source.

- Required: Yes
- Type: string

### Parameter: `dataSourceInfo.resourceUri`

The Uri of the resource.

- Required: Yes
- Type: string

### Parameter: `name`

The name of the backup instance.

- Required: Yes
- Type: string

### Parameter: `policyInfo`

Gets or sets the policy information.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`policyName`](#parameter-policyinfopolicyname) | string | The name of the backup instance policy. |
| [`policyParameters`](#parameter-policyinfopolicyparameters) | object | Policy parameters for the backup instance. |

### Parameter: `policyInfo.policyName`

The name of the backup instance policy.

- Required: Yes
- Type: string

### Parameter: `policyInfo.policyParameters`

Policy parameters for the backup instance.

- Required: Yes
- Type: object

### Parameter: `backupVaultName`

The name of the parent Backup Vault. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `friendlyName`

The friendly name of the backup instance.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the backup instance. |
| `resourceGroupName` | string | The name of the resource group the backup instance was created in. |
| `resourceId` | string | The resource ID of the backup instance. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
