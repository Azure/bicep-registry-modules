# App Configuration Stores Key Values `[Microsoft.AppConfiguration/configurationStores/keyValues]`

This module deploys an App Configuration Store Key Value.

You can reference the module as follows:
```bicep
module configurationStore 'br/public:avm/res/app-configuration/configuration-store/key-value:<version>' = {
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
| `Microsoft.AppConfiguration/configurationStores/keyValues` | 2025-02-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.appconfiguration_configurationstores_keyvalues.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.AppConfiguration/2025-02-01-preview/configurationStores/keyValues)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the key. |
| [`value`](#parameter-value) | string | The value of the key-value. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appConfigurationName`](#parameter-appconfigurationname) | string | The name of the parent app configuration store. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`contentType`](#parameter-contenttype) | string | The content type of the key-values value. Providing a proper content-type can enable transformations of values when they are retrieved by applications. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `name`

Name of the key.

- Required: Yes
- Type: string

### Parameter: `value`

The value of the key-value.

- Required: Yes
- Type: string

### Parameter: `appConfigurationName`

The name of the parent app configuration store. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `contentType`

The content type of the key-values value. Providing a proper content-type can enable transformations of values when they are retrieved by applications.

- Required: No
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the key values. |
| `resourceGroupName` | string | The resource group the batch account was deployed into. |
| `resourceId` | string | The resource ID of the key values. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
