# Event Grid Namespaces `[Microsoft.EventGrid/namespaces]`

This module deploys an Event Grid Namespace.

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
| `Microsoft.EventGrid/namespaces` | [2023-12-15-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventGrid/2023-12-15-preview/namespaces) |
| `Microsoft.EventGrid/namespaces/caCertificates` | [2023-12-15-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventGrid/2023-12-15-preview/namespaces/caCertificates) |
| `Microsoft.EventGrid/namespaces/clientGroups` | [2023-12-15-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventGrid/2023-12-15-preview/namespaces/clientGroups) |
| `Microsoft.EventGrid/namespaces/clients` | [2023-12-15-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventGrid/2023-12-15-preview/namespaces/clients) |
| `Microsoft.EventGrid/namespaces/permissionBindings` | [2023-12-15-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventGrid/2023-12-15-preview/namespaces/permissionBindings) |
| `Microsoft.EventGrid/namespaces/topics` | [2023-12-15-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventGrid/2023-12-15-preview/namespaces/topics) |
| `Microsoft.EventGrid/namespaces/topics/eventSubscriptions` | [2023-12-15-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventGrid/2023-12-15-preview/namespaces/topics/eventSubscriptions) |
| `Microsoft.EventGrid/namespaces/topicSpaces` | [2023-12-15-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventGrid/2023-12-15-preview/namespaces/topicSpaces) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/privateEndpoints` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints/privateDnsZoneGroups) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/event-grid/namespace:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [MQTT Broker with routing to a namespace topic](#example-3-mqtt-broker-with-routing-to-a-namespace-topic)
- [MQTT Broker with routing to a namespace topic](#example-4-mqtt-broker-with-routing-to-a-namespace-topic)
- [WAF-aligned](#example-5-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module namespace 'br/public:avm/res/event-grid/namespace:<version>' = {
  name: 'namespaceDeployment'
  params: {
    // Required parameters
    name: 'egnmin001'
    // Non-required parameters
    location: '<location>'
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
      "value": "egnmin001"
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

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module namespace 'br/public:avm/res/event-grid/namespace:<version>' = {
  name: 'namespaceDeployment'
  params: {
    // Required parameters
    name: 'egnmax001'
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
        name: 'bde32b53-e30c-41d0-a338-c637853fe524'
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
    topics: [
      {
        eventRetentionInDays: 7
        eventSubscriptions: [
          {
            deliveryConfiguration: {
              deliveryMode: 'Queue'
              queue: {
                eventTimeToLive: 'P7D'
                maxDeliveryCount: 10
                receiveLockDurationInSeconds: 60
              }
            }
            name: 'subscription1'
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
          {
            deliveryConfiguration: {
              deliveryMode: 'Push'
              push: {
                deliveryWithResourceIdentity: {
                  destination: {
                    endpointType: 'EventHub'
                    properties: {
                      deliveryAttributeMappings: [
                        {
                          name: 'StaticHeader1'
                          properties: {
                            isSecret: false
                            value: 'staticVaule'
                          }
                          type: 'Static'
                        }
                        {
                          name: 'DynamicHeader1'
                          properties: {
                            sourceField: 'id'
                          }
                          type: 'Dynamic'
                        }
                        {
                          name: 'StaticSecretHeader1'
                          properties: {
                            isSecret: true
                            value: 'Hidden'
                          }
                          type: 'Static'
                        }
                      ]
                      resourceId: '<resourceId>'
                    }
                  }
                  identity: {
                    type: 'UserAssigned'
                    userAssignedIdentity: '<userAssignedIdentity>'
                  }
                }
                eventTimeToLive: 'P7D'
                maxDeliveryCount: 10
              }
            }
            name: 'subscription2'
          }
        ]
        name: 'topic1'
      }
      {
        lock: {
          kind: 'CanNotDelete'
          name: 'myCustomLockName'
        }
        name: 'topic2'
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
      "value": "egnmax001"
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
          "name": "bde32b53-e30c-41d0-a338-c637853fe524",
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
    "topics": {
      "value": [
        {
          "eventRetentionInDays": 7,
          "eventSubscriptions": [
            {
              "deliveryConfiguration": {
                "deliveryMode": "Queue",
                "queue": {
                  "eventTimeToLive": "P7D",
                  "maxDeliveryCount": 10,
                  "receiveLockDurationInSeconds": 60
                }
              },
              "name": "subscription1",
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
            },
            {
              "deliveryConfiguration": {
                "deliveryMode": "Push",
                "push": {
                  "deliveryWithResourceIdentity": {
                    "destination": {
                      "endpointType": "EventHub",
                      "properties": {
                        "deliveryAttributeMappings": [
                          {
                            "name": "StaticHeader1",
                            "properties": {
                              "isSecret": false,
                              "value": "staticVaule"
                            },
                            "type": "Static"
                          },
                          {
                            "name": "DynamicHeader1",
                            "properties": {
                              "sourceField": "id"
                            },
                            "type": "Dynamic"
                          },
                          {
                            "name": "StaticSecretHeader1",
                            "properties": {
                              "isSecret": true,
                              "value": "Hidden"
                            },
                            "type": "Static"
                          }
                        ],
                        "resourceId": "<resourceId>"
                      }
                    },
                    "identity": {
                      "type": "UserAssigned",
                      "userAssignedIdentity": "<userAssignedIdentity>"
                    }
                  },
                  "eventTimeToLive": "P7D",
                  "maxDeliveryCount": 10
                }
              },
              "name": "subscription2"
            }
          ],
          "name": "topic1"
        },
        {
          "lock": {
            "kind": "CanNotDelete",
            "name": "myCustomLockName"
          },
          "name": "topic2",
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
    }
  }
}
```

