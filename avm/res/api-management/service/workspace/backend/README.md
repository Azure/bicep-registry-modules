# API Management Workspace Backends `[Microsoft.ApiManagement/service/workspaces/backends]`

This module deploys a Backend in an API Management Workspace.

You can reference the module as follows:
```bicep
module service 'br/public:avm/res/api-management/service/workspace/backend:<version>' = {
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
| `Microsoft.ApiManagement/service/workspaces/backends` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_workspaces_backends.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/workspaces/backends)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Backend Name. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiManagementServiceName`](#parameter-apimanagementservicename) | string | The name of the parent API Management service. Required if the template is used in a standalone deployment. |
| [`pool`](#parameter-pool) | object | Backend pool configuration for load balancing. Required if type is Pool and not supported if type is Single. |
| [`url`](#parameter-url) | string | Runtime URL of the Backend. Required if type is Single and not supported if type is Pool. |
| [`workspaceName`](#parameter-workspacename) | string | The name of the parent Workspace. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`circuitBreaker`](#parameter-circuitbreaker) | object | Backend Circuit Breaker Configuration. Not supported for Backend Pools. |
| [`credentials`](#parameter-credentials) | object | Backend Credentials Contract Properties. Not supported for Backend Pools. |
| [`description`](#parameter-description) | string | Backend Description. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`protocol`](#parameter-protocol) | string | Backend communication protocol. http or soap. Not supported for Backend Pools. |
| [`proxy`](#parameter-proxy) | object | Backend Proxy Contract Properties. Not supported for Backend Pools. |
| [`resourceId`](#parameter-resourceid) | string | Management Uri of the Resource in External System. This URL can be the Arm Resource ID of Logic Apps, Function Apps or API Apps. Not supported for Backend Pools. |
| [`serviceFabricCluster`](#parameter-servicefabriccluster) | object | Backend Service Fabric Cluster Properties. Not supported for Backend Pools. |
| [`title`](#parameter-title) | string | Backend Title. |
| [`tls`](#parameter-tls) | object | Backend TLS Properties. Not supported for Backend Pools. If not specified and type is Single, TLS properties will default to validateCertificateChain and validateCertificateName set to true. |
| [`type`](#parameter-type) | string | Type of the backend. A backend can be either Single or Pool. |

### Parameter: `name`

Backend Name.

- Required: Yes
- Type: string

### Parameter: `apiManagementServiceName`

The name of the parent API Management service. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `pool`

Backend pool configuration for load balancing. Required if type is Pool and not supported if type is Single.

- Required: No
- Type: object

### Parameter: `url`

Runtime URL of the Backend. Required if type is Single and not supported if type is Pool.

- Required: No
- Type: string

### Parameter: `workspaceName`

The name of the parent Workspace. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `circuitBreaker`

Backend Circuit Breaker Configuration. Not supported for Backend Pools.

- Required: No
- Type: object

### Parameter: `credentials`

Backend Credentials Contract Properties. Not supported for Backend Pools.

- Required: No
- Type: object

### Parameter: `description`

Backend Description.

- Required: No
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `protocol`

Backend communication protocol. http or soap. Not supported for Backend Pools.

- Required: No
- Type: string
- Default: `'http'`

### Parameter: `proxy`

Backend Proxy Contract Properties. Not supported for Backend Pools.

- Required: No
- Type: object

### Parameter: `resourceId`

Management Uri of the Resource in External System. This URL can be the Arm Resource ID of Logic Apps, Function Apps or API Apps. Not supported for Backend Pools.

- Required: No
- Type: string

### Parameter: `serviceFabricCluster`

Backend Service Fabric Cluster Properties. Not supported for Backend Pools.

- Required: No
- Type: object

### Parameter: `title`

Backend Title.

- Required: No
- Type: string

### Parameter: `tls`

Backend TLS Properties. Not supported for Backend Pools. If not specified and type is Single, TLS properties will default to validateCertificateChain and validateCertificateName set to true.

- Required: No
- Type: object

### Parameter: `type`

Type of the backend. A backend can be either Single or Pool.

- Required: No
- Type: string
- Default: `'Single'`
- Allowed:
  ```Bicep
  [
    'Pool'
    'Single'
  ]
  ```

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the workspace backend. |
| `resourceGroupName` | string | The resource group the workspace backend was deployed into. |
| `resourceId` | string | The resource ID of the workspace backend. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
