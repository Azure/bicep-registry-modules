# API Center Service Workspaces `[Microsoft.ApiCenter/services/workspaces]`

This module deploys an API Center Service Workspace.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.ApiCenter/services/workspaces` | 2024-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apicenter_services_workspaces.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiCenter/2024-03-01/services/workspaces)</li></ul> |
| `Microsoft.ApiCenter/services/workspaces/apis` | 2024-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apicenter_services_workspaces_apis.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiCenter/2024-03-01/services/workspaces/apis)</li></ul> |
| `Microsoft.ApiCenter/services/workspaces/apis/deployments` | 2024-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apicenter_services_workspaces_apis_deployments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiCenter/2024-03-01/services/workspaces/apis/deployments)</li></ul> |
| `Microsoft.ApiCenter/services/workspaces/apis/versions` | 2024-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apicenter_services_workspaces_apis_versions.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiCenter/2024-03-01/services/workspaces/apis/versions)</li></ul> |
| `Microsoft.ApiCenter/services/workspaces/apis/versions/definitions` | 2024-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apicenter_services_workspaces_apis_versions_definitions.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiCenter/2024-03-01/services/workspaces/apis/versions/definitions)</li></ul> |
| `Microsoft.ApiCenter/services/workspaces/environments` | 2024-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apicenter_services_workspaces_environments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiCenter/2024-03-01/services/workspaces/environments)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the workspace. |
| [`title`](#parameter-title) | string | The title of the workspace. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`serviceName`](#parameter-servicename) | string | The name of the parent API Center service. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apis`](#parameter-apis) | array | The APIs to create in the workspace. |
| [`description`](#parameter-description) | string | The description of the workspace. |
| [`environments`](#parameter-environments) | array | The environments to create in the workspace. |

### Parameter: `name`

The name of the workspace.

- Required: Yes
- Type: string

### Parameter: `title`

The title of the workspace.

- Required: Yes
- Type: string

### Parameter: `serviceName`

The name of the parent API Center service. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `apis`

The APIs to create in the workspace.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-apiskind) | string | The kind of API. |
| [`name`](#parameter-apisname) | string | The name of the API. |
| [`title`](#parameter-apistitle) | string | The title of the API. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`contacts`](#parameter-apiscontacts) | array | The contacts for the API. |
| [`customProperties`](#parameter-apiscustomproperties) | object | The custom metadata properties for the API. |
| [`deployments`](#parameter-apisdeployments) | array | The deployments to create for the API. |
| [`description`](#parameter-apisdescription) | string | The description of the API. |
| [`externalDocumentation`](#parameter-apisexternaldocumentation) | array | The external documentation for the API. |
| [`license`](#parameter-apislicense) | object | The license information for the API. |
| [`summary`](#parameter-apissummary) | string | Short description of the API. |
| [`termsOfService`](#parameter-apistermsofservice) | object | The terms of service for the API. |
| [`versions`](#parameter-apisversions) | array | The versions to create for the API. |

### Parameter: `apis.kind`

The kind of API.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'graphql'
    'grpc'
    'rest'
    'soap'
    'webhook'
    'websocket'
  ]
  ```

### Parameter: `apis.name`

The name of the API.

- Required: Yes
- Type: string

### Parameter: `apis.title`

The title of the API.

- Required: Yes
- Type: string

### Parameter: `apis.contacts`

The contacts for the API.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`email`](#parameter-apiscontactsemail) | string | The email of the contact. |
| [`name`](#parameter-apiscontactsname) | string | The name of the contact. |
| [`url`](#parameter-apiscontactsurl) | string | The URL of the contact. |

### Parameter: `apis.contacts.email`

The email of the contact.

- Required: No
- Type: string

### Parameter: `apis.contacts.name`

The name of the contact.

- Required: No
- Type: string

### Parameter: `apis.contacts.url`

The URL of the contact.

- Required: No
- Type: string

### Parameter: `apis.customProperties`

The custom metadata properties for the API.

- Required: No
- Type: object

### Parameter: `apis.deployments`

The deployments to create for the API.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-apisdeploymentsname) | string | The name of the deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`customProperties`](#parameter-apisdeploymentscustomproperties) | object | The custom metadata properties for the deployment. |
| [`definitionId`](#parameter-apisdeploymentsdefinitionid) | string | The definition ID of the deployment. |
| [`description`](#parameter-apisdeploymentsdescription) | string | The description of the deployment. |
| [`environmentId`](#parameter-apisdeploymentsenvironmentid) | string | The environment ID of the deployment. |
| [`server`](#parameter-apisdeploymentsserver) | object | The server information of the deployment. |
| [`state`](#parameter-apisdeploymentsstate) | string | The state of the deployment. |
| [`title`](#parameter-apisdeploymentstitle) | string | The title of the deployment. |

### Parameter: `apis.deployments.name`

The name of the deployment.

- Required: Yes
- Type: string

### Parameter: `apis.deployments.customProperties`

The custom metadata properties for the deployment.

- Required: No
- Type: object

### Parameter: `apis.deployments.definitionId`

The definition ID of the deployment.

- Required: No
- Type: string

### Parameter: `apis.deployments.description`

The description of the deployment.

- Required: No
- Type: string

### Parameter: `apis.deployments.environmentId`

The environment ID of the deployment.

- Required: No
- Type: string

### Parameter: `apis.deployments.server`

The server information of the deployment.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`runtimeUri`](#parameter-apisdeploymentsserverruntimeuri) | array | The runtime URIs. |

### Parameter: `apis.deployments.server.runtimeUri`

The runtime URIs.

- Required: No
- Type: array

### Parameter: `apis.deployments.state`

The state of the deployment.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'active'
    'inactive'
  ]
  ```

### Parameter: `apis.deployments.title`

The title of the deployment.

- Required: No
- Type: string

### Parameter: `apis.description`

The description of the API.

- Required: No
- Type: string

### Parameter: `apis.externalDocumentation`

The external documentation for the API.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`url`](#parameter-apisexternaldocumentationurl) | string | The URL of the documentation. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-apisexternaldocumentationdescription) | string | The description of the documentation. |
| [`title`](#parameter-apisexternaldocumentationtitle) | string | The title of the documentation. |

### Parameter: `apis.externalDocumentation.url`

The URL of the documentation.

- Required: Yes
- Type: string

### Parameter: `apis.externalDocumentation.description`

The description of the documentation.

- Required: No
- Type: string

### Parameter: `apis.externalDocumentation.title`

The title of the documentation.

- Required: No
- Type: string

### Parameter: `apis.license`

The license information for the API.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`identifier`](#parameter-apislicenseidentifier) | string | SPDX license identifier. |
| [`name`](#parameter-apislicensename) | string | The name of the license. |
| [`url`](#parameter-apislicenseurl) | string | The URL of the license. |

### Parameter: `apis.license.identifier`

SPDX license identifier.

- Required: No
- Type: string

### Parameter: `apis.license.name`

The name of the license.

- Required: No
- Type: string

### Parameter: `apis.license.url`

The URL of the license.

- Required: No
- Type: string

### Parameter: `apis.summary`

Short description of the API.

- Required: No
- Type: string

### Parameter: `apis.termsOfService`

The terms of service for the API.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`url`](#parameter-apistermsofserviceurl) | string | The URL of the terms of service. |

### Parameter: `apis.termsOfService.url`

The URL of the terms of service.

- Required: Yes
- Type: string

### Parameter: `apis.versions`

The versions to create for the API.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`lifecycleStage`](#parameter-apisversionslifecyclestage) | string | The lifecycle stage of the version. |
| [`name`](#parameter-apisversionsname) | string | The name of the version. |
| [`title`](#parameter-apisversionstitle) | string | The title of the version. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`definitions`](#parameter-apisversionsdefinitions) | array | The definitions to create for the version. |

### Parameter: `apis.versions.lifecycleStage`

The lifecycle stage of the version.

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

### Parameter: `apis.versions.name`

The name of the version.

- Required: Yes
- Type: string

### Parameter: `apis.versions.title`

The title of the version.

- Required: Yes
- Type: string

### Parameter: `apis.versions.definitions`

The definitions to create for the version.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-apisversionsdefinitionsname) | string | The name of the definition. |
| [`title`](#parameter-apisversionsdefinitionstitle) | string | The title of the definition. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-apisversionsdefinitionsdescription) | string | The description of the definition. |

### Parameter: `apis.versions.definitions.name`

The name of the definition.

- Required: Yes
- Type: string

### Parameter: `apis.versions.definitions.title`

The title of the definition.

- Required: Yes
- Type: string

### Parameter: `apis.versions.definitions.description`

The description of the definition.

- Required: No
- Type: string

### Parameter: `description`

The description of the workspace.

- Required: No
- Type: string

### Parameter: `environments`

The environments to create in the workspace.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-environmentskind) | string | The kind of environment. |
| [`name`](#parameter-environmentsname) | string | The name of the environment. |
| [`title`](#parameter-environmentstitle) | string | The title of the environment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`customProperties`](#parameter-environmentscustomproperties) | object | The custom metadata properties for the environment. |
| [`description`](#parameter-environmentsdescription) | string | The description of the environment. |
| [`onboarding`](#parameter-environmentsonboarding) | object | Onboarding information for the environment. |
| [`server`](#parameter-environmentsserver) | object | Server information of the environment. |

### Parameter: `environments.kind`

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

### Parameter: `environments.name`

The name of the environment.

- Required: Yes
- Type: string

### Parameter: `environments.title`

The title of the environment.

- Required: Yes
- Type: string

### Parameter: `environments.customProperties`

The custom metadata properties for the environment.

- Required: No
- Type: object

### Parameter: `environments.description`

The description of the environment.

- Required: No
- Type: string

### Parameter: `environments.onboarding`

Onboarding information for the environment.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`developerPortalUri`](#parameter-environmentsonboardingdeveloperportaluri) | array | The developer portal URIs. |
| [`instructions`](#parameter-environmentsonboardinginstructions) | string | Onboarding instructions. |

### Parameter: `environments.onboarding.developerPortalUri`

The developer portal URIs.

- Required: No
- Type: array

### Parameter: `environments.onboarding.instructions`

Onboarding instructions.

- Required: No
- Type: string

### Parameter: `environments.server`

Server information of the environment.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`managementPortalUri`](#parameter-environmentsservermanagementportaluri) | array | The management portal URIs. |
| [`type`](#parameter-environmentsservertype) | string | The type of server. |

### Parameter: `environments.server.managementPortalUri`

The management portal URIs.

- Required: No
- Type: array

### Parameter: `environments.server.type`

The type of server.

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
| `name` | string | The name of the workspace. |
| `resourceGroupName` | string | The name of the resource group the workspace was created in. |
| `resourceId` | string | The resource ID of the workspace. |
