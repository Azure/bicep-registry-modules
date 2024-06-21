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
| `Microsoft.ApiManagement/service/loggers` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2022-08-01/service/loggers) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`loggerType`](#parameter-loggertype) | string | Logger type. |
| [`name`](#parameter-name) | string | Resource Name. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiManagementServiceName`](#parameter-apimanagementservicename) | string | The name of the parent API Management service. Required if the template is used in a standalone deployment. |
| [`credentials`](#parameter-credentials) | object | Required if loggerType = applicationInsights or azureEventHub. The name and SendRule connection string of the event hub for azureEventHub logger. Instrumentation key for applicationInsights logger. |
| [`targetResourceId`](#parameter-targetresourceid) | string | Required if loggerType = applicationInsights or azureEventHub. Azure Resource Id of a log target (either Azure Event Hub resource or Azure Application Insights resource). |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`isBuffered`](#parameter-isbuffered) | bool | Whether records are buffered in the logger before publishing. Default is assumed to be true. |
| [`loggerDescription`](#parameter-loggerdescription) | string | Logger description. |

### Parameter: `loggerType`

Logger type.

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

Resource Name.

- Required: Yes
- Type: string

### Parameter: `apiManagementServiceName`

The name of the parent API Management service. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `credentials`

Required if loggerType = applicationInsights or azureEventHub. The name and SendRule connection string of the event hub for azureEventHub logger. Instrumentation key for applicationInsights logger.

- Required: Yes
- Type: object

### Parameter: `targetResourceId`

Required if loggerType = applicationInsights or azureEventHub. Azure Resource Id of a log target (either Azure Event Hub resource or Azure Application Insights resource).

- Required: Yes
- Type: string

### Parameter: `isBuffered`

Whether records are buffered in the logger before publishing. Default is assumed to be true.

- Required: Yes
- Type: bool

### Parameter: `loggerDescription`

Logger description.

- Required: Yes
- Type: string


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the logger. |
| `resourceGroupName` | string | The resource group the named value was deployed into. |
| `resourceId` | string | The resource ID of the logger. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
