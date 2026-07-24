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
- [Cross-referenced modules](#Cross-referenced-modules)
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
| `Microsoft.ApiCenter/services/workspaces/apiSources` | 2024-06-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apicenter_services_workspaces_apisources.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiCenter/2024-06-01-preview/services/workspaces/apiSources)</li></ul> |
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
    name: '<name>'
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
      "value": "<name>"
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
param name = '<name>'
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
    name: '<name>'
    // Non-required parameters
    apis: [
      {
        contacts: [
          {
            email: 'api-team@contoso.com'
            name: 'API Team'
            url: 'https://contoso.com/teams/api'
          }
        ]
        customProperties: {
          apiCostCenter: 'CC-2001'
          apiTeamOwner: 'Platform Engineering'
        }
        deployments: [
          {
            definition: 'openapi-spec'
            environment: 'staging-apim'
            name: 'petstore-staging-deployment'
            title: 'Petstore Staging'
            version: 'v2-0-0-preview'
          }
          {
            customProperties: {
              apiTeamOwner: 'Platform Engineering'
            }
            definition: 'openapi-spec'
            description: 'Production deployment of the Petstore API.'
            environment: 'production-apim'
            name: 'petstore-prod-deployment'
            server: {
              runtimeUri: [
                'https://contoso.com/petstore/api'
              ]
            }
            state: 'active'
            title: 'Petstore Production'
            version: 'v1-0-0'
          }
        ]
        description: 'A sample REST API for managing pets.'
        externalDocumentation: [
          {
            description: 'Full reference documentation for the Petstore API.'
            title: 'API Documentation'
            url: 'https://contoso.com/docs/petstore'
          }
          {
            title: 'Getting Started Guide'
            url: 'https://contoso.com/petstore/getting-started'
          }
        ]
        kind: 'rest'
        license: {
          identifier: 'mit'
          name: 'MIT License'
          url: 'https://opensource.org/licenses/MIT'
        }
        name: 'petstore-api'
        summary: 'Petstore management API.'
        termsOfService: {
          url: 'https://contoso.com/terms-of-service'
        }
        title: 'Petstore API'
        versions: [
          {
            lifecycleStage: 'retired'
            name: 'v0-9-0'
            title: 'v0.9.0'
          }
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
          {
            definitions: [
              {
                description: 'The OpenAPI 3.0 specification for the Petstore API v2.'
                name: 'openapi-spec'
                title: 'OpenAPI Specification'
              }
            ]
            lifecycleStage: 'preview'
            name: 'v2-0-0-preview'
            title: 'v2.0.0-preview'
          }
        ]
      }
      {
        customProperties: {
          apiCostCenter: 'CC-2001'
        }
        description: 'A GraphQL API'
        kind: 'graphql'
        name: 'graphql-api'
        title: 'GraphQL API'
      }
      {
        customProperties: {
          apiCostCenter: 'CC-3001'
        }
        description: 'A SOAP-based API'
        kind: 'soap'
        name: 'soap-api'
        title: 'SOAP API'
      }
      {
        customProperties: {
          apiCostCenter: 'CC-4001'
        }
        description: 'A webhook API'
        kind: 'webhook'
        name: 'webhook-notifications'
        title: 'Webhook Notifications'
      }
      {
        customProperties: {
          apiCostCenter: 'CC-5001'
        }
        description: 'A gRPC API'
        kind: 'grpc'
        name: 'grpc-api'
        title: 'gRPC API'
      }
      {
        customProperties: {
          apiCostCenter: 'CC-6001'
        }
        description: 'A WebSocket API'
        kind: 'websocket'
        name: 'ws-api'
        title: 'WebSocket API'
      }
    ]
    apiSources: [
      {
        azureApiManagementSource: {
          msiResourceId: '<msiResourceId>'
          resourceId: '<resourceId>'
        }
        importSpecification: 'always'
        name: 'apim-import-source'
        targetEnvironment: 'production-apim'
        targetLifecycleStage: 'production'
      }
    ]
    environments: [
      {
        customProperties: {
          apiCostCenter: 'CC-1001'
        }
        description: 'Production Azure API Management environment.'
        kind: 'production'
        name: 'production-apim'
        onboarding: {
          developerPortalUri: [
            'https://contoso.com/develop'
          ]
          instructions: 'Sign up using the developer portal to get started with our APIs.'
        }
        server: {
          managementPortalUri: [
            'https://portal.azure.com'
          ]
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
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'ApiCenterDeleteLock'
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
          {
            entity: 'environment'
            required: false
          }
        ]
        name: 'apiCostCenter'
        schema: '{\'type\':\'string\',\'title\':\'Cost Center\',\'pattern\':\'^[A-Z]{2}-[0-9]{4}$\'}'
      }
      {
        assignedTo: [
          {
            entity: 'api'
            required: false
          }
          {
            entity: 'deployment'
            required: false
          }
        ]
        name: 'apiTeamOwner'
        schema: '{\'type\':\'string\',\'title\':\'Team Owner\',\'minLength\':1,\'maxLength\':100}'
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
    sku: 'Free'
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
      "value": "<name>"
    },
    // Non-required parameters
    "apis": {
      "value": [
        {
          "contacts": [
            {
              "email": "api-team@contoso.com",
              "name": "API Team",
              "url": "https://contoso.com/teams/api"
            }
          ],
          "customProperties": {
            "apiCostCenter": "CC-2001",
            "apiTeamOwner": "Platform Engineering"
          },
          "deployments": [
            {
              "definition": "openapi-spec",
              "environment": "staging-apim",
              "name": "petstore-staging-deployment",
              "title": "Petstore Staging",
              "version": "v2-0-0-preview"
            },
            {
              "customProperties": {
                "apiTeamOwner": "Platform Engineering"
              },
              "definition": "openapi-spec",
              "description": "Production deployment of the Petstore API.",
              "environment": "production-apim",
              "name": "petstore-prod-deployment",
              "server": {
                "runtimeUri": [
                  "https://contoso.com/petstore/api"
                ]
              },
              "state": "active",
              "title": "Petstore Production",
              "version": "v1-0-0"
            }
          ],
          "description": "A sample REST API for managing pets.",
          "externalDocumentation": [
            {
              "description": "Full reference documentation for the Petstore API.",
              "title": "API Documentation",
              "url": "https://contoso.com/docs/petstore"
            },
            {
              "title": "Getting Started Guide",
              "url": "https://contoso.com/petstore/getting-started"
            }
          ],
          "kind": "rest",
          "license": {
            "identifier": "mit",
            "name": "MIT License",
            "url": "https://opensource.org/licenses/MIT"
          },
          "name": "petstore-api",
          "summary": "Petstore management API.",
          "termsOfService": {
            "url": "https://contoso.com/terms-of-service"
          },
          "title": "Petstore API",
          "versions": [
            {
              "lifecycleStage": "retired",
              "name": "v0-9-0",
              "title": "v0.9.0"
            },
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
            },
            {
              "definitions": [
                {
                  "description": "The OpenAPI 3.0 specification for the Petstore API v2.",
                  "name": "openapi-spec",
                  "title": "OpenAPI Specification"
                }
              ],
              "lifecycleStage": "preview",
              "name": "v2-0-0-preview",
              "title": "v2.0.0-preview"
            }
          ]
        },
        {
          "customProperties": {
            "apiCostCenter": "CC-2001"
          },
          "description": "A GraphQL API",
          "kind": "graphql",
          "name": "graphql-api",
          "title": "GraphQL API"
        },
        {
          "customProperties": {
            "apiCostCenter": "CC-3001"
          },
          "description": "A SOAP-based API",
          "kind": "soap",
          "name": "soap-api",
          "title": "SOAP API"
        },
        {
          "customProperties": {
            "apiCostCenter": "CC-4001"
          },
          "description": "A webhook API",
          "kind": "webhook",
          "name": "webhook-notifications",
          "title": "Webhook Notifications"
        },
        {
          "customProperties": {
            "apiCostCenter": "CC-5001"
          },
          "description": "A gRPC API",
          "kind": "grpc",
          "name": "grpc-api",
          "title": "gRPC API"
        },
        {
          "customProperties": {
            "apiCostCenter": "CC-6001"
          },
          "description": "A WebSocket API",
          "kind": "websocket",
          "name": "ws-api",
          "title": "WebSocket API"
        }
      ]
    },
    "apiSources": {
      "value": [
        {
          "azureApiManagementSource": {
            "msiResourceId": "<msiResourceId>",
            "resourceId": "<resourceId>"
          },
          "importSpecification": "always",
          "name": "apim-import-source",
          "targetEnvironment": "production-apim",
          "targetLifecycleStage": "production"
        }
      ]
    },
    "environments": {
      "value": [
        {
          "customProperties": {
            "apiCostCenter": "CC-1001"
          },
          "description": "Production Azure API Management environment.",
          "kind": "production",
          "name": "production-apim",
          "onboarding": {
            "developerPortalUri": [
              "https://contoso.com/develop"
            ],
            "instructions": "Sign up using the developer portal to get started with our APIs."
          },
          "server": {
            "managementPortalUri": [
              "https://portal.azure.com"
            ],
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
      ]
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "ApiCenterDeleteLock"
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
            },
            {
              "entity": "environment",
              "required": false
            }
          ],
          "name": "apiCostCenter",
          "schema": "{\"type\":\"string\",\"title\":\"Cost Center\",\"pattern\":\"^[A-Z]{2}-[0-9]{4}$\"}"
        },
        {
          "assignedTo": [
            {
              "entity": "api",
              "required": false
            },
            {
              "entity": "deployment",
              "required": false
            }
          ],
          "name": "apiTeamOwner",
          "schema": "{\"type\":\"string\",\"title\":\"Team Owner\",\"minLength\":1,\"maxLength\":100}"
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
    "sku": {
      "value": "Free"
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
param name = '<name>'
// Non-required parameters
param apis = [
  {
    contacts: [
      {
        email: 'api-team@contoso.com'
        name: 'API Team'
        url: 'https://contoso.com/teams/api'
      }
    ]
    customProperties: {
      apiCostCenter: 'CC-2001'
      apiTeamOwner: 'Platform Engineering'
    }
    deployments: [
      {
        definition: 'openapi-spec'
        environment: 'staging-apim'
        name: 'petstore-staging-deployment'
        title: 'Petstore Staging'
        version: 'v2-0-0-preview'
      }
      {
        customProperties: {
          apiTeamOwner: 'Platform Engineering'
        }
        definition: 'openapi-spec'
        description: 'Production deployment of the Petstore API.'
        environment: 'production-apim'
        name: 'petstore-prod-deployment'
        server: {
          runtimeUri: [
            'https://contoso.com/petstore/api'
          ]
        }
        state: 'active'
        title: 'Petstore Production'
        version: 'v1-0-0'
      }
    ]
    description: 'A sample REST API for managing pets.'
    externalDocumentation: [
      {
        description: 'Full reference documentation for the Petstore API.'
        title: 'API Documentation'
        url: 'https://contoso.com/docs/petstore'
      }
      {
        title: 'Getting Started Guide'
        url: 'https://contoso.com/petstore/getting-started'
      }
    ]
    kind: 'rest'
    license: {
      identifier: 'mit'
      name: 'MIT License'
      url: 'https://opensource.org/licenses/MIT'
    }
    name: 'petstore-api'
    summary: 'Petstore management API.'
    termsOfService: {
      url: 'https://contoso.com/terms-of-service'
    }
    title: 'Petstore API'
    versions: [
      {
        lifecycleStage: 'retired'
        name: 'v0-9-0'
        title: 'v0.9.0'
      }
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
      {
        definitions: [
          {
            description: 'The OpenAPI 3.0 specification for the Petstore API v2.'
            name: 'openapi-spec'
            title: 'OpenAPI Specification'
          }
        ]
        lifecycleStage: 'preview'
        name: 'v2-0-0-preview'
        title: 'v2.0.0-preview'
      }
    ]
  }
  {
    customProperties: {
      apiCostCenter: 'CC-2001'
    }
    description: 'A GraphQL API'
    kind: 'graphql'
    name: 'graphql-api'
    title: 'GraphQL API'
  }
  {
    customProperties: {
      apiCostCenter: 'CC-3001'
    }
    description: 'A SOAP-based API'
    kind: 'soap'
    name: 'soap-api'
    title: 'SOAP API'
  }
  {
    customProperties: {
      apiCostCenter: 'CC-4001'
    }
    description: 'A webhook API'
    kind: 'webhook'
    name: 'webhook-notifications'
    title: 'Webhook Notifications'
  }
  {
    customProperties: {
      apiCostCenter: 'CC-5001'
    }
    description: 'A gRPC API'
    kind: 'grpc'
    name: 'grpc-api'
    title: 'gRPC API'
  }
  {
    customProperties: {
      apiCostCenter: 'CC-6001'
    }
    description: 'A WebSocket API'
    kind: 'websocket'
    name: 'ws-api'
    title: 'WebSocket API'
  }
]
param apiSources = [
  {
    azureApiManagementSource: {
      msiResourceId: '<msiResourceId>'
      resourceId: '<resourceId>'
    }
    importSpecification: 'always'
    name: 'apim-import-source'
    targetEnvironment: 'production-apim'
    targetLifecycleStage: 'production'
  }
]
param environments = [
  {
    customProperties: {
      apiCostCenter: 'CC-1001'
    }
    description: 'Production Azure API Management environment.'
    kind: 'production'
    name: 'production-apim'
    onboarding: {
      developerPortalUri: [
        'https://contoso.com/develop'
      ]
      instructions: 'Sign up using the developer portal to get started with our APIs.'
    }
    server: {
      managementPortalUri: [
        'https://portal.azure.com'
      ]
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
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'ApiCenterDeleteLock'
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
      {
        entity: 'environment'
        required: false
      }
    ]
    name: 'apiCostCenter'
    schema: '{\'type\':\'string\',\'title\':\'Cost Center\',\'pattern\':\'^[A-Z]{2}-[0-9]{4}$\'}'
  }
  {
    assignedTo: [
      {
        entity: 'api'
        required: false
      }
      {
        entity: 'deployment'
        required: false
      }
    ]
    name: 'apiTeamOwner'
    schema: '{\'type\':\'string\',\'title\':\'Team Owner\',\'minLength\':1,\'maxLength\':100}'
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
param sku = 'Free'
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
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
    name: '<name>'
    // Non-required parameters
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'ApiCenterDeleteLock'
    }
    managedIdentities: {
      systemAssigned: true
    }
    metadataSchemas: []
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Azure API Center Data Reader'
      }
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Azure API Center Service Reader'
      }
    ]
    tags: {
      Environment: 'Non-Prod'
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
      "value": "<name>"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "ApiCenterDeleteLock"
      }
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": true
      }
    },
    "metadataSchemas": {
      "value": []
    },
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Azure API Center Data Reader"
        },
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Azure API Center Service Reader"
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
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
param name = '<name>'
// Non-required parameters
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'ApiCenterDeleteLock'
}
param managedIdentities = {
  systemAssigned: true
}
param metadataSchemas = []
param roleAssignments = [
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'Azure API Center Data Reader'
  }
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'Azure API Center Service Reader'
  }
]
param tags = {
  Environment: 'Non-Prod'
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
| [`apis`](#parameter-apis) | array | The APIs to create within the default workspace of the API Center service. |
| [`apiSources`](#parameter-apisources) | array | The API sources to create within the default workspace for importing APIs from external sources. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`environments`](#parameter-environments) | array | The environments to create within the default workspace of the API Center service. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`lock`](#parameter-lock) | object | The lock settings for the service resource. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`metadataSchemas`](#parameter-metadataschemas) | array | The metadata schemas to create within the API Center service. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create scoped to the service. |
| [`sku`](#parameter-sku) | string | The SKU to deploy, Use Free for evaluation purposes and Standard for long-lived and production deployments. Defaults to Standard. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `name`

The name of the API Center service.

- Required: Yes
- Type: string

### Parameter: `apis`

The APIs to create within the default workspace of the API Center service.

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
| [`customProperties`](#parameter-apiscustomproperties) |  | The custom metadata defined for API catalog entities. |
| [`deployments`](#parameter-apisdeployments) | array | The deployments for the API. |
| [`description`](#parameter-apisdescription) | string | The description of the API. |
| [`externalDocumentation`](#parameter-apisexternaldocumentation) | array | External documentation for the API. |
| [`license`](#parameter-apislicense) | object | The license information for the API. |
| [`summary`](#parameter-apissummary) | string | Short description of the API. |
| [`termsOfService`](#parameter-apistermsofservice) | object | The terms of service for the API. |
| [`versions`](#parameter-apisversions) | array | The versions for the API. |

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

The custom metadata defined for API catalog entities.

- Required: No
- Type: 

### Parameter: `apis.deployments`

The deployments for the API.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`definition`](#parameter-apisdeploymentsdefinition) | string | The deployed definition name. |
| [`environment`](#parameter-apisdeploymentsenvironment) | string | The target environment name of the deployment. |
| [`name`](#parameter-apisdeploymentsname) | string | The name of the deployment. |
| [`version`](#parameter-apisdeploymentsversion) | string | The deployed version name. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`customProperties`](#parameter-apisdeploymentscustomproperties) |  | The custom metadata defined for API catalog entities. |
| [`description`](#parameter-apisdeploymentsdescription) | string | The description of the deployment. |
| [`server`](#parameter-apisdeploymentsserver) | object | The server information of the deployment. |
| [`state`](#parameter-apisdeploymentsstate) | string | The state of the deployment. |
| [`title`](#parameter-apisdeploymentstitle) | string | The title of the deployment. |

### Parameter: `apis.deployments.definition`

The deployed definition name.

- Required: Yes
- Type: string

### Parameter: `apis.deployments.environment`

The target environment name of the deployment.

- Required: Yes
- Type: string

### Parameter: `apis.deployments.name`

The name of the deployment.

- Required: Yes
- Type: string

### Parameter: `apis.deployments.version`

The deployed version name.

- Required: Yes
- Type: string

### Parameter: `apis.deployments.customProperties`

The custom metadata defined for API catalog entities.

- Required: No
- Type: 

### Parameter: `apis.deployments.description`

The description of the deployment.

- Required: No
- Type: string

### Parameter: `apis.deployments.server`

The server information of the deployment.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`runtimeUri`](#parameter-apisdeploymentsserverruntimeuri) | array | The base runtime URIs for this deployment. |

### Parameter: `apis.deployments.server.runtimeUri`

The base runtime URIs for this deployment.

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

External documentation for the API.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`url`](#parameter-apisexternaldocumentationurl) | string | The URL pointing to the documentation. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-apisexternaldocumentationdescription) | string | The description of the documentation. |
| [`title`](#parameter-apisexternaldocumentationtitle) | string | The title of the documentation. |

### Parameter: `apis.externalDocumentation.url`

The URL pointing to the documentation.

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
| [`identifier`](#parameter-apislicenseidentifier) | string | SPDX license identifier. Mutually exclusive with url. |
| [`name`](#parameter-apislicensename) | string | The name of the license. |
| [`url`](#parameter-apislicenseurl) | string | URL pointing to the license details. Mutually exclusive with identifier. |

### Parameter: `apis.license.identifier`

SPDX license identifier. Mutually exclusive with url.

- Required: No
- Type: string

### Parameter: `apis.license.name`

The name of the license.

- Required: No
- Type: string

### Parameter: `apis.license.url`

URL pointing to the license details. Mutually exclusive with identifier.

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
| [`url`](#parameter-apistermsofserviceurl) | string | URL pointing to the terms of service. |

### Parameter: `apis.termsOfService.url`

URL pointing to the terms of service.

- Required: Yes
- Type: string

### Parameter: `apis.versions`

The versions for the API.

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

### Parameter: `apiSources`

The API sources to create within the default workspace for importing APIs from external sources.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`azureApiManagementSource`](#parameter-apisourcesazureapimanagementsource) | object | Configuration for importing APIs from Azure API Management. |
| [`name`](#parameter-apisourcesname) | string | The name of the API source. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`importSpecification`](#parameter-apisourcesimportspecification) | string | Indicates if the specification should be imported along with metadata. |
| [`targetEnvironment`](#parameter-apisourcestargetenvironment) | string | The target environment name. If not provided a new environment will be created. |
| [`targetLifecycleStage`](#parameter-apisourcestargetlifecyclestage) | string | The target lifecycle stage for imported APIs. |

### Parameter: `apiSources.azureApiManagementSource`

Configuration for importing APIs from Azure API Management.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`resourceId`](#parameter-apisourcesazureapimanagementsourceresourceid) | string | The resource ID of the Azure API Management instance. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`msiResourceId`](#parameter-apisourcesazureapimanagementsourcemsiresourceid) | string | The resource ID of the managed identity that has access to the API Management instance. If not provided, system-assigned identity is used and granted Api Management Service Reader role. |

### Parameter: `apiSources.azureApiManagementSource.resourceId`

The resource ID of the Azure API Management instance.

- Required: Yes
- Type: string

### Parameter: `apiSources.azureApiManagementSource.msiResourceId`

The resource ID of the managed identity that has access to the API Management instance. If not provided, system-assigned identity is used and granted Api Management Service Reader role.

- Required: No
- Type: string

### Parameter: `apiSources.name`

The name of the API source.

- Required: Yes
- Type: string

### Parameter: `apiSources.importSpecification`

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

### Parameter: `apiSources.targetEnvironment`

The target environment name. If not provided a new environment will be created.

- Required: No
- Type: string

### Parameter: `apiSources.targetLifecycleStage`

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

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `environments`

The environments to create within the default workspace of the API Center service.

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
| [`customProperties`](#parameter-environmentscustomproperties) |  | The custom metadata defined for API catalog entities. |
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

The custom metadata defined for API catalog entities.

- Required: No
- Type: 

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
| [`type`](#parameter-environmentsservertype) | string | The type of server that represents the environment. |

### Parameter: `environments.server.managementPortalUri`

The management portal URIs.

- Required: No
- Type: array

### Parameter: `environments.server.type`

The type of server that represents the environment.

- Required: No
- Type: string

### Parameter: `location`

Location for all Resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

The lock settings for the service resource.

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

The metadata schemas to create within the API Center service.

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
| [`deprecated`](#parameter-metadataschemasassignedtodeprecated) | bool | Whether the metadata property is deprecated. |
| [`entity`](#parameter-metadataschemasassignedtoentity) | string | The entity the metadata schema is assigned to. |
| [`required`](#parameter-metadataschemasassignedtorequired) | bool | Whether the metadata is required for the entity. |

### Parameter: `metadataSchemas.assignedTo.deprecated`

Whether the metadata property is deprecated.

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

Array of role assignments to create scoped to the service.

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

### Parameter: `sku`

The SKU to deploy, Use Free for evaluation purposes and Standard for long-lived and production deployments. Defaults to Standard.

- Required: No
- Type: string
- Default: `'Standard'`
- Allowed:
  ```Bicep
  [
    'Free'
    'Standard'
  ]
  ```

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the API Center service. |
| `resourceGroupName` | string | The name of the resource group the API Center service was deployed into. |
| `resourceId` | string | The resource ID of the API Center service. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.7.0` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
