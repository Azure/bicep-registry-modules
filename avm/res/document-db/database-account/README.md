# Azure Cosmos DB account `[Microsoft.DocumentDB/databaseAccounts]`

This module deploys an Azure Cosmos DB account. The API used for the account is determined by the child resources that are deployed.

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
| `Microsoft.Authorization/locks` | 2020-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_locks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks)</li></ul> |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |
| `Microsoft.DocumentDB/databaseAccounts` | 2024-11-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts)</li></ul> |
| `Microsoft.DocumentDB/databaseAccounts/gremlinDatabases` | 2024-11-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_gremlindatabases.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/gremlinDatabases)</li></ul> |
| `Microsoft.DocumentDB/databaseAccounts/gremlinDatabases/graphs` | 2024-11-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_gremlindatabases_graphs.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/gremlinDatabases/graphs)</li></ul> |
| `Microsoft.DocumentDB/databaseAccounts/mongodbDatabases` | 2024-11-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_mongodbdatabases.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/mongodbDatabases)</li></ul> |
| `Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections` | 2024-11-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_mongodbdatabases_collections.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/mongodbDatabases/collections)</li></ul> |
| `Microsoft.DocumentDB/databaseAccounts/sqlDatabases` | 2024-11-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_sqldatabases.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/sqlDatabases)</li></ul> |
| `Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers` | 2024-11-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_sqldatabases_containers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/sqlDatabases/containers)</li></ul> |
| `Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments` | 2024-11-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_sqlroleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/sqlRoleAssignments)</li></ul> |
| `Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions` | 2024-11-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_sqlroledefinitions.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/sqlRoleDefinitions)</li></ul> |
| `Microsoft.DocumentDB/databaseAccounts/tables` | 2024-11-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_tables.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/tables)</li></ul> |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_diagnosticsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)</li></ul> |
| `Microsoft.Network/privateEndpoints` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/privateEndpoints)</li></ul> |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints_privatednszonegroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/privateEndpoints/privateDnsZoneGroups)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/document-db/database-account:<version>`.

- [Using analytical storage](#example-1-using-analytical-storage)
- [Using bounded consistency](#example-2-using-bounded-consistency)
- [Using only defaults](#example-3-using-only-defaults)
- [Gremlin Database](#example-4-gremlin-database)
- [Deploying with Managed identities](#example-5-deploying-with-managed-identities)
- [Mongo Database](#example-6-mongo-database)
- [Deploying multiple regions](#example-7-deploying-multiple-regions)
- [Plain](#example-8-plain)
- [Public network restricted access with ACL](#example-9-public-network-restricted-access-with-acl)
- [SQL Database](#example-10-sql-database)
- [Deploying with a sql role definition and assignment](#example-11-deploying-with-a-sql-role-definition-and-assignment)
- [API for Table](#example-12-api-for-table)
- [WAF-aligned](#example-13-waf-aligned)

### Example 1: _Using analytical storage_

This instance deploys the module with analytical storage enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module databaseAccount 'br/public:avm/res/document-db/database-account:<version>' = {
  name: 'databaseAccountDeployment'
  params: {
    // Required parameters
    name: 'analytical'
    // Non-required parameters
    enableAnalyticalStorage: true
    sqlDatabases: [
      {
        name: 'no-containers-specified'
      }
    ]
    zoneRedundant: false
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
      "value": "analytical"
    },
    // Non-required parameters
    "enableAnalyticalStorage": {
      "value": true
    },
    "sqlDatabases": {
      "value": [
        {
          "name": "no-containers-specified"
        }
      ]
    },
    "zoneRedundant": {
      "value": false
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/document-db/database-account:<version>'

// Required parameters
param name = 'analytical'
// Non-required parameters
param enableAnalyticalStorage = true
param sqlDatabases = [
  {
    name: 'no-containers-specified'
  }
]
param zoneRedundant = false
```

</details>
<p>

### Example 2: _Using bounded consistency_

This instance deploys the module specifying a default consistency level.


<details>

<summary>via Bicep module</summary>

```bicep
module databaseAccount 'br/public:avm/res/document-db/database-account:<version>' = {
  name: 'databaseAccountDeployment'
  params: {
    // Required parameters
    name: 'bounded'
    // Non-required parameters
    defaultConsistencyLevel: 'BoundedStaleness'
    maxIntervalInSeconds: 600
    maxStalenessPrefix: 200000
    sqlDatabases: [
      {
        name: 'no-containers-specified'
      }
    ]
    zoneRedundant: false
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
      "value": "bounded"
    },
    // Non-required parameters
    "defaultConsistencyLevel": {
      "value": "BoundedStaleness"
    },
    "maxIntervalInSeconds": {
      "value": 600
    },
    "maxStalenessPrefix": {
      "value": 200000
    },
    "sqlDatabases": {
      "value": [
        {
          "name": "no-containers-specified"
        }
      ]
    },
    "zoneRedundant": {
      "value": false
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/document-db/database-account:<version>'

// Required parameters
param name = 'bounded'
// Non-required parameters
param defaultConsistencyLevel = 'BoundedStaleness'
param maxIntervalInSeconds = 600
param maxStalenessPrefix = 200000
param sqlDatabases = [
  {
    name: 'no-containers-specified'
  }
]
param zoneRedundant = false
```

</details>
<p>

