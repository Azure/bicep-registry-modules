# API Center Services `[Microsoft.ApiCenter/services]`

This module deploys an API Center Service.

You can reference the module as follows:
```bicep
module service 'br/public:avm/res/api-center/service:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.ApiCenter/services` | 2024-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apicenter_services.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiCenter/2024-03-01/services)</li></ul> |
| `Microsoft.ApiCenter/services/metadataSchemas` | 2024-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apicenter_services_metadataschemas.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiCenter/2024-03-01/services/metadataSchemas)</li></ul> |
| `Microsoft.ApiCenter/services/workspaces` | 2024-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apicenter_services_workspaces.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiCenter/2024-03-01/services/workspaces)</li></ul> |
| `Microsoft.ApiCenter/services/workspaces/apis` | 2024-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apicenter_services_workspaces_apis.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiCenter/2024-03-01/services/workspaces/apis)</li></ul> |
| `Microsoft.ApiCenter/services/workspaces/apis/deployments` | 2024-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apicenter_services_workspaces_apis_deployments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiCenter/2024-03-01/services/workspaces/apis/deployments)</li></ul> |
| `Microsoft.ApiCenter/services/workspaces/apis/versions` | 2024-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apicenter_services_workspaces_apis_versions.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiCenter/2024-03-01/services/workspaces/apis/versions)</li></ul> |
| `Microsoft.ApiCenter/services/workspaces/apis/versions/definitions` | 2024-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apicenter_services_workspaces_apis_versions_definitions.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiCenter/2024-03-01/services/workspaces/apis/versions/definitions)</li></ul> |
| `Microsoft.ApiCenter/services/workspaces/environments` | 2024-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apicenter_services_workspaces_environments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiCenter/2024-03-01/services/workspaces/environments)</li></ul> |
| `Microsoft.Authorization/locks` | 2020-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_locks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks)</li></ul> |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/api-center/service:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/defaults]


<details>

<summary>via Bicep module</summary>

