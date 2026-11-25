# Azure SQL Server Security Alert Policies `[Microsoft.Sql/servers/securityAlertPolicies]`

This module deploys an Azure SQL Server Security Alert Policy.

You can reference the module as follows:
```bicep
module server 'br/public:avm/res/sql/server/security-alert-policy:<version>' = {
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
| `Microsoft.Sql/servers/securityAlertPolicies` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.sql_servers_securityalertpolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2025-01-01/servers/securityAlertPolicies)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the Security Alert Policy. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`serverName`](#parameter-servername) | string | The name of the parent SQL Server. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`disabledAlerts`](#parameter-disabledalerts) | array | Alerts to disable. |
| [`emailAccountAdmins`](#parameter-emailaccountadmins) | bool | Specifies that the alert is sent to the account administrators. |
| [`emailAddresses`](#parameter-emailaddresses) | array | Specifies an array of email addresses to which the alert is sent. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`retentionDays`](#parameter-retentiondays) | int | Specifies the number of days to keep in the Threat Detection audit logs. |
| [`state`](#parameter-state) | string | Specifies the state of the policy, whether it is enabled or disabled or a policy has not been applied yet on the specific database. |
| [`storageAccountAccessKey`](#parameter-storageaccountaccesskey) | securestring | Specifies the identifier key of the Threat Detection audit storage account. |
| [`storageEndpoint`](#parameter-storageendpoint) | string | Specifies the blob storage endpoint. This blob storage will hold all Threat Detection audit logs. |

### Parameter: `name`

The name of the Security Alert Policy.

- Required: Yes
- Type: string

### Parameter: `serverName`

The name of the parent SQL Server. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `disabledAlerts`

Alerts to disable.

- Required: No
- Type: array
- Default: `[]`
- Allowed:
  ```Bicep
  [
    'Access_Anomaly'
    'Brute_Force'
    'Data_Exfiltration'
    'Sql_Injection'
    'Sql_Injection_Vulnerability'
    'Unsafe_Action'
  ]
  ```

### Parameter: `emailAccountAdmins`

Specifies that the alert is sent to the account administrators.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `emailAddresses`

Specifies an array of email addresses to which the alert is sent.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `retentionDays`

Specifies the number of days to keep in the Threat Detection audit logs.

- Required: No
- Type: int
- Default: `0`

### Parameter: `state`

Specifies the state of the policy, whether it is enabled or disabled or a policy has not been applied yet on the specific database.

- Required: No
- Type: string
- Default: `'Disabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `storageAccountAccessKey`

Specifies the identifier key of the Threat Detection audit storage account.

- Required: No
- Type: securestring

### Parameter: `storageEndpoint`

Specifies the blob storage endpoint. This blob storage will hold all Threat Detection audit logs.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed security alert policy. |
| `resourceGroupName` | string | The resource group of the deployed security alert policy. |
| `resourceId` | string | The resource ID of the deployed security alert policy. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
