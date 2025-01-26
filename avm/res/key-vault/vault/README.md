# Key Vaults `[Microsoft.KeyVault/vaults]`

This module deploys a Key Vault.

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
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.KeyVault/vaults` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults) |
| `Microsoft.KeyVault/vaults/accessPolicies` | [2023-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2023-07-01/vaults/accessPolicies) |
| `Microsoft.KeyVault/vaults/keys` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/keys) |
| `Microsoft.KeyVault/vaults/secrets` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/secrets) |
| `Microsoft.Network/privateEndpoints` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints/privateDnsZoneGroups) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/key-vault/vault:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using only defaults](#example-2-using-only-defaults)
- [Using large parameter set](#example-3-using-large-parameter-set)
- [Using only defaults](#example-4-using-only-defaults)
- [WAF-aligned](#example-5-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module vault 'br/public:avm/res/key-vault/vault:<version>' = {
  name: 'vaultDeployment'
  params: {
    // Required parameters
    name: 'kvvmin002'
    // Non-required parameters
    enablePurgeProtection: false
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
      "value": "kvvmin002"
    },
    // Non-required parameters
    "enablePurgeProtection": {
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
using 'br/public:avm/res/key-vault/vault:<version>'

// Required parameters
param name = 'kvvmin002'
// Non-required parameters
param enablePurgeProtection = false
```

</details>
<p>

