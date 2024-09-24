# Service Bus Namespaces `[Microsoft.ServiceBus/namespaces]`

This module deploys a Service Bus Namespace.

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
| `Microsoft.Network/privateEndpoints` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.ServiceBus/namespaces` | [2022-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2022-10-01-preview/namespaces) |
| `Microsoft.ServiceBus/namespaces/AuthorizationRules` | [2022-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2022-10-01-preview/namespaces/AuthorizationRules) |
| `Microsoft.ServiceBus/namespaces/disasterRecoveryConfigs` | [2022-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2022-10-01-preview/namespaces/disasterRecoveryConfigs) |
| `Microsoft.ServiceBus/namespaces/migrationConfigurations` | [2022-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2022-10-01-preview/namespaces/migrationConfigurations) |
| `Microsoft.ServiceBus/namespaces/networkRuleSets` | [2022-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2022-10-01-preview/namespaces/networkRuleSets) |
| `Microsoft.ServiceBus/namespaces/queues` | [2022-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2022-10-01-preview/namespaces/queues) |
| `Microsoft.ServiceBus/namespaces/queues/authorizationRules` | [2022-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2022-10-01-preview/namespaces/queues/authorizationRules) |
| `Microsoft.ServiceBus/namespaces/topics` | [2022-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2022-10-01-preview/namespaces/topics) |
| `Microsoft.ServiceBus/namespaces/topics/authorizationRules` | [2022-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2022-10-01-preview/namespaces/topics/authorizationRules) |
| `Microsoft.ServiceBus/namespaces/topics/subscriptions` | [2021-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2021-11-01/namespaces/topics/subscriptions) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/service-bus/namespace:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using encryption parameter set](#example-2-using-encryption-parameter-set)
- [Using large parameter set](#example-3-using-large-parameter-set)
- [WAF-aligned](#example-4-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module namespace 'br/public:avm/res/service-bus/namespace:<version>' = {
  name: 'namespaceDeployment'
  params: {
    // Required parameters
    name: 'sbnmin001'
    // Non-required parameters
    location: '<location>'
    skuObject: {
      capacity: 2
      name: 'Premium'
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "sbnmin001"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "skuObject": {
      "value": {
        "capacity": 2,
        "name": "Premium"
      }
    }
  }
}
```

</details>
<p>

### Example 2: _Using encryption parameter set_

This instance deploys the module with features enabled for CMK encryption.


<details>

<summary>via Bicep module</summary>

```bicep
module namespace 'br/public:avm/res/service-bus/namespace:<version>' = {
  name: 'namespaceDeployment'
  params: {
    // Required parameters
    name: 'sbnencr001'
    // Non-required parameters
    customerManagedKey: {
      keyName: '<keyName>'
      keyVaultResourceId: '<keyVaultResourceId>'
      userAssignedIdentityResourceId: '<userAssignedIdentityResourceId>'
    }
    location: '<location>'
    managedIdentities: {
      systemAssigned: false
      userAssignedResourcesIds: [
        '<managedIdentityResourceId>'
      ]
    }
    skuObject: {
      capacity: 1
      name: 'Premium'
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "sbnencr001"
    },
    // Non-required parameters
    "customerManagedKey": {
      "value": {
        "keyName": "<keyName>",
        "keyVaultResourceId": "<keyVaultResourceId>",
        "userAssignedIdentityResourceId": "<userAssignedIdentityResourceId>"
      }
    },
    "location": {
      "value": "<location>"
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": false,
        "userAssignedResourcesIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "skuObject": {
      "value": {
        "capacity": 1,
        "name": "Premium"
      }
    }
  }
}
```

</details>
<p>

