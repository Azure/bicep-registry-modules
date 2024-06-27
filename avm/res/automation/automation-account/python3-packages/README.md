# Automation Account Python 3 Packages `[Microsoft.Automation/automationAccounts/python3Packages]`

This module deploys a Python3 Package in the Automation Account.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Automation/automationAccounts/python3Packages` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Automation/2023-11-01/automationAccounts/python3Packages) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Python3 Automation Account package. |
| [`uri`](#parameter-uri) | string | Package URI, e.g. https://www.powershellgallery.com/api/v2/package. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`automationAccountName`](#parameter-automationaccountname) | string | The name of the parent Automation Account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`tags`](#parameter-tags) | object | Tags of the Automation Account resource. |
| [`version`](#parameter-version) | string | Package version or specify latest to get the latest version. |

### Parameter: `name`

Name of the Python3 Automation Account package.

- Required: Yes
- Type: string

### Parameter: `uri`

Package URI, e.g. https://www.powershellgallery.com/api/v2/package.

- Required: Yes
- Type: string

### Parameter: `automationAccountName`

The name of the parent Automation Account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `tags`

Tags of the Automation Account resource.

- Required: No
- Type: object

### Parameter: `version`

Package version or specify latest to get the latest version.

- Required: No
- Type: string
- Default: `'latest'`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed package. |
| `resourceGroupName` | string | The resource group of the deployed package. |
| `resourceId` | string | The resource ID of the deployed package. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
