# API Center Service Workspace Environments `[Microsoft.ApiCenter/services/workspaces/environments]`

This module deploys an API Center Service Workspace Environment.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.ApiCenter/services/workspaces/environments` | 2024-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apicenter_services_workspaces_environments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiCenter/2024-03-01/services/workspaces/environments)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-kind) | string | The kind of environment. |
| [`name`](#parameter-name) | string | The name of the environment. |
| [`title`](#parameter-title) | string | The title of the environment. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`serviceName`](#parameter-servicename) | string | The name of the parent API Center service. Required if the template is used in a standalone deployment. |
| [`workspaceName`](#parameter-workspacename) | string | The name of the parent workspace. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`customProperties`](#parameter-customproperties) | object | The custom metadata defined for API catalog entities. |
| [`description`](#parameter-description) | string | The description of the environment. |
| [`onboarding`](#parameter-onboarding) | object | Onboarding information for the environment. |
| [`server`](#parameter-server) | object | Server information of the environment. |

### Parameter: `kind`

The kind of environment.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'development'
    'production'
    'staging'
    'testing'
  ]
  ```

### Parameter: `name`

The name of the environment.

- Required: Yes
- Type: string

### Parameter: `title`

The title of the environment.

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

### Parameter: `description`

The description of the environment.

- Required: No
- Type: string

### Parameter: `onboarding`

Onboarding information for the environment.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`developerPortalUri`](#parameter-onboardingdeveloperportaluri) | array | The developer portal URIs. |
| [`instructions`](#parameter-onboardinginstructions) | string | Onboarding instructions. |

### Parameter: `onboarding.developerPortalUri`

The developer portal URIs.

- Required: No
- Type: array

### Parameter: `onboarding.instructions`

Onboarding instructions.

- Required: No
- Type: string

### Parameter: `server`

Server information of the environment.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`managementPortalUri`](#parameter-servermanagementportaluri) | array | The management portal URIs. |
| [`type`](#parameter-servertype) | string | The type of server that represents the environment. |

### Parameter: `server.managementPortalUri`

The management portal URIs.

- Required: No
- Type: array

### Parameter: `server.type`

The type of server that represents the environment.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Apigee API Management'
    'AWS API Gateway'
    'Azure API Management'
    'Azure compute service'
    'Kong API Gateway'
    'Kubernetes'
    'MuleSoft API Management'
  ]
  ```

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the environment. |
| `resourceGroupName` | string | The name of the resource group the environment was created in. |
| `resourceId` | string | The resource ID of the environment. |