</details>
<p>

### Example 3: _MQTT Broker with routing to a namespace topic_

This instance deploys the module as a MQTT Broker with routing to a topic within the same Eventgrid namespace.


<details>

<summary>via Bicep module</summary>

```bicep
module namespace 'br/public:avm/res/event-grid/namespace:<version>' = {
  name: 'namespaceDeployment'
  params: {
    // Required parameters
    name: 'egnmqttct001'
    // Non-required parameters
    alternativeAuthenticationNameSources: [
      'ClientCertificateEmail'
      'ClientCertificateUri'
    ]
    clientGroups: [
      {
        description: 'this is group1'
        name: 'group1'
        query: 'attributes.keyName IN [\'a\', \'b\', \'c\']'
      }
    ]
    clients: [
      {
        attributes: {
          deviceTypes: [
            'Fan'
            'Light'
          ]
          floor: 12
          room: '345'
        }
        authenticationName: 'client2auth'
        clientCertificateAuthenticationAllowedThumbprints: [
          '1111111111111111111111111111111111111111'
          '2222222222222222222222222222222222222222'
        ]
        clientCertificateAuthenticationValidationSchema: 'ThumbprintMatch'
        description: 'this is client2'
        name: 'client1'
        state: 'Enabled'
      }
      {
        clientCertificateAuthenticationAllowedThumbprints: [
          '3333333333333333333333333333333333333333'
        ]
        clientCertificateAuthenticationValidationSchema: 'ThumbprintMatch'
        name: 'client2'
      }
      {
        name: 'client3'
      }
      {
        clientCertificateAuthenticationValidationSchema: 'IpMatchesAuthenticationName'
        name: 'client4'
      }
    ]
    location: '<location>'
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    maximumClientSessionsPerAuthenticationName: 5
    maximumSessionExpiryInHours: 2
    permissionBindings: [
      {
        clientGroupName: 'group1'
        description: 'this is binding1'
        name: 'bindiing1'
        permission: 'Publisher'
        topicSpaceName: 'topicSpace1'
      }
      {
        clientGroupName: 'group1'
        name: 'bindiing2'
        permission: 'Subscriber'
        topicSpaceName: 'topicSpace2'
      }
    ]
    routeTopicResourceId: '<routeTopicResourceId>'
    routingEnrichments: {
      dynamic: [
        {
          key: 'dynamic1'
          value: '<value>'
        }
      ]
      static: [
        {
          key: 'static1'
          value: 'value1'
          valueType: 'String'
        }
        {
          key: 'static2'
          value: 'value2'
          valueType: 'String'
        }
      ]
    }
    routingIdentityInfo: {
      type: 'UserAssigned'
      userAssignedIdentity: '<userAssignedIdentity>'
    }
    topics: [
      {
        name: 'topic1'
      }
    ]
    topicSpaces: [
      {
        name: 'topicSpace1'
        topicTemplates: [
          'devices/foo/bar'
          'devices/topic1/+'
        ]
      }
      {
        name: 'topicSpace2'
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
        topicTemplates: [
          'devices/topic1/+'
        ]
      }
    ]
    topicSpacesState: 'Enabled'
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
      "value": "egnmqttct001"
    },
    // Non-required parameters
    "alternativeAuthenticationNameSources": {
      "value": [
        "ClientCertificateEmail",
        "ClientCertificateUri"
      ]
    },
    "clientGroups": {
      "value": [
        {
          "description": "this is group1",
          "name": "group1",
          "query": "attributes.keyName IN [\"a\", \"b\", \"c\"]"
        }
      ]
    },
    "clients": {
      "value": [
        {
          "attributes": {
            "deviceTypes": [
              "Fan",
              "Light"
            ],
            "floor": 12,
            "room": "345"
          },
          "authenticationName": "client2auth",
          "clientCertificateAuthenticationAllowedThumbprints": [
            "1111111111111111111111111111111111111111",
            "2222222222222222222222222222222222222222"
          ],
          "clientCertificateAuthenticationValidationSchema": "ThumbprintMatch",
          "description": "this is client2",
          "name": "client1",
          "state": "Enabled"
        },
        {
          "clientCertificateAuthenticationAllowedThumbprints": [
            "3333333333333333333333333333333333333333"
          ],
          "clientCertificateAuthenticationValidationSchema": "ThumbprintMatch",
          "name": "client2"
        },
        {
          "name": "client3"
        },
        {
          "clientCertificateAuthenticationValidationSchema": "IpMatchesAuthenticationName",
          "name": "client4"
        }
      ]
    },
    "location": {
      "value": "<location>"
    },
    "managedIdentities": {
      "value": {
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "maximumClientSessionsPerAuthenticationName": {
      "value": 5
    },
    "maximumSessionExpiryInHours": {
      "value": 2
    },
    "permissionBindings": {
      "value": [
        {
          "clientGroupName": "group1",
          "description": "this is binding1",
          "name": "bindiing1",
          "permission": "Publisher",
          "topicSpaceName": "topicSpace1"
        },
        {
          "clientGroupName": "group1",
          "name": "bindiing2",
          "permission": "Subscriber",
          "topicSpaceName": "topicSpace2"
        }
      ]
    },
    "routeTopicResourceId": {
      "value": "<routeTopicResourceId>"
    },
    "routingEnrichments": {
      "value": {
        "dynamic": [
          {
            "key": "dynamic1",
            "value": "<value>"
          }
        ],
        "static": [
          {
            "key": "static1",
            "value": "value1",
            "valueType": "String"
          },
          {
            "key": "static2",
            "value": "value2",
            "valueType": "String"
          }
        ]
      }
    },
    "routingIdentityInfo": {
      "value": {
        "type": "UserAssigned",
        "userAssignedIdentity": "<userAssignedIdentity>"
      }
    },
    "topics": {
      "value": [
        {
          "name": "topic1"
        }
      ]
    },
    "topicSpaces": {
      "value": [
        {
          "name": "topicSpace1",
          "topicTemplates": [
            "devices/foo/bar",
            "devices/topic1/+"
          ]
        },
        {
          "name": "topicSpace2",
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
          "topicTemplates": [
            "devices/topic1/+"
          ]
        }
      ]
    },
    "topicSpacesState": {
      "value": "Enabled"
    }
  }
}
```

