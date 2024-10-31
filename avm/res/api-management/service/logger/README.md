# API Management Service Loggers `[Microsoft.ApiManagement/service/loggers]`

This module deploys an API Management Service Logger.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

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
| [`credentials`](#parameter-credentials) | secureObject | Required if loggerType = applicationInsights or azureEventHub. The name and SendRule connection string of the event hub for azureEventHub logger. Instrumentation key for applicationInsights logger. |
| [`targetResourceId`](#parameter-targetresourceid) | string | Required if loggerType = applicationInsights or azureEventHub. Azure Resource Id of a log target (either Azure Event Hub resource or Azure Application Insights resource). |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`isBuffered`](#parameter-isbuffered) | bool | Whether records are buffered in the logger before publishing. |
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
- Type: secureObject

### Parameter: `targetResourceId`

Required if loggerType = applicationInsights or azureEventHub. Azure Resource Id of a log target (either Azure Event Hub resource or Azure Application Insights resource).

- Required: Yes
- Type: string

### Parameter: `isBuffered`

Whether records are buffered in the logger before publishing.

- Required: No
- Type: bool
- Default: `True`

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
