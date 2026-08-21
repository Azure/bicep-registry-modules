# API Center Service Workspace API Version Definitions `[Microsoft.ApiCenter/services/workspaces/apis/versions/definitions]`

This module deploys an API Center Service Workspace API Version Definition.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.ApiCenter/services/workspaces/apis/versions/definitions` | 2024-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apicenter_services_workspaces_apis_versions_definitions.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiCenter/2024-03-01/services/workspaces/apis/versions/definitions)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the API definition. |
| [`title`](#parameter-title) | string | The title of the API definition. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiName`](#parameter-apiname) | string | The name of the parent API. Required if the template is used in a standalone deployment. |
| [`serviceName`](#parameter-servicename) | string | The name of the parent API Center service. Required if the template is used in a standalone deployment. |
| [`versionName`](#parameter-versionname) | string | The name of the parent API version. Required if the template is used in a standalone deployment. |
| [`workspaceName`](#parameter-workspacename) | string | The name of the parent workspace. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-description) | string | The description of the API definition. |

### Parameter: `name`

The name of the API definition.

- Required: Yes
- Type: string

### Parameter: `title`

The title of the API definition.

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

### Parameter: `versionName`

The name of the parent API version. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `workspaceName`

The name of the parent workspace. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `description`

The description of the API definition.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the API definition. |
| `resourceGroupName` | string | The name of the resource group the API definition was created in. |
| `resourceId` | string | The resource ID of the API definition. |
