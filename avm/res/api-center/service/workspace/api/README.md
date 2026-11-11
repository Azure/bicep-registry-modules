# API Center Service Workspace APIs `[Microsoft.ApiCenter/services/workspaces/apis]`

This module deploys an API Center Service Workspace API.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.ApiCenter/services/workspaces/apis` | 2024-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apicenter_services_workspaces_apis.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiCenter/2024-03-01/services/workspaces/apis)</li></ul> |
| `Microsoft.ApiCenter/services/workspaces/apis/deployments` | 2024-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apicenter_services_workspaces_apis_deployments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiCenter/2024-03-01/services/workspaces/apis/deployments)</li></ul> |
| `Microsoft.ApiCenter/services/workspaces/apis/versions` | 2024-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apicenter_services_workspaces_apis_versions.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiCenter/2024-03-01/services/workspaces/apis/versions)</li></ul> |
| `Microsoft.ApiCenter/services/workspaces/apis/versions/definitions` | 2024-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apicenter_services_workspaces_apis_versions_definitions.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiCenter/2024-03-01/services/workspaces/apis/versions/definitions)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-kind) | string | The kind of API. |
| [`name`](#parameter-name) | string | The name of the API. |
| [`title`](#parameter-title) | string | The title of the API. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`serviceName`](#parameter-servicename) | string | The name of the parent API Center service. Required if the template is used in a standalone deployment. |
| [`workspaceName`](#parameter-workspacename) | string | The name of the parent workspace. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`contacts`](#parameter-contacts) | array | The contacts for the API. |
| [`customProperties`](#parameter-customproperties) |  | The custom metadata defined for API catalog entities. |
| [`deployments`](#parameter-deployments) | array | The deployments to create for the API. |
| [`description`](#parameter-description) | string | The description of the API. |
| [`externalDocumentation`](#parameter-externaldocumentation) | array | The external documentation for the API. |
| [`license`](#parameter-license) | object | The license information for the API. |
| [`summary`](#parameter-summary) | string | Short description of the API. |
| [`termsOfService`](#parameter-termsofservice) | object | The terms of service for the API. |
| [`versions`](#parameter-versions) | array | The versions to create for the API. |

### Parameter: `kind`

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

### Parameter: `name`

The name of the API.

- Required: Yes
- Type: string

### Parameter: `title`

The title of the API.

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

### Parameter: `contacts`

The contacts for the API.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`email`](#parameter-contactsemail) | string | The email of the contact. |
| [`name`](#parameter-contactsname) | string | The name of the contact. |
| [`url`](#parameter-contactsurl) | string | The URL of the contact. |

### Parameter: `contacts.email`

The email of the contact.

- Required: No
- Type: string

### Parameter: `contacts.name`

The name of the contact.

- Required: No
- Type: string

### Parameter: `contacts.url`

The URL of the contact.

- Required: No
- Type: string

### Parameter: `customProperties`

The custom metadata defined for API catalog entities.

- Required: No
- Type: 

### Parameter: `deployments`

The deployments to create for the API.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`definition`](#parameter-deploymentsdefinition) | string | The deployed definition name. |
| [`environment`](#parameter-deploymentsenvironment) | string | The target environment name of the deployment. |
| [`name`](#parameter-deploymentsname) | string | The name of the deployment. |
| [`version`](#parameter-deploymentsversion) | string | The deployed version name. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`customProperties`](#parameter-deploymentscustomproperties) |  | The custom metadata defined for API catalog entities. |
| [`description`](#parameter-deploymentsdescription) | string | The description of the deployment. |
| [`server`](#parameter-deploymentsserver) | object | The server information of the deployment. |
| [`state`](#parameter-deploymentsstate) | string | The state of the deployment. |
| [`title`](#parameter-deploymentstitle) | string | The title of the deployment. |

### Parameter: `deployments.definition`

The deployed definition name.

- Required: Yes
- Type: string

### Parameter: `deployments.environment`

The target environment name of the deployment.

- Required: Yes
- Type: string

### Parameter: `deployments.name`

The name of the deployment.

- Required: Yes
- Type: string

### Parameter: `deployments.version`

The deployed version name.

- Required: Yes
- Type: string

### Parameter: `deployments.customProperties`

The custom metadata defined for API catalog entities.

- Required: No
- Type: 

### Parameter: `deployments.description`

The description of the deployment.

- Required: No
- Type: string

### Parameter: `deployments.server`

The server information of the deployment.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`runtimeUri`](#parameter-deploymentsserverruntimeuri) | array | The base runtime URIs for this deployment. |

### Parameter: `deployments.server.runtimeUri`

The base runtime URIs for this deployment.

- Required: No
- Type: array

### Parameter: `deployments.state`

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

### Parameter: `deployments.title`

The title of the deployment.

- Required: No
- Type: string

### Parameter: `description`

The description of the API.

- Required: No
- Type: string

### Parameter: `externalDocumentation`

The external documentation for the API.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`url`](#parameter-externaldocumentationurl) | string | The URL pointing to the documentation. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-externaldocumentationdescription) | string | The description of the documentation. |
| [`title`](#parameter-externaldocumentationtitle) | string | The title of the documentation. |

### Parameter: `externalDocumentation.url`

The URL pointing to the documentation.

- Required: Yes
- Type: string

### Parameter: `externalDocumentation.description`

The description of the documentation.

- Required: No
- Type: string

### Parameter: `externalDocumentation.title`

The title of the documentation.

- Required: No
- Type: string

### Parameter: `license`

The license information for the API.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`identifier`](#parameter-licenseidentifier) | string | SPDX license identifier. Mutually exclusive with url. |
| [`name`](#parameter-licensename) | string | The name of the license. |
| [`url`](#parameter-licenseurl) | string | URL pointing to the license details. Mutually exclusive with identifier. |

### Parameter: `license.identifier`

SPDX license identifier. Mutually exclusive with url.

- Required: No
- Type: string

### Parameter: `license.name`

The name of the license.

- Required: No
- Type: string

### Parameter: `license.url`

URL pointing to the license details. Mutually exclusive with identifier.

- Required: No
- Type: string

### Parameter: `summary`

Short description of the API.

- Required: No
- Type: string

### Parameter: `termsOfService`

The terms of service for the API.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`url`](#parameter-termsofserviceurl) | string | URL pointing to the terms of service. |

### Parameter: `termsOfService.url`

URL pointing to the terms of service.

- Required: Yes
- Type: string

### Parameter: `versions`

The versions to create for the API.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`lifecycleStage`](#parameter-versionslifecyclestage) | string | The lifecycle stage of the version. |
| [`name`](#parameter-versionsname) | string | The name of the version. |
| [`title`](#parameter-versionstitle) | string | The title of the version. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`definitions`](#parameter-versionsdefinitions) | array | The definitions to create for the version. |

### Parameter: `versions.lifecycleStage`

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

### Parameter: `versions.name`

The name of the version.

- Required: Yes
- Type: string

### Parameter: `versions.title`

The title of the version.

- Required: Yes
- Type: string

### Parameter: `versions.definitions`

The definitions to create for the version.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-versionsdefinitionsname) | string | The name of the definition. |
| [`title`](#parameter-versionsdefinitionstitle) | string | The title of the definition. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-versionsdefinitionsdescription) | string | The description of the definition. |

### Parameter: `versions.definitions.name`

The name of the definition.

- Required: Yes
- Type: string

### Parameter: `versions.definitions.title`

The title of the definition.

- Required: Yes
- Type: string

### Parameter: `versions.definitions.description`

The description of the definition.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the API. |
| `resourceGroupName` | string | The name of the resource group the API was created in. |
| `resourceId` | string | The resource ID of the API. |
