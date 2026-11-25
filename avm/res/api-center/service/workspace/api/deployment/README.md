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
| [`definition`](#parameter-definition) | string | The deployed definition name. |
| [`environment`](#parameter-environment) | string | The target environment name of the deployment. |
| [`name`](#parameter-name) | string | The name of the deployment. |
| [`version`](#parameter-version) | string | The deployed version name. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiName`](#parameter-apiname) | string | The name of the parent API. Required if the template is used in a standalone deployment. |
| [`serviceName`](#parameter-servicename) | string | The name of the parent API Center service. Required if the template is used in a standalone deployment. |
| [`workspaceName`](#parameter-workspacename) | string | The name of the parent workspace. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`customProperties`](#parameter-customproperties) |  | The custom metadata defined for API catalog entities. |
| [`description`](#parameter-description) | string | The description of the deployment. |
| [`server`](#parameter-server) | object | The server information of the deployment. |
| [`state`](#parameter-state) | string | The state of the API deployment. |
| [`title`](#parameter-title) | string | The title of the deployment. |

### Parameter: `definition`

The deployed definition name.

- Required: Yes
- Type: string

### Parameter: `environment`

The target environment name of the deployment.

- Required: Yes
- Type: string

### Parameter: `name`

The name of the deployment.

- Required: Yes
- Type: string

### Parameter: `version`

The deployed version name.

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
- Type: 

### Parameter: `description`

The description of the deployment.

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
