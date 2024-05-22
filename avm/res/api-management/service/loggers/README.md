# API Management Service Loggers `[Microsoft.ApiManagement/service/loggers]`

This module deploys an API Management Service Logger.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service/loggers` | [2021-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/loggers) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appInsightsName`](#parameter-appinsightsname) | string | Reference app insights instance. |
| [`loggerType`](#parameter-loggertype) | string | The logger type for API Management. |
| [`name`](#parameter-name) | string | API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiManagementServiceName`](#parameter-apimanagementservicename) | string | The name of the parent API Management service. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`isBuffered`](#parameter-isbuffered) | bool | Whether records are buffered in the logger before publishing. Default is assumed to be true. |
| [`loggerDescription`](#parameter-loggerdescription) | string | Logger description. |

### Parameter: `appInsightsName`

Reference app insights instance.

- Required: Yes
- Type: string

### Parameter: `loggerType`

The logger type for API Management.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'applicationInsights'
    'azureEventHub'
    'azureMonitor'
  ]
  ```

### Parameter: `name`

API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.

- Required: Yes
- Type: string

### Parameter: `apiManagementServiceName`

The name of the parent API Management service. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `isBuffered`

Whether records are buffered in the logger before publishing. Default is assumed to be true.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `loggerDescription`

Logger description.

- Required: No
- Type: string
- Default: `'Logger to Azure Application Insights'`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the API management service logger. |
| `resourceGroupName` | string | The resource group the API management service API was deployed to. |
| `resourceId` | string | The resource ID of the API management service logger. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
