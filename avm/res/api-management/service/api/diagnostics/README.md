# API Management Service APIs Diagnostics. `[Microsoft.ApiManagement/service/apis/diagnostics]`

This module deploys an API Management Service API Diagnostics.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service/apis/diagnostics` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2022-08-01/service/apis/diagnostics) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiManagementServiceName`](#parameter-apimanagementservicename) | string | The name of the parent API Management service. |
| [`apiName`](#parameter-apiname) | string | The name of the parent API. |
| [`loggerName`](#parameter-loggername) | string | The name of the logger. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`httpCorrelationProtocol`](#parameter-httpcorrelationprotocol) | string | Sets correlation protocol to use for Application Insights diagnostics. Default is Legacy. Required if using Application Insights. |
| [`metrics`](#parameter-metrics) | bool | Emit custom metrics via emit-metric policy. Default is false. Required if using Application Insights. |
| [`operationNameFormat`](#parameter-operationnameformat) | string | The format of the Operation Name for Application Insights telemetries. Default is Name. Required if using Application Insights. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`alwaysLog`](#parameter-alwayslog) | string | Specifies for what type of messages sampling settings should not apply. |
| [`backend`](#parameter-backend) | object | Diagnostic settings for incoming/outgoing HTTP messages to the Backend. |
| [`diagnosticName`](#parameter-diagnosticname) | string | Type of diagnostic resource. Default is local. |
| [`frontend`](#parameter-frontend) | object | Diagnostic settings for incoming/outgoing HTTP messages to the Gateway. |
| [`logClientIp`](#parameter-logclientip) | bool | Log the ClientIP. Default is false. |
| [`samplingPercentage`](#parameter-samplingpercentage) | int | Rate of sampling for fixed-rate sampling. Specifies the percentage of requests that are logged. 0% sampling means zero requests logged, while 100% sampling means all requests logged. Default is 100. |
| [`verbosity`](#parameter-verbosity) | string | The verbosity level applied to traces emitted by trace policies. Default is "error". |

### Parameter: `apiManagementServiceName`

The name of the parent API Management service.

- Required: Yes
- Type: string

### Parameter: `apiName`

The name of the parent API.

- Required: Yes
- Type: string

### Parameter: `loggerName`

The name of the logger.

- Required: Yes
- Type: string

### Parameter: `httpCorrelationProtocol`

Sets correlation protocol to use for Application Insights diagnostics. Default is Legacy. Required if using Application Insights.

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

Emit custom metrics via emit-metric policy. Default is false. Required if using Application Insights.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `operationNameFormat`

The format of the Operation Name for Application Insights telemetries. Default is Name. Required if using Application Insights.

- Required: No
- Type: string
- Default: `'Name'`
- Allowed:
  ```Bicep
  [
    'Name'
    'URI'
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
- Default: `{}`

### Parameter: `diagnosticName`

Type of diagnostic resource. Default is local.

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

### Parameter: `frontend`

Diagnostic settings for incoming/outgoing HTTP messages to the Gateway.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `logClientIp`

Log the ClientIP. Default is false.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `samplingPercentage`

Rate of sampling for fixed-rate sampling. Specifies the percentage of requests that are logged. 0% sampling means zero requests logged, while 100% sampling means all requests logged. Default is 100.

- Required: No
- Type: int
- Default: `100`

### Parameter: `verbosity`

The verbosity level applied to traces emitted by trace policies. Default is "error".

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

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