### Example 3: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module namespace 'br/public:avm/res/service-bus/namespace:<version>' = {
  name: 'namespaceDeployment'
  params: {
    // Required parameters
    name: 'sbnmax001'
    // Non-required parameters
    authorizationRules: [
      {
        name: 'RootManageSharedAccessKey'
        rights: [
          'Listen'
          'Manage'
          'Send'
        ]
      }
      {
        name: 'AnotherKey'
        rights: [
          'Listen'
          'Send'
        ]
      }
    ]
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        logCategoriesAndGroups: [
          {
            category: 'RuntimeAuditLogs'
          }
        ]
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'diagnosticsetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    disableLocalAuth: true
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    managedIdentities: {
      systemAssigned: true
      userAssignedResourcesIds: [
        '<managedIdentityResourceId>'
      ]
    }
    minimumTlsVersion: '1.2'
    networkRuleSets: {
      defaultAction: 'Deny'
      ipRules: [
        {
          action: 'Allow'
          ipMask: '10.0.1.0/32'
        }
        {
          action: 'Allow'
          ipMask: '10.0.2.0/32'
        }
      ]
      trustedServiceAccessEnabled: true
      virtualNetworkRules: [
        {
          ignoreMissingVnetServiceEndpoint: true
          subnetResourceId: '<subnetResourceId>'
        }
      ]
    }
    premiumMessagingPartitions: 1
    privateEndpoints: [
      {
        customDnsConfigs: [
          {
            fqdn: 'abc.namespace.com'
            ipAddresses: [
              '10.0.0.10'
            ]
          }
        ]
        ipConfigurations: [
          {
            name: 'myIPconfig'
            properties: {
              groupId: 'namespace'
              memberName: 'namespace'
              privateIPAddress: '10.0.0.10'
            }
          }
        ]
        name: 'myPrivateEndpoint'
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        privateLinkServiceConnectionName: 'customLinkName'
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
    publicNetworkAccess: 'Enabled'
    queues: [
      {
        authorizationRules: [
          {
            name: 'RootManageSharedAccessKey'
            rights: [
              'Listen'
              'Manage'
              'Send'
            ]
          }
          {
            name: 'AnotherKey'
            rights: [
              'Listen'
              'Send'
            ]
          }
        ]
        autoDeleteOnIdle: 'PT5M'
        maxMessageSizeInKilobytes: 2048
        name: 'sbnmaxq001'
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
      }
    ]
    roleAssignments: [
      {
        name: '2c42f915-20bf-4094-ba42-fee1f811d374'
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
    skuObject: {
      capacity: 16
      name: 'Premium'
    }
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    topics: [
      {
        authorizationRules: [
          {
            name: 'RootManageSharedAccessKey'
            rights: [
              'Listen'
              'Manage'
              'Send'
            ]
          }
          {
            name: 'AnotherKey'
            rights: [
              'Listen'
              'Send'
            ]
          }
        ]
        name: 'sbnmaxt001'
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
        subscriptions: [
          {
            name: 'subscription001'
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

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "sbnmax001"
    },
    // Non-required parameters
    "authorizationRules": {
      "value": [
        {
          "name": "RootManageSharedAccessKey",
          "rights": [
            "Listen",
            "Manage",
            "Send"
          ]
        },
        {
          "name": "AnotherKey",
          "rights": [
            "Listen",
            "Send"
          ]
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
              "category": "RuntimeAuditLogs"
            }
          ],
          "metricCategories": [
            {
              "category": "AllMetrics"
            }
          ],
          "name": "diagnosticsetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "disableLocalAuth": {
      "value": true
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
    "managedIdentities": {
      "value": {
        "systemAssigned": true,
        "userAssignedResourcesIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "minimumTlsVersion": {
      "value": "1.2"
    },
    "networkRuleSets": {
      "value": {
        "defaultAction": "Deny",
        "ipRules": [
          {
            "action": "Allow",
            "ipMask": "10.0.1.0/32"
          },
          {
            "action": "Allow",
            "ipMask": "10.0.2.0/32"
          }
        ],
        "trustedServiceAccessEnabled": true,
        "virtualNetworkRules": [
          {
            "ignoreMissingVnetServiceEndpoint": true,
            "subnetResourceId": "<subnetResourceId>"
          }
        ]
      }
    },
    "premiumMessagingPartitions": {
      "value": 1
    },
    "privateEndpoints": {
      "value": [
        {
          "customDnsConfigs": [
            {
              "fqdn": "abc.namespace.com",
              "ipAddresses": [
                "10.0.0.10"
              ]
            }
          ],
          "ipConfigurations": [
            {
              "name": "myIPconfig",
              "properties": {
                "groupId": "namespace",
                "memberName": "namespace",
                "privateIPAddress": "10.0.0.10"
              }
            }
          ],
          "name": "myPrivateEndpoint",
          "privateDnsZoneGroup": {
            "privateDnsZoneGroupConfigs": [
              {
                "privateDnsZoneResourceId": "<privateDnsZoneResourceId>"
              }
            ]
          },
          "privateLinkServiceConnectionName": "customLinkName",
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
    "publicNetworkAccess": {
      "value": "Enabled"
    },
    "queues": {
      "value": [
        {
          "authorizationRules": [
            {
              "name": "RootManageSharedAccessKey",
              "rights": [
                "Listen",
                "Manage",
                "Send"
              ]
            },
            {
              "name": "AnotherKey",
              "rights": [
                "Listen",
                "Send"
              ]
            }
          ],
          "autoDeleteOnIdle": "PT5M",
          "maxMessageSizeInKilobytes": 2048,
          "name": "sbnmaxq001",
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
          ]
        }
      ]
    },
    "roleAssignments": {
      "value": [
        {
          "name": "2c42f915-20bf-4094-ba42-fee1f811d374",
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
    "skuObject": {
      "value": {
        "capacity": 16,
        "name": "Premium"
      }
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "topics": {
      "value": [
        {
          "authorizationRules": [
            {
              "name": "RootManageSharedAccessKey",
              "rights": [
                "Listen",
                "Manage",
                "Send"
              ]
            },
            {
              "name": "AnotherKey",
              "rights": [
                "Listen",
                "Send"
              ]
            }
          ],
          "name": "sbnmaxt001",
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
          "subscriptions": [
            {
              "name": "subscription001"
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

### Example 4: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module namespace 'br/public:avm/res/service-bus/namespace:<version>' = {
  name: 'namespaceDeployment'
  params: {
    // Required parameters
    name: 'sbnwaf001'
    // Non-required parameters
    authorizationRules: [
      {
        name: 'RootManageSharedAccessKey'
        rights: [
          'Listen'
          'Manage'
          'Send'
        ]
      }
      {
        name: 'AnotherKey'
        rights: [
          'Listen'
          'Send'
        ]
      }
    ]
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    disableLocalAuth: true
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    managedIdentities: {
      systemAssigned: true
      userAssignedResourcesIds: [
        '<managedIdentityResourceId>'
      ]
    }
    minimumTlsVersion: '1.2'
    networkRuleSets: {
      defaultAction: 'Deny'
      ipRules: [
        {
          action: 'Allow'
          ipMask: '10.0.1.0/32'
        }
        {
          action: 'Allow'
          ipMask: '10.0.2.0/32'
        }
      ]
      trustedServiceAccessEnabled: true
      virtualNetworkRules: [
        {
          ignoreMissingVnetServiceEndpoint: true
          subnetResourceId: '<subnetResourceId>'
        }
      ]
    }
    premiumMessagingPartitions: 1
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        service: 'namespace'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
    ]
    publicNetworkAccess: 'Enabled'
    queues: [
      {
        authorizationRules: [
          {
            name: 'RootManageSharedAccessKey'
            rights: [
              'Listen'
              'Manage'
              'Send'
            ]
          }
          {
            name: 'AnotherKey'
            rights: [
              'Listen'
              'Send'
            ]
          }
        ]
        autoDeleteOnIdle: 'PT5M'
        maxMessageSizeInKilobytes: 2048
        name: 'sbnwafq001'
        roleAssignments: []
      }
    ]
    roleAssignments: []
    skuObject: {
      capacity: 2
      name: 'Premium'
    }
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    topics: [
      {
        authorizationRules: [
          {
            name: 'RootManageSharedAccessKey'
            rights: [
              'Listen'
              'Manage'
              'Send'
            ]
          }
          {
            name: 'AnotherKey'
            rights: [
              'Listen'
              'Send'
            ]
          }
        ]
        name: 'sbnwaft001'
        roleAssignments: []
      }
    ]
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "sbnwaf001"
    },
    // Non-required parameters
    "authorizationRules": {
      "value": [
        {
          "name": "RootManageSharedAccessKey",
          "rights": [
            "Listen",
            "Manage",
            "Send"
          ]
        },
        {
          "name": "AnotherKey",
          "rights": [
            "Listen",
            "Send"
          ]
        }
      ]
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
    "disableLocalAuth": {
      "value": true
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
    "managedIdentities": {
      "value": {
        "systemAssigned": true,
        "userAssignedResourcesIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "minimumTlsVersion": {
      "value": "1.2"
    },
    "networkRuleSets": {
      "value": {
        "defaultAction": "Deny",
        "ipRules": [
          {
            "action": "Allow",
            "ipMask": "10.0.1.0/32"
          },
          {
            "action": "Allow",
            "ipMask": "10.0.2.0/32"
          }
        ],
        "trustedServiceAccessEnabled": true,
        "virtualNetworkRules": [
          {
            "ignoreMissingVnetServiceEndpoint": true,
            "subnetResourceId": "<subnetResourceId>"
          }
        ]
      }
    },
    "premiumMessagingPartitions": {
      "value": 1
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
          "service": "namespace",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        }
      ]
    },
    "publicNetworkAccess": {
      "value": "Enabled"
    },
    "queues": {
      "value": [
        {
          "authorizationRules": [
            {
              "name": "RootManageSharedAccessKey",
              "rights": [
                "Listen",
                "Manage",
                "Send"
              ]
            },
            {
              "name": "AnotherKey",
              "rights": [
                "Listen",
                "Send"
              ]
            }
          ],
          "autoDeleteOnIdle": "PT5M",
          "maxMessageSizeInKilobytes": 2048,
          "name": "sbnwafq001",
          "roleAssignments": []
        }
      ]
    },
    "roleAssignments": {
      "value": []
    },
    "skuObject": {
      "value": {
        "capacity": 2,
        "name": "Premium"
      }
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "topics": {
      "value": [
        {
          "authorizationRules": [
            {
              "name": "RootManageSharedAccessKey",
              "rights": [
                "Listen",
                "Manage",
                "Send"
              ]
            },
            {
              "name": "AnotherKey",
              "rights": [
                "Listen",
                "Send"
              ]
            }
          ],
          "name": "sbnwaft001",
          "roleAssignments": []
        }
      ]
    }
  }
}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Service Bus Namespace. |
| [`skuObject`](#parameter-skuobject) | object | The SKU of the Service Bus Namespace. Defaulted to Premium for ZoneRedundant configurations by default. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`alternateName`](#parameter-alternatename) | string | Alternate name for namespace. |
| [`authorizationRules`](#parameter-authorizationrules) | array | Authorization Rules for the Service Bus namespace. |
| [`customerManagedKey`](#parameter-customermanagedkey) | object | The customer managed key definition. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`disableLocalAuth`](#parameter-disablelocalauth) | bool | This property disables SAS authentication for the Service Bus namespace. |
| [`disasterRecoveryConfig`](#parameter-disasterrecoveryconfig) | object | The disaster recovery configuration. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`migrationConfiguration`](#parameter-migrationconfiguration) | object | The migration configuration. |
| [`minimumTlsVersion`](#parameter-minimumtlsversion) | string | The minimum TLS version for the cluster to support. |
| [`networkRuleSets`](#parameter-networkrulesets) | object | Configure networking options for Premium SKU Service Bus. This object contains IPs/Subnets to allow or restrict access to private endpoints only. For security reasons, it is recommended to configure this object on the Namespace. |
| [`premiumMessagingPartitions`](#parameter-premiummessagingpartitions) | int | The number of partitions of a Service Bus namespace. This property is only applicable to Premium SKU namespaces. The default value is 1 and possible values are 1, 2 and 4. |
| [`privateEndpoints`](#parameter-privateendpoints) | array | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set. |
| [`queues`](#parameter-queues) | array | The queues to create in the service bus namespace. |
| [`requireInfrastructureEncryption`](#parameter-requireinfrastructureencryption) | bool | Enable infrastructure encryption (double encryption). Note, this setting requires the configuration of Customer-Managed-Keys (CMK) via the corresponding module parameters. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`topics`](#parameter-topics) | array | The topics to create in the service bus namespace. |
| [`zoneRedundant`](#parameter-zoneredundant) | bool | Enabled by default in order to align with resiliency best practices, thus requires Premium SKU. |

### Parameter: `name`

Name of the Service Bus Namespace.

- Required: Yes
- Type: string

### Parameter: `skuObject`

The SKU of the Service Bus Namespace. Defaulted to Premium for ZoneRedundant configurations by default.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      capacity: 2
      name: 'Premium'
  }
  ```

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-skuobjectname) | string | Name of this SKU. - Basic, Standard, Premium. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`capacity`](#parameter-skuobjectcapacity) | int | The specified messaging units for the tier. Only used for Premium Sku tier. |

### Parameter: `skuObject.name`

Name of this SKU. - Basic, Standard, Premium.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Basic'
    'Premium'
    'Standard'
  ]
  ```

### Parameter: `skuObject.capacity`

The specified messaging units for the tier. Only used for Premium Sku tier.

- Required: No
- Type: int

### Parameter: `alternateName`

Alternate name for namespace.

- Required: No
- Type: string

### Parameter: `authorizationRules`

Authorization Rules for the Service Bus namespace.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    {
      name: 'RootManageSharedAccessKey'
      rights: [
        'Listen'
        'Manage'
        'Send'
      ]
    }
  ]
  ```

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-authorizationrulesname) | string | The name of the authorization rule. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`rights`](#parameter-authorizationrulesrights) | array | The rights associated with the rule. |

### Parameter: `authorizationRules.name`

The name of the authorization rule.

- Required: Yes
- Type: string

### Parameter: `authorizationRules.rights`

The rights associated with the rule.

- Required: No
- Type: array
- Allowed:
  ```Bicep
  [
    'Listen'
    'Manage'
    'Send'
  ]
  ```

### Parameter: `customerManagedKey`

The customer managed key definition.

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
| [`keyVersion`](#parameter-customermanagedkeykeyversion) | string | The version of the customer managed key to reference for encryption. If not provided, using 'latest'. |
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

The version of the customer managed key to reference for encryption. If not provided, using 'latest'.

- Required: No
- Type: string

### Parameter: `customerManagedKey.userAssignedIdentityResourceId`

User assigned identity to use when fetching the customer managed key. Required if no system assigned identity is available for use.

- Required: No
- Type: string

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

### Parameter: `disableLocalAuth`

This property disables SAS authentication for the Service Bus namespace.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `disasterRecoveryConfig`

The disaster recovery configuration.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`alternateName`](#parameter-disasterrecoveryconfigalternatename) | string | Primary/Secondary eventhub namespace name, which is part of GEO DR pairing. |
| [`name`](#parameter-disasterrecoveryconfigname) | string | The name of the disaster recovery config. |
| [`partnerNamespace`](#parameter-disasterrecoveryconfigpartnernamespace) | string | Resource ID of the Primary/Secondary event hub namespace name, which is part of GEO DR pairing. |

### Parameter: `disasterRecoveryConfig.alternateName`

Primary/Secondary eventhub namespace name, which is part of GEO DR pairing.

- Required: No
- Type: string

### Parameter: `disasterRecoveryConfig.name`

The name of the disaster recovery config.

- Required: No
- Type: string

### Parameter: `disasterRecoveryConfig.partnerNamespace`

Resource ID of the Primary/Secondary event hub namespace name, which is part of GEO DR pairing.

- Required: No
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

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

### Parameter: `managedIdentities`

The managed identity definition for this resource.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`systemAssigned`](#parameter-managedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. |
| [`userAssignedResourcesIds`](#parameter-managedidentitiesuserassignedresourcesids) | array | The resource ID(s) to assign to the resource. |

### Parameter: `managedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `managedIdentities.userAssignedResourcesIds`

The resource ID(s) to assign to the resource.

- Required: No
- Type: array

### Parameter: `migrationConfiguration`

The migration configuration.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`postMigrationName`](#parameter-migrationconfigurationpostmigrationname) | string | Name to access Standard Namespace after migration. |
| [`targetNamespace`](#parameter-migrationconfigurationtargetnamespace) | string | Existing premium Namespace resource ID which has no entities, will be used for migration. |

### Parameter: `migrationConfiguration.postMigrationName`

Name to access Standard Namespace after migration.

- Required: Yes
- Type: string

### Parameter: `migrationConfiguration.targetNamespace`

Existing premium Namespace resource ID which has no entities, will be used for migration.

- Required: Yes
- Type: string

### Parameter: `minimumTlsVersion`

The minimum TLS version for the cluster to support.

- Required: No
- Type: string
- Default: `'1.2'`
- Allowed:
  ```Bicep
  [
    '1.0'
    '1.1'
    '1.2'
  ]
  ```

### Parameter: `networkRuleSets`

Configure networking options for Premium SKU Service Bus. This object contains IPs/Subnets to allow or restrict access to private endpoints only. For security reasons, it is recommended to configure this object on the Namespace.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`defaultAction`](#parameter-networkrulesetsdefaultaction) | string | Default Action for Network Rule Set. Default is "Allow". It will not be set if publicNetworkAccess is "Disabled". Otherwise, it will be set to "Deny" if ipRules or virtualNetworkRules are being used. |
| [`ipRules`](#parameter-networkrulesetsiprules) | array | List of IpRules. It will not be set if publicNetworkAccess is "Disabled". Otherwise, when used, defaultAction will be set to "Deny". |
| [`publicNetworkAccess`](#parameter-networkrulesetspublicnetworkaccess) | string | This determines if traffic is allowed over public network. Default is "Enabled". If set to "Disabled", traffic to this namespace will be restricted over Private Endpoints only and network rules will not be applied. |
| [`trustedServiceAccessEnabled`](#parameter-networkrulesetstrustedserviceaccessenabled) | bool | Value that indicates whether Trusted Service Access is enabled or not. Default is "true". It will not be set if publicNetworkAccess is "Disabled". |
| [`virtualNetworkRules`](#parameter-networkrulesetsvirtualnetworkrules) | array | List virtual network rules. It will not be set if publicNetworkAccess is "Disabled". Otherwise, when used, defaultAction will be set to "Deny". |

### Parameter: `networkRuleSets.defaultAction`

Default Action for Network Rule Set. Default is "Allow". It will not be set if publicNetworkAccess is "Disabled". Otherwise, it will be set to "Deny" if ipRules or virtualNetworkRules are being used.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Allow'
    'Deny'
  ]
  ```

### Parameter: `networkRuleSets.ipRules`

List of IpRules. It will not be set if publicNetworkAccess is "Disabled". Otherwise, when used, defaultAction will be set to "Deny".

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`action`](#parameter-networkrulesetsiprulesaction) | string | The IP filter action. |
| [`ipMask`](#parameter-networkrulesetsiprulesipmask) | string | The IP mask. |

### Parameter: `networkRuleSets.ipRules.action`

The IP filter action.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Allow'
    'Deny'
  ]
  ```

### Parameter: `networkRuleSets.ipRules.ipMask`

The IP mask.

- Required: Yes
- Type: string

### Parameter: `networkRuleSets.publicNetworkAccess`

This determines if traffic is allowed over public network. Default is "Enabled". If set to "Disabled", traffic to this namespace will be restricted over Private Endpoints only and network rules will not be applied.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `networkRuleSets.trustedServiceAccessEnabled`

Value that indicates whether Trusted Service Access is enabled or not. Default is "true". It will not be set if publicNetworkAccess is "Disabled".

- Required: No
- Type: bool

### Parameter: `networkRuleSets.virtualNetworkRules`

List virtual network rules. It will not be set if publicNetworkAccess is "Disabled". Otherwise, when used, defaultAction will be set to "Deny".

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ignoreMissingVnetServiceEndpoint`](#parameter-networkrulesetsvirtualnetworkrulesignoremissingvnetserviceendpoint) | bool | The virtual network rule name. |
| [`subnetResourceId`](#parameter-networkrulesetsvirtualnetworkrulessubnetresourceid) | string | The ID of the subnet. |

### Parameter: `networkRuleSets.virtualNetworkRules.ignoreMissingVnetServiceEndpoint`

The virtual network rule name.

- Required: Yes
- Type: bool

### Parameter: `networkRuleSets.virtualNetworkRules.subnetResourceId`

The ID of the subnet.

- Required: Yes
- Type: string

### Parameter: `premiumMessagingPartitions`

The number of partitions of a Service Bus namespace. This property is only applicable to Premium SKU namespaces. The default value is 1 and possible values are 1, 2 and 4.

- Required: No
- Type: int
- Default: `1`

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
| [`resourceGroupName`](#parameter-privateendpointsresourcegroupname) | string | Specify if you want to deploy the Private Endpoint into a different resource group than the main resource. |
| [`roleAssignments`](#parameter-privateendpointsroleassignments) | array | Array of role assignments to create. |
| [`service`](#parameter-privateendpointsservice) | string | The subresource to deploy the private endpoint for. For example "vault", "mysqlServer" or "dataFactory". |
| [`tags`](#parameter-privateendpointstags) | object | Tags to be applied on all resources/resource groups in this deployment. |

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
| [`fqdn`](#parameter-privateendpointscustomdnsconfigsfqdn) | string | Fqdn that resolves to private endpoint IP address. |
| [`ipAddresses`](#parameter-privateendpointscustomdnsconfigsipaddresses) | array | A list of private IP addresses of the private endpoint. |

### Parameter: `privateEndpoints.customDnsConfigs.fqdn`

Fqdn that resolves to private endpoint IP address.

- Required: No
- Type: string

### Parameter: `privateEndpoints.customDnsConfigs.ipAddresses`

A list of private IP addresses of the private endpoint.

- Required: Yes
- Type: array

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
| [`privateDnsZoneGroupConfigs`](#parameter-privateendpointsprivatednszonegroupprivatednszonegroupconfigs) | array | The private DNS zone groups to associate the private endpoint. A DNS zone group can support up to 5 DNS zones. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-privateendpointsprivatednszonegroupname) | string | The name of the Private DNS Zone Group. |

### Parameter: `privateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs`

The private DNS zone groups to associate the private endpoint. A DNS zone group can support up to 5 DNS zones.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateDnsZoneResourceId`](#parameter-privateendpointsprivatednszonegroupprivatednszonegroupconfigsprivatednszoneresourceid) | string | The resource id of the private DNS zone. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-privateendpointsprivatednszonegroupprivatednszonegroupconfigsname) | string | The name of the private DNS zone group config. |

### Parameter: `privateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs.privateDnsZoneResourceId`

The resource id of the private DNS zone.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs.name`

The name of the private DNS zone group config.

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

### Parameter: `privateEndpoints.resourceGroupName`

Specify if you want to deploy the Private Endpoint into a different resource group than the main resource.

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
  - `'Role Based Access Control Administrator (Preview)'`

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

The subresource to deploy the private endpoint for. For example "vault", "mysqlServer" or "dataFactory".

- Required: No
- Type: string

### Parameter: `privateEndpoints.tags`

Tags to be applied on all resources/resource groups in this deployment.

- Required: No
- Type: object

### Parameter: `publicNetworkAccess`

Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set.

- Required: No
- Type: string
- Default: `''`
- Allowed:
  ```Bicep
  [
    ''
    'Disabled'
    'Enabled'
    'SecuredByPerimeter'
  ]
  ```

### Parameter: `queues`

The queues to create in the service bus namespace.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-queuesname) | string | The name of the queue. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authorizationRules`](#parameter-queuesauthorizationrules) | array | Authorization Rules for the Service Bus Queue. |
| [`autoDeleteOnIdle`](#parameter-queuesautodeleteonidle) | string | ISO 8061 timeSpan idle interval after which the queue is automatically deleted. The minimum duration is 5 minutes (PT5M). |
| [`deadLetteringOnMessageExpiration`](#parameter-queuesdeadletteringonmessageexpiration) | bool | A value that indicates whether this queue has dead letter support when a message expires. |
| [`defaultMessageTimeToLive`](#parameter-queuesdefaultmessagetimetolive) | string | ISO 8601 default message timespan to live value. This is the duration after which the message expires, starting from when the message is sent to Service Bus. This is the default value used when TimeToLive is not set on a message itself. |
| [`duplicateDetectionHistoryTimeWindow`](#parameter-queuesduplicatedetectionhistorytimewindow) | string | ISO 8601 timeSpan structure that defines the duration of the duplicate detection history. The default value is 10 minutes. |
| [`enableBatchedOperations`](#parameter-queuesenablebatchedoperations) | bool | Value that indicates whether server-side batched operations are enabled. |
| [`enableExpress`](#parameter-queuesenableexpress) | bool | A value that indicates whether Express Entities are enabled. An express queue holds a message in memory temporarily before writing it to persistent storage. This property is only used if the `service-bus/namespace` sku is Premium. |
| [`enablePartitioning`](#parameter-queuesenablepartitioning) | bool | A value that indicates whether the queue is to be partitioned across multiple message brokers. |
| [`forwardDeadLetteredMessagesTo`](#parameter-queuesforwarddeadletteredmessagesto) | string | Queue/Topic name to forward the Dead Letter message. |
| [`forwardTo`](#parameter-queuesforwardto) | string | Queue/Topic name to forward the messages. |
| [`lock`](#parameter-queueslock) | object | The lock settings of the service. |
| [`lockDuration`](#parameter-queueslockduration) | string | ISO 8601 timespan duration of a peek-lock; that is, the amount of time that the message is locked for other receivers. The maximum value for LockDuration is 5 minutes; the default value is 1 minute. |
| [`maxDeliveryCount`](#parameter-queuesmaxdeliverycount) | int | The maximum delivery count. A message is automatically deadlettered after this number of deliveries. default value is 10. |
| [`maxMessageSizeInKilobytes`](#parameter-queuesmaxmessagesizeinkilobytes) | int | Maximum size (in KB) of the message payload that can be accepted by the queue. This property is only used in Premium today and default is 1024. |
| [`maxSizeInMegabytes`](#parameter-queuesmaxsizeinmegabytes) | int | The maximum size of the queue in megabytes, which is the size of memory allocated for the queue. Default is 1024. |
| [`requiresDuplicateDetection`](#parameter-queuesrequiresduplicatedetection) | bool | A value indicating if this queue requires duplicate detection. |
| [`requiresSession`](#parameter-queuesrequiressession) | bool | A value that indicates whether the queue supports the concept of sessions. |
| [`roleAssignments`](#parameter-queuesroleassignments) | array | Array of role assignments to create. |
| [`status`](#parameter-queuesstatus) | string | Enumerates the possible values for the status of a messaging entity. - Active, Disabled, Restoring, SendDisabled, ReceiveDisabled, Creating, Deleting, Renaming, Unknown. |

### Parameter: `queues.name`

The name of the queue.

- Required: Yes
- Type: string

### Parameter: `queues.authorizationRules`

Authorization Rules for the Service Bus Queue.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-queuesauthorizationrulesname) | string | The name of the authorization rule. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`rights`](#parameter-queuesauthorizationrulesrights) | array | The rights associated with the rule. |

### Parameter: `queues.authorizationRules.name`

The name of the authorization rule.

- Required: Yes
- Type: string

### Parameter: `queues.authorizationRules.rights`

The rights associated with the rule.

- Required: No
- Type: array
- Allowed:
  ```Bicep
  [
    'Listen'
    'Manage'
    'Send'
  ]
  ```

### Parameter: `queues.autoDeleteOnIdle`

ISO 8061 timeSpan idle interval after which the queue is automatically deleted. The minimum duration is 5 minutes (PT5M).

- Required: No
- Type: string

### Parameter: `queues.deadLetteringOnMessageExpiration`

A value that indicates whether this queue has dead letter support when a message expires.

- Required: No
- Type: bool

### Parameter: `queues.defaultMessageTimeToLive`

ISO 8601 default message timespan to live value. This is the duration after which the message expires, starting from when the message is sent to Service Bus. This is the default value used when TimeToLive is not set on a message itself.

- Required: No
- Type: string

### Parameter: `queues.duplicateDetectionHistoryTimeWindow`

ISO 8601 timeSpan structure that defines the duration of the duplicate detection history. The default value is 10 minutes.

- Required: No
- Type: string

### Parameter: `queues.enableBatchedOperations`

Value that indicates whether server-side batched operations are enabled.

- Required: No
- Type: bool

### Parameter: `queues.enableExpress`

A value that indicates whether Express Entities are enabled. An express queue holds a message in memory temporarily before writing it to persistent storage. This property is only used if the `service-bus/namespace` sku is Premium.

- Required: No
- Type: bool

### Parameter: `queues.enablePartitioning`

A value that indicates whether the queue is to be partitioned across multiple message brokers.

- Required: No
- Type: bool

### Parameter: `queues.forwardDeadLetteredMessagesTo`

Queue/Topic name to forward the Dead Letter message.

- Required: No
- Type: string

### Parameter: `queues.forwardTo`

Queue/Topic name to forward the messages.

- Required: No
- Type: string

### Parameter: `queues.lock`

The lock settings of the service.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-queueslockkind) | string | Specify the type of lock. |
| [`name`](#parameter-queueslockname) | string | Specify the name of lock. |

### Parameter: `queues.lock.kind`

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

### Parameter: `queues.lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `queues.lockDuration`

ISO 8601 timespan duration of a peek-lock; that is, the amount of time that the message is locked for other receivers. The maximum value for LockDuration is 5 minutes; the default value is 1 minute.

- Required: No
- Type: string

### Parameter: `queues.maxDeliveryCount`

The maximum delivery count. A message is automatically deadlettered after this number of deliveries. default value is 10.

- Required: No
- Type: int

### Parameter: `queues.maxMessageSizeInKilobytes`

Maximum size (in KB) of the message payload that can be accepted by the queue. This property is only used in Premium today and default is 1024.

- Required: No
- Type: int

### Parameter: `queues.maxSizeInMegabytes`

The maximum size of the queue in megabytes, which is the size of memory allocated for the queue. Default is 1024.

- Required: No
- Type: int

### Parameter: `queues.requiresDuplicateDetection`

A value indicating if this queue requires duplicate detection.

- Required: No
- Type: bool

### Parameter: `queues.requiresSession`

A value that indicates whether the queue supports the concept of sessions.

- Required: No
- Type: bool

### Parameter: `queues.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Azure Service Bus Data Owner'`
  - `'Azure Service Bus Data Receiver'`
  - `'Azure Service Bus Data Sender'`
  - `'Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-queuesroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-queuesroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-queuesroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-queuesroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-queuesroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-queuesroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-queuesroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-queuesroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `queues.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `queues.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `queues.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `queues.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `queues.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `queues.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `queues.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `queues.roleAssignments.principalType`

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

### Parameter: `queues.status`

Enumerates the possible values for the status of a messaging entity. - Active, Disabled, Restoring, SendDisabled, ReceiveDisabled, Creating, Deleting, Renaming, Unknown.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Active'
    'Creating'
    'Deleting'
    'Disabled'
    'ReceiveDisabled'
    'Renaming'
    'Restoring'
    'SendDisabled'
    'Unknown'
  ]
  ```

### Parameter: `requireInfrastructureEncryption`

Enable infrastructure encryption (double encryption). Note, this setting requires the configuration of Customer-Managed-Keys (CMK) via the corresponding module parameters.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Azure Service Bus Data Owner'`
  - `'Azure Service Bus Data Receiver'`
  - `'Azure Service Bus Data Sender'`
  - `'Contributor'`
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

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `topics`

The topics to create in the service bus namespace.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-topicsname) | string | The name of the topic. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authorizationRules`](#parameter-topicsauthorizationrules) | array | Authorization Rules for the Service Bus Topic. |
| [`autoDeleteOnIdle`](#parameter-topicsautodeleteonidle) | string | ISO 8601 timespan idle interval after which the topic is automatically deleted. The minimum duration is 5 minutes. |
| [`defaultMessageTimeToLive`](#parameter-topicsdefaultmessagetimetolive) | string | ISO 8601 default message timespan to live value. This is the duration after which the message expires, starting from when the message is sent to Service Bus. This is the default value used when TimeToLive is not set on a message itself. |
| [`duplicateDetectionHistoryTimeWindow`](#parameter-topicsduplicatedetectionhistorytimewindow) | string | ISO 8601 timeSpan structure that defines the duration of the duplicate detection history. The default value is 10 minutes. |
| [`enableBatchedOperations`](#parameter-topicsenablebatchedoperations) | bool | Value that indicates whether server-side batched operations are enabled. |
| [`enableExpress`](#parameter-topicsenableexpress) | bool | A value that indicates whether Express Entities are enabled. An express topic holds a message in memory temporarily before writing it to persistent storage. This property is only used if the `service-bus/namespace` sku is Premium. |
| [`enablePartitioning`](#parameter-topicsenablepartitioning) | bool | A value that indicates whether the topic is to be partitioned across multiple message brokers. |
| [`lock`](#parameter-topicslock) | object | The lock settings of the service. |
| [`maxMessageSizeInKilobytes`](#parameter-topicsmaxmessagesizeinkilobytes) | int | Maximum size (in KB) of the message payload that can be accepted by the topic. This property is only used in Premium today and default is 1024. |
| [`maxSizeInMegabytes`](#parameter-topicsmaxsizeinmegabytes) | int | The maximum size of the topic in megabytes, which is the size of memory allocated for the topic. Default is 1024. |
| [`requiresDuplicateDetection`](#parameter-topicsrequiresduplicatedetection) | bool | A value indicating if this topic requires duplicate detection. |
| [`roleAssignments`](#parameter-topicsroleassignments) | array | Array of role assignments to create. |
| [`status`](#parameter-topicsstatus) | string | Enumerates the possible values for the status of a messaging entity. - Active, Disabled, Restoring, SendDisabled, ReceiveDisabled, Creating, Deleting, Renaming, Unknown. |
| [`subscriptions`](#parameter-topicssubscriptions) | array | The subscriptions of the topic. |
| [`supportOrdering`](#parameter-topicssupportordering) | bool | Value that indicates whether the topic supports ordering. |

### Parameter: `topics.name`

The name of the topic.

- Required: Yes
- Type: string

### Parameter: `topics.authorizationRules`

Authorization Rules for the Service Bus Topic.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-topicsauthorizationrulesname) | string | The name of the authorization rule. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`rights`](#parameter-topicsauthorizationrulesrights) | array | The rights associated with the rule. |

### Parameter: `topics.authorizationRules.name`

The name of the authorization rule.

- Required: Yes
- Type: string

### Parameter: `topics.authorizationRules.rights`

The rights associated with the rule.

- Required: No
- Type: array
- Allowed:
  ```Bicep
  [
    'Listen'
    'Manage'
    'Send'
  ]
  ```

### Parameter: `topics.autoDeleteOnIdle`

ISO 8601 timespan idle interval after which the topic is automatically deleted. The minimum duration is 5 minutes.

- Required: No
- Type: string

### Parameter: `topics.defaultMessageTimeToLive`

ISO 8601 default message timespan to live value. This is the duration after which the message expires, starting from when the message is sent to Service Bus. This is the default value used when TimeToLive is not set on a message itself.

- Required: No
- Type: string

### Parameter: `topics.duplicateDetectionHistoryTimeWindow`

ISO 8601 timeSpan structure that defines the duration of the duplicate detection history. The default value is 10 minutes.

- Required: No
- Type: string

### Parameter: `topics.enableBatchedOperations`

Value that indicates whether server-side batched operations are enabled.

- Required: No
- Type: bool

### Parameter: `topics.enableExpress`

A value that indicates whether Express Entities are enabled. An express topic holds a message in memory temporarily before writing it to persistent storage. This property is only used if the `service-bus/namespace` sku is Premium.

- Required: No
- Type: bool

### Parameter: `topics.enablePartitioning`

A value that indicates whether the topic is to be partitioned across multiple message brokers.

- Required: No
- Type: bool

### Parameter: `topics.lock`

The lock settings of the service.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-topicslockkind) | string | Specify the type of lock. |
| [`name`](#parameter-topicslockname) | string | Specify the name of lock. |

### Parameter: `topics.lock.kind`

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

### Parameter: `topics.lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `topics.maxMessageSizeInKilobytes`

Maximum size (in KB) of the message payload that can be accepted by the topic. This property is only used in Premium today and default is 1024.

- Required: No
- Type: int

### Parameter: `topics.maxSizeInMegabytes`

The maximum size of the topic in megabytes, which is the size of memory allocated for the topic. Default is 1024.

- Required: No
- Type: int

### Parameter: `topics.requiresDuplicateDetection`

A value indicating if this topic requires duplicate detection.

- Required: No
- Type: bool

### Parameter: `topics.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Azure Service Bus Data Owner'`
  - `'Azure Service Bus Data Receiver'`
  - `'Azure Service Bus Data Sender'`
  - `'Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-topicsroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-topicsroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-topicsroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-topicsroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-topicsroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-topicsroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-topicsroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-topicsroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `topics.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `topics.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `topics.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `topics.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `topics.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `topics.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `topics.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `topics.roleAssignments.principalType`

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

### Parameter: `topics.status`

Enumerates the possible values for the status of a messaging entity. - Active, Disabled, Restoring, SendDisabled, ReceiveDisabled, Creating, Deleting, Renaming, Unknown.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Active'
    'Creating'
    'Deleting'
    'Disabled'
    'ReceiveDisabled'
    'Renaming'
    'Restoring'
    'SendDisabled'
    'Unknown'
  ]
  ```

### Parameter: `topics.subscriptions`

The subscriptions of the topic.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-topicssubscriptionsname) | string | The name of the service bus namespace topic subscription. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoDeleteOnIdle`](#parameter-topicssubscriptionsautodeleteonidle) | string | ISO 8601 timespan idle interval after which the syubscription is automatically deleted. The minimum duration is 5 minutes. |
| [`clientAffineProperties`](#parameter-topicssubscriptionsclientaffineproperties) | object | The properties that are associated with a subscription that is client-affine. |
| [`deadLetteringOnFilterEvaluationExceptions`](#parameter-topicssubscriptionsdeadletteringonfilterevaluationexceptions) | bool | A value that indicates whether a subscription has dead letter support when a message expires. |
| [`deadLetteringOnMessageExpiration`](#parameter-topicssubscriptionsdeadletteringonmessageexpiration) | bool | A value that indicates whether a subscription has dead letter support when a message expires. |
| [`defaultMessageTimeToLive`](#parameter-topicssubscriptionsdefaultmessagetimetolive) | string | ISO 8601 timespan idle interval after which the message expires. The minimum duration is 5 minutes. |
| [`duplicateDetectionHistoryTimeWindow`](#parameter-topicssubscriptionsduplicatedetectionhistorytimewindow) | string | ISO 8601 timespan that defines the duration of the duplicate detection history. The default value is 10 minutes. |
| [`enableBatchedOperations`](#parameter-topicssubscriptionsenablebatchedoperations) | bool | A value that indicates whether server-side batched operations are enabled. |
| [`forwardDeadLetteredMessagesTo`](#parameter-topicssubscriptionsforwarddeadletteredmessagesto) | string | The name of the recipient entity to which all the messages sent to the subscription are forwarded to. |
| [`forwardTo`](#parameter-topicssubscriptionsforwardto) | string | The name of the recipient entity to which all the messages sent to the subscription are forwarded to. |
| [`isClientAffine`](#parameter-topicssubscriptionsisclientaffine) | bool | A value that indicates whether the subscription supports the concept of session. |
| [`lockDuration`](#parameter-topicssubscriptionslockduration) | string | ISO 8601 timespan duration of a peek-lock; that is, the amount of time that the message is locked for other receivers. The maximum value for LockDuration is 5 minutes; the default value is 1 minute. |
| [`maxDeliveryCount`](#parameter-topicssubscriptionsmaxdeliverycount) | int | Number of maximum deliveries. A message is automatically deadlettered after this number of deliveries. Default value is 10. |
| [`requiresSession`](#parameter-topicssubscriptionsrequiressession) | bool | A value that indicates whether the subscription supports the concept of session. |
| [`status`](#parameter-topicssubscriptionsstatus) | string | Enumerates the possible values for the status of a messaging entity. - Active, Disabled, Restoring, SendDisabled, ReceiveDisabled, Creating, Deleting, Renaming, Unknown. |

### Parameter: `topics.subscriptions.name`

The name of the service bus namespace topic subscription.

- Required: Yes
- Type: string

### Parameter: `topics.subscriptions.autoDeleteOnIdle`

ISO 8601 timespan idle interval after which the syubscription is automatically deleted. The minimum duration is 5 minutes.

- Required: No
- Type: string

### Parameter: `topics.subscriptions.clientAffineProperties`

The properties that are associated with a subscription that is client-affine.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clientId`](#parameter-topicssubscriptionsclientaffinepropertiesclientid) | string | Indicates the Client ID of the application that created the client-affine subscription. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`isDurable`](#parameter-topicssubscriptionsclientaffinepropertiesisdurable) | bool | For client-affine subscriptions, this value indicates whether the subscription is durable or not. |
| [`isShared`](#parameter-topicssubscriptionsclientaffinepropertiesisshared) | bool | For client-affine subscriptions, this value indicates whether the subscription is shared or not. |

### Parameter: `topics.subscriptions.clientAffineProperties.clientId`

Indicates the Client ID of the application that created the client-affine subscription.

- Required: Yes
- Type: string

### Parameter: `topics.subscriptions.clientAffineProperties.isDurable`

For client-affine subscriptions, this value indicates whether the subscription is durable or not.

- Required: No
- Type: bool

### Parameter: `topics.subscriptions.clientAffineProperties.isShared`

For client-affine subscriptions, this value indicates whether the subscription is shared or not.

- Required: No
- Type: bool

### Parameter: `topics.subscriptions.deadLetteringOnFilterEvaluationExceptions`

A value that indicates whether a subscription has dead letter support when a message expires.

- Required: No
- Type: bool

### Parameter: `topics.subscriptions.deadLetteringOnMessageExpiration`

A value that indicates whether a subscription has dead letter support when a message expires.

- Required: No
- Type: bool

### Parameter: `topics.subscriptions.defaultMessageTimeToLive`

ISO 8601 timespan idle interval after which the message expires. The minimum duration is 5 minutes.

- Required: No
- Type: string

### Parameter: `topics.subscriptions.duplicateDetectionHistoryTimeWindow`

ISO 8601 timespan that defines the duration of the duplicate detection history. The default value is 10 minutes.

- Required: No
- Type: string

### Parameter: `topics.subscriptions.enableBatchedOperations`

A value that indicates whether server-side batched operations are enabled.

- Required: No
- Type: bool

### Parameter: `topics.subscriptions.forwardDeadLetteredMessagesTo`

The name of the recipient entity to which all the messages sent to the subscription are forwarded to.

- Required: No
- Type: string

### Parameter: `topics.subscriptions.forwardTo`

The name of the recipient entity to which all the messages sent to the subscription are forwarded to.

- Required: No
- Type: string

### Parameter: `topics.subscriptions.isClientAffine`

A value that indicates whether the subscription supports the concept of session.

- Required: No
- Type: bool

### Parameter: `topics.subscriptions.lockDuration`

ISO 8601 timespan duration of a peek-lock; that is, the amount of time that the message is locked for other receivers. The maximum value for LockDuration is 5 minutes; the default value is 1 minute.

- Required: No
- Type: string

### Parameter: `topics.subscriptions.maxDeliveryCount`

Number of maximum deliveries. A message is automatically deadlettered after this number of deliveries. Default value is 10.

- Required: No
- Type: int

### Parameter: `topics.subscriptions.requiresSession`

A value that indicates whether the subscription supports the concept of session.

- Required: No
- Type: bool

### Parameter: `topics.subscriptions.status`

Enumerates the possible values for the status of a messaging entity. - Active, Disabled, Restoring, SendDisabled, ReceiveDisabled, Creating, Deleting, Renaming, Unknown.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Active'
    'Creating'
    'Deleting'
    'Disabled'
    'ReceiveDisabled'
    'Renaming'
    'Restoring'
    'SendDisabled'
    'Unknown'
  ]
  ```

### Parameter: `topics.supportOrdering`

Value that indicates whether the topic supports ordering.

- Required: No
- Type: bool

### Parameter: `zoneRedundant`

Enabled by default in order to align with resiliency best practices, thus requires Premium SKU.

- Required: No
- Type: bool
- Default: `True`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed service bus namespace. |
| `privateEndpoints` | array | The private endpoints of the service bus namespace. |
| `resourceGroupName` | string | The resource group of the deployed service bus namespace. |
| `resourceId` | string | The resource ID of the deployed service bus namespace. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/network/private-endpoint:0.7.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