</details>
<p>

### Example 4: _MQTT Broker with routing to a namespace topic_

This instance deploys the module as a MQTT Broker with routing to a topic within the same Eventgrid namespace.


<details>

<summary>via Bicep module</summary>

```bicep
module namespace 'br/public:avm/res/event-grid/namespace:<version>' = {
  name: 'namespaceDeployment'
  params: {
    // Required parameters
    name: 'egnmqttnt001'
    // Non-required parameters
    alternativeAuthenticationNameSources: [
      'ClientCertificateEmail'
      'ClientCertificateUri'
    ]
    clientGroups: [
      {
        description: 'this is group1'
        name: 'group1'
        query: 'attributes.keyName IN [\'a\', \'b\', \'c\']'
      }
    ]
    clients: [
      {
        attributes: {
          deviceTypes: [
            'Fan'
            'Light'
          ]
          floor: 12
          room: '345'
        }
        authenticationName: 'client2auth'
        clientCertificateAuthenticationAllowedThumbprints: [
          '1111111111111111111111111111111111111111'
          '2222222222222222222222222222222222222222'
        ]
        clientCertificateAuthenticationValidationSchema: 'ThumbprintMatch'
        description: 'this is client2'
        name: 'client1'
        state: 'Enabled'
      }
      {
        clientCertificateAuthenticationAllowedThumbprints: [
          '3333333333333333333333333333333333333333'
        ]
        clientCertificateAuthenticationValidationSchema: 'ThumbprintMatch'
        name: 'client2'
      }
      {
        name: 'client3'
      }
      {
        clientCertificateAuthenticationValidationSchema: 'IpMatchesAuthenticationName'
        name: 'client4'
      }
    ]
    location: '<location>'
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    maximumClientSessionsPerAuthenticationName: 5
    maximumSessionExpiryInHours: 2
    permissionBindings: [
      {
        clientGroupName: 'group1'
        description: 'this is binding1'
        name: 'bindiing1'
        permission: 'Publisher'
        topicSpaceName: 'topicSpace1'
      }
      {
        clientGroupName: 'group1'
        name: 'bindiing2'
        permission: 'Subscriber'
        topicSpaceName: 'topicSpace2'
      }
    ]
    routeTopicResourceId: '<routeTopicResourceId>'
    routingEnrichments: {
      dynamic: [
        {
          key: 'dynamic1'
          value: '<value>'
        }
      ]
      static: [
        {
          key: 'static1'
          value: 'value1'
          valueType: 'String'
        }
        {
          key: 'static2'
          value: 'value2'
          valueType: 'String'
        }
      ]
    }
    routingIdentityInfo: {
      type: 'UserAssigned'
      userAssignedIdentity: '<userAssignedIdentity>'
    }
    topics: [
      {
        name: 'topic1'
      }
    ]
    topicSpaces: [
      {
        name: 'topicSpace1'
        topicTemplates: [
          'devices/foo/bar'
          'devices/topic1/+'
        ]
      }
      {
        name: 'topicSpace2'
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
        topicTemplates: [
          'devices/topic1/+'
        ]
      }
    ]
    topicSpacesState: 'Enabled'
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
      "value": "egnmqttnt001"
    },
    // Non-required parameters
    "alternativeAuthenticationNameSources": {
      "value": [
        "ClientCertificateEmail",
        "ClientCertificateUri"
      ]
    },
    "clientGroups": {
      "value": [
        {
          "description": "this is group1",
          "name": "group1",
          "query": "attributes.keyName IN [\"a\", \"b\", \"c\"]"
        }
      ]
    },
    "clients": {
      "value": [
        {
          "attributes": {
            "deviceTypes": [
              "Fan",
              "Light"
            ],
            "floor": 12,
            "room": "345"
          },
          "authenticationName": "client2auth",
          "clientCertificateAuthenticationAllowedThumbprints": [
            "1111111111111111111111111111111111111111",
            "2222222222222222222222222222222222222222"
          ],
          "clientCertificateAuthenticationValidationSchema": "ThumbprintMatch",
          "description": "this is client2",
          "name": "client1",
          "state": "Enabled"
        },
        {
          "clientCertificateAuthenticationAllowedThumbprints": [
            "3333333333333333333333333333333333333333"
          ],
          "clientCertificateAuthenticationValidationSchema": "ThumbprintMatch",
          "name": "client2"
        },
        {
          "name": "client3"
        },
        {
          "clientCertificateAuthenticationValidationSchema": "IpMatchesAuthenticationName",
          "name": "client4"
        }
      ]
    },
    "location": {
      "value": "<location>"
    },
    "managedIdentities": {
      "value": {
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "maximumClientSessionsPerAuthenticationName": {
      "value": 5
    },
    "maximumSessionExpiryInHours": {
      "value": 2
    },
    "permissionBindings": {
      "value": [
        {
          "clientGroupName": "group1",
          "description": "this is binding1",
          "name": "bindiing1",
          "permission": "Publisher",
          "topicSpaceName": "topicSpace1"
        },
        {
          "clientGroupName": "group1",
          "name": "bindiing2",
          "permission": "Subscriber",
          "topicSpaceName": "topicSpace2"
        }
      ]
    },
    "routeTopicResourceId": {
      "value": "<routeTopicResourceId>"
    },
    "routingEnrichments": {
      "value": {
        "dynamic": [
          {
            "key": "dynamic1",
            "value": "<value>"
          }
        ],
        "static": [
          {
            "key": "static1",
            "value": "value1",
            "valueType": "String"
          },
          {
            "key": "static2",
            "value": "value2",
            "valueType": "String"
          }
        ]
      }
    },
    "routingIdentityInfo": {
      "value": {
        "type": "UserAssigned",
        "userAssignedIdentity": "<userAssignedIdentity>"
      }
    },
    "topics": {
      "value": [
        {
          "name": "topic1"
        }
      ]
    },
    "topicSpaces": {
      "value": [
        {
          "name": "topicSpace1",
          "topicTemplates": [
            "devices/foo/bar",
            "devices/topic1/+"
          ]
        },
        {
          "name": "topicSpace2",
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
          "topicTemplates": [
            "devices/topic1/+"
          ]
        }
      ]
    },
    "topicSpacesState": {
      "value": "Enabled"
    }
  }
}
```

