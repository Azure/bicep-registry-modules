# API Management Service Diagnostics `[Microsoft.ApiManagement/service/diagnostics]`

This module deploys an API Management Service Diagnostic.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.ApiManagement/service/diagnostics` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_diagnostics.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/diagnostics)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`loggerResourceId`](#parameter-loggerresourceid) | string | Logger resource ID. |
| [`name`](#parameter-name) | string | Diagnostic Name. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiManagementServiceName`](#parameter-apimanagementservicename) | string | The name of the parent API Management service. Required if the template is used in a standalone deployment. |
| [`httpCorrelationProtocol`](#parameter-httpcorrelationprotocol) | string | Sets correlation protocol to use for Application Insights diagnostics. Required if using Application Insights. |
| [`metrics`](#parameter-metrics) | bool | Emit custom metrics via emit-metric policy. Required if using Application Insights. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`alwaysLog`](#parameter-alwayslog) | string | Specifies for what type of messages sampling settings should not apply. |
| [`backend`](#parameter-backend) | object | Diagnostic settings for incoming/outgoing HTTP messages to the Backend. |
| [`frontend`](#parameter-frontend) | object | Diagnostic settings for incoming/outgoing HTTP messages to the Gateway. |
| [`logClientIp`](#parameter-logclientip) | bool | Log the ClientIP. |
| [`operationNameFormat`](#parameter-operationnameformat) | string | The format of the Operation Name for Application Insights telemetries. |
| [`samplingPercentage`](#parameter-samplingpercentage) | int | Rate of sampling for fixed-rate sampling. Specifies the percentage of requests that are logged. |
| [`verbosity`](#parameter-verbosity) | string | The verbosity level applied to traces emitted by trace policies. |

### Parameter: `loggerResourceId`

Logger resource ID.

- Required: Yes
- Type: string

### Parameter: `name`

Diagnostic Name.

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

### Parameter: `alwaysLog`

Specifies for what type of messages sampling settings should not apply.

- Required: No
- Type: string
- Default: `'allErrors'`

### Parameter: `backend`

Diagnostic settings for incoming/outgoing HTTP messages to the Backend.

- Required: No
- Type: object

### Parameter: `frontend`

Diagnostic settings for incoming/outgoing HTTP messages to the Gateway.

- Required: No
- Type: object

### Parameter: `logClientIp`

Log the ClientIP.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `operationNameFormat`

The format of the Operation Name for Application Insights telemetries.

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

### Parameter: `samplingPercentage`

Rate of sampling for fixed-rate sampling. Specifies the percentage of requests that are logged.

- Required: No
- Type: int
- Default: `100`

### Parameter: `verbosity`

The verbosity level applied to traces emitted by trace policies.

- Required: No
- Type: string
- Default: `'information'`
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
| `name` | string | The name of the API Management diagnostic. |
| `resourceGroupName` | string | The name of the resource group the API Management diagnostic was created in. |
| `resourceId` | string | The resource ID of the API Management diagnostic. |
