# API Management Service APIs Diagnostics. `[Microsoft.ApiManagement/service/apis/diagnostics]`

This module deploys an API Management Service API Diagnostics.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

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
| [`httpCorrelationProtocol`](#parameter-httpcorrelationprotocol) | string | Sets correlation protocol to use for Application Insights diagnostics. Required if using Application Insights. |
| [`metrics`](#parameter-metrics) | bool | Emit custom metrics via emit-metric policy. Required if using Application Insights. |
| [`operationNameFormat`](#parameter-operationnameformat) | string | The format of the Operation Name for Application Insights telemetries. Required if using Application Insights. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`alwaysLog`](#parameter-alwayslog) | string | Specifies for what type of messages sampling settings should not apply. |
| [`backend`](#parameter-backend) | object | Diagnostic settings for incoming/outgoing HTTP messages to the Backend. |
| [`frontend`](#parameter-frontend) | object | Diagnostic settings for incoming/outgoing HTTP messages to the Gateway. |
| [`logClientIp`](#parameter-logclientip) | bool | Log the ClientIP. |
| [`name`](#parameter-name) | string | Type of diagnostic resource. |
| [`samplingPercentage`](#parameter-samplingpercentage) | int | Rate of sampling for fixed-rate sampling. Specifies the percentage of requests that are logged. 0% sampling means zero requests logged, while 100% sampling means all requests logged. |
| [`verbosity`](#parameter-verbosity) | string | The verbosity level applied to traces emitted by trace policies. |

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

### Parameter: `frontend`

Diagnostic settings for incoming/outgoing HTTP messages to the Gateway.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `logClientIp`

Log the ClientIP.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `name`

Type of diagnostic resource.

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

Rate of sampling for fixed-rate sampling. Specifies the percentage of requests that are logged. 0% sampling means zero requests logged, while 100% sampling means all requests logged.

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
