# API Management Service API Version Sets `[Microsoft.ApiManagement/service/apiVersionSets]`

This module deploys an API Management Service API Version Set.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.ApiManagement/service/apiVersionSets` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_apiversionsets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/apiVersionSets)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`displayName`](#parameter-displayname) | string | The display name of the Name of API Version Set. |
| [`versioningScheme`](#parameter-versioningscheme) | string | An value that determines where the API Version identifier will be located in a HTTP request. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiManagementServiceName`](#parameter-apimanagementservicename) | string | The name of the parent API Management service. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-description) | string | Description of API Version Set. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`name`](#parameter-name) | string | API Version set name. |
| [`versionHeaderName`](#parameter-versionheadername) | string | Name of HTTP header parameter that indicates the API Version if versioningScheme is set to header. |
| [`versionQueryName`](#parameter-versionqueryname) | string | Name of query parameter that indicates the API Version if versioningScheme is set to query. |

### Parameter: `displayName`

The display name of the Name of API Version Set.

- Required: Yes
- Type: string

### Parameter: `versioningScheme`

An value that determines where the API Version identifier will be located in a HTTP request.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Header'
    'Query'
    'Segment'
  ]
  ```

### Parameter: `apiManagementServiceName`

The name of the parent API Management service. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `description`

Description of API Version Set.

- Required: No
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `name`

API Version set name.

- Required: No
- Type: string
- Default: `'default'`

### Parameter: `versionHeaderName`

Name of HTTP header parameter that indicates the API Version if versioningScheme is set to header.

- Required: No
- Type: string

### Parameter: `versionQueryName`

Name of query parameter that indicates the API Version if versioningScheme is set to query.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the API Version set. |
| `resourceGroupName` | string | The resource group the API Version set was deployed into. |
| `resourceId` | string | The resource ID of the API Version set. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
