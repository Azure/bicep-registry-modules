# Elastic SANs `[Microsoft.ElasticSan/elasticSans]`

This module deploys an Elastic SAN.

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
| `Microsoft.ElasticSan/elasticSans` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ElasticSan/2023-01-01/elasticSans) |
| `Microsoft.ElasticSan/elasticSans/volumegroups` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ElasticSan/2023-01-01/elasticSans/volumegroups) |
| `Microsoft.ElasticSan/elasticSans/volumegroups/snapshots` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ElasticSan/2023-01-01/elasticSans/volumegroups/snapshots) |
| `Microsoft.ElasticSan/elasticSans/volumegroups/volumes` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ElasticSan/2023-01-01/elasticSans/volumegroups/volumes) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/privateEndpoints` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints/privateDnsZoneGroups) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/elastic-san/elastic-san:<version>`.

- [Using encryption with Customer-Managed-Key](#example-1-using-encryption-with-customer-managed-key)
- [Using only defaults](#example-2-using-only-defaults)
- [Using large parameter set](#example-3-using-large-parameter-set)
- [Private endpoint-enabled deployment](#example-4-private-endpoint-enabled-deployment)
- [WAF-aligned](#example-5-waf-aligned)

### Example 1: _Using encryption with Customer-Managed-Key_

This instance deploys the module using Customer-Managed-Keys using a User-Assigned Identity to access the Customer-Managed-Key secret.


<details>

<summary>via Bicep module</summary>

```bicep
module elasticSan 'br/public:avm/res/elastic-san/elastic-san:<version>' = {
  name: 'elasticSanDeployment'
  params: {
    // Required parameters
    name: 'esancmk001'
    // Non-required parameters
    availabilityZone: 2
    sku: 'Premium_LRS'
    volumeGroups: [
      {
        customerManagedKey: {
          keyName: '<keyName>'
          keyVaultResourceId: '<keyVaultResourceId>'
          userAssignedIdentityResourceId: '<userAssignedIdentityResourceId>'
        }
        managedIdentities: {
          userAssignedResourceIds: [
            '<managedIdentityResourceId>'
          ]
        }
        name: 'vol-grp-01'
      }
      {
        customerManagedKey: {
          keyName: '<keyName>'
          keyVaultResourceId: '<keyVaultResourceId>'
          keyVersion: '<keyVersion>'
          userAssignedIdentityResourceId: '<userAssignedIdentityResourceId>'
        }
        managedIdentities: {
          userAssignedResourceIds: [
            '<managedIdentityResourceId>'
          ]
        }
        name: 'vol-grp-02'
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
      "value": "esancmk001"
    },
    // Non-required parameters
    "availabilityZone": {
      "value": 2
    },
    "sku": {
      "value": "Premium_LRS"
    },
    "volumeGroups": {
      "value": [
        {
          "customerManagedKey": {
            "keyName": "<keyName>",
            "keyVaultResourceId": "<keyVaultResourceId>",
            "userAssignedIdentityResourceId": "<userAssignedIdentityResourceId>"
          },
          "managedIdentities": {
            "userAssignedResourceIds": [
              "<managedIdentityResourceId>"
            ]
          },
          "name": "vol-grp-01"
        },
        {
          "customerManagedKey": {
            "keyName": "<keyName>",
            "keyVaultResourceId": "<keyVaultResourceId>",
            "keyVersion": "<keyVersion>",
            "userAssignedIdentityResourceId": "<userAssignedIdentityResourceId>"
          },
          "managedIdentities": {
            "userAssignedResourceIds": [
              "<managedIdentityResourceId>"
            ]
          },
          "name": "vol-grp-02"
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
using 'br/public:avm/res/elastic-san/elastic-san:<version>'

// Required parameters
param name = 'esancmk001'
// Non-required parameters
param availabilityZone = 2
param sku = 'Premium_LRS'
param volumeGroups = [
  {
    customerManagedKey: {
      keyName: '<keyName>'
      keyVaultResourceId: '<keyVaultResourceId>'
      userAssignedIdentityResourceId: '<userAssignedIdentityResourceId>'
    }
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    name: 'vol-grp-01'
  }
  {
    customerManagedKey: {
      keyName: '<keyName>'
      keyVaultResourceId: '<keyVaultResourceId>'
      keyVersion: '<keyVersion>'
      userAssignedIdentityResourceId: '<userAssignedIdentityResourceId>'
    }
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    name: 'vol-grp-02'
  }
]
```

</details>
<p>

### Example 2: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module elasticSan 'br/public:avm/res/elastic-san/elastic-san:<version>' = {
  name: 'elasticSanDeployment'
  params: {
    name: 'esanmin001'
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
      "value": "esanmin001"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/elastic-san/elastic-san:<version>'

param name = 'esanmin001'
```

</details>
<p>

### Example 3: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module elasticSan 'br/public:avm/res/elastic-san/elastic-san:<version>' = {
  name: 'elasticSanDeployment'
  params: {
    // Required parameters
    name: 'esanmax001'
    // Non-required parameters
    availabilityZone: 3
    baseSizeTiB: 2
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    extendedCapacitySizeTiB: 1
    location: '<location>'
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Owner'
      }
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
      }
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
      }
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Role Based Access Control Administrator'
      }
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'User Access Administrator'
      }
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Elastic SAN Network Admin'
      }
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Elastic SAN Owner'
      }
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Elastic SAN Reader'
      }
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Elastic SAN Volume Group Owner'
      }
    ]
    sku: 'Premium_LRS'
    tags: {
      CostCenter: '123-456-789'
      Owner: 'Contoso'
    }
    volumeGroups: [
      {
        name: 'vol-grp-01'
      }
      {
        name: 'vol-grp-02'
        volumes: [
          {
            name: 'vol-grp-02-vol-01'
            sizeGiB: 1
          }
          {
            name: 'vol-grp-02-vol-02'
            sizeGiB: 2
            snapshots: [
              {
                name: '<name>'
              }
              {
                name: '<name>'
              }
            ]
          }
        ]
      }
      {
        name: 'vol-grp-03'
        virtualNetworkRules: [
          {
            virtualNetworkSubnetResourceId: '<virtualNetworkSubnetResourceId>'
          }
        ]
      }
      {
        managedIdentities: {
          systemAssigned: true
        }
        name: 'vol-grp-04'
      }
      {
        managedIdentities: {
          userAssignedResourceIds: [
            '<managedIdentityResourceId>'
          ]
        }
        name: 'vol-grp-05'
      }
      {
        managedIdentities: {
          systemAssigned: true
          userAssignedResourceIds: [
            '<managedIdentityResourceId>'
          ]
        }
        name: 'vol-grp-06'
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
      "value": "esanmax001"
    },
    // Non-required parameters
    "availabilityZone": {
      "value": 3
    },
    "baseSizeTiB": {
      "value": 2
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
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "extendedCapacitySizeTiB": {
      "value": 1
    },
    "location": {
      "value": "<location>"
    },
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Owner"
        },
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "b24988ac-6180-42a0-ab88-20f7382dd24c"
        },
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "<roleDefinitionIdOrName>"
        },
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Role Based Access Control Administrator"
        },
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "User Access Administrator"
        },
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Elastic SAN Network Admin"
        },
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Elastic SAN Owner"
        },
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Elastic SAN Reader"
        },
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Elastic SAN Volume Group Owner"
        }
      ]
    },
    "sku": {
      "value": "Premium_LRS"
    },
    "tags": {
      "value": {
        "CostCenter": "123-456-789",
        "Owner": "Contoso"
      }
    },
    "volumeGroups": {
      "value": [
        {
          "name": "vol-grp-01"
        },
        {
          "name": "vol-grp-02",
          "volumes": [
            {
              "name": "vol-grp-02-vol-01",
              "sizeGiB": 1
            },
            {
              "name": "vol-grp-02-vol-02",
              "sizeGiB": 2,
              "snapshots": [
                {
                  "name": "<name>"
                },
                {
                  "name": "<name>"
                }
              ]
            }
          ]
        },
        {
          "name": "vol-grp-03",
          "virtualNetworkRules": [
            {
              "virtualNetworkSubnetResourceId": "<virtualNetworkSubnetResourceId>"
            }
          ]
        },
        {
          "managedIdentities": {
            "systemAssigned": true
          },
          "name": "vol-grp-04"
        },
        {
          "managedIdentities": {
            "userAssignedResourceIds": [
              "<managedIdentityResourceId>"
            ]
          },
          "name": "vol-grp-05"
        },
        {
          "managedIdentities": {
            "systemAssigned": true,
            "userAssignedResourceIds": [
              "<managedIdentityResourceId>"
            ]
          },
          "name": "vol-grp-06"
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
using 'br/public:avm/res/elastic-san/elastic-san:<version>'

// Required parameters
param name = 'esanmax001'
// Non-required parameters
param availabilityZone = 3
param baseSizeTiB = 2
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    metricCategories: [
      {
        category: 'AllMetrics'
      }
    ]
    name: 'customSetting'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param extendedCapacitySizeTiB = 1
param location = '<location>'
param roleAssignments = [
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'Owner'
  }
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  }
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
  }
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'Role Based Access Control Administrator'
  }
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'User Access Administrator'
  }
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'Elastic SAN Network Admin'
  }
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'Elastic SAN Owner'
  }
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'Elastic SAN Reader'
  }
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'Elastic SAN Volume Group Owner'
  }
]
param sku = 'Premium_LRS'
param tags = {
  CostCenter: '123-456-789'
  Owner: 'Contoso'
}
param volumeGroups = [
  {
    name: 'vol-grp-01'
  }
  {
    name: 'vol-grp-02'
    volumes: [
      {
        name: 'vol-grp-02-vol-01'
        sizeGiB: 1
      }
      {
        name: 'vol-grp-02-vol-02'
        sizeGiB: 2
        snapshots: [
          {
            name: '<name>'
          }
          {
            name: '<name>'
          }
        ]
      }
    ]
  }
  {
    name: 'vol-grp-03'
    virtualNetworkRules: [
      {
        virtualNetworkSubnetResourceId: '<virtualNetworkSubnetResourceId>'
      }
    ]
  }
  {
    managedIdentities: {
      systemAssigned: true
    }
    name: 'vol-grp-04'
  }
  {
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    name: 'vol-grp-05'
  }
  {
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    name: 'vol-grp-06'
  }
]
```

</details>
<p>

### Example 4: _Private endpoint-enabled deployment_

This instance deploys the module with private endpoints.


<details>

<summary>via Bicep module</summary>

```bicep
module elasticSan 'br/public:avm/res/elastic-san/elastic-san:<version>' = {
  name: 'elasticSanDeployment'
  params: {
    // Required parameters
    name: 'esanpe001'
    // Non-required parameters
    availabilityZone: 1
    sku: 'Premium_LRS'
    tags: {
      CostCenter: '123-456-789'
      Owner: 'Contoso'
    }
    volumeGroups: [
      {
        name: 'vol-grp-01'
        privateEndpoints: [
          {
            lock: {
              kind: 'CanNotDelete'
              name: 'myCustomLockName'
            }
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
                }
              ]
            }
            subnetResourceId: '<subnetResourceId>'
            tags: {
              CostCenter: '123-456-789'
              Owner: 'Contoso'
            }
          }
        ]
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
      "value": "esanpe001"
    },
    // Non-required parameters
    "availabilityZone": {
      "value": 1
    },
    "sku": {
      "value": "Premium_LRS"
    },
    "tags": {
      "value": {
        "CostCenter": "123-456-789",
        "Owner": "Contoso"
      }
    },
    "volumeGroups": {
      "value": [
        {
          "name": "vol-grp-01",
          "privateEndpoints": [
            {
              "lock": {
                "kind": "CanNotDelete",
                "name": "myCustomLockName"
              },
              "privateDnsZoneGroup": {
                "privateDnsZoneGroupConfigs": [
                  {
                    "privateDnsZoneResourceId": "<privateDnsZoneResourceId>"
                  }
                ]
              },
              "subnetResourceId": "<subnetResourceId>",
              "tags": {
                "CostCenter": "123-456-789",
                "Owner": "Contoso"
              }
            }
          ]
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
using 'br/public:avm/res/elastic-san/elastic-san:<version>'

// Required parameters
param name = 'esanpe001'
// Non-required parameters
param availabilityZone = 1
param sku = 'Premium_LRS'
param tags = {
  CostCenter: '123-456-789'
  Owner: 'Contoso'
}
param volumeGroups = [
  {
    name: 'vol-grp-01'
    privateEndpoints: [
      {
        lock: {
          kind: 'CanNotDelete'
          name: 'myCustomLockName'
        }
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        subnetResourceId: '<subnetResourceId>'
        tags: {
          CostCenter: '123-456-789'
          Owner: 'Contoso'
        }
      }
    ]
  }
]
```

</details>
<p>

### Example 5: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module elasticSan 'br/public:avm/res/elastic-san/elastic-san:<version>' = {
  name: 'elasticSanDeployment'
  params: {
    // Required parameters
    name: 'esanwaf001'
    // Non-required parameters
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    publicNetworkAccess: 'Disabled'
    sku: 'Premium_ZRS'
    tags: {
      CostCenter: '123-456-789'
      Owner: 'Contoso'
    }
    volumeGroups: [
      {
        customerManagedKey: {
          keyName: '<keyName>'
          keyVaultResourceId: '<keyVaultResourceId>'
          userAssignedIdentityResourceId: '<userAssignedIdentityResourceId>'
        }
        managedIdentities: {
          userAssignedResourceIds: [
            '<managedIdentityResourceId>'
          ]
        }
        name: 'vol-grp-01'
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
              CostCenter: '123-456-789'
              Owner: 'Contoso'
            }
          }
        ]
        volumes: [
          {
            name: 'vol-grp-01-vol-01'
            sizeGiB: 1
          }
        ]
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
      "value": "esanwaf001"
    },
    // Non-required parameters
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
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "publicNetworkAccess": {
      "value": "Disabled"
    },
    "sku": {
      "value": "Premium_ZRS"
    },
    "tags": {
      "value": {
        "CostCenter": "123-456-789",
        "Owner": "Contoso"
      }
    },
    "volumeGroups": {
      "value": [
        {
          "customerManagedKey": {
            "keyName": "<keyName>",
            "keyVaultResourceId": "<keyVaultResourceId>",
            "userAssignedIdentityResourceId": "<userAssignedIdentityResourceId>"
          },
          "managedIdentities": {
            "userAssignedResourceIds": [
              "<managedIdentityResourceId>"
            ]
          },
          "name": "vol-grp-01",
          "privateEndpoints": [
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
                "CostCenter": "123-456-789",
                "Owner": "Contoso"
              }
            }
          ],
          "volumes": [
            {
              "name": "vol-grp-01-vol-01",
              "sizeGiB": 1
            }
          ]
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
using 'br/public:avm/res/elastic-san/elastic-san:<version>'

// Required parameters
param name = 'esanwaf001'
// Non-required parameters
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    metricCategories: [
      {
        category: 'AllMetrics'
      }
    ]
    name: 'customSetting'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param publicNetworkAccess = 'Disabled'
param sku = 'Premium_ZRS'
param tags = {
  CostCenter: '123-456-789'
  Owner: 'Contoso'
}
param volumeGroups = [
  {
    customerManagedKey: {
      keyName: '<keyName>'
      keyVaultResourceId: '<keyVaultResourceId>'
      userAssignedIdentityResourceId: '<userAssignedIdentityResourceId>'
    }
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    name: 'vol-grp-01'
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
          CostCenter: '123-456-789'
          Owner: 'Contoso'
        }
      }
    ]
    volumes: [
      {
        name: 'vol-grp-01-vol-01'
        sizeGiB: 1
      }
    ]
  }
]
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Elastic SAN. The name can only contain lowercase letters, numbers, hyphens and underscores, and must begin and end with a letter or a number. Each hyphen and underscore must be preceded and followed by an alphanumeric character. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`availabilityZone`](#parameter-availabilityzone) | int | Configuration of the availability zone for the Elastic SAN. Required if `Sku` is `Premium_LRS`. If this parameter is not provided, the `Sku` parameter will default to Premium_ZRS. Note that the availability zone number here are the logical availability zone in your Azure subscription. Different subscriptions might have a different mapping of the physical zone and logical zone. To understand more, please refer to [Physical and logical availability zones](https://learn.microsoft.com/en-us/azure/reliability/availability-zones-overview?tabs=azure-cli#physical-and-logical-availability-zones). |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`baseSizeTiB`](#parameter-basesizetib) | int | Size of the Elastic SAN base capacity in Tebibytes (TiB). The supported capacity ranges from 1 Tebibyte (TiB) to 400 Tebibytes (TiB). |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`extendedCapacitySizeTiB`](#parameter-extendedcapacitysizetib) | int | Size of the Elastic SAN additional capacity in Tebibytes (TiB). The supported capacity ranges from 0 Tebibyte (TiB) to 600 Tebibytes (TiB). |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Whether or not public network access is allowed for this resource. For security reasons it should be `Disabled`, which necessitates the use of private endpoints. If not specified, public access will be `Disabled` by default when private endpoints are used without Virtual Network Rules. Setting public network access to `Disabled` while using Virtual Network Rules will result in an error. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`sku`](#parameter-sku) | string | Specifies the SKU for the Elastic SAN. |
| [`tags`](#parameter-tags) | object | Tags of the Elastic SAN resource. |
| [`volumeGroups`](#parameter-volumegroups) | array | List of Elastic SAN Volume Groups to be created in the Elastic SAN. An Elastic SAN can have a maximum of 200 volume groups. |

### Parameter: `name`

Name of the Elastic SAN. The name can only contain lowercase letters, numbers, hyphens and underscores, and must begin and end with a letter or a number. Each hyphen and underscore must be preceded and followed by an alphanumeric character.

- Required: Yes
- Type: string

### Parameter: `availabilityZone`

Configuration of the availability zone for the Elastic SAN. Required if `Sku` is `Premium_LRS`. If this parameter is not provided, the `Sku` parameter will default to Premium_ZRS. Note that the availability zone number here are the logical availability zone in your Azure subscription. Different subscriptions might have a different mapping of the physical zone and logical zone. To understand more, please refer to [Physical and logical availability zones](https://learn.microsoft.com/en-us/azure/reliability/availability-zones-overview?tabs=azure-cli#physical-and-logical-availability-zones).

- Required: No
- Type: int
- Allowed:
  ```Bicep
  [
    1
    2
    3
  ]
  ```

### Parameter: `baseSizeTiB`

Size of the Elastic SAN base capacity in Tebibytes (TiB). The supported capacity ranges from 1 Tebibyte (TiB) to 400 Tebibytes (TiB).

- Required: No
- Type: int
- Default: `1`
- MinValue: 1
- MaxValue: 400

### Parameter: `diagnosticSettings`

The diagnostic settings of the service.

- Required: No
- Type: array
- MinValue: 1
- MaxValue: 400

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
- MinValue: 1
- MaxValue: 400

### Parameter: `diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string
- MinValue: 1
- MaxValue: 400

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
- MinValue: 1
- MaxValue: 400

### Parameter: `diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string
- MinValue: 1
- MaxValue: 400

### Parameter: `diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array
- MinValue: 1
- MaxValue: 400

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
- MinValue: 1
- MaxValue: 400

### Parameter: `diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool
- MinValue: 1
- MaxValue: 400

### Parameter: `diagnosticSettings.name`

The name of diagnostic setting.

- Required: No
- Type: string
- MinValue: 1
- MaxValue: 400

### Parameter: `diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string
- MinValue: 1
- MaxValue: 400

### Parameter: `diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string
- MinValue: 1
- MaxValue: 400

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`
- MinValue: 1
- MaxValue: 400

### Parameter: `extendedCapacitySizeTiB`

Size of the Elastic SAN additional capacity in Tebibytes (TiB). The supported capacity ranges from 0 Tebibyte (TiB) to 600 Tebibytes (TiB).

- Required: No
- Type: int
- Default: `0`
- MinValue: 0
- MaxValue: 600

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`
- MinValue: 0
- MaxValue: 600

### Parameter: `lock`

The lock settings of the service.

- Required: No
- Type: object
- MinValue: 0
- MaxValue: 600

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
- MinValue: 0
- MaxValue: 600

### Parameter: `lock.name`

Specify the name of lock.

- Required: No
- Type: string
- MinValue: 0
- MaxValue: 600

### Parameter: `publicNetworkAccess`

Whether or not public network access is allowed for this resource. For security reasons it should be `Disabled`, which necessitates the use of private endpoints. If not specified, public access will be `Disabled` by default when private endpoints are used without Virtual Network Rules. Setting public network access to `Disabled` while using Virtual Network Rules will result in an error.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```
- MinValue: 0
- MaxValue: 600

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- MinValue: 0
- MaxValue: 600
- Roles configurable by name:
  - `'Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`
  - `'Elastic SAN Network Admin'`
  - `'Elastic SAN Owner'`
  - `'Elastic SAN Reader'`
  - `'Elastic SAN Volume Group Owner'`

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
- MinValue: 0
- MaxValue: 600

### Parameter: `roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string
- MinValue: 0
- MaxValue: 600

### Parameter: `roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string
- MinValue: 0
- MaxValue: 600

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
- MinValue: 0
- MaxValue: 600

### Parameter: `roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string
- MinValue: 0
- MaxValue: 600

### Parameter: `roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string
- MinValue: 0
- MaxValue: 600

### Parameter: `roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string
- MinValue: 0
- MaxValue: 600

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
- MinValue: 0
- MaxValue: 600

### Parameter: `sku`

Specifies the SKU for the Elastic SAN.

- Required: No
- Type: string
- Default: `'Premium_ZRS'`
- Allowed:
  ```Bicep
  [
    'Premium_LRS'
    'Premium_ZRS'
  ]
  ```
- MinValue: 0
- MaxValue: 600

### Parameter: `tags`

Tags of the Elastic SAN resource.

- Required: No
- Type: object
- MinValue: 0
- MaxValue: 600

### Parameter: `volumeGroups`

List of Elastic SAN Volume Groups to be created in the Elastic SAN. An Elastic SAN can have a maximum of 200 volume groups.

- Required: No
- Type: array
- MinValue: 0
- MaxValue: 600

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-volumegroupsname) | string | The name of the Elastic SAN Volume Group. The name can only contain lowercase letters, numbers and hyphens, and must begin and end with a letter or a number. Each hyphen must be preceded and followed by an alphanumeric character. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`customerManagedKey`](#parameter-volumegroupscustomermanagedkey) | object | The customer managed key definition. This parameter enables the encryption of Elastic SAN Volume Group using a customer-managed key. Currently, the only supported configuration is to use the same user-assigned identity for both 'managedIdentities.userAssignedResourceIds' and 'customerManagedKey.userAssignedIdentityResourceId'. Other configurations such as system-assigned identity are not supported. Ensure that the specified user-assigned identity has the 'Key Vault Crypto Service Encryption User' role access to both the key vault and the key itself. The key vault must also have purge protection enabled. |
| [`managedIdentities`](#parameter-volumegroupsmanagedidentities) | object | The managed identity definition for this resource. The Elastic SAN Volume Group supports the following identity combinations: no identity is specified, only system-assigned identity is specified, only user-assigned identity is specified, and both system-assigned and user-assigned identities are specified. A maximum of one user-assigned identity is supported. |
| [`privateEndpoints`](#parameter-volumegroupsprivateendpoints) | array | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| [`virtualNetworkRules`](#parameter-volumegroupsvirtualnetworkrules) | array | List of Virtual Network Rules, permitting virtual network subnet to connect to the resource through service endpoint. Each Elastic SAN Volume Group supports up to 200 virtual network rules. |
| [`volumes`](#parameter-volumegroupsvolumes) | array | List of Elastic SAN Volumes to be created in the Elastic SAN Volume Group. Elastic SAN Volume Group can contain up to 1,000 volumes. |

### Parameter: `volumeGroups.name`

The name of the Elastic SAN Volume Group. The name can only contain lowercase letters, numbers and hyphens, and must begin and end with a letter or a number. Each hyphen must be preceded and followed by an alphanumeric character.

- Required: Yes
- Type: string
- MinValue: 0
- MaxValue: 600

### Parameter: `volumeGroups.customerManagedKey`

The customer managed key definition. This parameter enables the encryption of Elastic SAN Volume Group using a customer-managed key. Currently, the only supported configuration is to use the same user-assigned identity for both 'managedIdentities.userAssignedResourceIds' and 'customerManagedKey.userAssignedIdentityResourceId'. Other configurations such as system-assigned identity are not supported. Ensure that the specified user-assigned identity has the 'Key Vault Crypto Service Encryption User' role access to both the key vault and the key itself. The key vault must also have purge protection enabled.

- Required: No
- Type: object
- MinValue: 0
- MaxValue: 600

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyName`](#parameter-volumegroupscustomermanagedkeykeyname) | string | The name of the customer managed key to use for encryption. |
| [`keyVaultResourceId`](#parameter-volumegroupscustomermanagedkeykeyvaultresourceid) | string | The resource ID of a key vault to reference a customer managed key for encryption from. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyVersion`](#parameter-volumegroupscustomermanagedkeykeyversion) | string | The version of the customer managed key to reference for encryption. If not provided, the deployment will use the latest version available at deployment time. |
| [`userAssignedIdentityResourceId`](#parameter-volumegroupscustomermanagedkeyuserassignedidentityresourceid) | string | User assigned identity to use when fetching the customer managed key. Required if no system assigned identity is available for use. |

### Parameter: `volumeGroups.customerManagedKey.keyName`

The name of the customer managed key to use for encryption.

- Required: Yes
- Type: string
- MinValue: 0
- MaxValue: 600

### Parameter: `volumeGroups.customerManagedKey.keyVaultResourceId`

The resource ID of a key vault to reference a customer managed key for encryption from.

- Required: Yes
- Type: string
- MinValue: 0
- MaxValue: 600

### Parameter: `volumeGroups.customerManagedKey.keyVersion`

The version of the customer managed key to reference for encryption. If not provided, the deployment will use the latest version available at deployment time.

- Required: No
- Type: string
- MinValue: 0
- MaxValue: 600

### Parameter: `volumeGroups.customerManagedKey.userAssignedIdentityResourceId`

User assigned identity to use when fetching the customer managed key. Required if no system assigned identity is available for use.

- Required: No
- Type: string
- MinValue: 0
- MaxValue: 600

### Parameter: `volumeGroups.managedIdentities`

The managed identity definition for this resource. The Elastic SAN Volume Group supports the following identity combinations: no identity is specified, only system-assigned identity is specified, only user-assigned identity is specified, and both system-assigned and user-assigned identities are specified. A maximum of one user-assigned identity is supported.

- Required: No
- Type: object
- MinValue: 0
- MaxValue: 600

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`systemAssigned`](#parameter-volumegroupsmanagedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. |
| [`userAssignedResourceIds`](#parameter-volumegroupsmanagedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption. |

### Parameter: `volumeGroups.managedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool
- MinValue: 0
- MaxValue: 600

### Parameter: `volumeGroups.managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption.

- Required: No
- Type: array
- MinValue: 0
- MaxValue: 600

### Parameter: `volumeGroups.privateEndpoints`

Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.

- Required: No
- Type: array
- MinValue: 0
- MaxValue: 600

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`subnetResourceId`](#parameter-volumegroupsprivateendpointssubnetresourceid) | string | Resource ID of the subnet where the endpoint needs to be created. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`applicationSecurityGroupResourceIds`](#parameter-volumegroupsprivateendpointsapplicationsecuritygroupresourceids) | array | Application security groups in which the Private Endpoint IP configuration is included. |
| [`customDnsConfigs`](#parameter-volumegroupsprivateendpointscustomdnsconfigs) | array | Custom DNS configurations. |
| [`customNetworkInterfaceName`](#parameter-volumegroupsprivateendpointscustomnetworkinterfacename) | string | The custom name of the network interface attached to the Private Endpoint. |
| [`enableTelemetry`](#parameter-volumegroupsprivateendpointsenabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`ipConfigurations`](#parameter-volumegroupsprivateendpointsipconfigurations) | array | A list of IP configurations of the Private Endpoint. This will be used to map to the first-party Service endpoints. |
| [`isManualConnection`](#parameter-volumegroupsprivateendpointsismanualconnection) | bool | If Manual Private Link Connection is required. |
| [`location`](#parameter-volumegroupsprivateendpointslocation) | string | The location to deploy the Private Endpoint to. |
| [`lock`](#parameter-volumegroupsprivateendpointslock) | object | Specify the type of lock. |
| [`manualConnectionRequestMessage`](#parameter-volumegroupsprivateendpointsmanualconnectionrequestmessage) | string | A message passed to the owner of the remote resource with the manual connection request. |
| [`name`](#parameter-volumegroupsprivateendpointsname) | string | The name of the Private Endpoint. |
| [`privateDnsZoneGroup`](#parameter-volumegroupsprivateendpointsprivatednszonegroup) | object | The private DNS Zone Group to configure for the Private Endpoint. |
| [`privateLinkServiceConnectionName`](#parameter-volumegroupsprivateendpointsprivatelinkserviceconnectionname) | string | The name of the private link connection to create. |
| [`resourceGroupName`](#parameter-volumegroupsprivateendpointsresourcegroupname) | string | Specify if you want to deploy the Private Endpoint into a different Resource Group than the main resource. |
| [`roleAssignments`](#parameter-volumegroupsprivateendpointsroleassignments) | array | Array of role assignments to create. |
| [`service`](#parameter-volumegroupsprivateendpointsservice) | string | The subresource to deploy the Private Endpoint for. For example "vault" for a Key Vault Private Endpoint. |
| [`tags`](#parameter-volumegroupsprivateendpointstags) | object | Tags to be applied on all resources/Resource Groups in this deployment. |

### Parameter: `volumeGroups.privateEndpoints.subnetResourceId`

Resource ID of the subnet where the endpoint needs to be created.

- Required: Yes
- Type: string
- MinValue: 0
- MaxValue: 600

### Parameter: `volumeGroups.privateEndpoints.applicationSecurityGroupResourceIds`

Application security groups in which the Private Endpoint IP configuration is included.

- Required: No
- Type: array
- MinValue: 0
- MaxValue: 600

### Parameter: `volumeGroups.privateEndpoints.customDnsConfigs`

Custom DNS configurations.

- Required: No
- Type: array
- MinValue: 0
- MaxValue: 600

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ipAddresses`](#parameter-volumegroupsprivateendpointscustomdnsconfigsipaddresses) | array | A list of private IP addresses of the private endpoint. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`fqdn`](#parameter-volumegroupsprivateendpointscustomdnsconfigsfqdn) | string | FQDN that resolves to private endpoint IP address. |

### Parameter: `volumeGroups.privateEndpoints.customDnsConfigs.ipAddresses`

A list of private IP addresses of the private endpoint.

- Required: Yes
- Type: array
- MinValue: 0
- MaxValue: 600

### Parameter: `volumeGroups.privateEndpoints.customDnsConfigs.fqdn`

FQDN that resolves to private endpoint IP address.

- Required: No
- Type: string
- MinValue: 0
- MaxValue: 600

### Parameter: `volumeGroups.privateEndpoints.customNetworkInterfaceName`

The custom name of the network interface attached to the Private Endpoint.

- Required: No
- Type: string
- MinValue: 0
- MaxValue: 600

### Parameter: `volumeGroups.privateEndpoints.enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- MinValue: 0
- MaxValue: 600

### Parameter: `volumeGroups.privateEndpoints.ipConfigurations`

A list of IP configurations of the Private Endpoint. This will be used to map to the first-party Service endpoints.

- Required: No
- Type: array
- MinValue: 0
- MaxValue: 600

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-volumegroupsprivateendpointsipconfigurationsname) | string | The name of the resource that is unique within a resource group. |
| [`properties`](#parameter-volumegroupsprivateendpointsipconfigurationsproperties) | object | Properties of private endpoint IP configurations. |

### Parameter: `volumeGroups.privateEndpoints.ipConfigurations.name`

The name of the resource that is unique within a resource group.

- Required: Yes
- Type: string
- MinValue: 0
- MaxValue: 600

### Parameter: `volumeGroups.privateEndpoints.ipConfigurations.properties`

Properties of private endpoint IP configurations.

- Required: Yes
- Type: object
- MinValue: 0
- MaxValue: 600

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`groupId`](#parameter-volumegroupsprivateendpointsipconfigurationspropertiesgroupid) | string | The ID of a group obtained from the remote resource that this private endpoint should connect to. |
| [`memberName`](#parameter-volumegroupsprivateendpointsipconfigurationspropertiesmembername) | string | The member name of a group obtained from the remote resource that this private endpoint should connect to. |
| [`privateIPAddress`](#parameter-volumegroupsprivateendpointsipconfigurationspropertiesprivateipaddress) | string | A private IP address obtained from the private endpoint's subnet. |

### Parameter: `volumeGroups.privateEndpoints.ipConfigurations.properties.groupId`

The ID of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: string
- MinValue: 0
- MaxValue: 600

### Parameter: `volumeGroups.privateEndpoints.ipConfigurations.properties.memberName`

The member name of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: string
- MinValue: 0
- MaxValue: 600

### Parameter: `volumeGroups.privateEndpoints.ipConfigurations.properties.privateIPAddress`

A private IP address obtained from the private endpoint's subnet.

- Required: Yes
- Type: string
- MinValue: 0
- MaxValue: 600

### Parameter: `volumeGroups.privateEndpoints.isManualConnection`

If Manual Private Link Connection is required.

- Required: No
- Type: bool
- MinValue: 0
- MaxValue: 600

### Parameter: `volumeGroups.privateEndpoints.location`

The location to deploy the Private Endpoint to.

- Required: No
- Type: string
- MinValue: 0
- MaxValue: 600

### Parameter: `volumeGroups.privateEndpoints.lock`

Specify the type of lock.

- Required: No
- Type: object
- MinValue: 0
- MaxValue: 600

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-volumegroupsprivateendpointslockkind) | string | Specify the type of lock. |
| [`name`](#parameter-volumegroupsprivateendpointslockname) | string | Specify the name of lock. |

### Parameter: `volumeGroups.privateEndpoints.lock.kind`

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
- MinValue: 0
- MaxValue: 600

### Parameter: `volumeGroups.privateEndpoints.lock.name`

Specify the name of lock.

- Required: No
- Type: string
- MinValue: 0
- MaxValue: 600

### Parameter: `volumeGroups.privateEndpoints.manualConnectionRequestMessage`

A message passed to the owner of the remote resource with the manual connection request.

- Required: No
- Type: string
- MinValue: 0
- MaxValue: 600

### Parameter: `volumeGroups.privateEndpoints.name`

The name of the Private Endpoint.

- Required: No
- Type: string
- MinValue: 0
- MaxValue: 600

### Parameter: `volumeGroups.privateEndpoints.privateDnsZoneGroup`

The private DNS Zone Group to configure for the Private Endpoint.

- Required: No
- Type: object
- MinValue: 0
- MaxValue: 600

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateDnsZoneGroupConfigs`](#parameter-volumegroupsprivateendpointsprivatednszonegroupprivatednszonegroupconfigs) | array | The private DNS Zone Groups to associate the Private Endpoint. A DNS Zone Group can support up to 5 DNS zones. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-volumegroupsprivateendpointsprivatednszonegroupname) | string | The name of the Private DNS Zone Group. |

### Parameter: `volumeGroups.privateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs`

The private DNS Zone Groups to associate the Private Endpoint. A DNS Zone Group can support up to 5 DNS zones.

- Required: Yes
- Type: array
- MinValue: 0
- MaxValue: 600

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateDnsZoneResourceId`](#parameter-volumegroupsprivateendpointsprivatednszonegroupprivatednszonegroupconfigsprivatednszoneresourceid) | string | The resource id of the private DNS zone. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-volumegroupsprivateendpointsprivatednszonegroupprivatednszonegroupconfigsname) | string | The name of the private DNS Zone Group config. |

### Parameter: `volumeGroups.privateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs.privateDnsZoneResourceId`

The resource id of the private DNS zone.

- Required: Yes
- Type: string
- MinValue: 0
- MaxValue: 600

### Parameter: `volumeGroups.privateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs.name`

The name of the private DNS Zone Group config.

- Required: No
- Type: string
- MinValue: 0
- MaxValue: 600

### Parameter: `volumeGroups.privateEndpoints.privateDnsZoneGroup.name`

The name of the Private DNS Zone Group.

- Required: No
- Type: string
- MinValue: 0
- MaxValue: 600

### Parameter: `volumeGroups.privateEndpoints.privateLinkServiceConnectionName`

The name of the private link connection to create.

- Required: No
- Type: string
- MinValue: 0
- MaxValue: 600

### Parameter: `volumeGroups.privateEndpoints.resourceGroupName`

Specify if you want to deploy the Private Endpoint into a different Resource Group than the main resource.

- Required: No
- Type: string
- MinValue: 0
- MaxValue: 600

### Parameter: `volumeGroups.privateEndpoints.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- MinValue: 0
- MaxValue: 600
- Roles configurable by name:
  - `'Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`
  - `'Elastic SAN Network Admin'`
  - `'Elastic SAN Owner'`
  - `'Elastic SAN Reader'`
  - `'Elastic SAN Volume Group Owner'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-volumegroupsprivateendpointsroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-volumegroupsprivateendpointsroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-volumegroupsprivateendpointsroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-volumegroupsprivateendpointsroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-volumegroupsprivateendpointsroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-volumegroupsprivateendpointsroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-volumegroupsprivateendpointsroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-volumegroupsprivateendpointsroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `volumeGroups.privateEndpoints.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string
- MinValue: 0
- MaxValue: 600

### Parameter: `volumeGroups.privateEndpoints.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string
- MinValue: 0
- MaxValue: 600

### Parameter: `volumeGroups.privateEndpoints.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string
- MinValue: 0
- MaxValue: 600

### Parameter: `volumeGroups.privateEndpoints.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```
- MinValue: 0
- MaxValue: 600

### Parameter: `volumeGroups.privateEndpoints.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string
- MinValue: 0
- MaxValue: 600

### Parameter: `volumeGroups.privateEndpoints.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string
- MinValue: 0
- MaxValue: 600

### Parameter: `volumeGroups.privateEndpoints.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string
- MinValue: 0
- MaxValue: 600

### Parameter: `volumeGroups.privateEndpoints.roleAssignments.principalType`

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
- MinValue: 0
- MaxValue: 600

### Parameter: `volumeGroups.privateEndpoints.service`

The subresource to deploy the Private Endpoint for. For example "vault" for a Key Vault Private Endpoint.

- Required: No
- Type: string
- MinValue: 0
- MaxValue: 600

### Parameter: `volumeGroups.privateEndpoints.tags`

Tags to be applied on all resources/Resource Groups in this deployment.

- Required: No
- Type: object
- MinValue: 0
- MaxValue: 600

### Parameter: `volumeGroups.virtualNetworkRules`

List of Virtual Network Rules, permitting virtual network subnet to connect to the resource through service endpoint. Each Elastic SAN Volume Group supports up to 200 virtual network rules.

- Required: No
- Type: array
- MinValue: 0
- MaxValue: 600

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`virtualNetworkSubnetResourceId`](#parameter-volumegroupsvirtualnetworkrulesvirtualnetworksubnetresourceid) | string | The resource ID of the subnet in the virtual network. |

### Parameter: `volumeGroups.virtualNetworkRules.virtualNetworkSubnetResourceId`

The resource ID of the subnet in the virtual network.

- Required: Yes
- Type: string
- MinValue: 0
- MaxValue: 600

### Parameter: `volumeGroups.volumes`

List of Elastic SAN Volumes to be created in the Elastic SAN Volume Group. Elastic SAN Volume Group can contain up to 1,000 volumes.

- Required: No
- Type: array
- MinValue: 0
- MaxValue: 600

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-volumegroupsvolumesname) | string | The name of the Elastic SAN Volume. The name can only contain lowercase letters, numbers, hyphens and underscores, and must begin and end with a letter or a number. Each hyphen and underscore must be preceded and followed by an alphanumeric character. |
| [`sizeGiB`](#parameter-volumegroupsvolumessizegib) | int | Size of the Elastic SAN Volume in Gibibytes (GiB). The supported capacity ranges from 1 Gibibyte (GiB) to 64 Tebibyte (TiB), equating to 65536 Gibibytes (GiB). |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`snapshots`](#parameter-volumegroupsvolumessnapshots) | array | List of Elastic SAN Volume Snapshots to be created in the Elastic SAN Volume. |

### Parameter: `volumeGroups.volumes.name`

The name of the Elastic SAN Volume. The name can only contain lowercase letters, numbers, hyphens and underscores, and must begin and end with a letter or a number. Each hyphen and underscore must be preceded and followed by an alphanumeric character.

- Required: Yes
- Type: string
- MinValue: 0
- MaxValue: 600

### Parameter: `volumeGroups.volumes.sizeGiB`

Size of the Elastic SAN Volume in Gibibytes (GiB). The supported capacity ranges from 1 Gibibyte (GiB) to 64 Tebibyte (TiB), equating to 65536 Gibibytes (GiB).

- Required: Yes
- Type: int
- MinValue: 1
- MaxValue: 65536

### Parameter: `volumeGroups.volumes.snapshots`

List of Elastic SAN Volume Snapshots to be created in the Elastic SAN Volume.

- Required: No
- Type: array
- MinValue: 1
- MaxValue: 65536

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-volumegroupsvolumessnapshotsname) | string | The name of the Elastic SAN Volume Snapshot. The name can only contain lowercase letters, numbers, hyphens and underscores, and must begin and end with a letter or a number. Each hyphen and underscore must be preceded and followed by an alphanumeric character. |

### Parameter: `volumeGroups.volumes.snapshots.name`

The name of the Elastic SAN Volume Snapshot. The name can only contain lowercase letters, numbers, hyphens and underscores, and must begin and end with a letter or a number. Each hyphen and underscore must be preceded and followed by an alphanumeric character.

- Required: Yes
- Type: string
- MinValue: 1
- MaxValue: 65536

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location of the deployed Elastic SAN. |
| `name` | string | The name of the deployed Elastic SAN. |
| `resourceGroupName` | string | The resource group of the deployed Elastic SAN. |
| `resourceId` | string | The resource ID of the deployed Elastic SAN. |
| `volumeGroups` | array | Details on the deployed Elastic SAN Volume Groups. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/network/private-endpoint:0.9.0` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.3.0` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
