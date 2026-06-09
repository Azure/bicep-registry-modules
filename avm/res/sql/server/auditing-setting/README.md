# Azure SQL Server Audit Settings `[Microsoft.Sql/servers/auditingSettings]`

This module deploys an Azure SQL Server Audit Settings.

You can reference the module as follows:
```bicep
module server 'br/public:avm/res/sql/server/auditing-setting:<version>' = {
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
| `Microsoft.Sql/servers/auditingSettings` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.sql_servers_auditingsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2025-01-01/servers/auditingSettings)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the audit settings. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`serverName`](#parameter-servername) | string | The Name of SQL Server. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`auditActionsAndGroups`](#parameter-auditactionsandgroups) | array | Specifies the Actions-Groups and Actions to audit. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`isAzureMonitorTargetEnabled`](#parameter-isazuremonitortargetenabled) | bool | Specifies whether audit events are sent to Azure Monitor. |
| [`isDevopsAuditEnabled`](#parameter-isdevopsauditenabled) | bool | Specifies the state of devops audit. If state is Enabled, devops logs will be sent to Azure Monitor. |
| [`isManagedIdentityInUse`](#parameter-ismanagedidentityinuse) | bool | Specifies whether Managed Identity is used to access blob storage. |
| [`isStorageSecondaryKeyInUse`](#parameter-isstoragesecondarykeyinuse) | bool | Specifies whether storageAccountAccessKey value is the storage's secondary key. |
| [`queueDelayMs`](#parameter-queuedelayms) | int | Specifies the amount of time in milliseconds that can elapse before audit actions are forced to be processed. |
| [`retentionDays`](#parameter-retentiondays) | int | Specifies the number of days to keep in the audit logs in the storage account. |
| [`state`](#parameter-state) | string | Specifies the state of the audit. If state is Enabled, storageEndpoint or isAzureMonitorTargetEnabled are required. |
| [`storageAccountResourceId`](#parameter-storageaccountresourceid) | string | A blob storage to hold the auditing storage account. |

### Parameter: `name`

The name of the audit settings.

- Required: Yes
- Type: string

### Parameter: `serverName`

The Name of SQL Server. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `auditActionsAndGroups`

Specifies the Actions-Groups and Actions to audit.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    'BATCH_COMPLETED_GROUP'
    'FAILED_DATABASE_AUTHENTICATION_GROUP'
    'SUCCESSFUL_DATABASE_AUTHENTICATION_GROUP'
  ]
  ```

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `isAzureMonitorTargetEnabled`

Specifies whether audit events are sent to Azure Monitor.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `isDevopsAuditEnabled`

Specifies the state of devops audit. If state is Enabled, devops logs will be sent to Azure Monitor.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `isManagedIdentityInUse`

Specifies whether Managed Identity is used to access blob storage.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `isStorageSecondaryKeyInUse`

Specifies whether storageAccountAccessKey value is the storage's secondary key.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `queueDelayMs`

Specifies the amount of time in milliseconds that can elapse before audit actions are forced to be processed.

- Required: No
- Type: int
- Default: `1000`

### Parameter: `retentionDays`

Specifies the number of days to keep in the audit logs in the storage account.

- Required: No
- Type: int
- Default: `90`

### Parameter: `state`

Specifies the state of the audit. If state is Enabled, storageEndpoint or isAzureMonitorTargetEnabled are required.

- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `storageAccountResourceId`

A blob storage to hold the auditing storage account.

- Required: No
- Type: string
- Default: `''`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed audit settings. |
| `resourceGroupName` | string | The resource group of the deployed audit settings. |
| `resourceId` | string | The resource ID of the deployed audit settings. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
