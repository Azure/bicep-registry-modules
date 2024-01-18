# Web Site Basic Publishing Credentials Policies `[Microsoft.Web/sites/basicPublishingCredentialsPolicies]`

This module deploys a Web Site Basic Publishing Credentials Policy.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Web/sites/basicPublishingCredentialsPolicies` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/sites) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the resource. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`webAppName`](#parameter-webappname) | string | The name of the parent web site. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allow`](#parameter-allow) | bool | Set to true to enable or false to disable a publishing method. |
| [`location`](#parameter-location) | string | Location for all Resources. |

### Parameter: `name`

The name of the resource.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'ftp'
    'scm'
  ]
  ```

### Parameter: `webAppName`

The name of the parent web site. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `allow`

Set to true to enable or false to disable a publishing method.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location for all Resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the basic publishing credential policy. |
| `resourceGroupName` | string | The name of the resource group the basic publishing credential policy was deployed into. |
| `resourceId` | string | The resource ID of the basic publishing credential policy. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
