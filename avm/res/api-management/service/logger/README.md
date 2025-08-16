# API Management Service Loggers `[Microsoft.ApiManagement/service/loggers]`

This module deploys an API Management Service Logger.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.ApiManagement/service/loggers` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_loggers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/loggers)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Resource Name. |
| [`type`](#parameter-type) | string | Logger type. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiManagementServiceName`](#parameter-apimanagementservicename) | string | The name of the parent API Management service. Required if the template is used in a standalone deployment. |
| [`credentials`](#parameter-credentials) | secureObject | The name and SendRule connection string of the event hub for azureEventHub logger. Instrumentation key for applicationInsights logger. Required if loggerType = applicationInsights or azureEventHub. |
| [`targetResourceId`](#parameter-targetresourceid) | string | Azure Resource Id of a log target (either Azure Event Hub resource or Azure Application Insights resource). Required if loggerType = applicationInsights or azureEventHub. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-description) | string | Logger description. |
| [`isBuffered`](#parameter-isbuffered) | bool | Whether records are buffered in the logger before publishing. |

### Parameter: `name`

Resource Name.

- Required: Yes
- Type: string

### Parameter: `type`

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

### Parameter: `apiManagementServiceName`

The name of the parent API Management service. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `credentials`

The name and SendRule connection string of the event hub for azureEventHub logger. Instrumentation key for applicationInsights logger. Required if loggerType = applicationInsights or azureEventHub.

- Required: Yes
- Type: secureObject

### Parameter: `targetResourceId`

Azure Resource Id of a log target (either Azure Event Hub resource or Azure Application Insights resource). Required if loggerType = applicationInsights or azureEventHub.

- Required: Yes
- Type: string

### Parameter: `description`

Logger description.

- Required: No
- Type: string
- Default: `''`

### Parameter: `isBuffered`

Whether records are buffered in the logger before publishing.

- Required: No
- Type: bool
- Default: `True`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the logger. |
| `resourceGroupName` | string | The resource group the named value was deployed into. |
| `resourceId` | string | The resource ID of the logger. |
