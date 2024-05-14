# Automation Account Modules `[Microsoft.Automation/automationAccounts/modules]`

This module deploys an Azure Automation Account Module.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Automation/automationAccounts/modules` | [2022-08-08](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Automation/2022-08-08/automationAccounts/modules) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Automation Account module. |
| [`uri`](#parameter-uri) | string | Module package URI, e.g. https://www.powershellgallery.com/api/v2/package. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`automationAccountName`](#parameter-automationaccountname) | string | The name of the parent Automation Account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`tags`](#parameter-tags) | object | Tags of the Automation Account resource. |
| [`version`](#parameter-version) | string | Module version or specify latest to get the latest version. |

### Parameter: `name`

Name of the Automation Account module.

- Required: Yes
- Type: string

### Parameter: `uri`

Module package URI, e.g. https://www.powershellgallery.com/api/v2/package.

- Required: Yes
- Type: string

### Parameter: `automationAccountName`

The name of the parent Automation Account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `tags`

Tags of the Automation Account resource.

- Required: No
- Type: object

### Parameter: `version`

Module version or specify latest to get the latest version.

- Required: No
- Type: string
- Default: `'latest'`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed module. |
| `resourceGroupName` | string | The resource group of the deployed module. |
| `resourceId` | string | The resource ID of the deployed module. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
