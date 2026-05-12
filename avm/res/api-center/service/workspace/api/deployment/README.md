# API Center Service Workspace API Deployments `[Microsoft.ApiCenter/services/workspaces/apis/deployments]`

This module deploys an API Center Service Workspace API Deployment.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.ApiCenter/services/workspaces/apis/deployments` | 2024-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apicenter_services_workspaces_apis_deployments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiCenter/2024-03-01/services/workspaces/apis/deployments)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the deployment. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiName`](#parameter-apiname) | string | The name of the parent API. Required if the template is used in a standalone deployment. |
| [`serviceName`](#parameter-servicename) | string | The name of the parent API Center service. Required if the template is used in a standalone deployment. |
| [`workspaceName`](#parameter-workspacename) | string | The name of the parent workspace. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`customProperties`](#parameter-customproperties) | object | The custom metadata defined for API catalog entities. |
| [`definitionId`](#parameter-definitionid) | string | The API center-scoped definition resource ID. |
| [`description`](#parameter-description) | string | The description of the deployment. |
| [`environmentId`](#parameter-environmentid) | string | The API center-scoped environment resource ID. |
| [`server`](#parameter-server) | object | The server information of the deployment. |
| [`state`](#parameter-state) | string | The state of the API deployment. |
| [`title`](#parameter-title) | string | The title of the deployment. |

### Parameter: `name`

The name of the deployment.

- Required: Yes
- Type: string

### Parameter: `apiName`

The name of the parent API. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `serviceName`

The name of the parent API Center service. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `workspaceName`

The name of the parent workspace. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `customProperties`

The custom metadata defined for API catalog entities.

- Required: No
- Type: object

### Parameter: `definitionId`

The API center-scoped definition resource ID.

- Required: No
- Type: string

### Parameter: `description`

The description of the deployment.

- Required: No
- Type: string

### Parameter: `environmentId`

The API center-scoped environment resource ID.

- Required: No
- Type: string

### Parameter: `server`

The server information of the deployment.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`runtimeUri`](#parameter-serverruntimeuri) | array | The base runtime URIs for this deployment. |

### Parameter: `server.runtimeUri`

The base runtime URIs for this deployment.

- Required: No
- Type: array

### Parameter: `state`

The state of the API deployment.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'active'
    'inactive'
  ]
  ```

### Parameter: `title`

The title of the deployment.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the API deployment. |
| `resourceGroupName` | string | The name of the resource group the API deployment was created in. |
| `resourceId` | string | The resource ID of the API deployment. |