### Example 3: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module databaseAccount 'br/public:avm/res/document-db/database-account:<version>' = {
  name: 'databaseAccountDeployment'
  params: {
    // Required parameters
    name: 'dddamin001'
    // Non-required parameters
    zoneRedundant: false
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
      "value": "dddamin001"
    },
    // Non-required parameters
    "zoneRedundant": {
      "value": false
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/document-db/database-account:<version>'

// Required parameters
param name = 'dddamin001'
// Non-required parameters
param zoneRedundant = false
```

</details>
<p>

### Example 4: _Gremlin Database_

This instance deploys the module with a Gremlin Database.


<details>

<summary>via Bicep module</summary>

```bicep
module databaseAccount 'br/public:avm/res/document-db/database-account:<version>' = {
  name: 'databaseAccountDeployment'
  params: {
    // Required parameters
    name: 'dddagrm002'
    // Non-required parameters
    capabilitiesToAdd: [
      'EnableGremlin'
    ]
    gremlinDatabases: [
      {
        graphs: [
          {
            indexingPolicy: {
              automatic: true
            }
            name: 'car_collection'
            partitionKeyPaths: [
              '/car_id'
            ]
          }
          {
            indexingPolicy: {
              automatic: true
            }
            name: 'truck_collection'
            partitionKeyPaths: [
              '/truck_id'
            ]
          }
        ]
        name: 'gdb-dddagrm-001'
        throughput: 10000
      }
      {
        graphs: [
          {
            indexingPolicy: {
              automatic: true
            }
            name: 'bike_collection'
            partitionKeyPaths: [
              '/bike_id'
            ]
          }
          {
            indexingPolicy: {
              automatic: true
            }
            name: 'bicycle_collection'
            partitionKeyPaths: [
              '/bicycle_id'
            ]
          }
        ]
        name: 'gdb-dddagrm-002'
      }
    ]
    zoneRedundant: false
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
      "value": "dddagrm002"
    },
    // Non-required parameters
    "capabilitiesToAdd": {
      "value": [
        "EnableGremlin"
      ]
    },
    "gremlinDatabases": {
      "value": [
        {
          "graphs": [
            {
              "indexingPolicy": {
                "automatic": true
              },
              "name": "car_collection",
              "partitionKeyPaths": [
                "/car_id"
              ]
            },
            {
              "indexingPolicy": {
                "automatic": true
              },
              "name": "truck_collection",
              "partitionKeyPaths": [
                "/truck_id"
              ]
            }
          ],
          "name": "gdb-dddagrm-001",
          "throughput": 10000
        },
        {
          "graphs": [
            {
              "indexingPolicy": {
                "automatic": true
              },
              "name": "bike_collection",
              "partitionKeyPaths": [
                "/bike_id"
              ]
            },
            {
              "indexingPolicy": {
                "automatic": true
              },
              "name": "bicycle_collection",
              "partitionKeyPaths": [
                "/bicycle_id"
              ]
            }
          ],
          "name": "gdb-dddagrm-002"
        }
      ]
    },
    "zoneRedundant": {
      "value": false
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/document-db/database-account:<version>'

// Required parameters
param name = 'dddagrm002'
// Non-required parameters
param capabilitiesToAdd = [
  'EnableGremlin'
]
param gremlinDatabases = [
  {
    graphs: [
      {
        indexingPolicy: {
          automatic: true
        }
        name: 'car_collection'
        partitionKeyPaths: [
          '/car_id'
        ]
      }
      {
        indexingPolicy: {
          automatic: true
        }
        name: 'truck_collection'
        partitionKeyPaths: [
          '/truck_id'
        ]
      }
    ]
    name: 'gdb-dddagrm-001'
    throughput: 10000
  }
  {
    graphs: [
      {
        indexingPolicy: {
          automatic: true
        }
        name: 'bike_collection'
        partitionKeyPaths: [
          '/bike_id'
        ]
      }
      {
        indexingPolicy: {
          automatic: true
        }
        name: 'bicycle_collection'
        partitionKeyPaths: [
          '/bicycle_id'
        ]
      }
    ]
    name: 'gdb-dddagrm-002'
  }
]
param zoneRedundant = false
```

</details>
<p>

### Example 5: _Deploying with Managed identities_

This instance deploys the module with an system and user assigned managed identity.


<details>

<summary>via Bicep module</summary>

```bicep
module databaseAccount 'br/public:avm/res/document-db/database-account:<version>' = {
  name: 'databaseAccountDeployment'
  params: {
    // Required parameters
    name: 'user-mi'
    // Non-required parameters
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    roleAssignments: [
      {
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
    zoneRedundant: false
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
      "value": "user-mi"
    },
    // Non-required parameters
    "managedIdentities": {
      "value": {
        "systemAssigned": true,
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "roleAssignments": {
      "value": [
        {
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
    "zoneRedundant": {
      "value": false
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/document-db/database-account:<version>'

// Required parameters
param name = 'user-mi'
// Non-required parameters
param managedIdentities = {
  systemAssigned: true
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param roleAssignments = [
  {
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
param zoneRedundant = false
```

</details>
<p>

### Example 6: _Mongo Database_

This instance deploys the module with a Mongo Database.


<details>

<summary>via Bicep module</summary>

```bicep
module databaseAccount 'br/public:avm/res/document-db/database-account:<version>' = {
  name: 'databaseAccountDeployment'
  params: {
    // Required parameters
    name: 'dddamng001'
    // Non-required parameters
    mongodbDatabases: [
      {
        collections: [
          {
            indexes: [
              {
                key: {
                  keys: [
                    '_id'
                  ]
                }
              }
              {
                key: {
                  keys: [
                    '$**'
                  ]
                }
              }
              {
                key: {
                  keys: [
                    'car_id'
                    'car_model'
                  ]
                }
                options: {
                  unique: true
                }
              }
              {
                key: {
                  keys: [
                    '_ts'
                  ]
                }
                options: {
                  expireAfterSeconds: 2629746
                }
              }
            ]
            name: 'car_collection'
            shardKey: {
              car_id: 'Hash'
            }
            throughput: 600
          }
          {
            indexes: [
              {
                key: {
                  keys: [
                    '_id'
                  ]
                }
              }
              {
                key: {
                  keys: [
                    '$**'
                  ]
                }
              }
              {
                key: {
                  keys: [
                    'truck_id'
                    'truck_model'
                  ]
                }
                options: {
                  unique: true
                }
              }
              {
                key: {
                  keys: [
                    '_ts'
                  ]
                }
                options: {
                  expireAfterSeconds: 2629746
                }
              }
            ]
            name: 'truck_collection'
            shardKey: {
              truck_id: 'Hash'
            }
          }
        ]
        name: 'mdb-dddamng-001'
        throughput: 800
      }
      {
        collections: [
          {
            indexes: [
              {
                key: {
                  keys: [
                    '_id'
                  ]
                }
              }
              {
                key: {
                  keys: [
                    '$**'
                  ]
                }
              }
              {
                key: {
                  keys: [
                    'bike_id'
                    'bike_model'
                  ]
                }
                options: {
                  unique: true
                }
              }
              {
                key: {
                  keys: [
                    '_ts'
                  ]
                }
                options: {
                  expireAfterSeconds: 2629746
                }
              }
            ]
            name: 'bike_collection'
            shardKey: {
              bike_id: 'Hash'
            }
          }
          {
            indexes: [
              {
                key: {
                  keys: [
                    '_id'
                  ]
                }
              }
              {
                key: {
                  keys: [
                    '$**'
                  ]
                }
              }
              {
                key: {
                  keys: [
                    'bicycle_id'
                    'bicycle_model'
                  ]
                }
                options: {
                  unique: true
                }
              }
              {
                key: {
                  keys: [
                    '_ts'
                  ]
                }
                options: {
                  expireAfterSeconds: 2629746
                }
              }
            ]
            name: 'bicycle_collection'
            shardKey: {
              bicycle_id: 'Hash'
            }
          }
        ]
        name: 'mdb-dddamng-002'
      }
    ]
    zoneRedundant: false
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
      "value": "dddamng001"
    },
    // Non-required parameters
    "mongodbDatabases": {
      "value": [
        {
          "collections": [
            {
              "indexes": [
                {
                  "key": {
                    "keys": [
                      "_id"
                    ]
                  }
                },
                {
                  "key": {
                    "keys": [
                      "$**"
                    ]
                  }
                },
                {
                  "key": {
                    "keys": [
                      "car_id",
                      "car_model"
                    ]
                  },
                  "options": {
                    "unique": true
                  }
                },
                {
                  "key": {
                    "keys": [
                      "_ts"
                    ]
                  },
                  "options": {
                    "expireAfterSeconds": 2629746
                  }
                }
              ],
              "name": "car_collection",
              "shardKey": {
                "car_id": "Hash"
              },
              "throughput": 600
            },
            {
              "indexes": [
                {
                  "key": {
                    "keys": [
                      "_id"
                    ]
                  }
                },
                {
                  "key": {
                    "keys": [
                      "$**"
                    ]
                  }
                },
                {
                  "key": {
                    "keys": [
                      "truck_id",
                      "truck_model"
                    ]
                  },
                  "options": {
                    "unique": true
                  }
                },
                {
                  "key": {
                    "keys": [
                      "_ts"
                    ]
                  },
                  "options": {
                    "expireAfterSeconds": 2629746
                  }
                }
              ],
              "name": "truck_collection",
              "shardKey": {
                "truck_id": "Hash"
              }
            }
          ],
          "name": "mdb-dddamng-001",
          "throughput": 800
        },
        {
          "collections": [
            {
              "indexes": [
                {
                  "key": {
                    "keys": [
                      "_id"
                    ]
                  }
                },
                {
                  "key": {
                    "keys": [
                      "$**"
                    ]
                  }
                },
                {
                  "key": {
                    "keys": [
                      "bike_id",
                      "bike_model"
                    ]
                  },
                  "options": {
                    "unique": true
                  }
                },
                {
                  "key": {
                    "keys": [
                      "_ts"
                    ]
                  },
                  "options": {
                    "expireAfterSeconds": 2629746
                  }
                }
              ],
              "name": "bike_collection",
              "shardKey": {
                "bike_id": "Hash"
              }
            },
            {
              "indexes": [
                {
                  "key": {
                    "keys": [
                      "_id"
                    ]
                  }
                },
                {
                  "key": {
                    "keys": [
                      "$**"
                    ]
                  }
                },
                {
                  "key": {
                    "keys": [
                      "bicycle_id",
                      "bicycle_model"
                    ]
                  },
                  "options": {
                    "unique": true
                  }
                },
                {
                  "key": {
                    "keys": [
                      "_ts"
                    ]
                  },
                  "options": {
                    "expireAfterSeconds": 2629746
                  }
                }
              ],
              "name": "bicycle_collection",
              "shardKey": {
                "bicycle_id": "Hash"
              }
            }
          ],
          "name": "mdb-dddamng-002"
        }
      ]
    },
    "zoneRedundant": {
      "value": false
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/document-db/database-account:<version>'

// Required parameters
param name = 'dddamng001'
// Non-required parameters
param mongodbDatabases = [
  {
    collections: [
      {
        indexes: [
          {
            key: {
              keys: [
                '_id'
              ]
            }
          }
          {
            key: {
              keys: [
                '$**'
              ]
            }
          }
          {
            key: {
              keys: [
                'car_id'
                'car_model'
              ]
            }
            options: {
              unique: true
            }
          }
          {
            key: {
              keys: [
                '_ts'
              ]
            }
            options: {
              expireAfterSeconds: 2629746
            }
          }
        ]
        name: 'car_collection'
        shardKey: {
          car_id: 'Hash'
        }
        throughput: 600
      }
      {
        indexes: [
          {
            key: {
              keys: [
                '_id'
              ]
            }
          }
          {
            key: {
              keys: [
                '$**'
              ]
            }
          }
          {
            key: {
              keys: [
                'truck_id'
                'truck_model'
              ]
            }
            options: {
              unique: true
            }
          }
          {
            key: {
              keys: [
                '_ts'
              ]
            }
            options: {
              expireAfterSeconds: 2629746
            }
          }
        ]
        name: 'truck_collection'
        shardKey: {
          truck_id: 'Hash'
        }
      }
    ]
    name: 'mdb-dddamng-001'
    throughput: 800
  }
  {
    collections: [
      {
        indexes: [
          {
            key: {
              keys: [
                '_id'
              ]
            }
          }
          {
            key: {
              keys: [
                '$**'
              ]
            }
          }
          {
            key: {
              keys: [
                'bike_id'
                'bike_model'
              ]
            }
            options: {
              unique: true
            }
          }
          {
            key: {
              keys: [
                '_ts'
              ]
            }
            options: {
              expireAfterSeconds: 2629746
            }
          }
        ]
        name: 'bike_collection'
        shardKey: {
          bike_id: 'Hash'
        }
      }
      {
        indexes: [
          {
            key: {
              keys: [
                '_id'
              ]
            }
          }
          {
            key: {
              keys: [
                '$**'
              ]
            }
          }
          {
            key: {
              keys: [
                'bicycle_id'
                'bicycle_model'
              ]
            }
            options: {
              unique: true
            }
          }
          {
            key: {
              keys: [
                '_ts'
              ]
            }
            options: {
              expireAfterSeconds: 2629746
            }
          }
        ]
        name: 'bicycle_collection'
        shardKey: {
          bicycle_id: 'Hash'
        }
      }
    ]
    name: 'mdb-dddamng-002'
  }
]
param zoneRedundant = false
```

</details>
<p>

### Example 7: _Deploying multiple regions_

This instance deploys the module in multiple regions with configs specific of multi region scenarios.


<details>

<summary>via Bicep module</summary>

```bicep
module databaseAccount 'br/public:avm/res/document-db/database-account:<version>' = {
  name: 'databaseAccountDeployment'
  params: {
    // Required parameters
    name: 'multi-region'
    // Non-required parameters
    automaticFailover: true
    backupIntervalInMinutes: 300
    backupPolicyType: 'Periodic'
    backupRetentionIntervalInHours: 16
    backupStorageRedundancy: 'Geo'
    enableMultipleWriteLocations: true
    failoverLocations: [
      {
        failoverPriority: 0
        isZoneRedundant: false
        locationName: '<locationName>'
      }
      {
        failoverPriority: 1
        isZoneRedundant: false
        locationName: '<locationName>'
      }
    ]
    sqlDatabases: [
      {
        name: 'no-containers-specified'
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
      "value": "multi-region"
    },
    // Non-required parameters
    "automaticFailover": {
      "value": true
    },
    "backupIntervalInMinutes": {
      "value": 300
    },
    "backupPolicyType": {
      "value": "Periodic"
    },
    "backupRetentionIntervalInHours": {
      "value": 16
    },
    "backupStorageRedundancy": {
      "value": "Geo"
    },
    "enableMultipleWriteLocations": {
      "value": true
    },
    "failoverLocations": {
      "value": [
        {
          "failoverPriority": 0,
          "isZoneRedundant": false,
          "locationName": "<locationName>"
        },
        {
          "failoverPriority": 1,
          "isZoneRedundant": false,
          "locationName": "<locationName>"
        }
      ]
    },
    "sqlDatabases": {
      "value": [
        {
          "name": "no-containers-specified"
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
using 'br/public:avm/res/document-db/database-account:<version>'

// Required parameters
param name = 'multi-region'
// Non-required parameters
param automaticFailover = true
param backupIntervalInMinutes = 300
param backupPolicyType = 'Periodic'
param backupRetentionIntervalInHours = 16
param backupStorageRedundancy = 'Geo'
param enableMultipleWriteLocations = true
param failoverLocations = [
  {
    failoverPriority: 0
    isZoneRedundant: false
    locationName: '<locationName>'
  }
  {
    failoverPriority: 1
    isZoneRedundant: false
    locationName: '<locationName>'
  }
]
param sqlDatabases = [
  {
    name: 'no-containers-specified'
  }
]
```

</details>
<p>

### Example 8: _Plain_

This instance deploys the module without a Database.


<details>

<summary>via Bicep module</summary>

```bicep
module databaseAccount 'br/public:avm/res/document-db/database-account:<version>' = {
  name: 'databaseAccountDeployment'
  params: {
    // Required parameters
    name: 'dddapln001'
    // Non-required parameters
    capabilitiesToAdd: [
      'EnableServerless'
    ]
    databaseAccountOfferType: 'Standard'
    failoverLocations: [
      {
        failoverPriority: 0
        isZoneRedundant: false
        locationName: '<locationName>'
      }
    ]
    sqlDatabases: [
      {
        name: 'no-containers-specified'
      }
    ]
    totalThroughputLimit: 4000
    zoneRedundant: false
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
      "value": "dddapln001"
    },
    // Non-required parameters
    "capabilitiesToAdd": {
      "value": [
        "EnableServerless"
      ]
    },
    "databaseAccountOfferType": {
      "value": "Standard"
    },
    "failoverLocations": {
      "value": [
        {
          "failoverPriority": 0,
          "isZoneRedundant": false,
          "locationName": "<locationName>"
        }
      ]
    },
    "sqlDatabases": {
      "value": [
        {
          "name": "no-containers-specified"
        }
      ]
    },
    "totalThroughputLimit": {
      "value": 4000
    },
    "zoneRedundant": {
      "value": false
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/document-db/database-account:<version>'

// Required parameters
param name = 'dddapln001'
// Non-required parameters
param capabilitiesToAdd = [
  'EnableServerless'
]
param databaseAccountOfferType = 'Standard'
param failoverLocations = [
  {
    failoverPriority: 0
    isZoneRedundant: false
    locationName: '<locationName>'
  }
]
param sqlDatabases = [
  {
    name: 'no-containers-specified'
  }
]
param totalThroughputLimit = 4000
param zoneRedundant = false
```

</details>
<p>

### Example 9: _Public network restricted access with ACL_

This instance deploys the module with public network access enabled but restricted to IPs, CIDRS or subnets.


<details>

<summary>via Bicep module</summary>

```bicep
module databaseAccount 'br/public:avm/res/document-db/database-account:<version>' = {
  name: 'databaseAccountDeployment'
  params: {
    // Required parameters
    name: 'dddapres001'
    // Non-required parameters
    networkRestrictions: {
      ipRules: [
        '79.0.0.0'
        '80.0.0.0'
      ]
      networkAclBypass: 'AzureServices'
      publicNetworkAccess: 'Enabled'
      virtualNetworkRules: [
        {
          subnetResourceId: '<subnetResourceId>'
        }
      ]
    }
    sqlDatabases: [
      {
        name: 'no-containers-specified'
      }
    ]
    zoneRedundant: false
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
      "value": "dddapres001"
    },
    // Non-required parameters
    "networkRestrictions": {
      "value": {
        "ipRules": [
          "79.0.0.0",
          "80.0.0.0"
        ],
        "networkAclBypass": "AzureServices",
        "publicNetworkAccess": "Enabled",
        "virtualNetworkRules": [
          {
            "subnetResourceId": "<subnetResourceId>"
          }
        ]
      }
    },
    "sqlDatabases": {
      "value": [
        {
          "name": "no-containers-specified"
        }
      ]
    },
    "zoneRedundant": {
      "value": false
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/document-db/database-account:<version>'

// Required parameters
param name = 'dddapres001'
// Non-required parameters
param networkRestrictions = {
  ipRules: [
    '79.0.0.0'
    '80.0.0.0'
  ]
  networkAclBypass: 'AzureServices'
  publicNetworkAccess: 'Enabled'
  virtualNetworkRules: [
    {
      subnetResourceId: '<subnetResourceId>'
    }
  ]
}
param sqlDatabases = [
  {
    name: 'no-containers-specified'
  }
]
param zoneRedundant = false
```

</details>
<p>

### Example 10: _SQL Database_

This instance deploys the module with a SQL Database.


<details>

<summary>via Bicep module</summary>

```bicep
module databaseAccount 'br/public:avm/res/document-db/database-account:<version>' = {
  name: 'databaseAccountDeployment'
  params: {
    // Required parameters
    name: 'dddasql001'
    // Non-required parameters
    enableAnalyticalStorage: true
    sqlDatabases: [
      {
        containers: [
          {
            analyticalStorageTtl: 0
            conflictResolutionPolicy: {
              conflictResolutionPath: '/myCustomId'
              mode: 'LastWriterWins'
            }
            defaultTtl: 1000
            indexingPolicy: {
              automatic: true
            }
            kind: 'Hash'
            name: 'container-001'
            paths: [
              '/myPartitionKey'
            ]
            throughput: 600
            uniqueKeyPolicyKeys: [
              {
                paths: [
                  '/firstName'
                ]
              }
              {
                paths: [
                  '/lastName'
                ]
              }
            ]
          }
        ]
        name: 'all-configs-specified'
      }
      {
        containers: [
          {
            indexingPolicy: {
              automatic: true
            }
            name: 'container-001'
            paths: [
              '/myPartitionKey'
            ]
          }
        ]
        name: 'automatic-indexing-policy'
      }
      {
        containers: [
          {
            conflictResolutionPolicy: {
              conflictResolutionPath: '/myCustomId'
              mode: 'LastWriterWins'
            }
            name: 'container-001'
            paths: [
              '/myPartitionKey'
            ]
          }
        ]
        name: 'last-writer-conflict-resolution-policy'
      }
      {
        containers: [
          {
            analyticalStorageTtl: 1000
            name: 'container-001'
            paths: [
              '/myPartitionKey'
            ]
          }
        ]
        name: 'fixed-analytical-ttl'
      }
      {
        containers: [
          {
            analyticalStorageTtl: -1
            name: 'container-001'
            paths: [
              '/myPartitionKey'
            ]
          }
        ]
        name: 'infinite-analytical-ttl'
      }
      {
        containers: [
          {
            defaultTtl: 1000
            name: 'container-001'
            paths: [
              '/myPartitionKey'
            ]
          }
        ]
        name: 'document-ttl'
      }
      {
        containers: [
          {
            name: 'container-001'
            paths: [
              '/myPartitionKey'
            ]
            uniqueKeyPolicyKeys: [
              {
                paths: [
                  '/firstName'
                ]
              }
              {
                paths: [
                  '/lastName'
                ]
              }
            ]
          }
        ]
        name: 'unique-key-policy'
      }
      {
        containers: [
          {
            name: 'container-003'
            paths: [
              '/myPartitionKey'
            ]
            throughput: 500
          }
        ]
        name: 'db-and-container-fixed-throughput-level'
        throughput: 500
      }
      {
        containers: [
          {
            name: 'container-003'
            paths: [
              '/myPartitionKey'
            ]
            throughput: 500
          }
        ]
        name: 'container-fixed-throughput-level'
      }
      {
        containers: [
          {
            name: 'container-003'
            paths: [
              '/myPartitionKey'
            ]
          }
        ]
        name: 'database-fixed-throughput-level'
        throughput: 500
      }
      {
        autoscaleSettingsMaxThroughput: 1000
        containers: [
          {
            autoscaleSettingsMaxThroughput: 1000
            name: 'container-003'
            paths: [
              '/myPartitionKey'
            ]
          }
        ]
        name: 'db-and-container-autoscale-level'
      }
      {
        containers: [
          {
            autoscaleSettingsMaxThroughput: 1000
            name: 'container-003'
            paths: [
              '/myPartitionKey'
            ]
          }
        ]
        name: 'container-autoscale-level'
      }
      {
        autoscaleSettingsMaxThroughput: 1000
        containers: [
          {
            name: 'container-003'
            paths: [
              '/myPartitionKey'
            ]
          }
        ]
        name: 'database-autoscale-level'
      }
      {
        containers: [
          {
            kind: 'MultiHash'
            name: 'container-001'
            paths: [
              '/myPartitionKey1'
              '/myPartitionKey2'
              '/myPartitionKey3'
            ]
          }
          {
            kind: 'MultiHash'
            name: 'container-002'
            paths: [
              'myPartitionKey1'
              'myPartitionKey2'
              'myPartitionKey3'
            ]
          }
          {
            kind: 'Hash'
            name: 'container-003'
            paths: [
              '/myPartitionKey1'
            ]
          }
          {
            kind: 'Hash'
            name: 'container-004'
            paths: [
              'myPartitionKey1'
            ]
          }
          {
            kind: 'Hash'
            name: 'container-005'
            paths: [
              'myPartitionKey1'
            ]
            version: 2
          }
        ]
        name: 'all-partition-key-types'
      }
      {
        containers: []
        name: 'empty-containers-array'
      }
      {
        name: 'no-containers-specified'
      }
    ]
    zoneRedundant: false
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
      "value": "dddasql001"
    },
    // Non-required parameters
    "enableAnalyticalStorage": {
      "value": true
    },
    "sqlDatabases": {
      "value": [
        {
          "containers": [
            {
              "analyticalStorageTtl": 0,
              "conflictResolutionPolicy": {
                "conflictResolutionPath": "/myCustomId",
                "mode": "LastWriterWins"
              },
              "defaultTtl": 1000,
              "indexingPolicy": {
                "automatic": true
              },
              "kind": "Hash",
              "name": "container-001",
              "paths": [
                "/myPartitionKey"
              ],
              "throughput": 600,
              "uniqueKeyPolicyKeys": [
                {
                  "paths": [
                    "/firstName"
                  ]
                },
                {
                  "paths": [
                    "/lastName"
                  ]
                }
              ]
            }
          ],
          "name": "all-configs-specified"
        },
        {
          "containers": [
            {
              "indexingPolicy": {
                "automatic": true
              },
              "name": "container-001",
              "paths": [
                "/myPartitionKey"
              ]
            }
          ],
          "name": "automatic-indexing-policy"
        },
        {
          "containers": [
            {
              "conflictResolutionPolicy": {
                "conflictResolutionPath": "/myCustomId",
                "mode": "LastWriterWins"
              },
              "name": "container-001",
              "paths": [
                "/myPartitionKey"
              ]
            }
          ],
          "name": "last-writer-conflict-resolution-policy"
        },
        {
          "containers": [
            {
              "analyticalStorageTtl": 1000,
              "name": "container-001",
              "paths": [
                "/myPartitionKey"
              ]
            }
          ],
          "name": "fixed-analytical-ttl"
        },
        {
          "containers": [
            {
              "analyticalStorageTtl": -1,
              "name": "container-001",
              "paths": [
                "/myPartitionKey"
              ]
            }
          ],
          "name": "infinite-analytical-ttl"
        },
        {
          "containers": [
            {
              "defaultTtl": 1000,
              "name": "container-001",
              "paths": [
                "/myPartitionKey"
              ]
            }
          ],
          "name": "document-ttl"
        },
        {
          "containers": [
            {
              "name": "container-001",
              "paths": [
                "/myPartitionKey"
              ],
              "uniqueKeyPolicyKeys": [
                {
                  "paths": [
                    "/firstName"
                  ]
                },
                {
                  "paths": [
                    "/lastName"
                  ]
                }
              ]
            }
          ],
          "name": "unique-key-policy"
        },
        {
          "containers": [
            {
              "name": "container-003",
              "paths": [
                "/myPartitionKey"
              ],
              "throughput": 500
            }
          ],
          "name": "db-and-container-fixed-throughput-level",
          "throughput": 500
        },
        {
          "containers": [
            {
              "name": "container-003",
              "paths": [
                "/myPartitionKey"
              ],
              "throughput": 500
            }
          ],
          "name": "container-fixed-throughput-level"
        },
        {
          "containers": [
            {
              "name": "container-003",
              "paths": [
                "/myPartitionKey"
              ]
            }
          ],
          "name": "database-fixed-throughput-level",
          "throughput": 500
        },
        {
          "autoscaleSettingsMaxThroughput": 1000,
          "containers": [
            {
              "autoscaleSettingsMaxThroughput": 1000,
              "name": "container-003",
              "paths": [
                "/myPartitionKey"
              ]
            }
          ],
          "name": "db-and-container-autoscale-level"
        },
        {
          "containers": [
            {
              "autoscaleSettingsMaxThroughput": 1000,
              "name": "container-003",
              "paths": [
                "/myPartitionKey"
              ]
            }
          ],
          "name": "container-autoscale-level"
        },
        {
          "autoscaleSettingsMaxThroughput": 1000,
          "containers": [
            {
              "name": "container-003",
              "paths": [
                "/myPartitionKey"
              ]
            }
          ],
          "name": "database-autoscale-level"
        },
        {
          "containers": [
            {
              "kind": "MultiHash",
              "name": "container-001",
              "paths": [
                "/myPartitionKey1",
                "/myPartitionKey2",
                "/myPartitionKey3"
              ]
            },
            {
              "kind": "MultiHash",
              "name": "container-002",
              "paths": [
                "myPartitionKey1",
                "myPartitionKey2",
                "myPartitionKey3"
              ]
            },
            {
              "kind": "Hash",
              "name": "container-003",
              "paths": [
                "/myPartitionKey1"
              ]
            },
            {
              "kind": "Hash",
              "name": "container-004",
              "paths": [
                "myPartitionKey1"
              ]
            },
            {
              "kind": "Hash",
              "name": "container-005",
              "paths": [
                "myPartitionKey1"
              ],
              "version": 2
            }
          ],
          "name": "all-partition-key-types"
        },
        {
          "containers": [],
          "name": "empty-containers-array"
        },
        {
          "name": "no-containers-specified"
        }
      ]
    },
    "zoneRedundant": {
      "value": false
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/document-db/database-account:<version>'

// Required parameters
param name = 'dddasql001'
// Non-required parameters
param enableAnalyticalStorage = true
param sqlDatabases = [
  {
    containers: [
      {
        analyticalStorageTtl: 0
        conflictResolutionPolicy: {
          conflictResolutionPath: '/myCustomId'
          mode: 'LastWriterWins'
        }
        defaultTtl: 1000
        indexingPolicy: {
          automatic: true
        }
        kind: 'Hash'
        name: 'container-001'
        paths: [
          '/myPartitionKey'
        ]
        throughput: 600
        uniqueKeyPolicyKeys: [
          {
            paths: [
              '/firstName'
            ]
          }
          {
            paths: [
              '/lastName'
            ]
          }
        ]
      }
    ]
    name: 'all-configs-specified'
  }
  {
    containers: [
      {
        indexingPolicy: {
          automatic: true
        }
        name: 'container-001'
        paths: [
          '/myPartitionKey'
        ]
      }
    ]
    name: 'automatic-indexing-policy'
  }
  {
    containers: [
      {
        conflictResolutionPolicy: {
          conflictResolutionPath: '/myCustomId'
          mode: 'LastWriterWins'
        }
        name: 'container-001'
        paths: [
          '/myPartitionKey'
        ]
      }
    ]
    name: 'last-writer-conflict-resolution-policy'
  }
  {
    containers: [
      {
        analyticalStorageTtl: 1000
        name: 'container-001'
        paths: [
          '/myPartitionKey'
        ]
      }
    ]
    name: 'fixed-analytical-ttl'
  }
  {
    containers: [
      {
        analyticalStorageTtl: -1
        name: 'container-001'
        paths: [
          '/myPartitionKey'
        ]
      }
    ]
    name: 'infinite-analytical-ttl'
  }
  {
    containers: [
      {
        defaultTtl: 1000
        name: 'container-001'
        paths: [
          '/myPartitionKey'
        ]
      }
    ]
    name: 'document-ttl'
  }
  {
    containers: [
      {
        name: 'container-001'
        paths: [
          '/myPartitionKey'
        ]
        uniqueKeyPolicyKeys: [
          {
            paths: [
              '/firstName'
            ]
          }
          {
            paths: [
              '/lastName'
            ]
          }
        ]
      }
    ]
    name: 'unique-key-policy'
  }
  {
    containers: [
      {
        name: 'container-003'
        paths: [
          '/myPartitionKey'
        ]
        throughput: 500
      }
    ]
    name: 'db-and-container-fixed-throughput-level'
    throughput: 500
  }
  {
    containers: [
      {
        name: 'container-003'
        paths: [
          '/myPartitionKey'
        ]
        throughput: 500
      }
    ]
    name: 'container-fixed-throughput-level'
  }
  {
    containers: [
      {
        name: 'container-003'
        paths: [
          '/myPartitionKey'
        ]
      }
    ]
    name: 'database-fixed-throughput-level'
    throughput: 500
  }
  {
    autoscaleSettingsMaxThroughput: 1000
    containers: [
      {
        autoscaleSettingsMaxThroughput: 1000
        name: 'container-003'
        paths: [
          '/myPartitionKey'
        ]
      }
    ]
    name: 'db-and-container-autoscale-level'
  }
  {
    containers: [
      {
        autoscaleSettingsMaxThroughput: 1000
        name: 'container-003'
        paths: [
          '/myPartitionKey'
        ]
      }
    ]
    name: 'container-autoscale-level'
  }
  {
    autoscaleSettingsMaxThroughput: 1000
    containers: [
      {
        name: 'container-003'
        paths: [
          '/myPartitionKey'
        ]
      }
    ]
    name: 'database-autoscale-level'
  }
  {
    containers: [
      {
        kind: 'MultiHash'
        name: 'container-001'
        paths: [
          '/myPartitionKey1'
          '/myPartitionKey2'
          '/myPartitionKey3'
        ]
      }
      {
        kind: 'MultiHash'
        name: 'container-002'
        paths: [
          'myPartitionKey1'
          'myPartitionKey2'
          'myPartitionKey3'
        ]
      }
      {
        kind: 'Hash'
        name: 'container-003'
        paths: [
          '/myPartitionKey1'
        ]
      }
      {
        kind: 'Hash'
        name: 'container-004'
        paths: [
          'myPartitionKey1'
        ]
      }
      {
        kind: 'Hash'
        name: 'container-005'
        paths: [
          'myPartitionKey1'
        ]
        version: 2
      }
    ]
    name: 'all-partition-key-types'
  }
  {
    containers: []
    name: 'empty-containers-array'
  }
  {
    name: 'no-containers-specified'
  }
]
param zoneRedundant = false
```

</details>
<p>

### Example 11: _Deploying with a sql role definition and assignment_

This instance deploys the module with sql role definition and assignment


<details>

<summary>via Bicep module</summary>

```bicep
module databaseAccount 'br/public:avm/res/document-db/database-account:<version>' = {
  name: 'databaseAccountDeployment'
  params: {
    // Required parameters
    name: 'role-ref'
    // Non-required parameters
    dataPlaneRoleAssignments: [
      {
        principalId: '<principalId>'
        roleDefinitionId: '<roleDefinitionId>'
      }
    ]
    dataPlaneRoleDefinitions: [
      {
        assignableScopes: [
          '<value>/providers/Microsoft.DocumentDB/databaseAccounts/role-ref'
        ]
        assignments: [
          {
            principalId: '<principalId>'
          }
        ]
        dataActions: [
          'Microsoft.DocumentDB/databaseAccounts/readMetadata'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/*'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/*'
        ]
        roleName: 'cosmos-sql-role-test'
      }
    ]
    zoneRedundant: false
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
      "value": "role-ref"
    },
    // Non-required parameters
    "dataPlaneRoleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "roleDefinitionId": "<roleDefinitionId>"
        }
      ]
    },
    "dataPlaneRoleDefinitions": {
      "value": [
        {
          "assignableScopes": [
            "<value>/providers/Microsoft.DocumentDB/databaseAccounts/role-ref"
          ],
          "assignments": [
            {
              "principalId": "<principalId>"
            }
          ],
          "dataActions": [
            "Microsoft.DocumentDB/databaseAccounts/readMetadata",
            "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/*",
            "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/*"
          ],
          "roleName": "cosmos-sql-role-test"
        }
      ]
    },
    "zoneRedundant": {
      "value": false
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/document-db/database-account:<version>'

// Required parameters
param name = 'role-ref'
// Non-required parameters
param dataPlaneRoleAssignments = [
  {
    principalId: '<principalId>'
    roleDefinitionId: '<roleDefinitionId>'
  }
]
param dataPlaneRoleDefinitions = [
  {
    assignableScopes: [
      '<value>/providers/Microsoft.DocumentDB/databaseAccounts/role-ref'
    ]
    assignments: [
      {
        principalId: '<principalId>'
      }
    ]
    dataActions: [
      'Microsoft.DocumentDB/databaseAccounts/readMetadata'
      'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/*'
      'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/*'
    ]
    roleName: 'cosmos-sql-role-test'
  }
]
param zoneRedundant = false
```

</details>
<p>

### Example 12: _API for Table_

This instance deploys the module for an Azure Cosmos DB for Table account with two example tables.


<details>

<summary>via Bicep module</summary>

```bicep
module databaseAccount 'br/public:avm/res/document-db/database-account:<version>' = {
  name: 'databaseAccountDeployment'
  params: {
    // Required parameters
    name: 'dddatbl001'
    // Non-required parameters
    capabilitiesToAdd: [
      'EnableTable'
    ]
    tables: [
      {
        name: 'tbl-dddatableminprov'
        throughput: 400
      }
      {
        maxThroughput: 1000
        name: 'tbl-dddatableminauto'
      }
    ]
    zoneRedundant: false
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
      "value": "dddatbl001"
    },
    // Non-required parameters
    "capabilitiesToAdd": {
      "value": [
        "EnableTable"
      ]
    },
    "tables": {
      "value": [
        {
          "name": "tbl-dddatableminprov",
          "throughput": 400
        },
        {
          "maxThroughput": 1000,
          "name": "tbl-dddatableminauto"
        }
      ]
    },
    "zoneRedundant": {
      "value": false
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/document-db/database-account:<version>'

// Required parameters
param name = 'dddatbl001'
// Non-required parameters
param capabilitiesToAdd = [
  'EnableTable'
]
param tables = [
  {
    name: 'tbl-dddatableminprov'
    throughput: 400
  }
  {
    maxThroughput: 1000
    name: 'tbl-dddatableminauto'
  }
]
param zoneRedundant = false
```

</details>
<p>

### Example 13: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module databaseAccount 'br/public:avm/res/document-db/database-account:<version>' = {
  name: 'databaseAccountDeployment'
  params: {
    // Required parameters
    name: 'dddawaf001'
    // Non-required parameters
    automaticFailover: true
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    disableKeyBasedMetadataWriteAccess: true
    disableLocalAuthentication: true
    failoverLocations: [
      {
        failoverPriority: 0
        isZoneRedundant: true
        locationName: '<locationName>'
      }
      {
        failoverPriority: 1
        isZoneRedundant: true
        locationName: '<locationName>'
      }
    ]
    minimumTlsVersion: 'Tls12'
    networkRestrictions: {
      networkAclBypass: 'None'
      publicNetworkAccess: 'Disabled'
    }
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        service: 'Sql'
        subnetResourceId: '<subnetResourceId>'
      }
    ]
    sqlDatabases: [
      {
        name: 'no-containers-specified'
      }
    ]
    tags: {
      environment: 'dev'
      role: 'validation'
      type: 'waf-aligned'
    }
    zoneRedundant: true
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
      "value": "dddawaf001"
    },
    // Non-required parameters
    "automaticFailover": {
      "value": true
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "disableKeyBasedMetadataWriteAccess": {
      "value": true
    },
    "disableLocalAuthentication": {
      "value": true
    },
    "failoverLocations": {
      "value": [
        {
          "failoverPriority": 0,
          "isZoneRedundant": true,
          "locationName": "<locationName>"
        },
        {
          "failoverPriority": 1,
          "isZoneRedundant": true,
          "locationName": "<locationName>"
        }
      ]
    },
    "minimumTlsVersion": {
      "value": "Tls12"
    },
    "networkRestrictions": {
      "value": {
        "networkAclBypass": "None",
        "publicNetworkAccess": "Disabled"
      }
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDnsZoneGroupConfigs": [
              {
                "privateDnsZoneResourceId": "<privateDnsZoneResourceId>"
              }
            ]
          },
          "service": "Sql",
          "subnetResourceId": "<subnetResourceId>"
        }
      ]
    },
    "sqlDatabases": {
      "value": [
        {
          "name": "no-containers-specified"
        }
      ]
    },
    "tags": {
      "value": {
        "environment": "dev",
        "role": "validation",
        "type": "waf-aligned"
      }
    },
    "zoneRedundant": {
      "value": true
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/document-db/database-account:<version>'

// Required parameters
param name = 'dddawaf001'
// Non-required parameters
param automaticFailover = true
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param disableKeyBasedMetadataWriteAccess = true
param disableLocalAuthentication = true
param failoverLocations = [
  {
    failoverPriority: 0
    isZoneRedundant: true
    locationName: '<locationName>'
  }
  {
    failoverPriority: 1
    isZoneRedundant: true
    locationName: '<locationName>'
  }
]
param minimumTlsVersion = 'Tls12'
param networkRestrictions = {
  networkAclBypass: 'None'
  publicNetworkAccess: 'Disabled'
}
param privateEndpoints = [
  {
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        {
          privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
        }
      ]
    }
    service: 'Sql'
    subnetResourceId: '<subnetResourceId>'
  }
]
param sqlDatabases = [
  {
    name: 'no-containers-specified'
  }
]
param tags = {
  environment: 'dev'
  role: 'validation'
  type: 'waf-aligned'
}
param zoneRedundant = true
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the account. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`automaticFailover`](#parameter-automaticfailover) | bool | Enable automatic failover for regions. Defaults to true. |
| [`backupIntervalInMinutes`](#parameter-backupintervalinminutes) | int | An integer representing the interval in minutes between two backups. This setting only applies to the periodic backup type. Defaults to 240. |
| [`backupPolicyContinuousTier`](#parameter-backuppolicycontinuoustier) | string | Configuration values to specify the retention period for continuous mode backup. Default to "Continuous30Days". |
| [`backupPolicyType`](#parameter-backuppolicytype) | string | Configures the backup mode. Periodic backup must be used if multiple write locations are used. Defaults to "Continuous". |
| [`backupRetentionIntervalInHours`](#parameter-backupretentionintervalinhours) | int | An integer representing the time (in hours) that each backup is retained. This setting only applies to the periodic backup type. Defaults to 8. |
| [`backupStorageRedundancy`](#parameter-backupstorageredundancy) | string | Setting that indicates the type of backup residency. This setting only applies to the periodic backup type. Defaults to "Local". |
| [`capabilitiesToAdd`](#parameter-capabilitiestoadd) | array | A list of Azure Cosmos DB specific capabilities for the account. |
| [`databaseAccountOfferType`](#parameter-databaseaccountoffertype) | string | The offer type for the account. Defaults to "Standard". |
| [`dataPlaneRoleAssignments`](#parameter-dataplaneroleassignments) | array | Configurations for Azure Cosmos DB for NoSQL native role-based access control assignments. |
| [`dataPlaneRoleDefinitions`](#parameter-dataplaneroledefinitions) | array | Configurations for Azure Cosmos DB for NoSQL native role-based access control definitions. Allows the creations of custom role definitions. |
| [`defaultConsistencyLevel`](#parameter-defaultconsistencylevel) | string | The default consistency level of the account. Defaults to "Session". |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings for the service. |
| [`disableKeyBasedMetadataWriteAccess`](#parameter-disablekeybasedmetadatawriteaccess) | bool | Disable write operations on metadata resources (databases, containers, throughput) via account keys. Defaults to true. |
| [`disableLocalAuthentication`](#parameter-disablelocalauthentication) | bool | Opt-out of local authentication and ensure that only Microsoft Entra can be used exclusively for authentication. Defaults to true. |
| [`enableAnalyticalStorage`](#parameter-enableanalyticalstorage) | bool | Flag to indicate whether to enable storage analytics. Defaults to false. |
| [`enableFreeTier`](#parameter-enablefreetier) | bool | Flag to indicate whether "Free Tier" is enabled. Defaults to false. |
| [`enableMultipleWriteLocations`](#parameter-enablemultiplewritelocations) | bool | Enables the account to write in multiple locations. Periodic backup must be used if enabled. Defaults to false. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`failoverLocations`](#parameter-failoverlocations) | array | The set of locations enabled for the account. Defaults to the location where the account is deployed. |
| [`gremlinDatabases`](#parameter-gremlindatabases) | array | Configuration for databases when using Azure Cosmos DB for Apache Gremlin. |
| [`location`](#parameter-location) | string | Defaults to the current resource group scope location. Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`maxIntervalInSeconds`](#parameter-maxintervalinseconds) | int | The maximum lag time in minutes. Required for "BoundedStaleness" consistency level. Valid ranges, Single Region: 5 to 84600. Multi Region: 300 to 86400. Defaults to 300. |
| [`maxStalenessPrefix`](#parameter-maxstalenessprefix) | int | The maximum stale requests. Required for "BoundedStaleness" consistency level. Valid ranges, Single Region: 10 to 1000000. Multi Region: 100000 to 1000000. Defaults to 100000. |
| [`minimumTlsVersion`](#parameter-minimumtlsversion) | string | Setting that indicates the minimum allowed TLS version. Azure Cosmos DB for MongoDB RU and Apache Cassandra only work with TLS 1.2 or later. Defaults to "Tls12" (TLS 1.2). |
| [`mongodbDatabases`](#parameter-mongodbdatabases) | array | Configuration for databases when using Azure Cosmos DB for MongoDB RU. |
| [`networkRestrictions`](#parameter-networkrestrictions) | object | The network configuration of this module. Defaults to `{ ipRules: [], virtualNetworkRules: [], publicNetworkAccess: 'Disabled' }`. |
| [`privateEndpoints`](#parameter-privateendpoints) | array | Configuration details for private endpoints. For security reasons, it is advised to use private endpoints whenever possible. |
| [`roleAssignments`](#parameter-roleassignments) | array | An array of control plane Azure role-based access control assignments. |
| [`serverVersion`](#parameter-serverversion) | string | Specifies the MongoDB server version to use if using Azure Cosmos DB for MongoDB RU. Defaults to "4.2". |
| [`sqlDatabases`](#parameter-sqldatabases) | array | Configuration for databases when using Azure Cosmos DB for NoSQL. |
| [`tables`](#parameter-tables) | array | Configuration for databases when using Azure Cosmos DB for Table. |
| [`tags`](#parameter-tags) | object | Tags for the resource. |
| [`totalThroughputLimit`](#parameter-totalthroughputlimit) | int | The total throughput limit imposed on this account in request units per second (RU/s). Default to unlimited throughput. |
| [`zoneRedundant`](#parameter-zoneredundant) | bool | Indicates whether the single-region account is zone redundant. Defaults to true. This property is ignored for multi-region accounts. |

### Parameter: `name`

The name of the account.

- Required: Yes
- Type: string

### Parameter: `automaticFailover`

Enable automatic failover for regions. Defaults to true.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `backupIntervalInMinutes`

An integer representing the interval in minutes between two backups. This setting only applies to the periodic backup type. Defaults to 240.

- Required: No
- Type: int
- Default: `240`
- MinValue: 60
- MaxValue: 1440

### Parameter: `backupPolicyContinuousTier`

Configuration values to specify the retention period for continuous mode backup. Default to "Continuous30Days".

- Required: No
- Type: string
- Default: `'Continuous30Days'`
- Allowed:
  ```Bicep
  [
    'Continuous30Days'
    'Continuous7Days'
  ]
  ```

### Parameter: `backupPolicyType`

Configures the backup mode. Periodic backup must be used if multiple write locations are used. Defaults to "Continuous".

- Required: No
- Type: string
- Default: `'Continuous'`
- Allowed:
  ```Bicep
  [
    'Continuous'
    'Periodic'
  ]
  ```

### Parameter: `backupRetentionIntervalInHours`

An integer representing the time (in hours) that each backup is retained. This setting only applies to the periodic backup type. Defaults to 8.

- Required: No
- Type: int
- Default: `8`
- MinValue: 2
- MaxValue: 720

### Parameter: `backupStorageRedundancy`

Setting that indicates the type of backup residency. This setting only applies to the periodic backup type. Defaults to "Local".

- Required: No
- Type: string
- Default: `'Local'`
- Allowed:
  ```Bicep
  [
    'Geo'
    'Local'
    'Zone'
  ]
  ```

### Parameter: `capabilitiesToAdd`

A list of Azure Cosmos DB specific capabilities for the account.

- Required: No
- Type: array
- Allowed:
  ```Bicep
  [
    'DeleteAllItemsByPartitionKey'
    'DisableRateLimitingResponses'
    'EnableCassandra'
    'EnableGremlin'
    'EnableMaterializedViews'
    'EnableMongo'
    'EnableNoSQLFullTextSearch'
    'EnableNoSQLVectorSearch'
    'EnableServerless'
    'EnableTable'
  ]
  ```

### Parameter: `databaseAccountOfferType`

The offer type for the account. Defaults to "Standard".

- Required: No
- Type: string
- Default: `'Standard'`
- Allowed:
  ```Bicep
  [
    'Standard'
  ]
  ```

### Parameter: `dataPlaneRoleAssignments`

Configurations for Azure Cosmos DB for NoSQL native role-based access control assignments.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-dataplaneroleassignmentsprincipalid) | string | The unique identifier for the associated Microsoft Entra ID principal to which access is being granted through this role-based access control assignment. The tenant ID for the principal is inferred using the tenant associated with the subscription. |
| [`roleDefinitionId`](#parameter-dataplaneroleassignmentsroledefinitionid) | string | The unique identifier of the Azure Cosmos DB for NoSQL native role-based access control definition. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-dataplaneroleassignmentsname) | string | The unique name of the role assignment. |

### Parameter: `dataPlaneRoleAssignments.principalId`

The unique identifier for the associated Microsoft Entra ID principal to which access is being granted through this role-based access control assignment. The tenant ID for the principal is inferred using the tenant associated with the subscription.

- Required: Yes
- Type: string

### Parameter: `dataPlaneRoleAssignments.roleDefinitionId`

The unique identifier of the Azure Cosmos DB for NoSQL native role-based access control definition.

- Required: Yes
- Type: string

### Parameter: `dataPlaneRoleAssignments.name`

The unique name of the role assignment.

- Required: No
- Type: string

### Parameter: `dataPlaneRoleDefinitions`

Configurations for Azure Cosmos DB for NoSQL native role-based access control definitions. Allows the creations of custom role definitions.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`roleName`](#parameter-dataplaneroledefinitionsrolename) | string | A user-friendly name for the role-based access control definition. This must be unique within the database account. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`assignableScopes`](#parameter-dataplaneroledefinitionsassignablescopes) | array | A set of fully-qualified scopes at or below which role-based access control assignments may be created using this definition. This setting allows application of this definition on the entire account or any underlying resource. This setting must have at least one element. Scopes higher than the account level are not enforceable as assignable scopes. Resources referenced in assignable scopes do not need to exist at creation. Defaults to the current account scope. |
| [`assignments`](#parameter-dataplaneroledefinitionsassignments) | array | An array of role-based access control assignments to be created for the definition. |
| [`dataActions`](#parameter-dataplaneroledefinitionsdataactions) | array | An array of data actions that are allowed. |
| [`name`](#parameter-dataplaneroledefinitionsname) | string | The unique identifier of the role-based access control definition. |

### Parameter: `dataPlaneRoleDefinitions.roleName`

A user-friendly name for the role-based access control definition. This must be unique within the database account.

- Required: Yes
- Type: string

### Parameter: `dataPlaneRoleDefinitions.assignableScopes`

A set of fully-qualified scopes at or below which role-based access control assignments may be created using this definition. This setting allows application of this definition on the entire account or any underlying resource. This setting must have at least one element. Scopes higher than the account level are not enforceable as assignable scopes. Resources referenced in assignable scopes do not need to exist at creation. Defaults to the current account scope.

- Required: No
- Type: array

### Parameter: `dataPlaneRoleDefinitions.assignments`

An array of role-based access control assignments to be created for the definition.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-dataplaneroledefinitionsassignmentsprincipalid) | string | The unique identifier for the associated AAD principal in the AAD graph to which access is being granted through this Role Assignment. Tenant ID for the principal is inferred using the tenant associated with the subscription. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-dataplaneroledefinitionsassignmentsname) | string | Name unique identifier of the SQL Role Assignment. |

### Parameter: `dataPlaneRoleDefinitions.assignments.principalId`

The unique identifier for the associated AAD principal in the AAD graph to which access is being granted through this Role Assignment. Tenant ID for the principal is inferred using the tenant associated with the subscription.

- Required: Yes
- Type: string

### Parameter: `dataPlaneRoleDefinitions.assignments.name`

Name unique identifier of the SQL Role Assignment.

- Required: No
- Type: string

### Parameter: `dataPlaneRoleDefinitions.dataActions`

An array of data actions that are allowed.

- Required: No
- Type: array

### Parameter: `dataPlaneRoleDefinitions.name`

The unique identifier of the role-based access control definition.

- Required: No
- Type: string

### Parameter: `defaultConsistencyLevel`

The default consistency level of the account. Defaults to "Session".

- Required: No
- Type: string
- Default: `'Session'`
- Allowed:
  ```Bicep
  [
    'BoundedStaleness'
    'ConsistentPrefix'
    'Eventual'
    'Session'
    'Strong'
  ]
  ```

### Parameter: `diagnosticSettings`

The diagnostic settings for the service.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-diagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-diagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-diagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-diagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-diagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-diagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-diagnosticsettingsname) | string | The name of the diagnostic setting. |
| [`storageAccountResourceId`](#parameter-diagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-diagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logAnalyticsDestinationType`

A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureDiagnostics'
    'Dedicated'
  ]
  ```

### Parameter: `diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-diagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-diagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-diagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-diagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-diagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `diagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `diagnosticSettings.name`

The name of the diagnostic setting.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `disableKeyBasedMetadataWriteAccess`

Disable write operations on metadata resources (databases, containers, throughput) via account keys. Defaults to true.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `disableLocalAuthentication`

Opt-out of local authentication and ensure that only Microsoft Entra can be used exclusively for authentication. Defaults to true.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableAnalyticalStorage`

Flag to indicate whether to enable storage analytics. Defaults to false.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableFreeTier`

Flag to indicate whether "Free Tier" is enabled. Defaults to false.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableMultipleWriteLocations`

Enables the account to write in multiple locations. Periodic backup must be used if enabled. Defaults to false.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `failoverLocations`

The set of locations enabled for the account. Defaults to the location where the account is deployed.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`failoverPriority`](#parameter-failoverlocationsfailoverpriority) | int | The failover priority of the region. A failover priority of 0 indicates a write region. The maximum value for a failover priority = (total number of regions - 1). Failover priority values must be unique for each of the regions in which the database account exists. |
| [`locationName`](#parameter-failoverlocationslocationname) | string | The name of the region. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`isZoneRedundant`](#parameter-failoverlocationsiszoneredundant) | bool | Flag to indicate whether or not this region is an AvailabilityZone region. Defaults to true. |

### Parameter: `failoverLocations.failoverPriority`

The failover priority of the region. A failover priority of 0 indicates a write region. The maximum value for a failover priority = (total number of regions - 1). Failover priority values must be unique for each of the regions in which the database account exists.

- Required: Yes
- Type: int

### Parameter: `failoverLocations.locationName`

The name of the region.

- Required: Yes
- Type: string

### Parameter: `failoverLocations.isZoneRedundant`

Flag to indicate whether or not this region is an AvailabilityZone region. Defaults to true.

- Required: No
- Type: bool

### Parameter: `gremlinDatabases`

Configuration for databases when using Azure Cosmos DB for Apache Gremlin.

- Required: No
- Type: array

### Parameter: `location`

Defaults to the current resource group scope location. Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

The lock settings of the service.

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

### Parameter: `maxIntervalInSeconds`

The maximum lag time in minutes. Required for "BoundedStaleness" consistency level. Valid ranges, Single Region: 5 to 84600. Multi Region: 300 to 86400. Defaults to 300.

- Required: No
- Type: int
- Default: `300`
- MinValue: 5
- MaxValue: 86400

### Parameter: `maxStalenessPrefix`

The maximum stale requests. Required for "BoundedStaleness" consistency level. Valid ranges, Single Region: 10 to 1000000. Multi Region: 100000 to 1000000. Defaults to 100000.

- Required: No
- Type: int
- Default: `100000`
- MinValue: 1
- MaxValue: 2147483647

### Parameter: `minimumTlsVersion`

Setting that indicates the minimum allowed TLS version. Azure Cosmos DB for MongoDB RU and Apache Cassandra only work with TLS 1.2 or later. Defaults to "Tls12" (TLS 1.2).

- Required: No
- Type: string
- Default: `'Tls12'`
- Allowed:
  ```Bicep
  [
    'Tls12'
  ]
  ```

### Parameter: `mongodbDatabases`

Configuration for databases when using Azure Cosmos DB for MongoDB RU.

- Required: No
- Type: array

### Parameter: `networkRestrictions`

The network configuration of this module. Defaults to `{ ipRules: [], virtualNetworkRules: [], publicNetworkAccess: 'Disabled' }`.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      ipRules: []
      publicNetworkAccess: 'Disabled'
      virtualNetworkRules: []
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ipRules`](#parameter-networkrestrictionsiprules) | array | A single IPv4 address or a single IPv4 address range in Classless Inter-Domain Routing (CIDR) format. Provided IPs must be well-formatted and cannot be contained in one of the following ranges: `10.0.0.0/8`, `100.64.0.0/10`, `172.16.0.0/12`, `192.168.0.0/16`, since these are not enforceable by the IP address filter. Example of valid inputs: `23.40.210.245` or `23.40.210.0/8`. |
| [`networkAclBypass`](#parameter-networkrestrictionsnetworkaclbypass) | string | Specifies the network ACL bypass for Azure services. Default to "None". |
| [`publicNetworkAccess`](#parameter-networkrestrictionspublicnetworkaccess) | string | Whether requests from the public network are allowed. Default to "Disabled". |
| [`virtualNetworkRules`](#parameter-networkrestrictionsvirtualnetworkrules) | array | List of virtual network access control list (ACL) rules configured for the account. |

### Parameter: `networkRestrictions.ipRules`

A single IPv4 address or a single IPv4 address range in Classless Inter-Domain Routing (CIDR) format. Provided IPs must be well-formatted and cannot be contained in one of the following ranges: `10.0.0.0/8`, `100.64.0.0/10`, `172.16.0.0/12`, `192.168.0.0/16`, since these are not enforceable by the IP address filter. Example of valid inputs: `23.40.210.245` or `23.40.210.0/8`.

- Required: No
- Type: array

### Parameter: `networkRestrictions.networkAclBypass`

Specifies the network ACL bypass for Azure services. Default to "None".

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureServices'
    'None'
  ]
  ```

### Parameter: `networkRestrictions.publicNetworkAccess`

Whether requests from the public network are allowed. Default to "Disabled".

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `networkRestrictions.virtualNetworkRules`

List of virtual network access control list (ACL) rules configured for the account.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`subnetResourceId`](#parameter-networkrestrictionsvirtualnetworkrulessubnetresourceid) | string | Resource ID of a subnet. |

### Parameter: `networkRestrictions.virtualNetworkRules.subnetResourceId`

Resource ID of a subnet.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints`

Configuration details for private endpoints. For security reasons, it is advised to use private endpoints whenever possible.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`service`](#parameter-privateendpointsservice) | string | The subresource to deploy the private endpoint for. For example "blob", "table", "queue" or "file" for a Storage Account's Private Endpoints. |
| [`subnetResourceId`](#parameter-privateendpointssubnetresourceid) | string | Resource ID of the subnet where the endpoint needs to be created. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`applicationSecurityGroupResourceIds`](#parameter-privateendpointsapplicationsecuritygroupresourceids) | array | Application security groups in which the private endpoint IP configuration is included. |
| [`customDnsConfigs`](#parameter-privateendpointscustomdnsconfigs) | array | Custom DNS configurations. |
| [`customNetworkInterfaceName`](#parameter-privateendpointscustomnetworkinterfacename) | string | The custom name of the network interface attached to the private endpoint. |
| [`enableTelemetry`](#parameter-privateendpointsenabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`ipConfigurations`](#parameter-privateendpointsipconfigurations) | array | A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints. |
| [`isManualConnection`](#parameter-privateendpointsismanualconnection) | bool | If Manual Private Link Connection is required. |
| [`location`](#parameter-privateendpointslocation) | string | The location to deploy the private endpoint to. |
| [`lock`](#parameter-privateendpointslock) | object | Specify the type of lock. |
| [`manualConnectionRequestMessage`](#parameter-privateendpointsmanualconnectionrequestmessage) | string | A message passed to the owner of the remote resource with the manual connection request. |
| [`name`](#parameter-privateendpointsname) | string | The name of the private endpoint. |
| [`privateDnsZoneGroup`](#parameter-privateendpointsprivatednszonegroup) | object | The private DNS zone group to configure for the private endpoint. |
| [`privateLinkServiceConnectionName`](#parameter-privateendpointsprivatelinkserviceconnectionname) | string | The name of the private link connection to create. |
| [`resourceGroupResourceId`](#parameter-privateendpointsresourcegroupresourceid) | string | The resource ID of the Resource Group the Private Endpoint will be created in. If not specified, the Resource Group of the provided Virtual Network Subnet is used. |
| [`roleAssignments`](#parameter-privateendpointsroleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-privateendpointstags) | object | Tags to be applied on all resources/resource groups in this deployment. |

### Parameter: `privateEndpoints.service`

The subresource to deploy the private endpoint for. For example "blob", "table", "queue" or "file" for a Storage Account's Private Endpoints.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.subnetResourceId`

Resource ID of the subnet where the endpoint needs to be created.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.applicationSecurityGroupResourceIds`

Application security groups in which the private endpoint IP configuration is included.

- Required: No
- Type: array

### Parameter: `privateEndpoints.customDnsConfigs`

Custom DNS configurations.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ipAddresses`](#parameter-privateendpointscustomdnsconfigsipaddresses) | array | A list of private IP addresses of the private endpoint. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`fqdn`](#parameter-privateendpointscustomdnsconfigsfqdn) | string | FQDN that resolves to private endpoint IP address. |

### Parameter: `privateEndpoints.customDnsConfigs.ipAddresses`

A list of private IP addresses of the private endpoint.

- Required: Yes
- Type: array

### Parameter: `privateEndpoints.customDnsConfigs.fqdn`

FQDN that resolves to private endpoint IP address.

- Required: No
- Type: string

### Parameter: `privateEndpoints.customNetworkInterfaceName`

The custom name of the network interface attached to the private endpoint.

- Required: No
- Type: string

### Parameter: `privateEndpoints.enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool

### Parameter: `privateEndpoints.ipConfigurations`

A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-privateendpointsipconfigurationsname) | string | The name of the resource that is unique within a resource group. |
| [`properties`](#parameter-privateendpointsipconfigurationsproperties) | object | Properties of private endpoint IP configurations. |

### Parameter: `privateEndpoints.ipConfigurations.name`

The name of the resource that is unique within a resource group.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.ipConfigurations.properties`

Properties of private endpoint IP configurations.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`groupId`](#parameter-privateendpointsipconfigurationspropertiesgroupid) | string | The ID of a group obtained from the remote resource that this private endpoint should connect to. |
| [`memberName`](#parameter-privateendpointsipconfigurationspropertiesmembername) | string | The member name of a group obtained from the remote resource that this private endpoint should connect to. |
| [`privateIPAddress`](#parameter-privateendpointsipconfigurationspropertiesprivateipaddress) | string | A private IP address obtained from the private endpoint's subnet. |

### Parameter: `privateEndpoints.ipConfigurations.properties.groupId`

The ID of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.ipConfigurations.properties.memberName`

The member name of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.ipConfigurations.properties.privateIPAddress`

A private IP address obtained from the private endpoint's subnet.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.isManualConnection`

If Manual Private Link Connection is required.

- Required: No
- Type: bool

### Parameter: `privateEndpoints.location`

The location to deploy the private endpoint to.

- Required: No
- Type: string

### Parameter: `privateEndpoints.lock`

Specify the type of lock.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-privateendpointslockkind) | string | Specify the type of lock. |
| [`name`](#parameter-privateendpointslockname) | string | Specify the name of lock. |
| [`notes`](#parameter-privateendpointslocknotes) | string | Specify the notes of the lock. |

### Parameter: `privateEndpoints.lock.kind`

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

### Parameter: `privateEndpoints.lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `privateEndpoints.lock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `privateEndpoints.manualConnectionRequestMessage`

A message passed to the owner of the remote resource with the manual connection request.

- Required: No
- Type: string

### Parameter: `privateEndpoints.name`

The name of the private endpoint.

- Required: No
- Type: string

### Parameter: `privateEndpoints.privateDnsZoneGroup`

The private DNS zone group to configure for the private endpoint.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateDnsZoneGroupConfigs`](#parameter-privateendpointsprivatednszonegroupprivatednszonegroupconfigs) | array | The private DNS Zone Groups to associate the Private Endpoint. A DNS Zone Group can support up to 5 DNS zones. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-privateendpointsprivatednszonegroupname) | string | The name of the Private DNS Zone Group. |

### Parameter: `privateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs`

The private DNS Zone Groups to associate the Private Endpoint. A DNS Zone Group can support up to 5 DNS zones.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateDnsZoneResourceId`](#parameter-privateendpointsprivatednszonegroupprivatednszonegroupconfigsprivatednszoneresourceid) | string | The resource id of the private DNS zone. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-privateendpointsprivatednszonegroupprivatednszonegroupconfigsname) | string | The name of the private DNS Zone Group config. |

### Parameter: `privateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs.privateDnsZoneResourceId`

The resource id of the private DNS zone.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs.name`

The name of the private DNS Zone Group config.

- Required: No
- Type: string

### Parameter: `privateEndpoints.privateDnsZoneGroup.name`

The name of the Private DNS Zone Group.

- Required: No
- Type: string

### Parameter: `privateEndpoints.privateLinkServiceConnectionName`

The name of the private link connection to create.

- Required: No
- Type: string

### Parameter: `privateEndpoints.resourceGroupResourceId`

The resource ID of the Resource Group the Private Endpoint will be created in. If not specified, the Resource Group of the provided Virtual Network Subnet is used.

- Required: No
- Type: string

### Parameter: `privateEndpoints.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-privateendpointsroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-privateendpointsroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-privateendpointsroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-privateendpointsroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-privateendpointsroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-privateendpointsroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-privateendpointsroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-privateendpointsroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `privateEndpoints.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `privateEndpoints.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `privateEndpoints.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `privateEndpoints.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `privateEndpoints.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `privateEndpoints.roleAssignments.principalType`

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

### Parameter: `privateEndpoints.tags`

Tags to be applied on all resources/resource groups in this deployment.

- Required: No
- Type: object

### Parameter: `roleAssignments`

An array of control plane Azure role-based access control assignments.

- Required: No
- Type: array

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

### Parameter: `serverVersion`

Specifies the MongoDB server version to use if using Azure Cosmos DB for MongoDB RU. Defaults to "4.2".

- Required: No
- Type: string
- Default: `'4.2'`
- Allowed:
  ```Bicep
  [
    '3.2'
    '3.6'
    '4.0'
    '4.2'
    '5.0'
    '6.0'
    '7.0'
  ]
  ```

### Parameter: `sqlDatabases`

Configuration for databases when using Azure Cosmos DB for NoSQL.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-sqldatabasesname) | string | Name of the database . |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoscaleSettingsMaxThroughput`](#parameter-sqldatabasesautoscalesettingsmaxthroughput) | int | Specifies the autoscale settings and represents maximum throughput the resource can scale up to. The autoscale throughput should have valid throughput values between 1000 and 1000000 inclusive in increments of 1000. If the value is not set, then autoscale will be disabled. Setting throughput at the database level is only recommended for development/test or when workload across all containers in the shared throughput database is uniform. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the container level and not at the database level. |
| [`containers`](#parameter-sqldatabasescontainers) | array | Set of containers to deploy in the database. |
| [`throughput`](#parameter-sqldatabasesthroughput) | int | Request units per second. Will be ignored if `autoscaleSettingsMaxThroughput` is used. Setting throughput at the database level is only recommended for development/test or when workload across all containers in the shared throughput database is uniform. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the container level and not at the database level. Defaults to 400. |

### Parameter: `sqlDatabases.name`

Name of the database .

- Required: Yes
- Type: string

### Parameter: `sqlDatabases.autoscaleSettingsMaxThroughput`

Specifies the autoscale settings and represents maximum throughput the resource can scale up to. The autoscale throughput should have valid throughput values between 1000 and 1000000 inclusive in increments of 1000. If the value is not set, then autoscale will be disabled. Setting throughput at the database level is only recommended for development/test or when workload across all containers in the shared throughput database is uniform. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the container level and not at the database level.

- Required: No
- Type: int

### Parameter: `sqlDatabases.containers`

Set of containers to deploy in the database.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-sqldatabasescontainersname) | string | Name of the container. |
| [`paths`](#parameter-sqldatabasescontainerspaths) | array | List of paths using which data within the container can be partitioned. For kind=MultiHash it can be up to 3. For anything else it needs to be exactly 1. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`analyticalStorageTtl`](#parameter-sqldatabasescontainersanalyticalstoragettl) | int | Default to 0. Indicates how long data should be retained in the analytical store, for a container. Analytical store is enabled when ATTL is set with a value other than 0. If the value is set to -1, the analytical store retains all historical data, irrespective of the retention of the data in the transactional store. |
| [`autoscaleSettingsMaxThroughput`](#parameter-sqldatabasescontainersautoscalesettingsmaxthroughput) | int | Specifies the Autoscale settings and represents maximum throughput, the resource can scale up to. The autoscale throughput should have valid throughput values between 1000 and 1000000 inclusive in increments of 1000. If value is set to null, then autoscale will be disabled. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the container level. |
| [`conflictResolutionPolicy`](#parameter-sqldatabasescontainersconflictresolutionpolicy) | object | The conflict resolution policy for the container. Conflicts and conflict resolution policies are applicable if the Azure Cosmos DB account is configured with multiple write regions. |
| [`defaultTtl`](#parameter-sqldatabasescontainersdefaultttl) | int | Default to -1. Default time to live (in seconds). With Time to Live or TTL, Azure Cosmos DB provides the ability to delete items automatically from a container after a certain time period. If the value is set to "-1", it is equal to infinity, and items don't expire by default. |
| [`indexingPolicy`](#parameter-sqldatabasescontainersindexingpolicy) | object | Indexing policy of the container. |
| [`kind`](#parameter-sqldatabasescontainerskind) | string | Default to Hash. Indicates the kind of algorithm used for partitioning. |
| [`throughput`](#parameter-sqldatabasescontainersthroughput) | int | Default to 400. Request Units per second. Will be ignored if autoscaleSettingsMaxThroughput is used. |
| [`uniqueKeyPolicyKeys`](#parameter-sqldatabasescontainersuniquekeypolicykeys) | array | The unique key policy configuration containing a list of unique keys that enforces uniqueness constraint on documents in the collection in the Azure Cosmos DB service. |
| [`version`](#parameter-sqldatabasescontainersversion) | int | Default to 1 for Hash and 2 for MultiHash - 1 is not allowed for MultiHash. Version of the partition key definition. |

### Parameter: `sqlDatabases.containers.name`

Name of the container.

- Required: Yes
- Type: string

### Parameter: `sqlDatabases.containers.paths`

List of paths using which data within the container can be partitioned. For kind=MultiHash it can be up to 3. For anything else it needs to be exactly 1.

- Required: Yes
- Type: array

### Parameter: `sqlDatabases.containers.analyticalStorageTtl`

Default to 0. Indicates how long data should be retained in the analytical store, for a container. Analytical store is enabled when ATTL is set with a value other than 0. If the value is set to -1, the analytical store retains all historical data, irrespective of the retention of the data in the transactional store.

- Required: No
- Type: int

### Parameter: `sqlDatabases.containers.autoscaleSettingsMaxThroughput`

Specifies the Autoscale settings and represents maximum throughput, the resource can scale up to. The autoscale throughput should have valid throughput values between 1000 and 1000000 inclusive in increments of 1000. If value is set to null, then autoscale will be disabled. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the container level.

- Required: No
- Type: int
- MaxValue: 1000000

### Parameter: `sqlDatabases.containers.conflictResolutionPolicy`

The conflict resolution policy for the container. Conflicts and conflict resolution policies are applicable if the Azure Cosmos DB account is configured with multiple write regions.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`mode`](#parameter-sqldatabasescontainersconflictresolutionpolicymode) | string | Indicates the conflict resolution mode. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`conflictResolutionPath`](#parameter-sqldatabasescontainersconflictresolutionpolicyconflictresolutionpath) | string | The conflict resolution path in the case of LastWriterWins mode. Required if `mode` is set to 'LastWriterWins'. |
| [`conflictResolutionProcedure`](#parameter-sqldatabasescontainersconflictresolutionpolicyconflictresolutionprocedure) | string | The procedure to resolve conflicts in the case of custom mode. Required if `mode` is set to 'Custom'. |

### Parameter: `sqlDatabases.containers.conflictResolutionPolicy.mode`

Indicates the conflict resolution mode.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Custom'
    'LastWriterWins'
  ]
  ```

### Parameter: `sqlDatabases.containers.conflictResolutionPolicy.conflictResolutionPath`

The conflict resolution path in the case of LastWriterWins mode. Required if `mode` is set to 'LastWriterWins'.

- Required: No
- Type: string

### Parameter: `sqlDatabases.containers.conflictResolutionPolicy.conflictResolutionProcedure`

The procedure to resolve conflicts in the case of custom mode. Required if `mode` is set to 'Custom'.

- Required: No
- Type: string

### Parameter: `sqlDatabases.containers.defaultTtl`

Default to -1. Default time to live (in seconds). With Time to Live or TTL, Azure Cosmos DB provides the ability to delete items automatically from a container after a certain time period. If the value is set to "-1", it is equal to infinity, and items don't expire by default.

- Required: No
- Type: int
- MinValue: -1
- MaxValue: 2147483647

### Parameter: `sqlDatabases.containers.indexingPolicy`

Indexing policy of the container.

- Required: No
- Type: object

### Parameter: `sqlDatabases.containers.kind`

Default to Hash. Indicates the kind of algorithm used for partitioning.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Hash'
    'MultiHash'
  ]
  ```

### Parameter: `sqlDatabases.containers.throughput`

Default to 400. Request Units per second. Will be ignored if autoscaleSettingsMaxThroughput is used.

- Required: No
- Type: int

### Parameter: `sqlDatabases.containers.uniqueKeyPolicyKeys`

The unique key policy configuration containing a list of unique keys that enforces uniqueness constraint on documents in the collection in the Azure Cosmos DB service.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`paths`](#parameter-sqldatabasescontainersuniquekeypolicykeyspaths) | array | List of paths must be unique for each document in the Azure Cosmos DB service. |

### Parameter: `sqlDatabases.containers.uniqueKeyPolicyKeys.paths`

List of paths must be unique for each document in the Azure Cosmos DB service.

- Required: Yes
- Type: array

### Parameter: `sqlDatabases.containers.version`

Default to 1 for Hash and 2 for MultiHash - 1 is not allowed for MultiHash. Version of the partition key definition.

- Required: No
- Type: int
- Allowed:
  ```Bicep
  [
    1
    2
  ]
  ```

### Parameter: `sqlDatabases.throughput`

Request units per second. Will be ignored if `autoscaleSettingsMaxThroughput` is used. Setting throughput at the database level is only recommended for development/test or when workload across all containers in the shared throughput database is uniform. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the container level and not at the database level. Defaults to 400.

- Required: No
- Type: int

### Parameter: `tables`

Configuration for databases when using Azure Cosmos DB for Table.

- Required: No
- Type: array

### Parameter: `tags`

Tags for the resource.

- Required: No
- Type: object

### Parameter: `totalThroughputLimit`

The total throughput limit imposed on this account in request units per second (RU/s). Default to unlimited throughput.

- Required: No
- Type: int
- Default: `-1`

### Parameter: `zoneRedundant`

Indicates whether the single-region account is zone redundant. Defaults to true. This property is ignored for multi-region accounts.

- Required: No
- Type: bool
- Default: `True`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `endpoint` | string | The endpoint of the database account. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the database account. |
| `primaryReadOnlyConnectionString` | securestring | The primary read-only connection string. |
| `primaryReadOnlyKey` | securestring | The primary read-only key. |
| `primaryReadWriteConnectionString` | securestring | The primary read-write connection string. |
| `primaryReadWriteKey` | securestring | The primary read-write key. |
| `privateEndpoints` | array | The private endpoints of the database account. |
| `resourceGroupName` | string | The name of the resource group the database account was created in. |
| `resourceId` | string | The resource ID of the database account. |
| `secondaryReadOnlyConnectionString` | securestring | The secondary read-only connection string. |
| `secondaryReadOnlyKey` | securestring | The secondary read-only key. |
| `secondaryReadWriteConnectionString` | securestring | The secondary read-write connection string. |
| `secondaryReadWriteKey` | securestring | The secondary read-write key. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/network/private-endpoint:0.11.0` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.6.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
