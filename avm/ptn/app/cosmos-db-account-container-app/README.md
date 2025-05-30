# Azure Cosmos DB & Azure Container Apps - Web Application `[App/CosmosDbAccountContainerApp]`

This module deploys an n-teir web application to Azure Container Apps. The module also deploys a backing Azure Cosmos DB account with an account type switch. Options for Azure Cosmos DB include; NoSQL, Table, and MongoDB (RU). The web application uses the appropriate security best practices to connect the web application to the backing account.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.App/containerApps` | [2024-10-02-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2024-10-02-preview/containerApps) |
| `Microsoft.App/containerApps/authConfigs` | [2024-10-02-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2024-10-02-preview/containerApps/authConfigs) |
| `Microsoft.App/managedEnvironments` | [2024-10-02-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2024-10-02-preview/managedEnvironments) |
| `Microsoft.App/managedEnvironments/certificates` | [2024-10-02-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2024-10-02-preview/managedEnvironments/certificates) |
| `Microsoft.App/managedEnvironments/storages` | [2024-10-02-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2024-10-02-preview/managedEnvironments/storages) |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.ContainerRegistry/registries` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-06-01-preview/registries) |
| `Microsoft.ContainerRegistry/registries/cacheRules` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-06-01-preview/registries/cacheRules) |
| `Microsoft.ContainerRegistry/registries/credentialSets` | [2023-11-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-11-01-preview/registries/credentialSets) |
| `Microsoft.ContainerRegistry/registries/replications` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-06-01-preview/registries/replications) |
| `Microsoft.ContainerRegistry/registries/scopeMaps` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-06-01-preview/registries/scopeMaps) |
| `Microsoft.ContainerRegistry/registries/webhooks` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-06-01-preview/registries/webhooks) |
| `Microsoft.DocumentDB/databaseAccounts` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts) |
| `Microsoft.DocumentDB/databaseAccounts/gremlinDatabases` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/gremlinDatabases) |
| `Microsoft.DocumentDB/databaseAccounts/gremlinDatabases/graphs` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/gremlinDatabases/graphs) |
| `Microsoft.DocumentDB/databaseAccounts/mongodbDatabases` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/mongodbDatabases) |
| `Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/mongodbDatabases/collections) |
| `Microsoft.DocumentDB/databaseAccounts/sqlDatabases` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/sqlDatabases) |
| `Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/sqlDatabases/containers) |
| `Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/sqlRoleAssignments) |
| `Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/sqlRoleDefinitions) |
| `Microsoft.DocumentDB/databaseAccounts/tables` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/tables) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.ManagedIdentity/userAssignedIdentities` | [2024-11-30](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2024-11-30/userAssignedIdentities) |
| `Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials` | [2024-11-30](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2024-11-30/userAssignedIdentities/federatedIdentityCredentials) |
| `Microsoft.Network/privateEndpoints` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.OperationalInsights/workspaces` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces) |
| `Microsoft.OperationalInsights/workspaces/dataExports` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces/dataExports) |
| `Microsoft.OperationalInsights/workspaces/dataSources` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces/dataSources) |
| `Microsoft.OperationalInsights/workspaces/linkedServices` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces/linkedServices) |
| `Microsoft.OperationalInsights/workspaces/linkedStorageAccounts` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces/linkedStorageAccounts) |
| `Microsoft.OperationalInsights/workspaces/savedSearches` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces/savedSearches) |
| `Microsoft.OperationalInsights/workspaces/storageInsightConfigs` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces/storageInsightConfigs) |
| `Microsoft.OperationalInsights/workspaces/tables` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces/tables) |
| `Microsoft.OperationsManagement/solutions` | [2015-11-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationsManagement/2015-11-01-preview/solutions) |
| `Microsoft.Resources/deploymentScripts` | [2023-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2023-08-01/deploymentScripts) |
| `Microsoft.SecurityInsights/onboardingStates` | [2024-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.SecurityInsights/2024-03-01/onboardingStates) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/app/cosmos-db-account-container-app:<version>`.

- [Test using a typical use-case pattern for Azure Developer CLI (AZD).](#example-1-test-using-a-typical-use-case-pattern-for-azure-developer-cli-azd)
- [Test using only the default parameters.](#example-2-test-using-only-the-default-parameters)
- [Test with all (max) parameters.](#example-3-test-with-all-max-parameters)
- [Test with WAF-aligned parameters.](#example-4-test-with-waf-aligned-parameters)

### Example 1: _Test using a typical use-case pattern for Azure Developer CLI (AZD)._

This test deploys a common web application using that would be used with an Azure Developer CLI (AZD) template. The web application has two tiers for front-end and back-end and is backed by an Azure Cosmos DB for NoSQL account.


<details>

<summary>via Bicep module</summary>

```bicep
module cosmosDbAccountContainerApp 'br/public:avm/ptn/app/cosmos-db-account-container-app:<version>' = {
  name: 'cosmosDbAccountContainerAppDeployment'
  params: {
    // Required parameters
    name: '<name>'
    // Non-required parameters
    database: {
      additionalRoleBasedAccessControlPrincipals: [
        '<objectId>'
      ]
      databases: [
        {
          containers: [
            {
              name: 'products'
              partitionKeys: [
                '/category'
                '/subCategory'
              ]
              seed: 'cosmicworks-products'
            }
          ]
          name: 'cosmicworks'
        }
      ]
      publicNetworkAccessEnabled: true
      type: 'NoSQL'
      zoneRedundant: false
    }
    location: '<location>'
    web: {
      additionalRoleBasedAccessControlPrincipals: [
        '<objectId>'
      ]
      publicNetworkAccessEnabled: true
      tiers: [
        {
          allowIngress: true
          environment: [
            {
              knownValue: 'AzureCosmosDBEndpoint'
              name: 'CONFIGURATION__AZURECOSMOSDB__ENDPOINT'
            }
            {
              name: 'CONFIGURATION__AZURECOSMOSDB__DATABASENAME'
              value: 'cosmicworks'
            }
            {
              name: 'CONFIGURATION__AZURECOSMOSDB__CONTAINERNAME'
              value: 'products'
            }
          ]
          image: 'mcr.microsoft.com/dotnet/samples:aspnetapp-9.0'
          name: 'back-end'
          port: 8080
          tags: {
            'azd-service-name': 'api'
          }
          useManagedIdentity: true
        }
        {
          allowIngress: true
          environment: [
            {
              format: '{0}/api'
              name: 'CONFIGURATION__API__ENDPOINT'
              tierEndpoint: 'back-end'
            }
          ]
          image: 'mcr.microsoft.com/dotnet/samples:aspnetapp-9.0'
          name: 'front-end'
          port: 8080
          tags: {
            'azd-service-name': 'web'
          }
          useManagedIdentity: true
        }
      ]
      zoneRedundant: false
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
    "database": {
      "value": {
        "additionalRoleBasedAccessControlPrincipals": [
          "<objectId>"
        ],
        "databases": [
          {
            "containers": [
              {
                "name": "products",
                "partitionKeys": [
                  "/category",
                  "/subCategory"
                ],
                "seed": "cosmicworks-products"
              }
            ],
            "name": "cosmicworks"
          }
        ],
        "publicNetworkAccessEnabled": true,
        "type": "NoSQL",
        "zoneRedundant": false
      }
    },
    "location": {
      "value": "<location>"
    },
    "web": {
      "value": {
        "additionalRoleBasedAccessControlPrincipals": [
          "<objectId>"
        ],
        "publicNetworkAccessEnabled": true,
        "tiers": [
          {
            "allowIngress": true,
            "environment": [
              {
                "knownValue": "AzureCosmosDBEndpoint",
                "name": "CONFIGURATION__AZURECOSMOSDB__ENDPOINT"
              },
              {
                "name": "CONFIGURATION__AZURECOSMOSDB__DATABASENAME",
                "value": "cosmicworks"
              },
              {
                "name": "CONFIGURATION__AZURECOSMOSDB__CONTAINERNAME",
                "value": "products"
              }
            ],
            "image": "mcr.microsoft.com/dotnet/samples:aspnetapp-9.0",
            "name": "back-end",
            "port": 8080,
            "tags": {
              "azd-service-name": "api"
            },
            "useManagedIdentity": true
          },
          {
            "allowIngress": true,
            "environment": [
              {
                "format": "{0}/api",
                "name": "CONFIGURATION__API__ENDPOINT",
                "tierEndpoint": "back-end"
              }
            ],
            "image": "mcr.microsoft.com/dotnet/samples:aspnetapp-9.0",
            "name": "front-end",
            "port": 8080,
            "tags": {
              "azd-service-name": "web"
            },
            "useManagedIdentity": true
          }
        ],
        "zoneRedundant": false
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
using 'br/public:avm/ptn/app/cosmos-db-account-container-app:<version>'

// Required parameters
param name = '<name>'
// Non-required parameters
param database = {
  additionalRoleBasedAccessControlPrincipals: [
    '<objectId>'
  ]
  databases: [
    {
      containers: [
        {
          name: 'products'
          partitionKeys: [
            '/category'
            '/subCategory'
          ]
          seed: 'cosmicworks-products'
        }
      ]
      name: 'cosmicworks'
    }
  ]
  publicNetworkAccessEnabled: true
  type: 'NoSQL'
  zoneRedundant: false
}
param location = '<location>'
param web = {
  additionalRoleBasedAccessControlPrincipals: [
    '<objectId>'
  ]
  publicNetworkAccessEnabled: true
  tiers: [
    {
      allowIngress: true
      environment: [
        {
          knownValue: 'AzureCosmosDBEndpoint'
          name: 'CONFIGURATION__AZURECOSMOSDB__ENDPOINT'
        }
        {
          name: 'CONFIGURATION__AZURECOSMOSDB__DATABASENAME'
          value: 'cosmicworks'
        }
        {
          name: 'CONFIGURATION__AZURECOSMOSDB__CONTAINERNAME'
          value: 'products'
        }
      ]
      image: 'mcr.microsoft.com/dotnet/samples:aspnetapp-9.0'
      name: 'back-end'
      port: 8080
      tags: {
        'azd-service-name': 'api'
      }
      useManagedIdentity: true
    }
    {
      allowIngress: true
      environment: [
        {
          format: '{0}/api'
          name: 'CONFIGURATION__API__ENDPOINT'
          tierEndpoint: 'back-end'
        }
      ]
      image: 'mcr.microsoft.com/dotnet/samples:aspnetapp-9.0'
      name: 'front-end'
      port: 8080
      tags: {
        'azd-service-name': 'web'
      }
      useManagedIdentity: true
    }
  ]
  zoneRedundant: false
}
```

</details>
<p>

### Example 2: _Test using only the default parameters._

This test deploys the pattern using only the minimum required parameters. All other values are set to their defaults by convention.


<details>

<summary>via Bicep module</summary>

```bicep
module cosmosDbAccountContainerApp 'br/public:avm/ptn/app/cosmos-db-account-container-app:<version>' = {
  name: 'cosmosDbAccountContainerAppDeployment'
  params: {
    name: '<name>'
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
    "name": {
      "value": "<name>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/app/cosmos-db-account-container-app:<version>'

param name = '<name>'
```

</details>
<p>

### Example 3: _Test with all (max) parameters._

This test deploys the pattern using all parameters. This test performs bulk parameter validation.


<details>

<summary>via Bicep module</summary>

```bicep
module cosmosDbAccountContainerApp 'br/public:avm/ptn/app/cosmos-db-account-container-app:<version>' = {
  name: 'cosmosDbAccountContainerAppDeployment'
  params: {
    // Required parameters
    name: '<name>'
    // Non-required parameters
    database: {
      additionalLocations: [
        '<pairedRegionName>'
      ]
      additionalRoleBasedAccessControlPrincipals: [
        '<userAssignedManagedIdentityResourceId>'
      ]
      databases: [
        {
          containers: [
            {
              name: 'example-container'
              partitionKeys: [
                '/id'
              ]
              seed: 'cosmicworks-employees'
            }
          ]
          name: 'example-database'
        }
      ]
      enableLogAnalytics: false
      publicNetworkAccessEnabled: true
      serverless: true
      tags: {
        type: 'nosql'
      }
      type: 'NoSQL'
      zoneRedundant: false
    }
    enableTelemetry: true
    location: '<location>'
    tags: {
      test: 'max'
    }
    web: {
      additionalRoleBasedAccessControlPrincipals: [
        '<userAssignedManagedIdentityResourceId>'
      ]
      enableLogAnalytics: false
      publicNetworkAccessEnabled: false
      tags: {
        host: 'azure-container-apps'
        platform: 'docker'
      }
      tiers: [
        {
          allowIngress: false
          cpu: '0.25'
          environment: [
            {
              name: 'LABELS_HEADER'
              value: 'Example Tier Header'
            }
            {
              knownValue: 'AzureCosmosDBEndpoint'
              name: 'DATABASE_ENDPOINT'
            }
            {
              format: '{0}/openapi/v1.json'
              name: 'RELATED_TIER_ENDPOINT'
              tierEndpoint: 'example-tier-2'
            }
          ]
          image: 'nginx:latest'
          memory: '0.5Gi'
          name: 'example-tier-1'
          port: 80
          tags: {
            description: 'Example web application tier.'
          }
          useManagedIdentity: true
        }
        {
          name: 'example-tier-2'
        }
      ]
      virtualNetworkSubnetResourceId: '<virtualNetworkSubnetResourceId>'
      zoneRedundant: false
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
    "database": {
      "value": {
        "additionalLocations": [
          "<pairedRegionName>"
        ],
        "additionalRoleBasedAccessControlPrincipals": [
          "<userAssignedManagedIdentityResourceId>"
        ],
        "databases": [
          {
            "containers": [
              {
                "name": "example-container",
                "partitionKeys": [
                  "/id"
                ],
                "seed": "cosmicworks-employees"
              }
            ],
            "name": "example-database"
          }
        ],
        "enableLogAnalytics": false,
        "publicNetworkAccessEnabled": true,
        "serverless": true,
        "tags": {
          "type": "nosql"
        },
        "type": "NoSQL",
        "zoneRedundant": false
      }
    },
    "enableTelemetry": {
      "value": true
    },
    "location": {
      "value": "<location>"
    },
    "tags": {
      "value": {
        "test": "max"
      }
    },
    "web": {
      "value": {
        "additionalRoleBasedAccessControlPrincipals": [
          "<userAssignedManagedIdentityResourceId>"
        ],
        "enableLogAnalytics": false,
        "publicNetworkAccessEnabled": false,
        "tags": {
          "host": "azure-container-apps",
          "platform": "docker"
        },
        "tiers": [
          {
            "allowIngress": false,
            "cpu": "0.25",
            "environment": [
              {
                "name": "LABELS_HEADER",
                "value": "Example Tier Header"
              },
              {
                "knownValue": "AzureCosmosDBEndpoint",
                "name": "DATABASE_ENDPOINT"
              },
              {
                "format": "{0}/openapi/v1.json",
                "name": "RELATED_TIER_ENDPOINT",
                "tierEndpoint": "example-tier-2"
              }
            ],
            "image": "nginx:latest",
            "memory": "0.5Gi",
            "name": "example-tier-1",
            "port": 80,
            "tags": {
              "description": "Example web application tier."
            },
            "useManagedIdentity": true
          },
          {
            "name": "example-tier-2"
          }
        ],
        "virtualNetworkSubnetResourceId": "<virtualNetworkSubnetResourceId>",
        "zoneRedundant": false
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
using 'br/public:avm/ptn/app/cosmos-db-account-container-app:<version>'

// Required parameters
param name = '<name>'
// Non-required parameters
param database = {
  additionalLocations: [
    '<pairedRegionName>'
  ]
  additionalRoleBasedAccessControlPrincipals: [
    '<userAssignedManagedIdentityResourceId>'
  ]
  databases: [
    {
      containers: [
        {
          name: 'example-container'
          partitionKeys: [
            '/id'
          ]
          seed: 'cosmicworks-employees'
        }
      ]
      name: 'example-database'
    }
  ]
  enableLogAnalytics: false
  publicNetworkAccessEnabled: true
  serverless: true
  tags: {
    type: 'nosql'
  }
  type: 'NoSQL'
  zoneRedundant: false
}
param enableTelemetry = true
param location = '<location>'
param tags = {
  test: 'max'
}
param web = {
  additionalRoleBasedAccessControlPrincipals: [
    '<userAssignedManagedIdentityResourceId>'
  ]
  enableLogAnalytics: false
  publicNetworkAccessEnabled: false
  tags: {
    host: 'azure-container-apps'
    platform: 'docker'
  }
  tiers: [
    {
      allowIngress: false
      cpu: '0.25'
      environment: [
        {
          name: 'LABELS_HEADER'
          value: 'Example Tier Header'
        }
        {
          knownValue: 'AzureCosmosDBEndpoint'
          name: 'DATABASE_ENDPOINT'
        }
        {
          format: '{0}/openapi/v1.json'
          name: 'RELATED_TIER_ENDPOINT'
          tierEndpoint: 'example-tier-2'
        }
      ]
      image: 'nginx:latest'
      memory: '0.5Gi'
      name: 'example-tier-1'
      port: 80
      tags: {
        description: 'Example web application tier.'
      }
      useManagedIdentity: true
    }
    {
      name: 'example-tier-2'
    }
  ]
  virtualNetworkSubnetResourceId: '<virtualNetworkSubnetResourceId>'
  zoneRedundant: false
}
```

</details>
<p>

### Example 4: _Test with WAF-aligned parameters._

This test deploys the pattern using WAF-aligned parameters. For more informaation, see https://learn.microsoft.com/azure/well-architected/.


<details>

<summary>via Bicep module</summary>

```bicep
module cosmosDbAccountContainerApp 'br/public:avm/ptn/app/cosmos-db-account-container-app:<version>' = {
  name: 'cosmosDbAccountContainerAppDeployment'
  params: {
    // Required parameters
    name: '<name>'
    // Non-required parameters
    database: {
      additionalLocations: [
        '<pairedRegionName>'
      ]
      enableLogAnalytics: true
      publicNetworkAccessEnabled: false
      type: 'NoSQL'
    }
    web: {
      enableLogAnalytics: true
      publicNetworkAccessEnabled: false
      tiers: [
        {
          environment: [
            {
              knownValue: 'AzureCosmosDBEndpoint'
              name: 'AZURE_COSMOS_DB_ENDPOINT'
            }
          ]
          useManagedIdentity: true
        }
      ]
      virtualNetworkSubnetResourceId: '<virtualNetworkSubnetResourceId>'
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
    "database": {
      "value": {
        "additionalLocations": [
          "<pairedRegionName>"
        ],
        "enableLogAnalytics": true,
        "publicNetworkAccessEnabled": false,
        "type": "NoSQL"
      }
    },
    "web": {
      "value": {
        "enableLogAnalytics": true,
        "publicNetworkAccessEnabled": false,
        "tiers": [
          {
            "environment": [
              {
                "knownValue": "AzureCosmosDBEndpoint",
                "name": "AZURE_COSMOS_DB_ENDPOINT"
              }
            ],
            "useManagedIdentity": true
          }
        ],
        "virtualNetworkSubnetResourceId": "<virtualNetworkSubnetResourceId>"
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
using 'br/public:avm/ptn/app/cosmos-db-account-container-app:<version>'

// Required parameters
param name = '<name>'
// Non-required parameters
param database = {
  additionalLocations: [
    '<pairedRegionName>'
  ]
  enableLogAnalytics: true
  publicNetworkAccessEnabled: false
  type: 'NoSQL'
}
param web = {
  enableLogAnalytics: true
  publicNetworkAccessEnabled: false
  tiers: [
    {
      environment: [
        {
          knownValue: 'AzureCosmosDBEndpoint'
          name: 'AZURE_COSMOS_DB_ENDPOINT'
        }
      ]
      useManagedIdentity: true
    }
  ]
  virtualNetworkSubnetResourceId: '<virtualNetworkSubnetResourceId>'
}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Alpha-numeric component to use for resource naming. The name must be between 3 and 6 characters in length. The name of resources created by this pattern are based on the Cloud Adoption Framework baseline naming convention. Resources will be named using the following pattern: <resource-type>-<name>-<location>-<instance>. For example, if the value specified for this parameter is "demoapp", a single Azure Container App environment deployed to West US 2 would be named "cae-demoapp-westus2-001". For more information, see https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`database`](#parameter-database) | object | The settings for the Azure Cosmos DB account. If not specified, the pattern will deploy a single Azure Cosmos DB for NoSQL account with a database and container. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | The location where to deploy all resources. |
| [`tags`](#parameter-tags) | object | Resource tags. |
| [`web`](#parameter-web) | object | The settings for the Azure Container Apps and Azure Container Registry resources. If not specified, the pattern will deploy a single web application as a default. |

### Parameter: `name`

Alpha-numeric component to use for resource naming. The name must be between 3 and 6 characters in length. The name of resources created by this pattern are based on the Cloud Adoption Framework baseline naming convention. Resources will be named using the following pattern: <resource-type>-<name>-<location>-<instance>. For example, if the value specified for this parameter is "demoapp", a single Azure Container App environment deployed to West US 2 would be named "cae-demoapp-westus2-001". For more information, see https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming.

- Required: Yes
- Type: string

### Parameter: `database`

The settings for the Azure Cosmos DB account. If not specified, the pattern will deploy a single Azure Cosmos DB for NoSQL account with a database and container.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`type`](#parameter-databasetype) | string | The type (API) of the account. Defaults to "NoSQL". Valid values are "NoSQL" and "Table". |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`additionalLocations`](#parameter-databaseadditionallocations) | array | Additional locations for the account. Defaults to an empty array. |
| [`additionalRoleBasedAccessControlPrincipals`](#parameter-databaseadditionalrolebasedaccesscontrolprincipals) | array | List of additional role-based access control principals to assign the same role as the managed identity of the environment. For example, you can assign "deployer().objectId" to grant yourself RBAC permissions to the resource. Defaults to an empty array. |
| [`databases`](#parameter-databasedatabases) | array | The settings for the databases in the accounts. Defaults to an empty array. |
| [`enableLogAnalytics`](#parameter-databaseenableloganalytics) | bool | Indicates whether the account is configured with a paired Azure Log Analytics workspace. Defaults to false. If true, the account will be automatically created. |
| [`publicNetworkAccessEnabled`](#parameter-databasepublicnetworkaccessenabled) | bool | Whether requests from the public network are allowed. Defaults to true. |
| [`serverless`](#parameter-databaseserverless) | bool | Indicates if the account is serverless. Defaults to true. |
| [`tags`](#parameter-databasetags) | object | Resource tags specific to the Azure Cosmos DB account. |
| [`zoneRedundant`](#parameter-databasezoneredundant) | bool | Indicates whether the single-region account is zone redundant. Defaults to true. This property is ignored for multi-region accounts. |

### Parameter: `database.type`

The type (API) of the account. Defaults to "NoSQL". Valid values are "NoSQL" and "Table".

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'NoSQL'
    'Table'
  ]
  ```

### Parameter: `database.additionalLocations`

Additional locations for the account. Defaults to an empty array.

- Required: No
- Type: array

### Parameter: `database.additionalRoleBasedAccessControlPrincipals`

List of additional role-based access control principals to assign the same role as the managed identity of the environment. For example, you can assign "deployer().objectId" to grant yourself RBAC permissions to the resource. Defaults to an empty array.

- Required: No
- Type: array

### Parameter: `database.databases`

The settings for the databases in the accounts. Defaults to an empty array.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`containers`](#parameter-databasedatabasescontainers) | array | The settings for the child containers. |
| [`name`](#parameter-databasedatabasesname) | string | The name of the database. |

### Parameter: `database.databases.containers`

The settings for the child containers.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-databasedatabasescontainersname) | string | The name of the container. |
| [`partitionKeys`](#parameter-databasedatabasescontainerspartitionkeys) | array | The partition keys for the container. Defaults to `[ "/id" ]`. |
| [`seed`](#parameter-databasedatabasescontainersseed) | string | Specifies the seed data to use for the container. Defaults to not set. The seed operation is not performed if this property is not set. Valid values are "cosmicworks-products" and "cosmicworks-employees". |

### Parameter: `database.databases.containers.name`

The name of the container.

- Required: No
- Type: string

### Parameter: `database.databases.containers.partitionKeys`

The partition keys for the container. Defaults to `[ "/id" ]`.

- Required: No
- Type: array

### Parameter: `database.databases.containers.seed`

Specifies the seed data to use for the container. Defaults to not set. The seed operation is not performed if this property is not set. Valid values are "cosmicworks-products" and "cosmicworks-employees".

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'cosmicworks-employees'
    'cosmicworks-products'
  ]
  ```

### Parameter: `database.databases.name`

The name of the database.

- Required: No
- Type: string

### Parameter: `database.enableLogAnalytics`

Indicates whether the account is configured with a paired Azure Log Analytics workspace. Defaults to false. If true, the account will be automatically created.

- Required: No
- Type: bool

### Parameter: `database.publicNetworkAccessEnabled`

Whether requests from the public network are allowed. Defaults to true.

- Required: No
- Type: bool

### Parameter: `database.serverless`

Indicates if the account is serverless. Defaults to true.

- Required: No
- Type: bool

### Parameter: `database.tags`

Resource tags specific to the Azure Cosmos DB account.

- Required: No
- Type: object

### Parameter: `database.zoneRedundant`

Indicates whether the single-region account is zone redundant. Defaults to true. This property is ignored for multi-region accounts.

- Required: No
- Type: bool

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

The location where to deploy all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `tags`

Resource tags.

- Required: No
- Type: object

### Parameter: `web`

The settings for the Azure Container Apps and Azure Container Registry resources. If not specified, the pattern will deploy a single web application as a default.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`additionalRoleBasedAccessControlPrincipals`](#parameter-webadditionalrolebasedaccesscontrolprincipals) | array | List of additional role-based access control principals to assign the same role as the managed identity of the environment. For example, you can assign "deployer().objectId" to grant yourself RBAC permissions to the resource. Defaults to an empty array. |
| [`enableLogAnalytics`](#parameter-webenableloganalytics) | bool | Indicates whether the environment is configured with a paired Azure Log Analytics workspace. Defaults to false. If true, the workspace will be automatically created. |
| [`publicNetworkAccessEnabled`](#parameter-webpublicnetworkaccessenabled) | bool | Whether requests from the public network are allowed. Defaults to true. |
| [`tags`](#parameter-webtags) | object | Resource tags specific to the Azure Container Apps environment. |
| [`tiers`](#parameter-webtiers) | array | The settings for the tiers/apps in the environment. Defaults to a single default web application tier. |
| [`virtualNetworkSubnetResourceId`](#parameter-webvirtualnetworksubnetresourceid) | string | The resource ID of the virtual network subnet to use for the environment. Is not set by default. This property is required if zoneRedundant is set to true. |
| [`zoneRedundant`](#parameter-webzoneredundant) | bool | Indicates whether the environment is zone redundant. Defaults to true. If this property is set to true, the environment must be configured with a virtual network. |

### Parameter: `web.additionalRoleBasedAccessControlPrincipals`

List of additional role-based access control principals to assign the same role as the managed identity of the environment. For example, you can assign "deployer().objectId" to grant yourself RBAC permissions to the resource. Defaults to an empty array.

- Required: No
- Type: array

### Parameter: `web.enableLogAnalytics`

Indicates whether the environment is configured with a paired Azure Log Analytics workspace. Defaults to false. If true, the workspace will be automatically created.

- Required: No
- Type: bool

### Parameter: `web.publicNetworkAccessEnabled`

Whether requests from the public network are allowed. Defaults to true.

- Required: No
- Type: bool

### Parameter: `web.tags`

Resource tags specific to the Azure Container Apps environment.

- Required: No
- Type: object

### Parameter: `web.tiers`

The settings for the tiers/apps in the environment. Defaults to a single default web application tier.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowIngress`](#parameter-webtiersallowingress) | bool | Whether to allow ingress to the container. Defaults to false. |
| [`cpu`](#parameter-webtierscpu) | string | The amount of CPU (in cores) to allocate to the container. Defaults to "0.5". |
| [`environment`](#parameter-webtiersenvironment) | array | The settings for the environment variables for the container. Defaults to an empty array. |
| [`image`](#parameter-webtiersimage) | string | The image to use for the container. Defaults to "nginx:latest". |
| [`memory`](#parameter-webtiersmemory) | string | The amount of memory (in Gi) to allocate to the container. Defaults to "1.0". |
| [`name`](#parameter-webtiersname) | string | The name of the tier/app. Defaults to "container". |
| [`port`](#parameter-webtiersport) | int | The port to expose for ingress. Defaults to 80. |
| [`tags`](#parameter-webtierstags) | object | Resource tags specific to the Azure Container Apps instance. |
| [`useManagedIdentity`](#parameter-webtiersusemanagedidentity) | bool | Whether to use a managed identity for the container. Defaults to false. |

### Parameter: `web.tiers.allowIngress`

Whether to allow ingress to the container. Defaults to false.

- Required: No
- Type: bool

### Parameter: `web.tiers.cpu`

The amount of CPU (in cores) to allocate to the container. Defaults to "0.5".

- Required: No
- Type: string

### Parameter: `web.tiers.environment`

The settings for the environment variables for the container. Defaults to an empty array.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-webtiersenvironmentname) | string | The name of the environment variable. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`format`](#parameter-webtiersenvironmentformat) | string | The string format expression to use for the environment variable value. This property is ignored if the value is not set. |
| [`knownValue`](#parameter-webtiersenvironmentknownvalue) | string | Sets a well-known value for the environment variable. This property takes precedence over `value`. This property is ignored if the value is not set. |
| [`tierEndpoint`](#parameter-webtiersenvironmenttierendpoint) | string | Selects a tier endpoint to use for the environment variable. This property takes precedence over `knownValue` and `value`. This property is ignored if the value is not set. |
| [`value`](#parameter-webtiersenvironmentvalue) | string | The plain-text value of the environment variable. This property is ignored if the value is not set. |

### Parameter: `web.tiers.environment.name`

The name of the environment variable.

- Required: Yes
- Type: string

### Parameter: `web.tiers.environment.format`

The string format expression to use for the environment variable value. This property is ignored if the value is not set.

- Required: No
- Type: string

### Parameter: `web.tiers.environment.knownValue`

Sets a well-known value for the environment variable. This property takes precedence over `value`. This property is ignored if the value is not set.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureCosmosDBEndpoint'
    'ManagedIdentityClientId'
  ]
  ```

### Parameter: `web.tiers.environment.tierEndpoint`

Selects a tier endpoint to use for the environment variable. This property takes precedence over `knownValue` and `value`. This property is ignored if the value is not set.

- Required: No
- Type: string

### Parameter: `web.tiers.environment.value`

The plain-text value of the environment variable. This property is ignored if the value is not set.

- Required: No
- Type: string

### Parameter: `web.tiers.image`

The image to use for the container. Defaults to "nginx:latest".

- Required: No
- Type: string

### Parameter: `web.tiers.memory`

The amount of memory (in Gi) to allocate to the container. Defaults to "1.0".

- Required: No
- Type: string

### Parameter: `web.tiers.name`

The name of the tier/app. Defaults to "container".

- Required: No
- Type: string

### Parameter: `web.tiers.port`

The port to expose for ingress. Defaults to 80.

- Required: No
- Type: int

### Parameter: `web.tiers.tags`

Resource tags specific to the Azure Container Apps instance.

- Required: No
- Type: object

### Parameter: `web.tiers.useManagedIdentity`

Whether to use a managed identity for the container. Defaults to false.

- Required: No
- Type: bool

### Parameter: `web.virtualNetworkSubnetResourceId`

The resource ID of the virtual network subnet to use for the environment. Is not set by default. This property is required if zoneRedundant is set to true.

- Required: No
- Type: string

### Parameter: `web.zoneRedundant`

Indicates whether the environment is zone redundant. Defaults to true. If this property is set to true, the environment must be configured with a virtual network.

- Required: No
- Type: bool

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `azureContainerRegistryEndpoint` | string | The endpoint for the Azure Container Registry resource. |
| `azureCosmosDBEndpoint` | string | The endpoint for the Azure Cosmos DB account. |
| `name` | string | The name of the Azure Cosmos DB account. |
| `resourceGroupName` | string | The name of the Resource Group the resource was deployed into. |
| `resourceId` | string | The resource ID of the Azure Cosmos DB account. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
