# API Management Service APIs Diagnostics. `[Microsoft.ApiManagement/service/apis/diagnostics]`

This module deploys an API Management Service API Diagnostics.

You can reference the module as follows:
```bicep
module service 'br/public:avm/res/api-management/service/api/diagnostics:<version>' = {
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
| `Microsoft.ApiManagement/service/apis/diagnostics` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_apis_diagnostics.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/apis/diagnostics)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiName`](#parameter-apiname) | string | The name of the parent API. |
| [`loggerName`](#parameter-loggername) | string | The name of the logger. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiManagementServiceName`](#parameter-apimanagementservicename) | string | The name of the parent API Management service. Required if the template is used in a standalone deployment. |
| [`httpCorrelationProtocol`](#parameter-httpcorrelationprotocol) | string | Sets correlation protocol to use for Application Insights diagnostics. Required if using Application Insights. |
| [`metrics`](#parameter-metrics) | bool | Emit custom metrics via emit-metric policy. Required if using Application Insights. |
| [`operationNameFormat`](#parameter-operationnameformat) | string | The format of the Operation Name for Application Insights telemetries. Required if using Application Insights. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`alwaysLog`](#parameter-alwayslog) | string | Specifies for what type of messages sampling settings should not apply. |
| [`backend`](#parameter-backend) | object | Diagnostic settings for incoming/outgoing HTTP messages to the Backend. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`frontend`](#parameter-frontend) | object | Diagnostic settings for incoming/outgoing HTTP messages to the Gateway. |
| [`logClientIp`](#parameter-logclientip) | bool | Log the ClientIP. |
| [`name`](#parameter-name) | string | Name of diagnostic resource. |
| [`samplingPercentage`](#parameter-samplingpercentage) | int | Rate of sampling for fixed-rate sampling. Specifies the percentage of requests that are logged. |
| [`verbosity`](#parameter-verbosity) | string | The verbosity level applied to traces emitted by trace policies. |

### Parameter: `apiName`

The name of the parent API.

- Required: Yes
- Type: string

### Parameter: `loggerName`

The name of the logger.

- Required: Yes
- Type: string

### Parameter: `apiManagementServiceName`

The name of the parent API Management service. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `httpCorrelationProtocol`

Sets correlation protocol to use for Application Insights diagnostics. Required if using Application Insights.

- Required: No
- Type: string
- Default: `'Legacy'`
- Allowed:
  ```Bicep
  [
    'Legacy'
    'None'
    'W3C'
  ]
  ```

### Parameter: `metrics`

Emit custom metrics via emit-metric policy. Required if using Application Insights.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `operationNameFormat`

The format of the Operation Name for Application Insights telemetries. Required if using Application Insights.

- Required: No
- Type: string
- Default: `'Name'`
- Allowed:
  ```Bicep
  [
    'Name'
    'Url'
  ]
  ```

### Parameter: `alwaysLog`

Specifies for what type of messages sampling settings should not apply.

- Required: No
- Type: string
- Default: `'allErrors'`

### Parameter: `backend`

Diagnostic settings for incoming/outgoing HTTP messages to the Backend.

- Required: No
- Type: object

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `frontend`

Diagnostic settings for incoming/outgoing HTTP messages to the Gateway.

- Required: No
- Type: object

### Parameter: `logClientIp`

Log the ClientIP.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `name`

Name of diagnostic resource.

- Required: No
- Type: string
- Default: `'local'`
- Allowed:
  ```Bicep
  [
    'applicationinsights'
    'azuremonitor'
    'local'
  ]
  ```

### Parameter: `samplingPercentage`

Rate of sampling for fixed-rate sampling. Specifies the percentage of requests that are logged.

- Required: No
- Type: int
- Default: `100`

### Parameter: `verbosity`

The verbosity level applied to traces emitted by trace policies.

- Required: No
- Type: string
- Default: `'error'`
- Allowed:
  ```Bicep
  [
    'error'
    'information'
    'verbose'
  ]
  ```

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the API diagnostic. |
| `resourceGroupName` | string | The resource group the API diagnostic was deployed into. |
| `resourceId` | string | The resource ID of the API diagnostic. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
