# CDN Profiles Endpoints `[Microsoft.Cdn/profiles/endpoints]`

This module deploys a CDN Profile Endpoint.

You can reference the module as follows:
```bicep
module profile 'br/public:avm/res/cdn/profile/endpoint:<version>' = {
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
| `Microsoft.Cdn/profiles/endpoints` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cdn_profiles_endpoints.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2025-06-01/profiles/endpoints)</li></ul> |
| `Microsoft.Cdn/profiles/endpoints/origins` | 2025-04-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cdn_profiles_endpoints_origins.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2025-04-15/profiles/endpoints/origins)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the endpoint under the profile which is unique globally. |
| [`properties`](#parameter-properties) | object | Endpoint properties (see https://learn.microsoft.com/en-us/azure/templates/microsoft.cdn/profiles/endpoints?pivots=deployment-language-bicep#endpointproperties for details). |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`profileName`](#parameter-profilename) | string | The name of the parent CDN profile. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Resource location. |
| [`tags`](#parameter-tags) | object | Endpoint tags. |

### Parameter: `name`

Name of the endpoint under the profile which is unique globally.

- Required: Yes
- Type: string

### Parameter: `properties`

Endpoint properties (see https://learn.microsoft.com/en-us/azure/templates/microsoft.cdn/profiles/endpoints?pivots=deployment-language-bicep#endpointproperties for details).

- Required: Yes
- Type: object

### Parameter: `profileName`

The name of the parent CDN profile. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Resource location.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `tags`

Endpoint tags.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `endpointProperties` | object | The properties of the endpoint. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the endpoint. |
| `resourceGroupName` | string | The name of the resource group the endpoint was created in. |
| `resourceId` | string | The resource ID of the endpoint. |
| `uri` | string | The uri of the endpoint. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