### Example 2: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module vault 'br/public:avm/res/key-vault/vault:<version>' = {
  name: 'vaultDeployment'
  params: {
    // Required parameters
    name: 'kvvec002'
    // Non-required parameters
    enablePurgeProtection: false
    enableRbacAuthorization: true
    keys: [
      {
        attributes: {
          exp: 1725109032
          nbf: 10000
        }
        kty: 'EC'
        name: 'keyName'
        rotationPolicy: {
          attributes: {
            expiryTime: 'P2Y'
          }
          lifetimeActions: [
            {
              action: {
                type: 'Rotate'
              }
              trigger: {
                timeBeforeExpiry: 'P2M'
              }
            }
            {
              action: {
                type: 'Notify'
              }
              trigger: {
                timeBeforeExpiry: 'P30D'
              }
            }
          ]
        }
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
    "name": {
      "value": "kvvec002"
    },
    "enablePurgeProtection": {
      "value": false
    },
    "enableRbacAuthorization": {
      "value": true
    },
    "keys": {
      "value": [
        {
          "attributes": {
            "exp": 1725109032,
            "nbf": 10000
          },
          "kty": "EC",
          "name": "keyName",
          "rotationPolicy": {
            "attributes": {
              "expiryTime": "P2Y"
            },
            "lifetimeActions": [
              {
                "action": {
                  "type": "Rotate"
                },
                "trigger": {
                  "timeBeforeExpiry": "P2M"
                }
              },
              {
                "action": {
                  "type": "Notify"
                },
                "trigger": {
                  "timeBeforeExpiry": "P30D"
                }
              }
            ]
          }
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
using 'br/public:avm/res/key-vault/vault:<version>'

// Required parameters
param name = 'kvvec002'
// Non-required parameters
param enablePurgeProtection = false
param enableRbacAuthorization = true
param keys = [
  {
    attributes: {
      exp: 1725109032
      nbf: 10000
    }
    kty: 'EC'
    name: 'keyName'
    rotationPolicy: {
      attributes: {
        expiryTime: 'P2Y'
      }
      lifetimeActions: [
        {
          action: {
            type: 'Rotate'
          }
          trigger: {
            timeBeforeExpiry: 'P2M'
          }
        }
        {
          action: {
            type: 'Notify'
          }
          trigger: {
            timeBeforeExpiry: 'P30D'
          }
        }
      ]
    }
  }
]
```

</details>
<p>

### Example 3: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module vault 'br/public:avm/res/key-vault/vault:<version>' = {
  name: 'vaultDeployment'
  params: {
    // Required parameters
    name: 'kvvmax002'
    // Non-required parameters
    accessPolicies: [
      {
        objectId: '<objectId>'
        permissions: {
          keys: [
            'get'
            'list'
            'update'
          ]
          secrets: [
            'all'
          ]
        }
        tenantId: '<tenantId>'
      }
      {
        objectId: '<objectId>'
        permissions: {
          certificates: [
            'backup'
            'create'
            'delete'
          ]
          secrets: [
            'all'
          ]
        }
      }
    ]
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        logCategoriesAndGroups: [
          {
            category: 'AzurePolicyEvaluationDetails'
          }
          {
            category: 'AuditEvent'
          }
        ]
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
    enablePurgeProtection: false
    enableRbacAuthorization: false
    keys: [
      {
        attributes: {
          exp: 1725109032
          nbf: 10000
        }
        name: 'keyName'
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
        ]
        rotationPolicy: {
          attributes: {
            expiryTime: 'P2Y'
          }
          lifetimeActions: [
            {
              action: {
                type: 'Rotate'
              }
              trigger: {
                timeBeforeExpiry: 'P2M'
              }
            }
            {
              action: {
                type: 'Notify'
              }
              trigger: {
                timeBeforeExpiry: 'P30D'
              }
            }
          ]
        }
      }
    ]
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      ipRules: [
        {
          value: '40.74.28.0/23'
        }
      ]
      virtualNetworkRules: [
        {
          id: '<id>'
          ignoreMissingVnetServiceEndpoint: false
        }
      ]
    }
    privateEndpoints: [
      {
        customDnsConfigs: [
          {
            fqdn: 'abc.keyvault.com'
            ipAddresses: [
              '10.0.0.10'
            ]
          }
        ]
        ipConfigurations: [
          {
            name: 'myIPconfig'
            properties: {
              groupId: 'vault'
              memberName: 'default'
              privateIPAddress: '10.0.0.10'
            }
          }
        ]
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Owner'
          }
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
          }
        ]
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        subnetResourceId: '<subnetResourceId>'
      }
    ]
    roleAssignments: [
      {
        name: 'b50cc72e-a2f2-4c4c-a3ad-86a43feb6ab8'
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
    secrets: [
      {
        attributes: {
          exp: 1725109032
          nbf: 10000
        }
        contentType: 'Something'
        name: 'secretName'
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
        ]
        value: 'secretValue'
      }
    ]
    softDeleteRetentionInDays: 7
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
    "name": {
      "value": "kvvmax002"
    },
    "accessPolicies": {
      "value": [
        {
          "objectId": "<objectId>",
          "permissions": {
            "keys": [
              "get",
              "list",
              "update"
            ],
            "secrets": [
              "all"
            ]
          },
          "tenantId": "<tenantId>"
        },
        {
          "objectId": "<objectId>",
          "permissions": {
            "certificates": [
              "backup",
              "create",
              "delete"
            ],
            "secrets": [
              "all"
            ]
          }
        }
      ]
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "logCategoriesAndGroups": [
            {
              "category": "AzurePolicyEvaluationDetails"
            },
            {
              "category": "AuditEvent"
            }
          ],
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
    "enablePurgeProtection": {
      "value": false
    },
    "enableRbacAuthorization": {
      "value": false
    },
    "keys": {
      "value": [
        {
          "attributes": {
            "exp": 1725109032,
            "nbf": 10000
          },
          "name": "keyName",
          "roleAssignments": [
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
            }
          ],
          "rotationPolicy": {
            "attributes": {
              "expiryTime": "P2Y"
            },
            "lifetimeActions": [
              {
                "action": {
                  "type": "Rotate"
                },
                "trigger": {
                  "timeBeforeExpiry": "P2M"
                }
              },
              {
                "action": {
                  "type": "Notify"
                },
                "trigger": {
                  "timeBeforeExpiry": "P30D"
                }
              }
            ]
          }
        }
      ]
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
    "networkAcls": {
      "value": {
        "bypass": "AzureServices",
        "defaultAction": "Deny",
        "ipRules": [
          {
            "value": "40.74.28.0/23"
          }
        ],
        "virtualNetworkRules": [
          {
            "id": "<id>",
            "ignoreMissingVnetServiceEndpoint": false
          }
        ]
      }
    },
    "privateEndpoints": {
      "value": [
        {
          "customDnsConfigs": [
            {
              "fqdn": "abc.keyvault.com",
              "ipAddresses": [
                "10.0.0.10"
              ]
            }
          ],
          "ipConfigurations": [
            {
              "name": "myIPconfig",
              "properties": {
                "groupId": "vault",
                "memberName": "default",
                "privateIPAddress": "10.0.0.10"
              }
            }
          ],
          "privateDnsZoneGroup": {
            "privateDnsZoneGroupConfigs": [
              {
                "privateDnsZoneResourceId": "<privateDnsZoneResourceId>"
              }
            ]
          },
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Owner"
            },
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "<roleDefinitionIdOrName>"
            }
          ],
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        },
        {
          "privateDnsZoneGroup": {
            "privateDnsZoneGroupConfigs": [
              {
                "privateDnsZoneResourceId": "<privateDnsZoneResourceId>"
              }
            ]
          },
          "subnetResourceId": "<subnetResourceId>"
        }
      ]
    },
    "roleAssignments": {
      "value": [
        {
          "name": "b50cc72e-a2f2-4c4c-a3ad-86a43feb6ab8",
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
    "secrets": {
      "value": [
        {
          "attributes": {
            "exp": 1725109032,
            "nbf": 10000
          },
          "contentType": "Something",
          "name": "secretName",
          "roleAssignments": [
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
            }
          ],
          "value": "secretValue"
        }
      ]
    },
    "softDeleteRetentionInDays": {
      "value": 7
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
using 'br/public:avm/res/key-vault/vault:<version>'

// Required parameters
param name = 'kvvmax002'
// Non-required parameters
param accessPolicies = [
  {
    objectId: '<objectId>'
    permissions: {
      keys: [
        'get'
        'list'
        'update'
      ]
      secrets: [
        'all'
      ]
    }
    tenantId: '<tenantId>'
  }
  {
    objectId: '<objectId>'
    permissions: {
      certificates: [
        'backup'
        'create'
        'delete'
      ]
      secrets: [
        'all'
      ]
    }
  }
]
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    logCategoriesAndGroups: [
      {
        category: 'AzurePolicyEvaluationDetails'
      }
      {
        category: 'AuditEvent'
      }
    ]
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
param enablePurgeProtection = false
param enableRbacAuthorization = false
param keys = [
  {
    attributes: {
      exp: 1725109032
      nbf: 10000
    }
    name: 'keyName'
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
    ]
    rotationPolicy: {
      attributes: {
        expiryTime: 'P2Y'
      }
      lifetimeActions: [
        {
          action: {
            type: 'Rotate'
          }
          trigger: {
            timeBeforeExpiry: 'P2M'
          }
        }
        {
          action: {
            type: 'Notify'
          }
          trigger: {
            timeBeforeExpiry: 'P30D'
          }
        }
      ]
    }
  }
]
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param networkAcls = {
  bypass: 'AzureServices'
  defaultAction: 'Deny'
  ipRules: [
    {
      value: '40.74.28.0/23'
    }
  ]
  virtualNetworkRules: [
    {
      id: '<id>'
      ignoreMissingVnetServiceEndpoint: false
    }
  ]
}
param privateEndpoints = [
  {
    customDnsConfigs: [
      {
        fqdn: 'abc.keyvault.com'
        ipAddresses: [
          '10.0.0.10'
        ]
      }
    ]
    ipConfigurations: [
      {
        name: 'myIPconfig'
        properties: {
          groupId: 'vault'
          memberName: 'default'
          privateIPAddress: '10.0.0.10'
        }
      }
    ]
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        {
          privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
        }
      ]
    }
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Owner'
      }
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
      }
    ]
    subnetResourceId: '<subnetResourceId>'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
  }
  {
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        {
          privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
        }
      ]
    }
    subnetResourceId: '<subnetResourceId>'
  }
]
param roleAssignments = [
  {
    name: 'b50cc72e-a2f2-4c4c-a3ad-86a43feb6ab8'
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
param secrets = [
  {
    attributes: {
      exp: 1725109032
      nbf: 10000
    }
    contentType: 'Something'
    name: 'secretName'
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
    ]
    value: 'secretValue'
  }
]
param softDeleteRetentionInDays = 7
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
```

</details>
<p>

### Example 4: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module vault 'br/public:avm/res/key-vault/vault:<version>' = {
  name: 'vaultDeployment'
  params: {
    // Required parameters
    name: 'kvvrsa002'
    // Non-required parameters
    enablePurgeProtection: false
    enableRbacAuthorization: true
    keys: [
      {
        attributes: {
          exp: 1725109032
          nbf: 10000
        }
        kty: 'RSA'
        name: 'keyName'
        rotationPolicy: {
          attributes: {
            expiryTime: 'P2Y'
          }
          lifetimeActions: [
            {
              action: {
                type: 'Rotate'
              }
              trigger: {
                timeBeforeExpiry: 'P2M'
              }
            }
            {
              action: {
                type: 'Notify'
              }
              trigger: {
                timeBeforeExpiry: 'P30D'
              }
            }
          ]
        }
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
    "name": {
      "value": "kvvrsa002"
    },
    "enablePurgeProtection": {
      "value": false
    },
    "enableRbacAuthorization": {
      "value": true
    },
    "keys": {
      "value": [
        {
          "attributes": {
            "exp": 1725109032,
            "nbf": 10000
          },
          "kty": "RSA",
          "name": "keyName",
          "rotationPolicy": {
            "attributes": {
              "expiryTime": "P2Y"
            },
            "lifetimeActions": [
              {
                "action": {
                  "type": "Rotate"
                },
                "trigger": {
                  "timeBeforeExpiry": "P2M"
                }
              },
              {
                "action": {
                  "type": "Notify"
                },
                "trigger": {
                  "timeBeforeExpiry": "P30D"
                }
              }
            ]
          }
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
using 'br/public:avm/res/key-vault/vault:<version>'

// Required parameters
param name = 'kvvrsa002'
// Non-required parameters
param enablePurgeProtection = false
param enableRbacAuthorization = true
param keys = [
  {
    attributes: {
      exp: 1725109032
      nbf: 10000
    }
    kty: 'RSA'
    name: 'keyName'
    rotationPolicy: {
      attributes: {
        expiryTime: 'P2Y'
      }
      lifetimeActions: [
        {
          action: {
            type: 'Rotate'
          }
          trigger: {
            timeBeforeExpiry: 'P2M'
          }
        }
        {
          action: {
            type: 'Notify'
          }
          trigger: {
            timeBeforeExpiry: 'P30D'
          }
        }
      ]
    }
  }
]
```

</details>
<p>

### Example 5: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module vault 'br/public:avm/res/key-vault/vault:<version>' = {
  name: 'vaultDeployment'
  params: {
    // Required parameters
    name: 'kvvwaf002'
    // Non-required parameters
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    enablePurgeProtection: false
    enableRbacAuthorization: true
    keys: [
      {
        attributes: {
          enabled: true
          exp: 1702648632
          nbf: 10000
        }
        keySize: 4096
        name: 'keyName'
        rotationPolicy: {
          attributes: {
            expiryTime: 'P2Y'
          }
          lifetimeActions: [
            {
              action: {
                type: 'Rotate'
              }
              trigger: {
                timeBeforeExpiry: 'P2M'
              }
            }
            {
              action: {
                type: 'Notify'
              }
              trigger: {
                timeBeforeExpiry: 'P30D'
              }
            }
          ]
        }
      }
    ]
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
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
        service: 'vault'
        subnetResourceId: '<subnetResourceId>'
      }
    ]
    secrets: [
      {
        attributes: {
          enabled: true
          exp: 1702648632
          nbf: 10000
        }
        contentType: 'Something'
        name: 'secretName'
        value: 'secretValue'
      }
    ]
    softDeleteRetentionInDays: 7
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
    "name": {
      "value": "kvvwaf002"
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
    "enablePurgeProtection": {
      "value": false
    },
    "enableRbacAuthorization": {
      "value": true
    },
    "keys": {
      "value": [
        {
          "attributes": {
            "enabled": true,
            "exp": 1702648632,
            "nbf": 10000
          },
          "keySize": 4096,
          "name": "keyName",
          "rotationPolicy": {
            "attributes": {
              "expiryTime": "P2Y"
            },
            "lifetimeActions": [
              {
                "action": {
                  "type": "Rotate"
                },
                "trigger": {
                  "timeBeforeExpiry": "P2M"
                }
              },
              {
                "action": {
                  "type": "Notify"
                },
                "trigger": {
                  "timeBeforeExpiry": "P30D"
                }
              }
            ]
          }
        }
      ]
    },
    "networkAcls": {
      "value": {
        "bypass": "AzureServices",
        "defaultAction": "Deny"
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
          "service": "vault",
          "subnetResourceId": "<subnetResourceId>"
        }
      ]
    },
    "secrets": {
      "value": [
        {
          "attributes": {
            "enabled": true,
            "exp": 1702648632,
            "nbf": 10000
          },
          "contentType": "Something",
          "name": "secretName",
          "value": "secretValue"
        }
      ]
    },
    "softDeleteRetentionInDays": {
      "value": 7
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
using 'br/public:avm/res/key-vault/vault:<version>'

// Required parameters
param name = 'kvvwaf002'
// Non-required parameters
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param enablePurgeProtection = false
param enableRbacAuthorization = true
param keys = [
  {
    attributes: {
      enabled: true
      exp: 1702648632
      nbf: 10000
    }
    keySize: 4096
    name: 'keyName'
    rotationPolicy: {
      attributes: {
        expiryTime: 'P2Y'
      }
      lifetimeActions: [
        {
          action: {
            type: 'Rotate'
          }
          trigger: {
            timeBeforeExpiry: 'P2M'
          }
        }
        {
          action: {
            type: 'Notify'
          }
          trigger: {
            timeBeforeExpiry: 'P30D'
          }
        }
      ]
    }
  }
]
param networkAcls = {
  bypass: 'AzureServices'
  defaultAction: 'Deny'
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
    service: 'vault'
    subnetResourceId: '<subnetResourceId>'
  }
]
param secrets = [
  {
    attributes: {
      enabled: true
      exp: 1702648632
      nbf: 10000
    }
    contentType: 'Something'
    name: 'secretName'
    value: 'secretValue'
  }
]
param softDeleteRetentionInDays = 7
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
| [`name`](#parameter-name) | string | Name of the Key Vault. Must be globally unique. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`accessPolicies`](#parameter-accesspolicies) | array | All access policies to create. |
| [`createMode`](#parameter-createmode) | string | The vault's create mode to indicate whether the vault need to be recovered or not. - recover or default. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`enablePurgeProtection`](#parameter-enablepurgeprotection) | bool | Provide 'true' to enable Key Vault's purge protection feature. |
| [`enableRbacAuthorization`](#parameter-enablerbacauthorization) | bool | Property that controls how data actions are authorized. When true, the key vault will use Role Based Access Control (RBAC) for authorization of data actions, and the access policies specified in vault properties will be ignored. When false, the key vault will use the access policies specified in vault properties, and any policy stored on Azure Resource Manager will be ignored. Note that management actions are always authorized with RBAC. |
| [`enableSoftDelete`](#parameter-enablesoftdelete) | bool | Switch to enable/disable Key Vault's soft delete feature. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`enableVaultForDeployment`](#parameter-enablevaultfordeployment) | bool | Specifies if the vault is enabled for deployment by script or compute. |
| [`enableVaultForDiskEncryption`](#parameter-enablevaultfordiskencryption) | bool | Specifies if the azure platform has access to the vault for enabling disk encryption scenarios. |
| [`enableVaultForTemplateDeployment`](#parameter-enablevaultfortemplatedeployment) | bool | Specifies if the vault is enabled for a template deployment. |
| [`keys`](#parameter-keys) | array | All keys to create. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`networkAcls`](#parameter-networkacls) | object | Rules governing the accessibility of the resource from specific network locations. |
| [`privateEndpoints`](#parameter-privateendpoints) | array | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and networkAcls are not set. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`secrets`](#parameter-secrets) | array | All secrets to create. |
| [`sku`](#parameter-sku) | string | Specifies the SKU for the vault. |
| [`softDeleteRetentionInDays`](#parameter-softdeleteretentionindays) | int | softDelete data retention days. It accepts >=7 and <=90. |
| [`tags`](#parameter-tags) | object | Resource tags. |

### Parameter: `name`

Name of the Key Vault. Must be globally unique.

- Required: Yes
- Type: string

### Parameter: `accessPolicies`

All access policies to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`objectId`](#parameter-accesspoliciesobjectid) | string | The object ID of a user, service principal or security group in the tenant for the vault. |
| [`permissions`](#parameter-accesspoliciespermissions) | object | Permissions the identity has for keys, secrets and certificates. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`applicationId`](#parameter-accesspoliciesapplicationid) | string | Application ID of the client making request on behalf of a principal. |
| [`tenantId`](#parameter-accesspoliciestenantid) | string | The tenant ID that is used for authenticating requests to the key vault. |

### Parameter: `accessPolicies.objectId`

The object ID of a user, service principal or security group in the tenant for the vault.

- Required: Yes
- Type: string

### Parameter: `accessPolicies.permissions`

Permissions the identity has for keys, secrets and certificates.

- Required: Yes
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`certificates`](#parameter-accesspoliciespermissionscertificates) | array | Permissions to certificates. |
| [`keys`](#parameter-accesspoliciespermissionskeys) | array | Permissions to keys. |
| [`secrets`](#parameter-accesspoliciespermissionssecrets) | array | Permissions to secrets. |
| [`storage`](#parameter-accesspoliciespermissionsstorage) | array | Permissions to storage accounts. |

### Parameter: `accessPolicies.permissions.certificates`

Permissions to certificates.

- Required: No
- Type: array
- Allowed:
  ```Bicep
  [
    'all'
    'backup'
    'create'
    'delete'
    'deleteissuers'
    'get'
    'getissuers'
    'import'
    'list'
    'listissuers'
    'managecontacts'
    'manageissuers'
    'purge'
    'recover'
    'restore'
    'setissuers'
    'update'
  ]
  ```

### Parameter: `accessPolicies.permissions.keys`

Permissions to keys.

- Required: No
- Type: array
- Allowed:
  ```Bicep
  [
    'all'
    'backup'
    'create'
    'decrypt'
    'delete'
    'encrypt'
    'get'
    'getrotationpolicy'
    'import'
    'list'
    'purge'
    'recover'
    'release'
    'restore'
    'rotate'
    'setrotationpolicy'
    'sign'
    'unwrapKey'
    'update'
    'verify'
    'wrapKey'
  ]
  ```

### Parameter: `accessPolicies.permissions.secrets`

Permissions to secrets.

- Required: No
- Type: array
- Allowed:
  ```Bicep
  [
    'all'
    'backup'
    'delete'
    'get'
    'list'
    'purge'
    'recover'
    'restore'
    'set'
  ]
  ```

### Parameter: `accessPolicies.permissions.storage`

Permissions to storage accounts.

- Required: No
- Type: array
- Allowed:
  ```Bicep
  [
    'all'
    'backup'
    'delete'
    'deletesas'
    'get'
    'getsas'
    'list'
    'listsas'
    'purge'
    'recover'
    'regeneratekey'
    'restore'
    'set'
    'setsas'
    'update'
  ]
  ```

### Parameter: `accessPolicies.applicationId`

Application ID of the client making request on behalf of a principal.

- Required: No
- Type: string

### Parameter: `accessPolicies.tenantId`

The tenant ID that is used for authenticating requests to the key vault.

- Required: No
- Type: string

### Parameter: `createMode`

The vault's create mode to indicate whether the vault need to be recovered or not. - recover or default.

- Required: No
- Type: string
- Default: `'default'`

### Parameter: `diagnosticSettings`

The diagnostic settings of the service.

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

### Parameter: `enablePurgeProtection`

Provide 'true' to enable Key Vault's purge protection feature.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableRbacAuthorization`

Property that controls how data actions are authorized. When true, the key vault will use Role Based Access Control (RBAC) for authorization of data actions, and the access policies specified in vault properties will be ignored. When false, the key vault will use the access policies specified in vault properties, and any policy stored on Azure Resource Manager will be ignored. Note that management actions are always authorized with RBAC.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableSoftDelete`

Switch to enable/disable Key Vault's soft delete feature.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableVaultForDeployment`

Specifies if the vault is enabled for deployment by script or compute.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableVaultForDiskEncryption`

Specifies if the azure platform has access to the vault for enabling disk encryption scenarios.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableVaultForTemplateDeployment`

Specifies if the vault is enabled for a template deployment.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `keys`

All keys to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-keysname) | string | The name of the key. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`attributes`](#parameter-keysattributes) | object | Contains attributes of the key. |
| [`curveName`](#parameter-keyscurvename) | string | The elliptic curve name. Only works if "keySize" equals "EC" or "EC-HSM". Default is "P-256". |
| [`keyOps`](#parameter-keyskeyops) | array | The allowed operations on this key. |
| [`keySize`](#parameter-keyskeysize) | int | The key size in bits. Only works if "keySize" equals "RSA" or "RSA-HSM". Default is "4096". |
| [`kty`](#parameter-keyskty) | string | The type of the key. Default is "EC". |
| [`releasePolicy`](#parameter-keysreleasepolicy) | object | Key release policy. |
| [`roleAssignments`](#parameter-keysroleassignments) | array | Array of role assignments to create. |
| [`rotationPolicy`](#parameter-keysrotationpolicy) | object | Key rotation policy. |
| [`tags`](#parameter-keystags) | object | Resource tags. |

### Parameter: `keys.name`

The name of the key.

- Required: Yes
- Type: string

### Parameter: `keys.attributes`

Contains attributes of the key.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-keysattributesenabled) | bool | Defines whether the key is enabled or disabled. |
| [`exp`](#parameter-keysattributesexp) | int | Defines when the key will become invalid. Defined in seconds since 1970-01-01T00:00:00Z. |
| [`nbf`](#parameter-keysattributesnbf) | int | If set, defines the date from which onwards the key becomes valid. Defined in seconds since 1970-01-01T00:00:00Z. |

### Parameter: `keys.attributes.enabled`

Defines whether the key is enabled or disabled.

- Required: No
- Type: bool

### Parameter: `keys.attributes.exp`

Defines when the key will become invalid. Defined in seconds since 1970-01-01T00:00:00Z.

- Required: No
- Type: int

### Parameter: `keys.attributes.nbf`

If set, defines the date from which onwards the key becomes valid. Defined in seconds since 1970-01-01T00:00:00Z.

- Required: No
- Type: int

### Parameter: `keys.curveName`

The elliptic curve name. Only works if "keySize" equals "EC" or "EC-HSM". Default is "P-256".

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'P-256'
    'P-256K'
    'P-384'
    'P-521'
  ]
  ```

### Parameter: `keys.keyOps`

The allowed operations on this key.

- Required: No
- Type: array
- Allowed:
  ```Bicep
  [
    'decrypt'
    'encrypt'
    'import'
    'release'
    'sign'
    'unwrapKey'
    'verify'
    'wrapKey'
  ]
  ```

### Parameter: `keys.keySize`

The key size in bits. Only works if "keySize" equals "RSA" or "RSA-HSM". Default is "4096".

- Required: No
- Type: int
- Allowed:
  ```Bicep
  [
    2048
    3072
    4096
  ]
  ```

### Parameter: `keys.kty`

The type of the key. Default is "EC".

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'EC'
    'EC-HSM'
    'RSA'
    'RSA-HSM'
  ]
  ```

### Parameter: `keys.releasePolicy`

Key release policy.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`contentType`](#parameter-keysreleasepolicycontenttype) | string | Content type and version of key release policy. |
| [`data`](#parameter-keysreleasepolicydata) | string | Blob encoding the policy rules under which the key can be released. |

### Parameter: `keys.releasePolicy.contentType`

Content type and version of key release policy.

- Required: No
- Type: string

### Parameter: `keys.releasePolicy.data`

Blob encoding the policy rules under which the key can be released.

- Required: No
- Type: string

### Parameter: `keys.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Key Vault Administrator'`
  - `'Key Vault Contributor'`
  - `'Key Vault Crypto Officer'`
  - `'Key Vault Crypto Service Encryption User'`
  - `'Key Vault Crypto User'`
  - `'Key Vault Reader'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-keysroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-keysroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-keysroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-keysroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-keysroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-keysroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-keysroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-keysroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `keys.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `keys.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `keys.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `keys.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `keys.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `keys.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `keys.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `keys.roleAssignments.principalType`

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

### Parameter: `keys.rotationPolicy`

Key rotation policy.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`attributes`](#parameter-keysrotationpolicyattributes) | object | The attributes of key rotation policy. |
| [`lifetimeActions`](#parameter-keysrotationpolicylifetimeactions) | array | The lifetimeActions for key rotation action. |

### Parameter: `keys.rotationPolicy.attributes`

The attributes of key rotation policy.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`expiryTime`](#parameter-keysrotationpolicyattributesexpirytime) | string | The expiration time for the new key version. It should be in ISO8601 format. Eg: "P90D", "P1Y". |

### Parameter: `keys.rotationPolicy.attributes.expiryTime`

The expiration time for the new key version. It should be in ISO8601 format. Eg: "P90D", "P1Y".

- Required: No
- Type: string

### Parameter: `keys.rotationPolicy.lifetimeActions`

The lifetimeActions for key rotation action.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`action`](#parameter-keysrotationpolicylifetimeactionsaction) | object | The action of key rotation policy lifetimeAction. |
| [`trigger`](#parameter-keysrotationpolicylifetimeactionstrigger) | object | The trigger of key rotation policy lifetimeAction. |

### Parameter: `keys.rotationPolicy.lifetimeActions.action`

The action of key rotation policy lifetimeAction.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`type`](#parameter-keysrotationpolicylifetimeactionsactiontype) | string | The type of action. |

### Parameter: `keys.rotationPolicy.lifetimeActions.action.type`

The type of action.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Notify'
    'Rotate'
  ]
  ```

### Parameter: `keys.rotationPolicy.lifetimeActions.trigger`

The trigger of key rotation policy lifetimeAction.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`timeAfterCreate`](#parameter-keysrotationpolicylifetimeactionstriggertimeaftercreate) | string | The time duration after key creation to rotate the key. It only applies to rotate. It will be in ISO 8601 duration format. Eg: "P90D", "P1Y". |
| [`timeBeforeExpiry`](#parameter-keysrotationpolicylifetimeactionstriggertimebeforeexpiry) | string | The time duration before key expiring to rotate or notify. It will be in ISO 8601 duration format. Eg: "P90D", "P1Y". |

### Parameter: `keys.rotationPolicy.lifetimeActions.trigger.timeAfterCreate`

The time duration after key creation to rotate the key. It only applies to rotate. It will be in ISO 8601 duration format. Eg: "P90D", "P1Y".

- Required: No
- Type: string

### Parameter: `keys.rotationPolicy.lifetimeActions.trigger.timeBeforeExpiry`

The time duration before key expiring to rotate or notify. It will be in ISO 8601 duration format. Eg: "P90D", "P1Y".

- Required: No
- Type: string

### Parameter: `keys.tags`

Resource tags.

- Required: No
- Type: object

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

### Parameter: `networkAcls`

Rules governing the accessibility of the resource from specific network locations.

- Required: No
- Type: object

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

### Parameter: `publicNetworkAccess`

Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and networkAcls are not set.

- Required: No
- Type: string
- Default: `''`
- Allowed:
  ```Bicep
  [
    ''
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Key Vault Administrator'`
  - `'Key Vault Certificates Officer'`
  - `'Key Vault Certificate User'`
  - `'Key Vault Contributor'`
  - `'Key Vault Crypto Officer'`
  - `'Key Vault Crypto Service Encryption User'`
  - `'Key Vault Crypto User'`
  - `'Key Vault Reader'`
  - `'Key Vault Secrets Officer'`
  - `'Key Vault Secrets User'`
  - `'Owner'`
  - `'Reader'`
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

### Parameter: `secrets`

All secrets to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-secretsname) | string | The name of the secret. |
| [`value`](#parameter-secretsvalue) | securestring | The value of the secret. NOTE: "value" will never be returned from the service, as APIs using this model are is intended for internal use in ARM deployments. Users should use the data-plane REST service for interaction with vault secrets. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`attributes`](#parameter-secretsattributes) | object | Contains attributes of the secret. |
| [`contentType`](#parameter-secretscontenttype) | string | The content type of the secret. |
| [`roleAssignments`](#parameter-secretsroleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-secretstags) | object | Resource tags. |

### Parameter: `secrets.name`

The name of the secret.

- Required: Yes
- Type: string

### Parameter: `secrets.value`

The value of the secret. NOTE: "value" will never be returned from the service, as APIs using this model are is intended for internal use in ARM deployments. Users should use the data-plane REST service for interaction with vault secrets.

- Required: Yes
- Type: securestring

### Parameter: `secrets.attributes`

Contains attributes of the secret.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-secretsattributesenabled) | bool | Defines whether the secret is enabled or disabled. |
| [`exp`](#parameter-secretsattributesexp) | int | Defines when the secret will become invalid. Defined in seconds since 1970-01-01T00:00:00Z. |
| [`nbf`](#parameter-secretsattributesnbf) | int | If set, defines the date from which onwards the secret becomes valid. Defined in seconds since 1970-01-01T00:00:00Z. |

### Parameter: `secrets.attributes.enabled`

Defines whether the secret is enabled or disabled.

- Required: No
- Type: bool

### Parameter: `secrets.attributes.exp`

Defines when the secret will become invalid. Defined in seconds since 1970-01-01T00:00:00Z.

- Required: No
- Type: int

### Parameter: `secrets.attributes.nbf`

If set, defines the date from which onwards the secret becomes valid. Defined in seconds since 1970-01-01T00:00:00Z.

- Required: No
- Type: int

### Parameter: `secrets.contentType`

The content type of the secret.

- Required: No
- Type: string

### Parameter: `secrets.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Key Vault Administrator'`
  - `'Key Vault Contributor'`
  - `'Key Vault Reader'`
  - `'Key Vault Secrets Officer'`
  - `'Key Vault Secrets User'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-secretsroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-secretsroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-secretsroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-secretsroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-secretsroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-secretsroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-secretsroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-secretsroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `secrets.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `secrets.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `secrets.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `secrets.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `secrets.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `secrets.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `secrets.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `secrets.roleAssignments.principalType`

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

### Parameter: `secrets.tags`

Resource tags.

- Required: No
- Type: object

### Parameter: `sku`

Specifies the SKU for the vault.

- Required: No
- Type: string
- Default: `'premium'`
- Allowed:
  ```Bicep
  [
    'premium'
    'standard'
  ]
  ```

### Parameter: `softDeleteRetentionInDays`

softDelete data retention days. It accepts >=7 and <=90.

- Required: No
- Type: int
- Default: `90`

### Parameter: `tags`

Resource tags.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `keys` | array | The properties of the created keys. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the key vault. |
| `privateEndpoints` | array | The private endpoints of the key vault. |
| `resourceGroupName` | string | The name of the resource group the key vault was created in. |
| `resourceId` | string | The resource ID of the key vault. |
| `secrets` | array | The properties of the created secrets. |
| `uri` | string | The URI of the key vault. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/network/private-endpoint:0.9.0` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
