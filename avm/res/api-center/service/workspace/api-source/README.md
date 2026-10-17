# API Center Service Workspace API Sources `[Microsoft.ApiCenter/services/workspaces/apiSources]`

This module deploys an API Center Service Workspace API Source for importing APIs from external sources like Azure API Management.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.ApiCenter/services/workspaces/apiSources` | 2024-06-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apicenter_services_workspaces_apisources.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiCenter/2024-06-01-preview/services/workspaces/apiSources)</li></ul> |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`azureApiManagementSource`](#parameter-azureapimanagementsource) | object | Configuration for importing APIs from an Azure API Management instance. |
| [`name`](#parameter-name) | string | The name of the API source. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`serviceName`](#parameter-servicename) | string | The name of the parent API Center service. Required if the template is used in a standalone deployment. |
| [`workspaceName`](#parameter-workspacename) | string | The name of the parent workspace. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`importSpecification`](#parameter-importspecification) | string | Indicates if the specification should be imported along with metadata. |
| [`targetEnvironment`](#parameter-targetenvironment) | string | The target environment name. If not provided a new environment will be created. |
| [`targetLifecycleStage`](#parameter-targetlifecyclestage) | string | The target lifecycle stage for imported APIs. |

### Parameter: `azureApiManagementSource`

Configuration for importing APIs from an Azure API Management instance.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`resourceId`](#parameter-azureapimanagementsourceresourceid) | string | The resource ID of the Azure API Management instance. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`msiResourceId`](#parameter-azureapimanagementsourcemsiresourceid) | string | The resource ID of the managed identity that has access to the API Management instance. If not provided, system-assigned identity is used and granted Api Management Service Reader role. |

### Parameter: `azureApiManagementSource.resourceId`

The resource ID of the Azure API Management instance.

- Required: Yes
- Type: string

### Parameter: `azureApiManagementSource.msiResourceId`

The resource ID of the managed identity that has access to the API Management instance. If not provided, system-assigned identity is used and granted Api Management Service Reader role.

- Required: No
- Type: string

### Parameter: `name`

The name of the API source.

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

### Parameter: `importSpecification`

Indicates if the specification should be imported along with metadata.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'always'
    'never'
    'ondemand'
  ]
  ```

### Parameter: `targetEnvironment`

The target environment name. If not provided a new environment will be created.

- Required: No
- Type: string

### Parameter: `targetLifecycleStage`

The target lifecycle stage for imported APIs.

- Required: No
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

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the API source. |
| `resourceGroupName` | string | The name of the resource group the API source was created in. |
| `resourceId` | string | The resource ID of the API source. |
