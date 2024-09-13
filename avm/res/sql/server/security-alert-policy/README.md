# Azure SQL Server Security Alert Policies `[Microsoft.Sql/servers/securityAlertPolicies]`

This module deploys an Azure SQL Server Security Alert Policy.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Sql/servers/securityAlertPolicies` | [2023-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/servers/securityAlertPolicies) |

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
| [`disabledAlerts`](#parameter-disabledalerts) | array | Specifies an array of alerts that are disabled. Allowed values are: Sql_Injection, Sql_Injection_Vulnerability, Access_Anomaly, Data_Exfiltration, Unsafe_Action, Brute_Force. |
| [`emailAccountAdmins`](#parameter-emailaccountadmins) | bool | Specifies that the alert is sent to the account administrators. |
| [`emailAddresses`](#parameter-emailaddresses) | array | Specifies an array of email addresses to which the alert is sent. |
| [`retentionDays`](#parameter-retentiondays) | int | Specifies the number of days to keep in the Threat Detection audit logs. |
| [`state`](#parameter-state) | string | Specifies the state of the policy, whether it is enabled or disabled or a policy has not been applied yet on the specific database. |
| [`storageAccountAccessKey`](#parameter-storageaccountaccesskey) | securestring | Specifies the identifier key of the Threat Detection audit storage account.. |
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

Specifies an array of alerts that are disabled. Allowed values are: Sql_Injection, Sql_Injection_Vulnerability, Access_Anomaly, Data_Exfiltration, Unsafe_Action, Brute_Force.

- Required: No
- Type: array
- Default: `[]`

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

Specifies the identifier key of the Threat Detection audit storage account..

- Required: No
- Type: securestring
- Default: `''`

### Parameter: `storageEndpoint`

Specifies the blob storage endpoint. This blob storage will hold all Threat Detection audit logs.

- Required: No
- Type: string
- Default: `''`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed security alert policy. |
| `resourceGroupName` | string | The resource group of the deployed security alert policy. |
| `resourceId` | string | The resource ID of the deployed security alert policy. |
