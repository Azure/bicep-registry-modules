# SQL Managed Instance Security Alert Policies `[Microsoft.Sql/managedInstances/securityAlertPolicies]`

This module deploys a SQL Managed Instance Security Alert Policy.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Sql/managedInstances/securityAlertPolicies` | 2024-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.sql_managedinstances_securityalertpolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2024-05-01-preview/managedInstances/securityAlertPolicies)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the security alert policy. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`managedInstanceName`](#parameter-managedinstancename) | string | The name of the parent SQL managed instance. Required if the template is used in a standalone deployment. |
| [`storageAccountResourceId`](#parameter-storageaccountresourceid) | string | A blob storage to hold all Threat Detection audit logs. Required if state is 'Enabled'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`disabledAlerts`](#parameter-disabledalerts) | array | Specifies an array of alerts that are disabled. |
| [`emailAccountAdmins`](#parameter-emailaccountadmins) | bool | Specifies that the schedule scan notification will be is sent to the subscription administrators. |
| [`emailAddresses`](#parameter-emailaddresses) | array | Specifies an array of e-mail addresses to which the alert is sent. |
| [`retentionDays`](#parameter-retentiondays) | int | Specifies the number of days to keep in the Threat Detection audit logs. |
| [`state`](#parameter-state) | string | Enables advanced data security features, like recuring vulnerability assesment scans and ATP. If enabled, storage account must be provided. |

### Parameter: `name`

The name of the security alert policy.

- Required: Yes
- Type: string

### Parameter: `managedInstanceName`

The name of the parent SQL managed instance. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `storageAccountResourceId`

A blob storage to hold all Threat Detection audit logs. Required if state is 'Enabled'.

- Required: No
- Type: string

### Parameter: `disabledAlerts`

Specifies an array of alerts that are disabled.

- Required: No
- Type: array
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

Specifies that the schedule scan notification will be is sent to the subscription administrators.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `emailAddresses`

Specifies an array of e-mail addresses to which the alert is sent.

- Required: No
- Type: array

### Parameter: `retentionDays`

Specifies the number of days to keep in the Threat Detection audit logs.

- Required: No
- Type: int

### Parameter: `state`

Enables advanced data security features, like recuring vulnerability assesment scans and ATP. If enabled, storage account must be provided.

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

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed security alert policy. |
| `resourceGroupName` | string | The resource group of the deployed security alert policy. |
| `resourceId` | string | The resource ID of the deployed security alert policy. |
