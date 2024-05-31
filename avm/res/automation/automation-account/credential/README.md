# Automation Account Credentials `[Microsoft.Automation/automationAccounts/credentials]`

This module deploys Azure Automation Account Credentials.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Automation/automationAccounts/credentials` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Automation/2023-11-01/automationAccounts/credentials) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Automation Account module. |
| [`password`](#parameter-password) | securestring | Password of the credential. |
| [`userName`](#parameter-username) | string | The user name associated to the credential. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`automationAccountName`](#parameter-automationaccountname) | string | The name of the parent Automation Account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`credentialDescription`](#parameter-credentialdescription) | string | Description of the credential. |

### Parameter: `name`

Name of the Automation Account module.

- Required: Yes
- Type: string

### Parameter: `password`

Password of the credential.

- Required: Yes
- Type: securestring

### Parameter: `userName`

The user name associated to the credential.

- Required: Yes
- Type: string

### Parameter: `automationAccountName`

The name of the parent Automation Account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `credentialDescription`

Description of the credential.

- Required: No
- Type: string
- Default: `''`


## Outputs

| Output | Type |
| :-- | :-- |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
