# Automation Account Variables `[Microsoft.Automation/automationAccounts/variables]`

This module deploys an Azure Automation Account Variable.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Automation/automationAccounts/variables` | [2022-08-08](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Automation/2022-08-08/automationAccounts/variables) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the variable. |
| [`value`](#parameter-value) | securestring | The value of the variable. For security best practices, this value is always passed as a secure string as it could contain an encrypted value when the "isEncrypted" property is set to true. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`automationAccountName`](#parameter-automationaccountname) | string | The name of the parent Automation Account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-description) | string | The description of the variable. |
| [`isEncrypted`](#parameter-isencrypted) | bool | If the variable should be encrypted. For security reasons encryption of variables should be enabled. |

### Parameter: `name`

The name of the variable.

- Required: Yes
- Type: string

### Parameter: `value`

The value of the variable. For security best practices, this value is always passed as a secure string as it could contain an encrypted value when the "isEncrypted" property is set to true.

- Required: Yes
- Type: securestring

### Parameter: `automationAccountName`

The name of the parent Automation Account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `description`

The description of the variable.

- Required: No
- Type: string
- Default: `''`

### Parameter: `isEncrypted`

If the variable should be encrypted. For security reasons encryption of variables should be enabled.

- Required: No
- Type: bool
- Default: `True`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed variable. |
| `resourceGroupName` | string | The resource group of the deployed variable. |
| `resourceId` | string | The resource ID of the deployed variable. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
