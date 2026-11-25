# API Center Service Workspace API Versions `[Microsoft.ApiCenter/services/workspaces/apis/versions]`

This module deploys an API Center Service Workspace API Version.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.ApiCenter/services/workspaces/apis/versions` | 2024-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apicenter_services_workspaces_apis_versions.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiCenter/2024-03-01/services/workspaces/apis/versions)</li></ul> |
| `Microsoft.ApiCenter/services/workspaces/apis/versions/definitions` | 2024-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apicenter_services_workspaces_apis_versions_definitions.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiCenter/2024-03-01/services/workspaces/apis/versions/definitions)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`lifecycleStage`](#parameter-lifecyclestage) | string | The lifecycle stage of the API version. |
| [`name`](#parameter-name) | string | The name of the API version. |
| [`title`](#parameter-title) | string | The title of the API version. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiName`](#parameter-apiname) | string | The name of the parent API. Required if the template is used in a standalone deployment. |
| [`serviceName`](#parameter-servicename) | string | The name of the parent API Center service. Required if the template is used in a standalone deployment. |
| [`workspaceName`](#parameter-workspacename) | string | The name of the parent workspace. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`definitions`](#parameter-definitions) | array | The definitions to create for the API version. |

### Parameter: `lifecycleStage`

The lifecycle stage of the API version.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'deprecated'
    'design'
    'development'
    'preview'
    'production'
    'retired'
    'testing'
  ]
  ```

### Parameter: `name`

The name of the API version.

- Required: Yes
- Type: string

### Parameter: `title`

The title of the API version.

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

### Parameter: `definitions`

The definitions to create for the API version.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-definitionsname) | string | The name of the definition. |
| [`title`](#parameter-definitionstitle) | string | The title of the definition. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-definitionsdescription) | string | The description of the definition. |

### Parameter: `definitions.name`

The name of the definition.

- Required: Yes
- Type: string

### Parameter: `definitions.title`

The title of the definition.

- Required: Yes
- Type: string

### Parameter: `definitions.description`

The description of the definition.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the API version. |
| `resourceGroupName` | string | The name of the resource group the API version was created in. |
| `resourceId` | string | The resource ID of the API version. |
