# Redis Enterprise and Azure Managed Redis `[Microsoft.Cache/redisEnterprise]`

This module deploys a Redis Enterprise or Azure Managed Redis cache.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Cache/redisEnterprise` | [2025-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cache/2025-05-01-preview/redisEnterprise) |
| `Microsoft.Cache/redisEnterprise/databases` | [2025-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cache/2025-05-01-preview/redisEnterprise/databases) |
| `Microsoft.Cache/redisEnterprise/databases/accessPolicyAssignments` | [2025-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cache/2025-05-01-preview/redisEnterprise/databases/accessPolicyAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.KeyVault/vaults/secrets` | [2023-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2023-07-01/vaults/secrets) |
| `Microsoft.Network/privateEndpoints` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/privateEndpoints/privateDnsZoneGroups) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/cache/redis-enterprise:<version>`.

- [Active geo-replication](#example-1-active-geo-replication)
- [Azure Managed Redis with Entra ID authentication](#example-2-azure-managed-redis-with-entra-id-authentication)
- [Azure Managed Redis with non-clustered policy (Preview)](#example-3-azure-managed-redis-with-non-clustered-policy-preview)
- [Using only defaults](#example-4-using-only-defaults)
- [Deploying with a key vault reference to save secrets](#example-5-deploying-with-a-key-vault-reference-to-save-secrets)
- [Using large parameter set](#example-6-using-large-parameter-set)
- [Using Customer-Managed-Keys with User-Assigned identity](#example-7-using-customer-managed-keys-with-user-assigned-identity)
- [WAF-aligned](#example-8-waf-aligned)

### Example 1: _Active geo-replication_

This instance deploys the module with active geo-replication enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module redisEnterprise 'br/public:avm/res/cache/redis-enterprise:<version>' = {
  name: 'redisEnterpriseDeployment'
  params: {
    // Required parameters
    name: 'creagr002'
    // Non-required parameters
    database: {
      geoReplication: {
        groupNickname: '<groupNickname>'
        linkedDatabases: [
          {
            id: '<id>'
          }
          {
            id: '<id>'
          }
        ]
      }
    }
    location: '<location>'
    skuName: 'Balanced_B10'
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
      "value": "creagr002"
    },
    // Non-required parameters
    "database": {
      "value": {
        "geoReplication": {
          "groupNickname": "<groupNickname>",
          "linkedDatabases": [
            {
              "id": "<id>"
            },
            {
              "id": "<id>"
            }
          ]
        }
      }
    },
    "location": {
      "value": "<location>"
    },
    "skuName": {
      "value": "Balanced_B10"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/cache/redis-enterprise:<version>'

// Required parameters
param name = 'creagr002'
// Non-required parameters
param database = {
  geoReplication: {
    groupNickname: '<groupNickname>'
    linkedDatabases: [
      {
        id: '<id>'
      }
      {
        id: '<id>'
      }
    ]
  }
}
param location = '<location>'
param skuName = 'Balanced_B10'
```

</details>
<p>

### Example 2: _Azure Managed Redis with Entra ID authentication_

This instance deploys an Azure Managed Redis cache with Entra ID authentication.


<details>

<summary>via Bicep module</summary>

```bicep
module redisEnterprise 'br/public:avm/res/cache/redis-enterprise:<version>' = {
  name: 'redisEnterpriseDeployment'
  params: {
    // Required parameters
    name: 'creaei001'
    // Non-required parameters
    database: {
      accessKeysAuthentication: 'Disabled'
      accessPolicyAssignments: [
        {
          name: 'assign1'
          userObjectId: '<userObjectId>'
        }
      ]
    }
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
      "value": "creaei001"
    },
    // Non-required parameters
    "database": {
      "value": {
        "accessKeysAuthentication": "Disabled",
        "accessPolicyAssignments": [
          {
            "name": "assign1",
            "userObjectId": "<userObjectId>"
          }
        ]
      }
    },
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
using 'br/public:avm/res/cache/redis-enterprise:<version>'

// Required parameters
param name = 'creaei001'
// Non-required parameters
param database = {
  accessKeysAuthentication: 'Disabled'
  accessPolicyAssignments: [
    {
      name: 'assign1'
      userObjectId: '<userObjectId>'
    }
  ]
}
param location = '<location>'
```

</details>
<p>

### Example 3: _Azure Managed Redis with non-clustered policy (Preview)_

This instance deploys an Azure Managed Redis cache in non-clustered mode (Preview).


<details>

<summary>via Bicep module</summary>

```bicep
module redisEnterprise 'br/public:avm/res/cache/redis-enterprise:<version>' = {
  name: 'redisEnterpriseDeployment'
  params: {
    // Required parameters
    name: 'creanc001'
    // Non-required parameters
    database: {
      clusteringPolicy: 'NoCluster'
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
      "value": "creanc001"
    },
    // Non-required parameters
    "database": {
      "value": {
        "clusteringPolicy": "NoCluster"
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
using 'br/public:avm/res/cache/redis-enterprise:<version>'

// Required parameters
param name = 'creanc001'
// Non-required parameters
param database = {
  clusteringPolicy: 'NoCluster'
}
```

