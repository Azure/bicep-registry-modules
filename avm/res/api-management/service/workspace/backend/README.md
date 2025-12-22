# API Management Workspace Backends `[Microsoft.ApiManagement/service/workspaces/backends]`

This module deploys a Backend in an API Management Workspace.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

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
