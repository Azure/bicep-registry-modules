# Static Web App Site Config `[Microsoft.Web/staticSites/config]`

This module deploys a Static Web App Site Config.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Web/staticSites/config` | [2022-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/staticSites/config) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-kind) | string | Type of settings to apply. |
| [`properties`](#parameter-properties) | object | App settings. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`staticSiteName`](#parameter-staticsitename) | string | The name of the parent Static Web App. Required if the template is used in a standalone deployment. |

### Parameter: `kind`

Type of settings to apply.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'appsettings'
    'functionappsettings'
  ]
  ```

### Parameter: `properties`

App settings.

- Required: Yes
- Type: object

### Parameter: `staticSiteName`

The name of the parent Static Web App. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the config. |
| `resourceGroupName` | string | The name of the resource group the config was created in. |
| `resourceId` | string | The resource ID of the config. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