</details>
<p>

### Example 4: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module redisEnterprise 'br/public:avm/res/cache/redis-enterprise:<version>' = {
  name: 'redisEnterpriseDeployment'
  params: {
    name: 'cremin001'
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
      "value": "cremin001"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/cache/redis-enterprise:<version>'

param name = 'cremin001'
```

</details>
<p>

### Example 5: _Deploying with a key vault reference to save secrets_

This instance deploys the module saving all its secrets in a key vault.


<details>

<summary>via Bicep module</summary>

```bicep
module redisEnterprise 'br/public:avm/res/cache/redis-enterprise:<version>' = {
  name: 'redisEnterpriseDeployment'
  params: {
    // Required parameters
    name: 'kvref'
    // Non-required parameters
    database: {
      secretsExportConfiguration: {
        keyVaultResourceId: '<keyVaultResourceId>'
        primaryAccessKeyName: 'custom-primaryAccessKey-name'
        primaryConnectionStringName: 'custom-primaryConnectionString-name'
        primaryStackExchangeRedisConnectionStringName: 'custom-primaryStackExchangeRedisConnectionString-name'
        secondaryAccessKeyName: 'custom-secondaryAccessKey-name'
        secondaryConnectionStringName: 'custom-secondaryConnectionString-name'
        secondaryStackExchangeRedisConnectionStringName: 'custom-secondaryStackExchangeRedisConnectionString-name'
      }
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
      "value": "kvref"
    },
    // Non-required parameters
    "database": {
      "value": {
        "secretsExportConfiguration": {
          "keyVaultResourceId": "<keyVaultResourceId>",
          "primaryAccessKeyName": "custom-primaryAccessKey-name",
          "primaryConnectionStringName": "custom-primaryConnectionString-name",
          "primaryStackExchangeRedisConnectionStringName": "custom-primaryStackExchangeRedisConnectionString-name",
          "secondaryAccessKeyName": "custom-secondaryAccessKey-name",
          "secondaryConnectionStringName": "custom-secondaryConnectionString-name",
          "secondaryStackExchangeRedisConnectionStringName": "custom-secondaryStackExchangeRedisConnectionString-name"
        }
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
using 'br/public:avm/res/cache/redis-enterprise:<version>'

// Required parameters
param name = 'kvref'
// Non-required parameters
param database = {
  secretsExportConfiguration: {
    keyVaultResourceId: '<keyVaultResourceId>'
    primaryAccessKeyName: 'custom-primaryAccessKey-name'
    primaryConnectionStringName: 'custom-primaryConnectionString-name'
    primaryStackExchangeRedisConnectionStringName: 'custom-primaryStackExchangeRedisConnectionString-name'
    secondaryAccessKeyName: 'custom-secondaryAccessKey-name'
    secondaryConnectionStringName: 'custom-secondaryConnectionString-name'
    secondaryStackExchangeRedisConnectionStringName: 'custom-secondaryStackExchangeRedisConnectionString-name'
  }
}
```

</details>
<p>

### Example 6: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module redisEnterprise 'br/public:avm/res/cache/redis-enterprise:<version>' = {
  name: 'redisEnterpriseDeployment'
  params: {
    // Required parameters
    name: 'cremax001'
    // Non-required parameters
    database: {
      clientProtocol: 'Plaintext'
      clusteringPolicy: 'EnterpriseCluster'
      deferUpgrade: 'Deferred'
      diagnosticSettings: [
        {
          eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
          eventHubName: '<eventHubName>'
          logCategoriesAndGroups: [
            {
              categoryGroup: 'allLogs'
            }
          ]
          name: 'customSettingDatabase'
          storageAccountResourceId: '<storageAccountResourceId>'
          workspaceResourceId: '<workspaceResourceId>'
        }
      ]
      evictionPolicy: 'NoEviction'
      modules: [
        {
          name: 'RedisBloom'
        }
        {
          name: 'RediSearch'
        }
      ]
      persistence: {
        frequency: '1s'
        type: 'aof'
      }
    }
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'customSettingCluster'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    enableTelemetry: true
    highAvailability: 'Disabled'
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    minimumTlsVersion: '1.2'
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
    ]
    roleAssignments: [
      {
        name: '759769d2-fc52-4a92-a943-724e48927e0b'
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
    skuName: 'Balanced_B10'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    zones: [
      1
      2
      3
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
      "value": "cremax001"
    },
    // Non-required parameters
    "database": {
      "value": {
        "clientProtocol": "Plaintext",
        "clusteringPolicy": "EnterpriseCluster",
        "deferUpgrade": "Deferred",
        "diagnosticSettings": [
          {
            "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
            "eventHubName": "<eventHubName>",
            "logCategoriesAndGroups": [
              {
                "categoryGroup": "allLogs"
              }
            ],
            "name": "customSettingDatabase",
            "storageAccountResourceId": "<storageAccountResourceId>",
            "workspaceResourceId": "<workspaceResourceId>"
          }
        ],
        "evictionPolicy": "NoEviction",
        "modules": [
          {
            "name": "RedisBloom"
          },
          {
            "name": "RediSearch"
          }
        ],
        "persistence": {
          "frequency": "1s",
          "type": "aof"
        }
      }
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "metricCategories": [
            {
              "category": "AllMetrics"
            }
          ],
          "name": "customSettingCluster",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "enableTelemetry": {
      "value": true
    },
    "highAvailability": {
      "value": "Disabled"
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "minimumTlsVersion": {
      "value": "1.2"
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
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        }
      ]
    },
    "roleAssignments": {
      "value": [
        {
          "name": "759769d2-fc52-4a92-a943-724e48927e0b",
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
    "skuName": {
      "value": "Balanced_B10"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "zones": {
      "value": [
        1,
        2,
        3
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
using 'br/public:avm/res/cache/redis-enterprise:<version>'

// Required parameters
param name = 'cremax001'
// Non-required parameters
param database = {
  clientProtocol: 'Plaintext'
  clusteringPolicy: 'EnterpriseCluster'
  deferUpgrade: 'Deferred'
  diagnosticSettings: [
    {
      eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
      eventHubName: '<eventHubName>'
      logCategoriesAndGroups: [
        {
          categoryGroup: 'allLogs'
        }
      ]
      name: 'customSettingDatabase'
      storageAccountResourceId: '<storageAccountResourceId>'
      workspaceResourceId: '<workspaceResourceId>'
    }
  ]
  evictionPolicy: 'NoEviction'
  modules: [
    {
      name: 'RedisBloom'
    }
    {
      name: 'RediSearch'
    }
  ]
  persistence: {
    frequency: '1s'
    type: 'aof'
  }
}
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    metricCategories: [
      {
        category: 'AllMetrics'
      }
    ]
    name: 'customSettingCluster'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param enableTelemetry = true
param highAvailability = 'Disabled'
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param minimumTlsVersion = '1.2'
param privateEndpoints = [
  {
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        {
          privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
        }
      ]
    }
    subnetResourceId: '<subnetResourceId>'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
  }
]
param roleAssignments = [
  {
    name: '759769d2-fc52-4a92-a943-724e48927e0b'
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
param skuName = 'Balanced_B10'
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
param zones = [
  1
  2
  3
]
```

</details>
<p>

### Example 7: _Using Customer-Managed-Keys with User-Assigned identity_

This instance deploys the module using Customer-Managed-Keys using a User-Assigned Identity to access the Customer-Managed-Key secret.


<details>

<summary>via Bicep module</summary>

```bicep
module redisEnterprise 'br/public:avm/res/cache/redis-enterprise:<version>' = {
  name: 'redisEnterpriseDeployment'
  params: {
    // Required parameters
    name: 'creuace001'
    // Non-required parameters
    customerManagedKey: {
      keyName: '<keyName>'
      keyVaultResourceId: '<keyVaultResourceId>'
      userAssignedIdentityResourceId: '<userAssignedIdentityResourceId>'
    }
    database: {
      persistence: {
        frequency: '6h'
        type: 'rdb'
      }
    }
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
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
      "value": "creuace001"
    },
    // Non-required parameters
    "customerManagedKey": {
      "value": {
        "keyName": "<keyName>",
        "keyVaultResourceId": "<keyVaultResourceId>",
        "userAssignedIdentityResourceId": "<userAssignedIdentityResourceId>"
      }
    },
    "database": {
      "value": {
        "persistence": {
          "frequency": "6h",
          "type": "rdb"
        }
      }
    },
    "managedIdentities": {
      "value": {
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
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
using 'br/public:avm/res/cache/redis-enterprise:<version>'

// Required parameters
param name = 'creuace001'
// Non-required parameters
param customerManagedKey = {
  keyName: '<keyName>'
  keyVaultResourceId: '<keyVaultResourceId>'
  userAssignedIdentityResourceId: '<userAssignedIdentityResourceId>'
}
param database = {
  persistence: {
    frequency: '6h'
    type: 'rdb'
  }
}
param managedIdentities = {
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
```

</details>
<p>

### Example 8: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module redisEnterprise 'br/public:avm/res/cache/redis-enterprise:<version>' = {
  name: 'redisEnterpriseDeployment'
  params: {
    // Required parameters
    name: 'crewaf001'
    // Non-required parameters
    database: {
      diagnosticSettings: [
        {
          eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
          eventHubName: '<eventHubName>'
          logCategoriesAndGroups: [
            {
              categoryGroup: 'allLogs'
            }
          ]
          name: 'customSettingDatabase'
          storageAccountResourceId: '<storageAccountResourceId>'
          workspaceResourceId: '<workspaceResourceId>'
        }
      ]
      persistence: {
        frequency: '1h'
        type: 'rdb'
      }
    }
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'customSettingCluster'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
    ]
    skuName: 'Balanced_B10'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    zones: [
      1
      2
      3
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
      "value": "crewaf001"
    },
    // Non-required parameters
    "database": {
      "value": {
        "diagnosticSettings": [
          {
            "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
            "eventHubName": "<eventHubName>",
            "logCategoriesAndGroups": [
              {
                "categoryGroup": "allLogs"
              }
            ],
            "name": "customSettingDatabase",
            "storageAccountResourceId": "<storageAccountResourceId>",
            "workspaceResourceId": "<workspaceResourceId>"
          }
        ],
        "persistence": {
          "frequency": "1h",
          "type": "rdb"
        }
      }
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "metricCategories": [
            {
              "category": "AllMetrics"
            }
          ],
          "name": "customSettingCluster",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
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
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        }
      ]
    },
    "skuName": {
      "value": "Balanced_B10"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "zones": {
      "value": [
        1,
        2,
        3
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
using 'br/public:avm/res/cache/redis-enterprise:<version>'

// Required parameters
param name = 'crewaf001'
// Non-required parameters
param database = {
  diagnosticSettings: [
    {
      eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
      eventHubName: '<eventHubName>'
      logCategoriesAndGroups: [
        {
          categoryGroup: 'allLogs'
        }
      ]
      name: 'customSettingDatabase'
      storageAccountResourceId: '<storageAccountResourceId>'
      workspaceResourceId: '<workspaceResourceId>'
    }
  ]
  persistence: {
    frequency: '1h'
    type: 'rdb'
  }
}
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    metricCategories: [
      {
        category: 'AllMetrics'
      }
    ]
    name: 'customSettingCluster'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param privateEndpoints = [
  {
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        {
          privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
        }
      ]
    }
    subnetResourceId: '<subnetResourceId>'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
  }
]
param skuName = 'Balanced_B10'
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
param zones = [
  1
  2
  3
]
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the cache resource. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. Required if 'customerManagedKey' is not empty. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`capacity`](#parameter-capacity) | int | The size of the cluster. Only supported on Redis Enterprise SKUs: Enterprise, EnterpriseFlash. Valid values are (2, 4, 6, 8, 10) for Enterprise SKUs and (3, 9) for EnterpriseFlash SKUs. [Learn more](https://learn.microsoft.com/azure/azure-cache-for-redis/cache-best-practices-enterprise-tiers#sharding-and-cpu-utilization). |
| [`customerManagedKey`](#parameter-customermanagedkey) | object | The customer managed key definition to use for the managed service. |
| [`database`](#parameter-database) | object | Database configuration. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The cluster-level diagnostic settings of the service. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`highAvailability`](#parameter-highavailability) | string | Specifies whether to enable data replication for high availability. Used only with Azure Managed Redis SKUs: Balanced, ComputeOptimized, FlashOptimized, and MemoryOptimized. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`minimumTlsVersion`](#parameter-minimumtlsversion) | string | The minimum TLS version for the Redis cluster to support. |
| [`privateEndpoints`](#parameter-privateendpoints) | array | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`skuName`](#parameter-skuname) | string | The type of cluster to deploy. Some Azure Managed Redis SKUs ARE IN PREVIEW, MICROSOFT MAY NOT PROVIDE SUPPORT FOR THIS, PLEASE CHECK THE [PRODUCT DOCS](https://learn.microsoft.com/azure/redis/overview#choosing-the-right-tier) FOR CLARIFICATION. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`zones`](#parameter-zones) | array | The Availability Zones to place the resources in. Currently only supported on Enterprise and EnterpriseFlash SKUs. |

### Parameter: `name`

The name of the cache resource.

- Required: Yes
- Type: string

### Parameter: `managedIdentities`

The managed identity definition for this resource. Required if 'customerManagedKey' is not empty.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`userAssignedResourceIds`](#parameter-managedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption. |

### Parameter: `managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption.

- Required: No
- Type: array

### Parameter: `capacity`

The size of the cluster. Only supported on Redis Enterprise SKUs: Enterprise, EnterpriseFlash. Valid values are (2, 4, 6, 8, 10) for Enterprise SKUs and (3, 9) for EnterpriseFlash SKUs. [Learn more](https://learn.microsoft.com/azure/azure-cache-for-redis/cache-best-practices-enterprise-tiers#sharding-and-cpu-utilization).

- Required: No
- Type: int
- Default: `2`
- Allowed:
  ```Bicep
  [
    2
    3
    4
    6
    8
    9
    10
  ]
  ```

### Parameter: `customerManagedKey`

The customer managed key definition to use for the managed service.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyName`](#parameter-customermanagedkeykeyname) | string | The name of the customer managed key to use for encryption. |
| [`keyVaultResourceId`](#parameter-customermanagedkeykeyvaultresourceid) | string | The resource ID of a key vault to reference a customer managed key for encryption from. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyVersion`](#parameter-customermanagedkeykeyversion) | string | The version of the customer managed key to reference for encryption. If not provided, the deployment will use the latest version available at deployment time. |
| [`userAssignedIdentityResourceId`](#parameter-customermanagedkeyuserassignedidentityresourceid) | string | User assigned identity to use when fetching the customer managed key. Required if no system assigned identity is available for use. |

### Parameter: `customerManagedKey.keyName`

The name of the customer managed key to use for encryption.

- Required: Yes
- Type: string

### Parameter: `customerManagedKey.keyVaultResourceId`

The resource ID of a key vault to reference a customer managed key for encryption from.

- Required: Yes
- Type: string

### Parameter: `customerManagedKey.keyVersion`

The version of the customer managed key to reference for encryption. If not provided, the deployment will use the latest version available at deployment time.

- Required: No
- Type: string

### Parameter: `customerManagedKey.userAssignedIdentityResourceId`

User assigned identity to use when fetching the customer managed key. Required if no system assigned identity is available for use.

- Required: No
- Type: string

### Parameter: `database`

Database configuration.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`accessKeysAuthentication`](#parameter-databaseaccesskeysauthentication) | string | Allow authentication via access keys. |
| [`accessPolicyAssignments`](#parameter-databaseaccesspolicyassignments) | array | Access policy assignments for Microsoft Entra authentication. Only supported on Azure Managed Redis SKUs: Balanced, ComputeOptimized, FlashOptimized, and MemoryOptimized. |
| [`clientProtocol`](#parameter-databaseclientprotocol) | string | Specifies whether Redis clients can connect using TLS-encrypted or plaintext Redis protocols. |
| [`clusteringPolicy`](#parameter-databaseclusteringpolicy) | string | Redis clustering policy. [Learn more](https://aka.ms/redis/enterprise/clustering). |
| [`deferUpgrade`](#parameter-databasedeferupgrade) | string | Specifies whether to defer future Redis major version upgrades by up to 90 days. [Learn more](https://aka.ms/redisversionupgrade#defer-upgrades). |
| [`diagnosticSettings`](#parameter-databasediagnosticsettings) | array | The database-level diagnostic settings of the service. |
| [`evictionPolicy`](#parameter-databaseevictionpolicy) | string | Specifies the eviction policy for the Redis resource. |
| [`geoReplication`](#parameter-databasegeoreplication) | object | The active geo-replication settings of the service. All caches within a geo-replication group must have the same configuration. |
| [`modules`](#parameter-databasemodules) | array | Redis modules to enable. Restrictions may apply based on SKU and configuration. [Learn more](https://aka.ms/redis/enterprise/modules). |
| [`name`](#parameter-databasename) | string | Name of the database. |
| [`persistence`](#parameter-databasepersistence) | object | The persistence settings of the service. |
| [`port`](#parameter-databaseport) | int | TCP port of the database endpoint. |
| [`secretsExportConfiguration`](#parameter-databasesecretsexportconfiguration) | object | Key vault reference and secret settings for the module's secrets export. |

### Parameter: `database.accessKeysAuthentication`

Allow authentication via access keys.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `database.accessPolicyAssignments`

Access policy assignments for Microsoft Entra authentication. Only supported on Azure Managed Redis SKUs: Balanced, ComputeOptimized, FlashOptimized, and MemoryOptimized.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`userObjectId`](#parameter-databaseaccesspolicyassignmentsuserobjectid) | string | Object ID to which the access policy will be assigned. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`accessPolicyName`](#parameter-databaseaccesspolicyassignmentsaccesspolicyname) | string | Name of the access policy to be assigned. The current only allowed name is 'default'. |
| [`name`](#parameter-databaseaccesspolicyassignmentsname) | string | Name of the access policy assignment. |

### Parameter: `database.accessPolicyAssignments.userObjectId`

Object ID to which the access policy will be assigned.

- Required: Yes
- Type: string

### Parameter: `database.accessPolicyAssignments.accessPolicyName`

Name of the access policy to be assigned. The current only allowed name is 'default'.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'default'
  ]
  ```

### Parameter: `database.accessPolicyAssignments.name`

Name of the access policy assignment.

- Required: No
- Type: string

### Parameter: `database.clientProtocol`

Specifies whether Redis clients can connect using TLS-encrypted or plaintext Redis protocols.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Encrypted'
    'Plaintext'
  ]
  ```

### Parameter: `database.clusteringPolicy`

Redis clustering policy. [Learn more](https://aka.ms/redis/enterprise/clustering).

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'EnterpriseCluster'
    'NoCluster'
    'OSSCluster'
  ]
  ```

### Parameter: `database.deferUpgrade`

Specifies whether to defer future Redis major version upgrades by up to 90 days. [Learn more](https://aka.ms/redisversionupgrade#defer-upgrades).

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Deferred'
    'NotDeferred'
  ]
  ```

### Parameter: `database.diagnosticSettings`

The database-level diagnostic settings of the service.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-databasediagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-databasediagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-databasediagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-databasediagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-databasediagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`name`](#parameter-databasediagnosticsettingsname) | string | The name of diagnostic setting. |
| [`storageAccountResourceId`](#parameter-databasediagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-databasediagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `database.diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `database.diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `database.diagnosticSettings.logAnalyticsDestinationType`

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

### Parameter: `database.diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-databasediagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-databasediagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-databasediagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `database.diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `database.diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `database.diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `database.diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `database.diagnosticSettings.name`

The name of diagnostic setting.

- Required: No
- Type: string

### Parameter: `database.diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `database.diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `database.evictionPolicy`

Specifies the eviction policy for the Redis resource.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AllKeysLFU'
    'AllKeysLRU'
    'AllKeysRandom'
    'NoEviction'
    'VolatileLFU'
    'VolatileLRU'
    'VolatileRandom'
    'VolatileTTL'
  ]
  ```

### Parameter: `database.geoReplication`

The active geo-replication settings of the service. All caches within a geo-replication group must have the same configuration.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`groupNickname`](#parameter-databasegeoreplicationgroupnickname) | string | The name of the geo-replication group. |
| [`linkedDatabases`](#parameter-databasegeoreplicationlinkeddatabases) | array | List of database resources to link with this database, including itself. |

### Parameter: `database.geoReplication.groupNickname`

The name of the geo-replication group.

- Required: Yes
- Type: string

### Parameter: `database.geoReplication.linkedDatabases`

List of database resources to link with this database, including itself.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-databasegeoreplicationlinkeddatabasesid) | string | Resource ID of linked database. Should be in the form: `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cache/redisEnterprise/{redisName}/databases/default`. |

### Parameter: `database.geoReplication.linkedDatabases.id`

Resource ID of linked database. Should be in the form: `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cache/redisEnterprise/{redisName}/databases/default`.

- Required: Yes
- Type: string

### Parameter: `database.modules`

Redis modules to enable. Restrictions may apply based on SKU and configuration. [Learn more](https://aka.ms/redis/enterprise/modules).

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-databasemodulesname) | string | The name of the module. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`args`](#parameter-databasemodulesargs) | string | Additional module arguments. |

### Parameter: `database.modules.name`

The name of the module.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'RedisBloom'
    'RediSearch'
    'RedisJSON'
    'RedisTimeSeries'
  ]
  ```

### Parameter: `database.modules.args`

Additional module arguments.

- Required: No
- Type: string

### Parameter: `database.name`

Name of the database.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'default'
  ]
  ```

### Parameter: `database.persistence`

The persistence settings of the service.

- Required: No
- Type: object
- Discriminator: `type`

<h4>The available variants are:</h4>

| Variant | Description |
| :-- | :-- |
| [`disabled`](#variant-databasepersistencetype-disabled) |  |
| [`aof`](#variant-databasepersistencetype-aof) |  |
| [`rdb`](#variant-databasepersistencetype-rdb) |  |

### Variant: `database.persistence.type-disabled`


To use this variant, set the property `type` to `disabled`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`type`](#parameter-databasepersistencetype-disabledtype) | string | Disabled persistence type. |

### Parameter: `database.persistence.type-disabled.type`

Disabled persistence type.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'disabled'
  ]
  ```

### Variant: `database.persistence.type-aof`


To use this variant, set the property `type` to `aof`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`frequency`](#parameter-databasepersistencetype-aoffrequency) | string | The frequency at which data is written to disk. |
| [`type`](#parameter-databasepersistencetype-aoftype) | string | AOF persistence type. |

### Parameter: `database.persistence.type-aof.frequency`

The frequency at which data is written to disk.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    '1s'
  ]
  ```

### Parameter: `database.persistence.type-aof.type`

AOF persistence type.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'aof'
  ]
  ```

### Variant: `database.persistence.type-rdb`


To use this variant, set the property `type` to `rdb`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`frequency`](#parameter-databasepersistencetype-rdbfrequency) | string | The frequency at which an RDB snapshot of the database is created. |
| [`type`](#parameter-databasepersistencetype-rdbtype) | string | RDB persistence type. |

### Parameter: `database.persistence.type-rdb.frequency`

The frequency at which an RDB snapshot of the database is created.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    '12h'
    '1h'
    '6h'
  ]
  ```

### Parameter: `database.persistence.type-rdb.type`

RDB persistence type.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'rdb'
  ]
  ```

### Parameter: `database.port`

TCP port of the database endpoint.

- Required: No
- Type: int
- MinValue: 10000
- MaxValue: 10000

### Parameter: `database.secretsExportConfiguration`

Key vault reference and secret settings for the module's secrets export.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyVaultResourceId`](#parameter-databasesecretsexportconfigurationkeyvaultresourceid) | string | The resource ID of the key vault where to store the secrets of this module. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`primaryAccessKeyName`](#parameter-databasesecretsexportconfigurationprimaryaccesskeyname) | string | The primaryAccessKey secret name to create. |
| [`primaryConnectionStringName`](#parameter-databasesecretsexportconfigurationprimaryconnectionstringname) | string | The primaryConnectionString secret name to create. |
| [`primaryStackExchangeRedisConnectionStringName`](#parameter-databasesecretsexportconfigurationprimarystackexchangeredisconnectionstringname) | string | The primaryStackExchangeRedisConnectionString secret name to create. |
| [`secondaryAccessKeyName`](#parameter-databasesecretsexportconfigurationsecondaryaccesskeyname) | string | The secondaryAccessKey secret name to create. |
| [`secondaryConnectionStringName`](#parameter-databasesecretsexportconfigurationsecondaryconnectionstringname) | string | The secondaryConnectionString secret name to create. |
| [`secondaryStackExchangeRedisConnectionStringName`](#parameter-databasesecretsexportconfigurationsecondarystackexchangeredisconnectionstringname) | string | The secondaryStackExchangeRedisConnectionString secret name to create. |

### Parameter: `database.secretsExportConfiguration.keyVaultResourceId`

The resource ID of the key vault where to store the secrets of this module.

- Required: Yes
- Type: string

### Parameter: `database.secretsExportConfiguration.primaryAccessKeyName`

The primaryAccessKey secret name to create.

- Required: No
- Type: string

### Parameter: `database.secretsExportConfiguration.primaryConnectionStringName`

The primaryConnectionString secret name to create.

- Required: No
- Type: string

### Parameter: `database.secretsExportConfiguration.primaryStackExchangeRedisConnectionStringName`

The primaryStackExchangeRedisConnectionString secret name to create.

- Required: No
- Type: string

### Parameter: `database.secretsExportConfiguration.secondaryAccessKeyName`

The secondaryAccessKey secret name to create.

- Required: No
- Type: string

### Parameter: `database.secretsExportConfiguration.secondaryConnectionStringName`

The secondaryConnectionString secret name to create.

- Required: No
- Type: string

### Parameter: `database.secretsExportConfiguration.secondaryStackExchangeRedisConnectionStringName`

The secondaryStackExchangeRedisConnectionString secret name to create.

- Required: No
- Type: string

### Parameter: `diagnosticSettings`

The cluster-level diagnostic settings of the service.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-diagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-diagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-diagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`marketplacePartnerResourceId`](#parameter-diagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-diagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-diagnosticsettingsname) | string | The name of diagnostic setting. |
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

The name of diagnostic setting.

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

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `highAvailability`

Specifies whether to enable data replication for high availability. Used only with Azure Managed Redis SKUs: Balanced, ComputeOptimized, FlashOptimized, and MemoryOptimized.

- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `location`

Location for all resources.

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

### Parameter: `minimumTlsVersion`

The minimum TLS version for the Redis cluster to support.

- Required: No
- Type: string
- Default: `'1.2'`
- Allowed:
  ```Bicep
  [
    '1.2'
  ]
  ```

### Parameter: `privateEndpoints`

Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`subnetResourceId`](#parameter-privateendpointssubnetresourceid) | string | Resource ID of the subnet where the endpoint needs to be created. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`applicationSecurityGroupResourceIds`](#parameter-privateendpointsapplicationsecuritygroupresourceids) | array | Application security groups in which the Private Endpoint IP configuration is included. |
| [`customDnsConfigs`](#parameter-privateendpointscustomdnsconfigs) | array | Custom DNS configurations. |
| [`customNetworkInterfaceName`](#parameter-privateendpointscustomnetworkinterfacename) | string | The custom name of the network interface attached to the Private Endpoint. |
| [`enableTelemetry`](#parameter-privateendpointsenabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`ipConfigurations`](#parameter-privateendpointsipconfigurations) | array | A list of IP configurations of the Private Endpoint. This will be used to map to the first-party Service endpoints. |
| [`isManualConnection`](#parameter-privateendpointsismanualconnection) | bool | If Manual Private Link Connection is required. |
| [`location`](#parameter-privateendpointslocation) | string | The location to deploy the Private Endpoint to. |
| [`lock`](#parameter-privateendpointslock) | object | Specify the type of lock. |
| [`manualConnectionRequestMessage`](#parameter-privateendpointsmanualconnectionrequestmessage) | string | A message passed to the owner of the remote resource with the manual connection request. |
| [`name`](#parameter-privateendpointsname) | string | The name of the Private Endpoint. |
| [`privateDnsZoneGroup`](#parameter-privateendpointsprivatednszonegroup) | object | The private DNS Zone Group to configure for the Private Endpoint. |
| [`privateLinkServiceConnectionName`](#parameter-privateendpointsprivatelinkserviceconnectionname) | string | The name of the private link connection to create. |
| [`resourceGroupResourceId`](#parameter-privateendpointsresourcegroupresourceid) | string | The resource ID of the Resource Group the Private Endpoint will be created in. If not specified, the Resource Group of the provided Virtual Network Subnet is used. |
| [`roleAssignments`](#parameter-privateendpointsroleassignments) | array | Array of role assignments to create. |
| [`service`](#parameter-privateendpointsservice) | string | The subresource to deploy the Private Endpoint for. For example "vault" for a Key Vault Private Endpoint. |
| [`tags`](#parameter-privateendpointstags) | object | Tags to be applied on all resources/Resource Groups in this deployment. |

### Parameter: `privateEndpoints.subnetResourceId`

Resource ID of the subnet where the endpoint needs to be created.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.applicationSecurityGroupResourceIds`

Application security groups in which the Private Endpoint IP configuration is included.

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

The custom name of the network interface attached to the Private Endpoint.

- Required: No
- Type: string

### Parameter: `privateEndpoints.enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool

### Parameter: `privateEndpoints.ipConfigurations`

A list of IP configurations of the Private Endpoint. This will be used to map to the first-party Service endpoints.

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

The location to deploy the Private Endpoint to.

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

### Parameter: `privateEndpoints.manualConnectionRequestMessage`

A message passed to the owner of the remote resource with the manual connection request.

- Required: No
- Type: string

### Parameter: `privateEndpoints.name`

The name of the Private Endpoint.

- Required: No
- Type: string

### Parameter: `privateEndpoints.privateDnsZoneGroup`

The private DNS Zone Group to configure for the Private Endpoint.

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
- Roles configurable by name:
  - `'Contributor'`
  - `'DNS Resolver Contributor'`
  - `'DNS Zone Contributor'`
  - `'Domain Services Contributor'`
  - `'Domain Services Reader'`
  - `'Network Contributor'`
  - `'Owner'`
  - `'Private DNS Zone Contributor'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`

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

### Parameter: `privateEndpoints.service`

The subresource to deploy the Private Endpoint for. For example "vault" for a Key Vault Private Endpoint.

- Required: No
- Type: string

### Parameter: `privateEndpoints.tags`

Tags to be applied on all resources/Resource Groups in this deployment.

- Required: No
- Type: object

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Redis Cache Contributor'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`

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

### Parameter: `skuName`

The type of cluster to deploy. Some Azure Managed Redis SKUs ARE IN PREVIEW, MICROSOFT MAY NOT PROVIDE SUPPORT FOR THIS, PLEASE CHECK THE [PRODUCT DOCS](https://learn.microsoft.com/azure/redis/overview#choosing-the-right-tier) FOR CLARIFICATION.

- Required: No
- Type: string
- Default: `'Balanced_B5'`
- Allowed:
  ```Bicep
  [
    'Balanced_B0'
    'Balanced_B1'
    'Balanced_B10'
    'Balanced_B100'
    'Balanced_B1000'
    'Balanced_B150'
    'Balanced_B20'
    'Balanced_B250'
    'Balanced_B3'
    'Balanced_B350'
    'Balanced_B5'
    'Balanced_B50'
    'Balanced_B500'
    'Balanced_B700'
    'ComputeOptimized_X10'
    'ComputeOptimized_X100'
    'ComputeOptimized_X150'
    'ComputeOptimized_X20'
    'ComputeOptimized_X250'
    'ComputeOptimized_X3'
    'ComputeOptimized_X350'
    'ComputeOptimized_X5'
    'ComputeOptimized_X50'
    'ComputeOptimized_X500'
    'ComputeOptimized_X700'
    'Enterprise_E1'
    'Enterprise_E10'
    'Enterprise_E100'
    'Enterprise_E20'
    'Enterprise_E200'
    'Enterprise_E400'
    'Enterprise_E5'
    'Enterprise_E50'
    'EnterpriseFlash_F1500'
    'EnterpriseFlash_F300'
    'EnterpriseFlash_F700'
    'FlashOptimized_A1000'
    'FlashOptimized_A1500'
    'FlashOptimized_A2000'
    'FlashOptimized_A250'
    'FlashOptimized_A4500'
    'FlashOptimized_A500'
    'FlashOptimized_A700'
    'MemoryOptimized_M10'
    'MemoryOptimized_M100'
    'MemoryOptimized_M1000'
    'MemoryOptimized_M150'
    'MemoryOptimized_M1500'
    'MemoryOptimized_M20'
    'MemoryOptimized_M2000'
    'MemoryOptimized_M250'
    'MemoryOptimized_M350'
    'MemoryOptimized_M50'
    'MemoryOptimized_M500'
    'MemoryOptimized_M700'
  ]
  ```

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `zones`

The Availability Zones to place the resources in. Currently only supported on Enterprise and EnterpriseFlash SKUs.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    1
    2
    3
  ]
  ```
- Allowed:
  ```Bicep
  [
    1
    2
    3
  ]
  ```

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `databaseName` | string | The name of the Redis database. |
| `databaseResourceId` | string | The resource ID of the database. |
| `endpoint` | string | The Redis endpoint. |
| `exportedSecrets` |  | A hashtable of references to the secrets exported to the provided Key Vault. The key of each reference is each secret's name. |
| `hostName` | string | The Redis host name. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the Redis cluster. |
| `port` | int | The Redis port. |
| `privateEndpoints` | array | The private endpoints of the Redis resource. |
| `resourceGroupName` | string | The name of the resource group the Redis resource was created in. |
| `resourceId` | string | The resource ID of the Redis cluster. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/network/private-endpoint:0.11.0` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
