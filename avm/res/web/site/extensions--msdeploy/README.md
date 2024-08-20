# Site Deployment Extension  `[Microsoft.Web/sites/extensions]`

This module deploys a Site extension for MSDeploy.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Web/sites/extensions` | [2023-12-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/sites/extensions) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appName`](#parameter-appname) | string | The name of the parent site resource. |
| [`msDeployConfiguration`](#parameter-msdeployconfiguration) | object | Sets the MSDeployment Properties. |

### Parameter: `appName`

The name of the parent site resource.

- Required: Yes
- Type: string

### Parameter: `msDeployConfiguration`

Sets the MSDeployment Properties.

- Required: No
- Type: object


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the MSDeploy Package. |
| `resourceGroupName` | string | The resource group the site config was deployed into. |
| `resourceId` | string | The resource ID of the Site Extension. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