```bicep
module service 'br/public:avm/res/api-center/service:<version>' = {
  params: {
    // Required parameters
    name: 'acsmin001'
    // Non-required parameters
    location: '<location>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "acsmin001"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/api-center/service:<version>'

// Required parameters
param name = 'acsmin001'
// Non-required parameters
param location = '<location>'
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/max]


<details>

<summary>via Bicep module</summary>

```bicep
module service 'br/public:avm/res/api-center/service:<version>' = {
  params: {
    // Required parameters
    name: 'acsmax001'
    // Non-required parameters
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    metadataSchemas: [
      {
        assignedTo: [
          {
            entity: 'api'
            required: true
          }
        ]
        name: 'apiLifecycleStage'
        schema: '{\'type\':\'string\',\'title\':\'API Lifecycle Stage\',\'enum\':[\'design\',\'development\',\'testing\',\'preview\',\'production\',\'deprecated\',\'retired\']}'
      }
      {
        assignedTo: [
          {
            entity: 'api'
            required: false
          }
          {
            entity: 'environment'
            required: false
          }
        ]
        name: 'apiCostCenter'
        schema: '{\'type\':\'string\',\'title\':\'Cost Center\',\'pattern\':\'^[A-Z]{2}-[0-9]{4}$\'}'
      }
    ]
    roleAssignments: [
      {
        name: '73ec30e0-2e25-475f-beec-d90cab332eb7'
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Owner'
      }
      {
        name: '<name>'
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
      }
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    workspaces: [
      {
        apis: [
          {
            contacts: [
              {
                email: 'api-team@contoso.com'
                name: 'API Team'
              }
            ]
            description: 'A sample REST API for managing pets.'
            kind: 'rest'
            name: 'petstore-api'
            summary: 'Petstore management API.'
            title: 'Petstore API'
            versions: [
              {
                definitions: [
                  {
                    description: 'The OpenAPI 3.0 specification for the Petstore API v1.'
                    name: 'openapi-spec'
                    title: 'OpenAPI Specification'
                  }
                ]
                lifecycleStage: 'production'
                name: 'v1-0-0'
                title: 'v1.0.0'
              }
            ]
          }
        ]
        description: 'The default workspace for API governance.'
        environments: [
          {
            description: 'Production Azure API Management environment.'
            kind: 'production'
            name: 'production-apim'
            server: {
              type: 'Azure API Management'
            }
            title: 'Production APIM'
          }
          {
            description: 'Staging Azure API Management environment.'
            kind: 'staging'
            name: 'staging-apim'
            server: {
              type: 'Azure API Management'
            }
            title: 'Staging APIM'
          }
        ]
        name: 'default'
        title: 'Default Workspace'
      }
    ]
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "acsmax001"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": true,
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "metadataSchemas": {
      "value": [
        {
          "assignedTo": [
            {
              "entity": "api",
              "required": true
            }
          ],
          "name": "apiLifecycleStage",
          "schema": "{\"type\":\"string\",\"title\":\"API Lifecycle Stage\",\"enum\":[\"design\",\"development\",\"testing\",\"preview\",\"production\",\"deprecated\",\"retired\"]}"
        },
        {
          "assignedTo": [
            {
              "entity": "api",
              "required": false
            },
            {
              "entity": "environment",
              "required": false
            }
          ],
          "name": "apiCostCenter",
          "schema": "{\"type\":\"string\",\"title\":\"Cost Center\",\"pattern\":\"^[A-Z]{2}-[0-9]{4}$\"}"
        }
      ]
    },
    "roleAssignments": {
      "value": [
        {
          "name": "73ec30e0-2e25-475f-beec-d90cab332eb7",
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Owner"
        },
        {
          "name": "<name>",
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "b24988ac-6180-42a0-ab88-20f7382dd24c"
        },
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "<roleDefinitionIdOrName>"
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "workspaces": {
      "value": [
        {
          "apis": [
            {
              "contacts": [
                {
                  "email": "api-team@contoso.com",
                  "name": "API Team"
                }
              ],
              "description": "A sample REST API for managing pets.",
              "kind": "rest",
              "name": "petstore-api",
              "summary": "Petstore management API.",
              "title": "Petstore API",
              "versions": [
                {
                  "definitions": [
                    {
                      "description": "The OpenAPI 3.0 specification for the Petstore API v1.",
                      "name": "openapi-spec",
                      "title": "OpenAPI Specification"
                    }
                  ],
                  "lifecycleStage": "production",
                  "name": "v1-0-0",
                  "title": "v1.0.0"
                }
              ]
            }
          ],
          "description": "The default workspace for API governance.",
          "environments": [
            {
              "description": "Production Azure API Management environment.",
              "kind": "production",
              "name": "production-apim",
              "server": {
                "type": "Azure API Management"
              },
              "title": "Production APIM"
            },
            {
              "description": "Staging Azure API Management environment.",
              "kind": "staging",
              "name": "staging-apim",
              "server": {
                "type": "Azure API Management"
              },
              "title": "Staging APIM"
            }
          ],
          "name": "default",
          "title": "Default Workspace"
        }
      ]
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/api-center/service:<version>'

// Required parameters
param name = 'acsmax001'
// Non-required parameters
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param managedIdentities = {
  systemAssigned: true
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param metadataSchemas = [
  {
    assignedTo: [
      {
        entity: 'api'
        required: true
      }
    ]
    name: 'apiLifecycleStage'
    schema: '{\'type\':\'string\',\'title\':\'API Lifecycle Stage\',\'enum\':[\'design\',\'development\',\'testing\',\'preview\',\'production\',\'deprecated\',\'retired\']}'
  }
  {
    assignedTo: [
      {
        entity: 'api'
        required: false
      }
      {
        entity: 'environment'
        required: false
      }
    ]
    name: 'apiCostCenter'
    schema: '{\'type\':\'string\',\'title\':\'Cost Center\',\'pattern\':\'^[A-Z]{2}-[0-9]{4}$\'}'
  }
]
param roleAssignments = [
  {
    name: '73ec30e0-2e25-475f-beec-d90cab332eb7'
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'Owner'
  }
  {
    name: '<name>'
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  }
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
  }
]
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
param workspaces = [
  {
    apis: [
      {
        contacts: [
          {
            email: 'api-team@contoso.com'
            name: 'API Team'
          }
        ]
        description: 'A sample REST API for managing pets.'
        kind: 'rest'
        name: 'petstore-api'
        summary: 'Petstore management API.'
        title: 'Petstore API'
        versions: [
          {
            definitions: [
              {
                description: 'The OpenAPI 3.0 specification for the Petstore API v1.'
                name: 'openapi-spec'
                title: 'OpenAPI Specification'
              }
            ]
            lifecycleStage: 'production'
            name: 'v1-0-0'
            title: 'v1.0.0'
          }
        ]
      }
    ]
    description: 'The default workspace for API governance.'
    environments: [
      {
        description: 'Production Azure API Management environment.'
        kind: 'production'
        name: 'production-apim'
        server: {
          type: 'Azure API Management'
        }
        title: 'Production APIM'
      }
      {
        description: 'Staging Azure API Management environment.'
        kind: 'staging'
        name: 'staging-apim'
        server: {
          type: 'Azure API Management'
        }
        title: 'Staging APIM'
      }
    ]
    name: 'default'
    title: 'Default Workspace'
  }
]
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/waf-aligned]


<details>

<summary>via Bicep module</summary>

```bicep
module service 'br/public:avm/res/api-center/service:<version>' = {
  params: {
    // Required parameters
    name: 'acswaf001'
    // Non-required parameters
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    managedIdentities: {
      systemAssigned: true
    }
    metadataSchemas: [
      {
        assignedTo: [
          {
            entity: 'api'
            required: true
          }
        ]
        name: 'apiLifecycleStage'
        schema: '{\'type\':\'string\',\'title\':\'API Lifecycle Stage\',\'enum\':[\'design\',\'development\',\'testing\',\'preview\',\'production\',\'deprecated\',\'retired\']}'
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "acswaf001"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": true
      }
    },
    "metadataSchemas": {
      "value": [
        {
          "assignedTo": [
            {
              "entity": "api",
              "required": true
            }
          ],
          "name": "apiLifecycleStage",
          "schema": "{\"type\":\"string\",\"title\":\"API Lifecycle Stage\",\"enum\":[\"design\",\"development\",\"testing\",\"preview\",\"production\",\"deprecated\",\"retired\"]}"
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/api-center/service:<version>'

// Required parameters
param name = 'acswaf001'
// Non-required parameters
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param managedIdentities = {
  systemAssigned: true
}
param metadataSchemas = [
  {
    assignedTo: [
      {
        entity: 'api'
        required: true
      }
    ]
    name: 'apiLifecycleStage'
    schema: '{\'type\':\'string\',\'title\':\'API Lifecycle Stage\',\'enum\':[\'design\',\'development\',\'testing\',\'preview\',\'production\',\'deprecated\',\'retired\']}'
  }
]
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the API Center service. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`lock`](#parameter-lock) | object | The lock settings for all Resources in the solution. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`metadataSchemas`](#parameter-metadataschemas) | array | The metadata schemas to create as part of the API Center service. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`workspaces`](#parameter-workspaces) | array | The workspaces to create as part of the API Center service. |

### Parameter: `name`

The name of the API Center service.

- Required: Yes
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location for all Resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

The lock settings for all Resources in the solution.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-lockkind) | string | Specify the type of lock. |
| [`name`](#parameter-lockname) | string | Specify the name of lock. |
| [`notes`](#parameter-locknotes) | string | Specify the notes of the lock. |

### Parameter: `lock.kind`

Specify the type of lock.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'CanNotDelete'
    'None'
    'ReadOnly'
  ]
  ```

### Parameter: `lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `lock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `managedIdentities`

The managed identity definition for this resource.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`systemAssigned`](#parameter-managedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. |
| [`userAssignedResourceIds`](#parameter-managedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption. |

### Parameter: `managedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption.

- Required: No
- Type: array

### Parameter: `metadataSchemas`

The metadata schemas to create as part of the API Center service.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-metadataschemasname) | string | The name of the metadata schema. |
| [`schema`](#parameter-metadataschemasschema) | string | The JSON schema defining the metadata type. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`assignedTo`](#parameter-metadataschemasassignedto) | array | The entities the metadata schema is assigned to. |

### Parameter: `metadataSchemas.name`

The name of the metadata schema.

- Required: Yes
- Type: string

### Parameter: `metadataSchemas.schema`

The JSON schema defining the metadata type.

- Required: Yes
- Type: string

### Parameter: `metadataSchemas.assignedTo`

The entities the metadata schema is assigned to.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`deprecated`](#parameter-metadataschemasassignedtodeprecated) | bool | Whether the assignment is deprecated. |
| [`entity`](#parameter-metadataschemasassignedtoentity) | string | The entity the metadata schema is assigned to. |
| [`required`](#parameter-metadataschemasassignedtorequired) | bool | Whether the metadata is required for the entity. |

### Parameter: `metadataSchemas.assignedTo.deprecated`

Whether the assignment is deprecated.

- Required: No
- Type: bool

### Parameter: `metadataSchemas.assignedTo.entity`

The entity the metadata schema is assigned to.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'api'
    'deployment'
    'environment'
  ]
  ```

### Parameter: `metadataSchemas.assignedTo.required`

Whether the metadata is required for the entity.

- Required: No
- Type: bool

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`
  - `'Azure API Center Compliance Manager'`
  - `'Azure API Center Data Reader'`
  - `'Azure API Center Service Contributor'`
  - `'Azure API Center Service Reader'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-roleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-roleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-roleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `roleAssignments.principalType`

The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Device'
    'ForeignGroup'
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `workspaces`

The workspaces to create as part of the API Center service.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-workspacesname) | string | The name of the workspace. |
| [`title`](#parameter-workspacestitle) | string | The title of the workspace. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apis`](#parameter-workspacesapis) | array | The APIs to create in the workspace. |
| [`description`](#parameter-workspacesdescription) | string | The description of the workspace. |
| [`environments`](#parameter-workspacesenvironments) | array | The environments to create in the workspace. |

### Parameter: `workspaces.name`

The name of the workspace.

- Required: Yes
- Type: string

### Parameter: `workspaces.title`

The title of the workspace.

- Required: Yes
- Type: string

### Parameter: `workspaces.apis`

The APIs to create in the workspace.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-workspacesapiskind) | string | The kind of API. |
| [`name`](#parameter-workspacesapisname) | string | The name of the API. |
| [`title`](#parameter-workspacesapistitle) | string | The title of the API. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`contacts`](#parameter-workspacesapiscontacts) | array | The contacts for the API. |
| [`customProperties`](#parameter-workspacesapiscustomproperties) | object | The custom metadata properties. |
| [`deployments`](#parameter-workspacesapisdeployments) | array | The deployments for the API. |
| [`description`](#parameter-workspacesapisdescription) | string | The description of the API. |
| [`externalDocumentation`](#parameter-workspacesapisexternaldocumentation) | array | External documentation for the API. |
| [`license`](#parameter-workspacesapislicense) | object | The license information. |
| [`summary`](#parameter-workspacesapissummary) | string | Short description of the API. |
| [`termsOfService`](#parameter-workspacesapistermsofservice) | object | The terms of service. |
| [`versions`](#parameter-workspacesapisversions) | array | The versions for the API. |

### Parameter: `workspaces.apis.kind`

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

### Parameter: `workspaces.apis.name`

The name of the API.

- Required: Yes
- Type: string

### Parameter: `workspaces.apis.title`

The title of the API.

- Required: Yes
- Type: string

### Parameter: `workspaces.apis.contacts`

The contacts for the API.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`email`](#parameter-workspacesapiscontactsemail) | string | The email. |
| [`name`](#parameter-workspacesapiscontactsname) | string | The name. |
| [`url`](#parameter-workspacesapiscontactsurl) | string | The URL. |

### Parameter: `workspaces.apis.contacts.email`

The email.

- Required: No
- Type: string

### Parameter: `workspaces.apis.contacts.name`

The name.

- Required: No
- Type: string

### Parameter: `workspaces.apis.contacts.url`

The URL.

- Required: No
- Type: string

### Parameter: `workspaces.apis.customProperties`

The custom metadata properties.

- Required: No
- Type: object

### Parameter: `workspaces.apis.deployments`

The deployments for the API.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-workspacesapisdeploymentsname) | string | The name. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`customProperties`](#parameter-workspacesapisdeploymentscustomproperties) | object | Custom properties. |
| [`definitionId`](#parameter-workspacesapisdeploymentsdefinitionid) | string | The definition ID. |
| [`description`](#parameter-workspacesapisdeploymentsdescription) | string | The description. |
| [`environmentId`](#parameter-workspacesapisdeploymentsenvironmentid) | string | The environment ID. |
| [`server`](#parameter-workspacesapisdeploymentsserver) | object | Server information. |
| [`state`](#parameter-workspacesapisdeploymentsstate) | string | The state. |
| [`title`](#parameter-workspacesapisdeploymentstitle) | string | The title. |

### Parameter: `workspaces.apis.deployments.name`

The name.

- Required: Yes
- Type: string

### Parameter: `workspaces.apis.deployments.customProperties`

Custom properties.

- Required: No
- Type: object

### Parameter: `workspaces.apis.deployments.definitionId`

The definition ID.

- Required: No
- Type: string

### Parameter: `workspaces.apis.deployments.description`

The description.

- Required: No
- Type: string

### Parameter: `workspaces.apis.deployments.environmentId`

The environment ID.

- Required: No
- Type: string

### Parameter: `workspaces.apis.deployments.server`

Server information.

- Required: No
- Type: object

### Parameter: `workspaces.apis.deployments.state`

The state.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'active'
    'inactive'
  ]
  ```

### Parameter: `workspaces.apis.deployments.title`

The title.

- Required: No
- Type: string

### Parameter: `workspaces.apis.description`

The description of the API.

- Required: No
- Type: string

### Parameter: `workspaces.apis.externalDocumentation`

External documentation for the API.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`url`](#parameter-workspacesapisexternaldocumentationurl) | string | The URL of the documentation. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-workspacesapisexternaldocumentationdescription) | string | The description. |
| [`title`](#parameter-workspacesapisexternaldocumentationtitle) | string | The title. |

### Parameter: `workspaces.apis.externalDocumentation.url`

The URL of the documentation.

- Required: Yes
- Type: string

### Parameter: `workspaces.apis.externalDocumentation.description`

The description.

- Required: No
- Type: string

### Parameter: `workspaces.apis.externalDocumentation.title`

The title.

- Required: No
- Type: string

### Parameter: `workspaces.apis.license`

The license information.

- Required: No
- Type: object

### Parameter: `workspaces.apis.summary`

Short description of the API.

- Required: No
- Type: string

### Parameter: `workspaces.apis.termsOfService`

The terms of service.

- Required: No
- Type: object

### Parameter: `workspaces.apis.versions`

The versions for the API.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`lifecycleStage`](#parameter-workspacesapisversionslifecyclestage) | string | The lifecycle stage. |
| [`name`](#parameter-workspacesapisversionsname) | string | The name of the version. |
| [`title`](#parameter-workspacesapisversionstitle) | string | The title. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`definitions`](#parameter-workspacesapisversionsdefinitions) | array | Definitions for the version. |

### Parameter: `workspaces.apis.versions.lifecycleStage`

The lifecycle stage.

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

### Parameter: `workspaces.apis.versions.name`

The name of the version.

- Required: Yes
- Type: string

### Parameter: `workspaces.apis.versions.title`

The title.

- Required: Yes
- Type: string

### Parameter: `workspaces.apis.versions.definitions`

Definitions for the version.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-workspacesapisversionsdefinitionsname) | string | The name. |
| [`title`](#parameter-workspacesapisversionsdefinitionstitle) | string | The title. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-workspacesapisversionsdefinitionsdescription) | string | The description. |

### Parameter: `workspaces.apis.versions.definitions.name`

The name.

- Required: Yes
- Type: string

### Parameter: `workspaces.apis.versions.definitions.title`

The title.

- Required: Yes
- Type: string

### Parameter: `workspaces.apis.versions.definitions.description`

The description.

- Required: No
- Type: string

### Parameter: `workspaces.description`

The description of the workspace.

- Required: No
- Type: string

### Parameter: `workspaces.environments`

The environments to create in the workspace.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-workspacesenvironmentskind) | string | The kind of environment. |
| [`name`](#parameter-workspacesenvironmentsname) | string | The name of the environment. |
| [`title`](#parameter-workspacesenvironmentstitle) | string | The title of the environment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`customProperties`](#parameter-workspacesenvironmentscustomproperties) | object | The custom metadata properties. |
| [`description`](#parameter-workspacesenvironmentsdescription) | string | The description of the environment. |
| [`onboarding`](#parameter-workspacesenvironmentsonboarding) | object | Onboarding information for the environment. |
| [`server`](#parameter-workspacesenvironmentsserver) | object | Server information of the environment. |

### Parameter: `workspaces.environments.kind`

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

### Parameter: `workspaces.environments.name`

The name of the environment.

- Required: Yes
- Type: string

### Parameter: `workspaces.environments.title`

The title of the environment.

- Required: Yes
- Type: string

### Parameter: `workspaces.environments.customProperties`

The custom metadata properties.

- Required: No
- Type: object

### Parameter: `workspaces.environments.description`

The description of the environment.

- Required: No
- Type: string

### Parameter: `workspaces.environments.onboarding`

Onboarding information for the environment.

- Required: No
- Type: object

### Parameter: `workspaces.environments.server`

Server information of the environment.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the API Center service. |
| `resourceGroupName` | string | The name of the resource group the API Center service was created in. |
| `resourceId` | string | The resource ID of the API Center service. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