</details>
<p>

### Example 5: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module namespace 'br/public:avm/res/event-grid/namespace:<version>' = {
  name: 'namespaceDeployment'
  params: {
    // Required parameters
    name: 'egnwaf001'
    // Non-required parameters
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    location: '<location>'
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

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "egnwaf001"
    },
    // Non-required parameters
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
    "location": {
      "value": "<location>"
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

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Event Grid Namespace to create. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`routingIdentityInfo`](#parameter-routingidentityinfo) | object | Routing identity info for topic spaces configuration. Required if the 'routeTopicResourceId' points to a topic outside of the current Event Grid Namespace.  Used only when MQTT broker is enabled ('topicSpacesState' is set to 'Enabled') and routing is enabled ('routeTopicResourceId' is set). |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`alternativeAuthenticationNameSources`](#parameter-alternativeauthenticationnamesources) | array | Alternative authentication name sources related to client authentication settings for namespace resource. Used only when MQTT broker is enabled ('topicSpacesState' is set to 'Enabled'). |
| [`caCertificates`](#parameter-cacertificates) | array | CA certificates (Root or intermediate) used to sign the client certificates for clients authenticated using CA-signed certificates.  Used only when MQTT broker is enabled ('topicSpacesState' is set to 'Enabled'). |
| [`clientGroups`](#parameter-clientgroups) | array | All namespace Client Groups to create. Used only when MQTT broker is enabled ('topicSpacesState' is set to 'Enabled'). |
| [`clients`](#parameter-clients) | array | All namespace Clients to create. Used only when MQTT broker is enabled ('topicSpacesState' is set to 'Enabled'). |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`inboundIpRules`](#parameter-inboundiprules) | array | This can be used to restrict traffic from specific IPs instead of all IPs. Note: These are considered only if PublicNetworkAccess is enabled. |
| [`isZoneRedundant`](#parameter-iszoneredundant) | bool | Allows the user to specify if the namespace resource supports zone-redundancy capability or not. If this property is not specified explicitly by the user, its default value depends on the following conditions: a. For Availability Zones enabled regions - The default property value would be true. b. For non-Availability Zones enabled regions - The default property value would be false. Once specified, this property cannot be updated. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`maximumClientSessionsPerAuthenticationName`](#parameter-maximumclientsessionsperauthenticationname) | int | The maximum number of sessions per authentication name. Used only when MQTT broker is enabled ('topicSpacesState' is set to 'Enabled'). |
| [`maximumSessionExpiryInHours`](#parameter-maximumsessionexpiryinhours) | int | The maximum session expiry in hours. Used only when MQTT broker is enabled ('topicSpacesState' is set to 'Enabled'). |
| [`permissionBindings`](#parameter-permissionbindings) | array | All namespace Permission Bindings to create. Used only when MQTT broker is enabled ('topicSpacesState' is set to 'Enabled'). |
| [`privateEndpoints`](#parameter-privateendpoints) | array | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | This determines if traffic is allowed over public network. By default it is enabled. You can further restrict to specific IPs by configuring. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`routeTopicResourceId`](#parameter-routetopicresourceid) | string | Resource Id for the Event Grid Topic to which events will be routed to from TopicSpaces under a namespace. This enables routing of the MQTT messages to an Event Grid Topic. Used only when MQTT broker is enabled ('topicSpacesState' is set to 'Enabled'). Note that the topic must exist prior to deployment, meaning: if referencing a topic in the same namespace, the deployment must be launched twice: 1. To create the topic 2. To enable the routing this topic. |
| [`routingEnrichments`](#parameter-routingenrichments) | object | Routing enrichments for topic spaces configuration.  Used only when MQTT broker is enabled ('topicSpacesState' is set to 'Enabled') and routing is enabled ('routeTopicResourceId' is set). |
| [`tags`](#parameter-tags) | object | Resource tags. |
| [`topics`](#parameter-topics) | array | All namespace Topics to create. |
| [`topicSpaces`](#parameter-topicspaces) | array | All namespace Topic Spaces to create. Used only when MQTT broker is enabled ('topicSpacesState' is set to 'Enabled'). |
| [`topicSpacesState`](#parameter-topicspacesstate) | string | Indicates if Topic Spaces Configuration is enabled for the namespace. This enables the MQTT Broker functionality for the namespace. Once enabled, this property cannot be disabled. |

### Parameter: `name`

Name of the Event Grid Namespace to create.

- Required: Yes
- Type: string

### Parameter: `routingIdentityInfo`

Routing identity info for topic spaces configuration. Required if the 'routeTopicResourceId' points to a topic outside of the current Event Grid Namespace.  Used only when MQTT broker is enabled ('topicSpacesState' is set to 'Enabled') and routing is enabled ('routeTopicResourceId' is set).

- Required: No
- Type: object

### Parameter: `alternativeAuthenticationNameSources`

Alternative authentication name sources related to client authentication settings for namespace resource. Used only when MQTT broker is enabled ('topicSpacesState' is set to 'Enabled').

- Required: No
- Type: array
- Allowed:
  ```Bicep
  [
    'ClientCertificateDns'
    'ClientCertificateEmail'
    'ClientCertificateIp'
    'ClientCertificateSubject'
    'ClientCertificateUri'
  ]
  ```

### Parameter: `caCertificates`

CA certificates (Root or intermediate) used to sign the client certificates for clients authenticated using CA-signed certificates.  Used only when MQTT broker is enabled ('topicSpacesState' is set to 'Enabled').

- Required: No
- Type: array

### Parameter: `clientGroups`

All namespace Client Groups to create. Used only when MQTT broker is enabled ('topicSpacesState' is set to 'Enabled').

- Required: No
- Type: array

### Parameter: `clients`

All namespace Clients to create. Used only when MQTT broker is enabled ('topicSpacesState' is set to 'Enabled').

- Required: No
- Type: array

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

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `inboundIpRules`

This can be used to restrict traffic from specific IPs instead of all IPs. Note: These are considered only if PublicNetworkAccess is enabled.

- Required: No
- Type: array

### Parameter: `isZoneRedundant`

Allows the user to specify if the namespace resource supports zone-redundancy capability or not. If this property is not specified explicitly by the user, its default value depends on the following conditions: a. For Availability Zones enabled regions - The default property value would be true. b. For non-Availability Zones enabled regions - The default property value would be false. Once specified, this property cannot be updated.

- Required: No
- Type: bool

### Parameter: `location`

Location for all Resources.

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
| [`userAssignedResourceIds`](#parameter-managedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. |

### Parameter: `managedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource.

- Required: No
- Type: array

### Parameter: `maximumClientSessionsPerAuthenticationName`

The maximum number of sessions per authentication name. Used only when MQTT broker is enabled ('topicSpacesState' is set to 'Enabled').

- Required: No
- Type: int
- Default: `1`

### Parameter: `maximumSessionExpiryInHours`

The maximum session expiry in hours. Used only when MQTT broker is enabled ('topicSpacesState' is set to 'Enabled').

- Required: No
- Type: int
- Default: `1`

### Parameter: `permissionBindings`

All namespace Permission Bindings to create. Used only when MQTT broker is enabled ('topicSpacesState' is set to 'Enabled').

- Required: No
- Type: array

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

This determines if traffic is allowed over public network. By default it is enabled. You can further restrict to specific IPs by configuring.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
    'SecuredByPerimeter'
  ]
  ```

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Azure Resource Notifications System Topics Subscriber'`
  - `'Contributor'`
  - `'EventGrid Contributor'`
  - `'EventGrid Data Contributor'`
  - `'EventGrid Data Receiver'`
  - `'EventGrid Data Sender'`
  - `'EventGrid EventSubscription Contributor'`
  - `'EventGrid EventSubscription Reader'`
  - `'EventGrid TopicSpaces Publisher'`
  - `'EventGrid TopicSpaces Subscriber'`
  - `'Owner'`
  - `'Reader'`
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

### Parameter: `routeTopicResourceId`

Resource Id for the Event Grid Topic to which events will be routed to from TopicSpaces under a namespace. This enables routing of the MQTT messages to an Event Grid Topic. Used only when MQTT broker is enabled ('topicSpacesState' is set to 'Enabled'). Note that the topic must exist prior to deployment, meaning: if referencing a topic in the same namespace, the deployment must be launched twice: 1. To create the topic 2. To enable the routing this topic.

- Required: No
- Type: string

### Parameter: `routingEnrichments`

Routing enrichments for topic spaces configuration.  Used only when MQTT broker is enabled ('topicSpacesState' is set to 'Enabled') and routing is enabled ('routeTopicResourceId' is set).

- Required: No
- Type: object

### Parameter: `tags`

Resource tags.

- Required: No
- Type: object

### Parameter: `topics`

All namespace Topics to create.

- Required: No
- Type: array

### Parameter: `topicSpaces`

All namespace Topic Spaces to create. Used only when MQTT broker is enabled ('topicSpacesState' is set to 'Enabled').

- Required: No
- Type: array

### Parameter: `topicSpacesState`

Indicates if Topic Spaces Configuration is enabled for the namespace. This enables the MQTT Broker functionality for the namespace. Once enabled, this property cannot be disabled.

- Required: No
- Type: string
- Default: `'Disabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the EventGrid Namespace was deployed into. |
| `name` | string | The name of the EventGrid Namespace. |
| `privateEndpoints` | array | The private endpoints of the EventGrid Namespace. |
| `resourceGroupName` | string | The name of the resource group the EventGrid Namespace was created in. |
| `resourceId` | string | The resource ID of the EventGrid Namespace. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |
| `topicResourceIds` | array | The Resources IDs of the EventGrid Namespace Topics. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/network/private-endpoint:0.7.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
