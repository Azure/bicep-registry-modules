# Network Managers `[Microsoft.Network/networkManagers]`

This module deploys a Network Manager.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Notes](#Notes)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Network/networkManagers` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/networkManagers) |
| `Microsoft.Network/networkManagers/connectivityConfigurations` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/networkManagers/connectivityConfigurations) |
| `Microsoft.Network/networkManagers/networkGroups` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/networkManagers/networkGroups) |
| `Microsoft.Network/networkManagers/networkGroups/staticMembers` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/networkManagers/networkGroups/staticMembers) |
| `Microsoft.Network/networkManagers/routingConfigurations` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/networkManagers/routingConfigurations) |
| `Microsoft.Network/networkManagers/routingConfigurations/ruleCollections` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/networkManagers/routingConfigurations/ruleCollections) |
| `Microsoft.Network/networkManagers/routingConfigurations/ruleCollections/rules` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/networkManagers/routingConfigurations/ruleCollections/rules) |
| `Microsoft.Network/networkManagers/scopeConnections` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/networkManagers/scopeConnections) |
| `Microsoft.Network/networkManagers/securityAdminConfigurations` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/networkManagers/securityAdminConfigurations) |
| `Microsoft.Network/networkManagers/securityAdminConfigurations/ruleCollections` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/networkManagers/securityAdminConfigurations/ruleCollections) |
| `Microsoft.Network/networkManagers/securityAdminConfigurations/ruleCollections/rules` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/networkManagers/securityAdminConfigurations/ruleCollections/rules) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/network/network-manager:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module networkManager 'br/public:avm/res/network/network-manager:<version>' = {
  name: 'networkManagerDeployment'
  params: {
    // Required parameters
    name: 'nnmmin001'
    networkManagerScopes: {
      subscriptions: [
        '<id>'
      ]
    }
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
      "value": "nnmmin001"
    },
    "networkManagerScopes": {
      "value": {
        "subscriptions": [
          "<id>"
        ]
      }
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
using 'br/public:avm/res/network/network-manager:<version>'

// Required parameters
param name = 'nnmmin001'
param networkManagerScopes = {
  subscriptions: [
    '<id>'
  ]
}
// Non-required parameters
param location = '<location>'
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module networkManager 'br/public:avm/res/network/network-manager:<version>' = {
  name: 'networkManagerDeployment'
  params: {
    // Required parameters
    name: '<name>'
    networkManagerScopes: {
      managementGroups: [
        '/providers/Microsoft.Management/managementGroups/#_managementGroupId_#'
      ]
    }
    // Non-required parameters
    connectivityConfigurations: [
      {
        appliesToGroups: [
          {
            groupConnectivity: 'None'
            isGlobal: false
            networkGroupResourceId: '<networkGroupResourceId>'
            useHubGateway: false
          }
        ]
        connectivityTopology: 'HubAndSpoke'
        deleteExistingPeering: true
        description: 'hubSpokeConnectivity description'
        hubs: [
          {
            resourceId: '<resourceId>'
            resourceType: 'Microsoft.Network/virtualNetworks'
          }
        ]
        isGlobal: false
        name: 'hubSpokeConnectivity'
      }
      {
        appliesToGroups: [
          {
            groupConnectivity: 'DirectlyConnected'
            isGlobal: true
            networkGroupResourceId: '<networkGroupResourceId>'
            useHubGateway: false
          }
        ]
        connectivityTopology: 'Mesh'
        deleteExistingPeering: true
        description: 'MeshConnectivity description'
        isGlobal: true
        name: 'MeshConnectivity-1'
      }
      {
        appliesToGroups: [
          {
            groupConnectivity: 'DirectlyConnected'
            isGlobal: false
            networkGroupResourceId: '<networkGroupResourceId>'
            useHubGateway: false
          }
        ]
        connectivityTopology: 'Mesh'
        isGlobal: false
        name: 'MeshConnectivity-2'
      }
    ]
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    networkGroups: [
      {
        description: 'network-group-spokes description'
        memberType: 'VirtualNetwork'
        name: 'network-group-spokes-1'
        staticMembers: [
          {
            name: 'virtualNetworkSpoke1'
            resourceId: '<resourceId>'
          }
          {
            name: 'virtualNetworkSpoke2'
            resourceId: '<resourceId>'
          }
        ]
      }
      {
        memberType: 'VirtualNetwork'
        name: 'network-group-spokes-2'
        staticMembers: [
          {
            name: 'default'
            resourceId: '<resourceId>'
          }
        ]
      }
      {
        memberType: 'VirtualNetwork'
        name: 'network-group-spokes-3'
      }
      {
        memberType: 'Subnet'
        name: 'network-groups-subnets-1'
        staticMembers: [
          {
            name: 'virtualNetworkSpoke1-defaultSubnet'
            resourceId: '<resourceId>'
          }
          {
            name: 'virtualNetworkSpoke2-defaultSubnet'
            resourceId: '<resourceId>'
          }
        ]
      }
    ]
    networkManagerScopeAccesses: [
      'Connectivity'
      'Routing'
      'SecurityAdmin'
    ]
    roleAssignments: [
      {
        name: 'e8472331-308c-4c77-aa31-017279d8e5b6'
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
    routingConfigurations: [
      {
        description: 'description of the routing config'
        name: 'test-routing-config-1'
      }
      {
        name: 'test-routing-config-2'
        ruleCollections: [
          {
            appliesTo: [
              {
                networkGroupResourceId: '<networkGroupResourceId>'
              }
            ]
            disableBgpRoutePropagation: false
            name: 'test-routing-rule-collection-1-subnet'
            rules: [
              {
                destination: {
                  destinationAddress: 'AzureCloud'
                  type: 'ServiceTag'
                }
                name: 'test-routing-rule-1'
                nextHop: {
                  nextHopType: 'VnetLocal'
                }
              }
              {
                destination: {
                  destinationAddress: '10.10.10.10/32'
                  type: 'AddressPrefix'
                }
                name: 'test-routing-rule-2'
                nextHop: {
                  nextHopAddress: '192.168.1.1'
                  nextHopType: 'VirtualAppliance'
                }
              }
            ]
          }
        ]
      }
      {
        name: 'test-routing-config-3'
        ruleCollections: [
          {
            appliesTo: [
              {
                networkGroupResourceId: '<networkGroupResourceId>'
              }
            ]
            name: 'test-routing-rule-collection-2-virtual-network'
          }
        ]
      }
    ]
    scopeConnections: [
      {
        description: 'description of the scope connection'
        name: 'scope-connection-test'
        resourceId: '<resourceId>'
        tenantId: '<tenantId>'
      }
    ]
    securityAdminConfigurations: [
      {
        applyOnNetworkIntentPolicyBasedServices: [
          'AllowRulesOnly'
        ]
        description: 'description of the security admin config'
        name: 'test-security-admin-config-1'
        ruleCollections: [
          {
            appliesToGroups: [
              {
                networkGroupResourceId: '<networkGroupResourceId>'
              }
            ]
            description: 'test-rule-collection-description'
            name: 'test-rule-collection-1'
            rules: [
              {
                access: 'Allow'
                description: 'test-inbound-allow-rule-1-description'
                direction: 'Inbound'
                name: 'test-inbound-allow-rule-1'
                priority: 150
                protocol: 'Tcp'
              }
              {
                access: 'Deny'
                description: 'test-outbound-deny-rule-2-description'
                direction: 'Outbound'
                name: 'test-outbound-deny-rule-2'
                priority: 200
                protocol: 'Tcp'
                sourcePortRanges: [
                  '442-445'
                  '80'
                ]
                sources: [
                  {
                    addressPrefix: 'AppService.WestEurope'
                    addressPrefixType: 'ServiceTag'
                  }
                ]
              }
            ]
          }
          {
            appliesToGroups: [
              {
                networkGroupResourceId: '<networkGroupResourceId>'
              }
              {
                networkGroupResourceId: '<networkGroupResourceId>'
              }
            ]
            name: 'test-rule-collection-2'
            rules: [
              {
                access: 'Allow'
                destinationPortRanges: [
                  '442-445'
                  '80'
                ]
                destinations: [
                  {
                    addressPrefix: '192.168.20.20'
                    addressPrefixType: 'IPPrefix'
                  }
                ]
                direction: 'Inbound'
                name: 'test-inbound-allow-rule-3'
                priority: 250
                protocol: 'Tcp'
              }
              {
                access: 'Allow'
                description: 'test-inbound-allow-rule-4-description'
                destinations: [
                  {
                    addressPrefix: '172.16.0.0/24'
                    addressPrefixType: 'IPPrefix'
                  }
                  {
                    addressPrefix: '172.16.1.0/24'
                    addressPrefixType: 'IPPrefix'
                  }
                ]
                direction: 'Inbound'
                name: 'test-inbound-allow-rule-4'
                priority: 260
                protocol: 'Tcp'
                sources: [
                  {
                    addressPrefix: '10.0.0.0/24'
                    addressPrefixType: 'IPPrefix'
                  }
                  {
                    addressPrefix: '100.100.100.100'
                    addressPrefixType: 'IPPrefix'
                  }
                ]
              }
            ]
          }
        ]
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
      "value": "<name>"
    },
    "networkManagerScopes": {
      "value": {
        "managementGroups": [
          "/providers/Microsoft.Management/managementGroups/#_managementGroupId_#"
        ]
      }
    },
    // Non-required parameters
    "connectivityConfigurations": {
      "value": [
        {
          "appliesToGroups": [
            {
              "groupConnectivity": "None",
              "isGlobal": false,
              "networkGroupResourceId": "<networkGroupResourceId>",
              "useHubGateway": false
            }
          ],
          "connectivityTopology": "HubAndSpoke",
          "deleteExistingPeering": true,
          "description": "hubSpokeConnectivity description",
          "hubs": [
            {
              "resourceId": "<resourceId>",
              "resourceType": "Microsoft.Network/virtualNetworks"
            }
          ],
          "isGlobal": false,
          "name": "hubSpokeConnectivity"
        },
        {
          "appliesToGroups": [
            {
              "groupConnectivity": "DirectlyConnected",
              "isGlobal": true,
              "networkGroupResourceId": "<networkGroupResourceId>",
              "useHubGateway": false
            }
          ],
          "connectivityTopology": "Mesh",
          "deleteExistingPeering": true,
          "description": "MeshConnectivity description",
          "isGlobal": true,
          "name": "MeshConnectivity-1"
        },
        {
          "appliesToGroups": [
            {
              "groupConnectivity": "DirectlyConnected",
              "isGlobal": false,
              "networkGroupResourceId": "<networkGroupResourceId>",
              "useHubGateway": false
            }
          ],
          "connectivityTopology": "Mesh",
          "isGlobal": false,
          "name": "MeshConnectivity-2"
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
    "networkGroups": {
      "value": [
        {
          "description": "network-group-spokes description",
          "memberType": "VirtualNetwork",
          "name": "network-group-spokes-1",
          "staticMembers": [
            {
              "name": "virtualNetworkSpoke1",
              "resourceId": "<resourceId>"
            },
            {
              "name": "virtualNetworkSpoke2",
              "resourceId": "<resourceId>"
            }
          ]
        },
        {
          "memberType": "VirtualNetwork",
          "name": "network-group-spokes-2",
          "staticMembers": [
            {
              "name": "default",
              "resourceId": "<resourceId>"
            }
          ]
        },
        {
          "memberType": "VirtualNetwork",
          "name": "network-group-spokes-3"
        },
        {
          "memberType": "Subnet",
          "name": "network-groups-subnets-1",
          "staticMembers": [
            {
              "name": "virtualNetworkSpoke1-defaultSubnet",
              "resourceId": "<resourceId>"
            },
            {
              "name": "virtualNetworkSpoke2-defaultSubnet",
              "resourceId": "<resourceId>"
            }
          ]
        }
      ]
    },
    "networkManagerScopeAccesses": {
      "value": [
        "Connectivity",
        "Routing",
        "SecurityAdmin"
      ]
    },
    "roleAssignments": {
      "value": [
        {
          "name": "e8472331-308c-4c77-aa31-017279d8e5b6",
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
    "routingConfigurations": {
      "value": [
        {
          "description": "description of the routing config",
          "name": "test-routing-config-1"
        },
        {
          "name": "test-routing-config-2",
          "ruleCollections": [
            {
              "appliesTo": [
                {
                  "networkGroupResourceId": "<networkGroupResourceId>"
                }
              ],
              "disableBgpRoutePropagation": false,
              "name": "test-routing-rule-collection-1-subnet",
              "rules": [
                {
                  "destination": {
                    "destinationAddress": "AzureCloud",
                    "type": "ServiceTag"
                  },
                  "name": "test-routing-rule-1",
                  "nextHop": {
                    "nextHopType": "VnetLocal"
                  }
                },
                {
                  "destination": {
                    "destinationAddress": "10.10.10.10/32",
                    "type": "AddressPrefix"
                  },
                  "name": "test-routing-rule-2",
                  "nextHop": {
                    "nextHopAddress": "192.168.1.1",
                    "nextHopType": "VirtualAppliance"
                  }
                }
              ]
            }
          ]
        },
        {
          "name": "test-routing-config-3",
          "ruleCollections": [
            {
              "appliesTo": [
                {
                  "networkGroupResourceId": "<networkGroupResourceId>"
                }
              ],
              "name": "test-routing-rule-collection-2-virtual-network"
            }
          ]
        }
      ]
    },
    "scopeConnections": {
      "value": [
        {
          "description": "description of the scope connection",
          "name": "scope-connection-test",
          "resourceId": "<resourceId>",
          "tenantId": "<tenantId>"
        }
      ]
    },
    "securityAdminConfigurations": {
      "value": [
        {
          "applyOnNetworkIntentPolicyBasedServices": [
            "AllowRulesOnly"
          ],
          "description": "description of the security admin config",
          "name": "test-security-admin-config-1",
          "ruleCollections": [
            {
              "appliesToGroups": [
                {
                  "networkGroupResourceId": "<networkGroupResourceId>"
                }
              ],
              "description": "test-rule-collection-description",
              "name": "test-rule-collection-1",
              "rules": [
                {
                  "access": "Allow",
                  "description": "test-inbound-allow-rule-1-description",
                  "direction": "Inbound",
                  "name": "test-inbound-allow-rule-1",
                  "priority": 150,
                  "protocol": "Tcp"
                },
                {
                  "access": "Deny",
                  "description": "test-outbound-deny-rule-2-description",
                  "direction": "Outbound",
                  "name": "test-outbound-deny-rule-2",
                  "priority": 200,
                  "protocol": "Tcp",
                  "sourcePortRanges": [
                    "442-445",
                    "80"
                  ],
                  "sources": [
                    {
                      "addressPrefix": "AppService.WestEurope",
                      "addressPrefixType": "ServiceTag"
                    }
                  ]
                }
              ]
            },
            {
              "appliesToGroups": [
                {
                  "networkGroupResourceId": "<networkGroupResourceId>"
                },
                {
                  "networkGroupResourceId": "<networkGroupResourceId>"
                }
              ],
              "name": "test-rule-collection-2",
              "rules": [
                {
                  "access": "Allow",
                  "destinationPortRanges": [
                    "442-445",
                    "80"
                  ],
                  "destinations": [
                    {
                      "addressPrefix": "192.168.20.20",
                      "addressPrefixType": "IPPrefix"
                    }
                  ],
                  "direction": "Inbound",
                  "name": "test-inbound-allow-rule-3",
                  "priority": 250,
                  "protocol": "Tcp"
                },
                {
                  "access": "Allow",
                  "description": "test-inbound-allow-rule-4-description",
                  "destinations": [
                    {
                      "addressPrefix": "172.16.0.0/24",
                      "addressPrefixType": "IPPrefix"
                    },
                    {
                      "addressPrefix": "172.16.1.0/24",
                      "addressPrefixType": "IPPrefix"
                    }
                  ],
                  "direction": "Inbound",
                  "name": "test-inbound-allow-rule-4",
                  "priority": 260,
                  "protocol": "Tcp",
                  "sources": [
                    {
                      "addressPrefix": "10.0.0.0/24",
                      "addressPrefixType": "IPPrefix"
                    },
                    {
                      "addressPrefix": "100.100.100.100",
                      "addressPrefixType": "IPPrefix"
                    }
                  ]
                }
              ]
            }
          ]
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
using 'br/public:avm/res/network/network-manager:<version>'

// Required parameters
param name = '<name>'
param networkManagerScopes = {
  managementGroups: [
    '/providers/Microsoft.Management/managementGroups/#_managementGroupId_#'
  ]
}
// Non-required parameters
param connectivityConfigurations = [
  {
    appliesToGroups: [
      {
        groupConnectivity: 'None'
        isGlobal: false
        networkGroupResourceId: '<networkGroupResourceId>'
        useHubGateway: false
      }
    ]
    connectivityTopology: 'HubAndSpoke'
    deleteExistingPeering: true
    description: 'hubSpokeConnectivity description'
    hubs: [
      {
        resourceId: '<resourceId>'
        resourceType: 'Microsoft.Network/virtualNetworks'
      }
    ]
    isGlobal: false
    name: 'hubSpokeConnectivity'
  }
  {
    appliesToGroups: [
      {
        groupConnectivity: 'DirectlyConnected'
        isGlobal: true
        networkGroupResourceId: '<networkGroupResourceId>'
        useHubGateway: false
      }
    ]
    connectivityTopology: 'Mesh'
    deleteExistingPeering: true
    description: 'MeshConnectivity description'
    isGlobal: true
    name: 'MeshConnectivity-1'
  }
  {
    appliesToGroups: [
      {
        groupConnectivity: 'DirectlyConnected'
        isGlobal: false
        networkGroupResourceId: '<networkGroupResourceId>'
        useHubGateway: false
      }
    ]
    connectivityTopology: 'Mesh'
    isGlobal: false
    name: 'MeshConnectivity-2'
  }
]
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param networkGroups = [
  {
    description: 'network-group-spokes description'
    memberType: 'VirtualNetwork'
    name: 'network-group-spokes-1'
    staticMembers: [
      {
        name: 'virtualNetworkSpoke1'
        resourceId: '<resourceId>'
      }
      {
        name: 'virtualNetworkSpoke2'
        resourceId: '<resourceId>'
      }
    ]
  }
  {
    memberType: 'VirtualNetwork'
    name: 'network-group-spokes-2'
    staticMembers: [
      {
        name: 'default'
        resourceId: '<resourceId>'
      }
    ]
  }
  {
    memberType: 'VirtualNetwork'
    name: 'network-group-spokes-3'
  }
  {
    memberType: 'Subnet'
    name: 'network-groups-subnets-1'
    staticMembers: [
      {
        name: 'virtualNetworkSpoke1-defaultSubnet'
        resourceId: '<resourceId>'
      }
      {
        name: 'virtualNetworkSpoke2-defaultSubnet'
        resourceId: '<resourceId>'
      }
    ]
  }
]
param networkManagerScopeAccesses = [
  'Connectivity'
  'Routing'
  'SecurityAdmin'
]
param roleAssignments = [
  {
    name: 'e8472331-308c-4c77-aa31-017279d8e5b6'
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
param routingConfigurations = [
  {
    description: 'description of the routing config'
    name: 'test-routing-config-1'
  }
  {
    name: 'test-routing-config-2'
    ruleCollections: [
      {
        appliesTo: [
          {
            networkGroupResourceId: '<networkGroupResourceId>'
          }
        ]
        disableBgpRoutePropagation: false
        name: 'test-routing-rule-collection-1-subnet'
        rules: [
          {
            destination: {
              destinationAddress: 'AzureCloud'
              type: 'ServiceTag'
            }
            name: 'test-routing-rule-1'
            nextHop: {
              nextHopType: 'VnetLocal'
            }
          }
          {
            destination: {
              destinationAddress: '10.10.10.10/32'
              type: 'AddressPrefix'
            }
            name: 'test-routing-rule-2'
            nextHop: {
              nextHopAddress: '192.168.1.1'
              nextHopType: 'VirtualAppliance'
            }
          }
        ]
      }
    ]
  }
  {
    name: 'test-routing-config-3'
    ruleCollections: [
      {
        appliesTo: [
          {
            networkGroupResourceId: '<networkGroupResourceId>'
          }
        ]
        name: 'test-routing-rule-collection-2-virtual-network'
      }
    ]
  }
]
param scopeConnections = [
  {
    description: 'description of the scope connection'
    name: 'scope-connection-test'
    resourceId: '<resourceId>'
    tenantId: '<tenantId>'
  }
]
param securityAdminConfigurations = [
  {
    applyOnNetworkIntentPolicyBasedServices: [
      'AllowRulesOnly'
    ]
    description: 'description of the security admin config'
    name: 'test-security-admin-config-1'
    ruleCollections: [
      {
        appliesToGroups: [
          {
            networkGroupResourceId: '<networkGroupResourceId>'
          }
        ]
        description: 'test-rule-collection-description'
        name: 'test-rule-collection-1'
        rules: [
          {
            access: 'Allow'
            description: 'test-inbound-allow-rule-1-description'
            direction: 'Inbound'
            name: 'test-inbound-allow-rule-1'
            priority: 150
            protocol: 'Tcp'
          }
          {
            access: 'Deny'
            description: 'test-outbound-deny-rule-2-description'
            direction: 'Outbound'
            name: 'test-outbound-deny-rule-2'
            priority: 200
            protocol: 'Tcp'
            sourcePortRanges: [
              '442-445'
              '80'
            ]
            sources: [
              {
                addressPrefix: 'AppService.WestEurope'
                addressPrefixType: 'ServiceTag'
              }
            ]
          }
        ]
      }
      {
        appliesToGroups: [
          {
            networkGroupResourceId: '<networkGroupResourceId>'
          }
          {
            networkGroupResourceId: '<networkGroupResourceId>'
          }
        ]
        name: 'test-rule-collection-2'
        rules: [
          {
            access: 'Allow'
            destinationPortRanges: [
              '442-445'
              '80'
            ]
            destinations: [
              {
                addressPrefix: '192.168.20.20'
                addressPrefixType: 'IPPrefix'
              }
            ]
            direction: 'Inbound'
            name: 'test-inbound-allow-rule-3'
            priority: 250
            protocol: 'Tcp'
          }
          {
            access: 'Allow'
            description: 'test-inbound-allow-rule-4-description'
            destinations: [
              {
                addressPrefix: '172.16.0.0/24'
                addressPrefixType: 'IPPrefix'
              }
              {
                addressPrefix: '172.16.1.0/24'
                addressPrefixType: 'IPPrefix'
              }
            ]
            direction: 'Inbound'
            name: 'test-inbound-allow-rule-4'
            priority: 260
            protocol: 'Tcp'
            sources: [
              {
                addressPrefix: '10.0.0.0/24'
                addressPrefixType: 'IPPrefix'
              }
              {
                addressPrefix: '100.100.100.100'
                addressPrefixType: 'IPPrefix'
              }
            ]
          }
        ]
      }
    ]
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

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module networkManager 'br/public:avm/res/network/network-manager:<version>' = {
  name: 'networkManagerDeployment'
  params: {
    // Required parameters
    name: 'nnmwaf001'
    networkManagerScopes: {
      subscriptions: [
        '<id>'
      ]
    }
    // Non-required parameters
    location: '<location>'
    networkManagerScopeAccesses: [
      'SecurityAdmin'
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
      "value": "nnmwaf001"
    },
    "networkManagerScopes": {
      "value": {
        "subscriptions": [
          "<id>"
        ]
      }
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "networkManagerScopeAccesses": {
      "value": [
        "SecurityAdmin"
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
using 'br/public:avm/res/network/network-manager:<version>'

// Required parameters
param name = 'nnmwaf001'
param networkManagerScopes = {
  subscriptions: [
    '<id>'
  ]
}
// Non-required parameters
param location = '<location>'
param networkManagerScopeAccesses = [
  'SecurityAdmin'
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
| [`name`](#parameter-name) | string | Name of the Network Manager. |
| [`networkManagerScopes`](#parameter-networkmanagerscopes) | object | Scope of Network Manager. Contains a list of management groups or a list of subscriptions. This defines the boundary of network resources that this Network Manager instance can manage. If using Management Groups, ensure that the "Microsoft.Network" resource provider is registered for those Management Groups prior to deployment. Must contain at least one management group or subscription. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`networkGroups`](#parameter-networkgroups) | array | Network Groups and static members to create for the network manager. Required if using "connectivityConfigurations" or "securityAdminConfigurations" parameters. A network group is global container that includes a set of virtual network resources from any region. Then, configurations are applied to target the network group, which applies the configuration to all members of the group. The two types are group memberships are static and dynamic memberships. Static membership allows you to explicitly add virtual networks to a group by manually selecting individual virtual networks, and is available as a child module, while dynamic membership is defined through Azure policy. See [How Azure Policy works with Network Groups](https://learn.microsoft.com/en-us/azure/virtual-network-manager/concept-azure-policy-integration) for more details. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`connectivityConfigurations`](#parameter-connectivityconfigurations) | array | Connectivity Configurations to create for the network manager. Network manager must contain at least one network group in order to define connectivity configurations. |
| [`description`](#parameter-description) | string | A description of the Network Manager. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`networkManagerScopeAccesses`](#parameter-networkmanagerscopeaccesses) | array | Scope Access (Also known as features). String array containing any of "Connectivity", "SecurityAdmin", or "Routing". The connectivity feature allows you to create network topologies at scale. The security admin feature lets you create high-priority security rules, which take precedence over NSGs. The routing feature allows you to describe your desired routing behavior and orchestrate user-defined routes (UDRs) to create and maintain the desired routing behavior. If none of the features are required, then this parameter does not need to be specified, which then only enables features like "IPAM" and "Virtual Network Verifier". |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`routingConfigurations`](#parameter-routingconfigurations) | array | Routing Configurations requires enabling the "Routing" feature on Network Manager. A routing configuration contains a set of rule collections. Each rule collection contains one or more routing rules. |
| [`scopeConnections`](#parameter-scopeconnections) | array | Scope Connections to create for the network manager. Allows network manager to manage resources from another tenant. Supports management groups or subscriptions from another tenant. |
| [`securityAdminConfigurations`](#parameter-securityadminconfigurations) | array | Security Admin Configurations requires enabling the "SecurityAdmin" feature on Network Manager. A security admin configuration contains a set of rule collections. Each rule collection contains one or more security admin rules. You then associate the rule collection with the network groups that you want to apply the security admin rules to. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `name`

Name of the Network Manager.

- Required: Yes
- Type: string

### Parameter: `networkManagerScopes`

Scope of Network Manager. Contains a list of management groups or a list of subscriptions. This defines the boundary of network resources that this Network Manager instance can manage. If using Management Groups, ensure that the "Microsoft.Network" resource provider is registered for those Management Groups prior to deployment. Must contain at least one management group or subscription.

- Required: Yes
- Type: object

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`managementGroups`](#parameter-networkmanagerscopesmanagementgroups) | array |  List of fully qualified IDs of management groups to assign to the network manager to manage. Required if `subscriptions` is not provided. Fully qualified ID format: '/providers/Microsoft.Management/managementGroups/{managementGroupId}'. |
| [`subscriptions`](#parameter-networkmanagerscopessubscriptions) | array | List of fully qualified IDs of Subscriptions to assign to the network manager to manage. Required if `managementGroups` is not provided. Fully qualified ID format: '/subscriptions/{subscriptionId}'. |

### Parameter: `networkManagerScopes.managementGroups`

 List of fully qualified IDs of management groups to assign to the network manager to manage. Required if `subscriptions` is not provided. Fully qualified ID format: '/providers/Microsoft.Management/managementGroups/{managementGroupId}'.

- Required: No
- Type: array

### Parameter: `networkManagerScopes.subscriptions`

List of fully qualified IDs of Subscriptions to assign to the network manager to manage. Required if `managementGroups` is not provided. Fully qualified ID format: '/subscriptions/{subscriptionId}'.

- Required: No
- Type: array

### Parameter: `networkGroups`

Network Groups and static members to create for the network manager. Required if using "connectivityConfigurations" or "securityAdminConfigurations" parameters. A network group is global container that includes a set of virtual network resources from any region. Then, configurations are applied to target the network group, which applies the configuration to all members of the group. The two types are group memberships are static and dynamic memberships. Static membership allows you to explicitly add virtual networks to a group by manually selecting individual virtual networks, and is available as a child module, while dynamic membership is defined through Azure policy. See [How Azure Policy works with Network Groups](https://learn.microsoft.com/en-us/azure/virtual-network-manager/concept-azure-policy-integration) for more details.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-networkgroupsname) | string | The name of the network group. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-networkgroupsdescription) | string | A description of the network group. |
| [`memberType`](#parameter-networkgroupsmembertype) | string | The type of the group member. Subnet member type is used for routing configurations. |
| [`staticMembers`](#parameter-networkgroupsstaticmembers) | array | Static Members to create for the network group. Contains virtual networks to add to the network group. |

### Parameter: `networkGroups.name`

The name of the network group.

- Required: Yes
- Type: string

### Parameter: `networkGroups.description`

A description of the network group.

- Required: No
- Type: string

### Parameter: `networkGroups.memberType`

The type of the group member. Subnet member type is used for routing configurations.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Subnet'
    'VirtualNetwork'
  ]
  ```

### Parameter: `networkGroups.staticMembers`

Static Members to create for the network group. Contains virtual networks to add to the network group.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-networkgroupsstaticmembersname) | string | The name of the static member. |
| [`resourceId`](#parameter-networkgroupsstaticmembersresourceid) | string | Resource ID of the virtual network. |

### Parameter: `networkGroups.staticMembers.name`

The name of the static member.

- Required: Yes
- Type: string

### Parameter: `networkGroups.staticMembers.resourceId`

Resource ID of the virtual network.

- Required: Yes
- Type: string

### Parameter: `connectivityConfigurations`

Connectivity Configurations to create for the network manager. Network manager must contain at least one network group in order to define connectivity configurations.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appliesToGroups`](#parameter-connectivityconfigurationsappliestogroups) | array | Network Groups for the configuration. A connectivity configuration must be associated to at least one network group. |
| [`connectivityTopology`](#parameter-connectivityconfigurationsconnectivitytopology) | string | The connectivity topology to apply the configuration to. |
| [`name`](#parameter-connectivityconfigurationsname) | string | The name of the connectivity configuration. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`deleteExistingPeering`](#parameter-connectivityconfigurationsdeleteexistingpeering) | bool | Delete existing peering connections. |
| [`description`](#parameter-connectivityconfigurationsdescription) | string | A description of the connectivity configuration. |
| [`hubs`](#parameter-connectivityconfigurationshubs) | array | The hubs to apply the configuration to. |
| [`isGlobal`](#parameter-connectivityconfigurationsisglobal) | bool | Is global configuration. |

### Parameter: `connectivityConfigurations.appliesToGroups`

Network Groups for the configuration. A connectivity configuration must be associated to at least one network group.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`groupConnectivity`](#parameter-connectivityconfigurationsappliestogroupsgroupconnectivity) | string | Group connectivity type. |
| [`networkGroupResourceId`](#parameter-connectivityconfigurationsappliestogroupsnetworkgroupresourceid) | string | Resource Id of the network group. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`isGlobal`](#parameter-connectivityconfigurationsappliestogroupsisglobal) | bool | Flag if global is supported. |
| [`useHubGateway`](#parameter-connectivityconfigurationsappliestogroupsusehubgateway) | bool | Flag if use hub gateway. |

### Parameter: `connectivityConfigurations.appliesToGroups.groupConnectivity`

Group connectivity type.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'DirectlyConnected'
    'None'
  ]
  ```

### Parameter: `connectivityConfigurations.appliesToGroups.networkGroupResourceId`

Resource Id of the network group.

- Required: Yes
- Type: string

### Parameter: `connectivityConfigurations.appliesToGroups.isGlobal`

Flag if global is supported.

- Required: No
- Type: bool

### Parameter: `connectivityConfigurations.appliesToGroups.useHubGateway`

Flag if use hub gateway.

- Required: No
- Type: bool

### Parameter: `connectivityConfigurations.connectivityTopology`

The connectivity topology to apply the configuration to.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'HubAndSpoke'
    'Mesh'
  ]
  ```

### Parameter: `connectivityConfigurations.name`

The name of the connectivity configuration.

- Required: Yes
- Type: string

### Parameter: `connectivityConfigurations.deleteExistingPeering`

Delete existing peering connections.

- Required: No
- Type: bool

### Parameter: `connectivityConfigurations.description`

A description of the connectivity configuration.

- Required: No
- Type: string

### Parameter: `connectivityConfigurations.hubs`

The hubs to apply the configuration to.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`resourceId`](#parameter-connectivityconfigurationshubsresourceid) | string | Resource Id of the hub. |
| [`resourceType`](#parameter-connectivityconfigurationshubsresourcetype) | string | Resource type of the hub. |

### Parameter: `connectivityConfigurations.hubs.resourceId`

Resource Id of the hub.

- Required: Yes
- Type: string

### Parameter: `connectivityConfigurations.hubs.resourceType`

Resource type of the hub.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Microsoft.Network/virtualNetworks'
  ]
  ```

### Parameter: `connectivityConfigurations.isGlobal`

Is global configuration.

- Required: No
- Type: bool

### Parameter: `description`

A description of the Network Manager.

- Required: No
- Type: string
- Default: `''`

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

### Parameter: `networkManagerScopeAccesses`

Scope Access (Also known as features). String array containing any of "Connectivity", "SecurityAdmin", or "Routing". The connectivity feature allows you to create network topologies at scale. The security admin feature lets you create high-priority security rules, which take precedence over NSGs. The routing feature allows you to describe your desired routing behavior and orchestrate user-defined routes (UDRs) to create and maintain the desired routing behavior. If none of the features are required, then this parameter does not need to be specified, which then only enables features like "IPAM" and "Virtual Network Verifier".

- Required: No
- Type: array
- Allowed:
  ```Bicep
  [
    'Connectivity'
    'Routing'
    'SecurityAdmin'
  ]
  ```

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'IPAM Pool User'`
  - `'LocalNGFirewallAdministrator role'`
  - `'Network Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Resource Policy Contributor'`
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

### Parameter: `routingConfigurations`

Routing Configurations requires enabling the "Routing" feature on Network Manager. A routing configuration contains a set of rule collections. Each rule collection contains one or more routing rules.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-routingconfigurationsname) | string | The name of the routing configuration. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-routingconfigurationsdescription) | string | A description of the routing configuration. |
| [`ruleCollections`](#parameter-routingconfigurationsrulecollections) | array | Rule collections to create for the routing configuration. |

### Parameter: `routingConfigurations.name`

The name of the routing configuration.

- Required: Yes
- Type: string

### Parameter: `routingConfigurations.description`

A description of the routing configuration.

- Required: No
- Type: string

### Parameter: `routingConfigurations.ruleCollections`

Rule collections to create for the routing configuration.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appliesTo`](#parameter-routingconfigurationsrulecollectionsappliesto) | array | List of network groups for configuration. A routing rule collection must be associated to at least one network group. |
| [`name`](#parameter-routingconfigurationsrulecollectionsname) | string | The name of the rule collection. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-routingconfigurationsrulecollectionsdescription) | string | A description of the rule collection. |
| [`disableBgpRoutePropagation`](#parameter-routingconfigurationsrulecollectionsdisablebgproutepropagation) | bool | Disables BGP route propagation for the rule collection. Defaults to true. |
| [`rules`](#parameter-routingconfigurationsrulecollectionsrules) | array | List of rules for the routing rules collection. Warning: A rule collection without a rule will cause a deployment of routing configuration to fail in network manager. |

### Parameter: `routingConfigurations.ruleCollections.appliesTo`

List of network groups for configuration. A routing rule collection must be associated to at least one network group.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`networkGroupResourceId`](#parameter-routingconfigurationsrulecollectionsappliestonetworkgroupresourceid) | string | The resource ID of the network group. |

### Parameter: `routingConfigurations.ruleCollections.appliesTo.networkGroupResourceId`

The resource ID of the network group.

- Required: Yes
- Type: string

### Parameter: `routingConfigurations.ruleCollections.name`

The name of the rule collection.

- Required: Yes
- Type: string

### Parameter: `routingConfigurations.ruleCollections.description`

A description of the rule collection.

- Required: No
- Type: string

### Parameter: `routingConfigurations.ruleCollections.disableBgpRoutePropagation`

Disables BGP route propagation for the rule collection. Defaults to true.

- Required: No
- Type: bool

### Parameter: `routingConfigurations.ruleCollections.rules`

List of rules for the routing rules collection. Warning: A rule collection without a rule will cause a deployment of routing configuration to fail in network manager.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`destination`](#parameter-routingconfigurationsrulecollectionsrulesdestination) | object | The destination can be IP addresses or Service Tag for this route. Address Prefixes are defined using the CIDR format, while Service tags are predefined identifiers that represent a category of IP addresses, which are managed by Azure. |
| [`name`](#parameter-routingconfigurationsrulecollectionsrulesname) | string | The name of the rule. |
| [`nextHop`](#parameter-routingconfigurationsrulecollectionsrulesnexthop) | object | The next hop handles the matching packets for this route. It can be the virtual network, the virtual network gateway, the internet, a virtual appliance, or none. Virtual network gateways cannot be used if the address prefix is IPv6. If the next hop type is VirtualAppliance, the next hop address must be specified. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-routingconfigurationsrulecollectionsrulesdescription) | string | A description of the rule. |

### Parameter: `routingConfigurations.ruleCollections.rules.destination`

The destination can be IP addresses or Service Tag for this route. Address Prefixes are defined using the CIDR format, while Service tags are predefined identifiers that represent a category of IP addresses, which are managed by Azure.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`destinationAddress`](#parameter-routingconfigurationsrulecollectionsrulesdestinationdestinationaddress) | string | The destination IP addresses or Service Tag for this route. For IP addresses, it is the IP address range in CIDR notation that this route applies to. If the destination IP address of a packet falls in this range, it matches this route. As for Service Tags, valid identifiers can be "AzureCloud", "Storage.AustraliaEast", etc. See https://docs.microsoft.com/en-us/azure/virtual-network/service-tags-overview for more information on service tags. |
| [`type`](#parameter-routingconfigurationsrulecollectionsrulesdestinationtype) | string | The destination type can be IP addresses or Service Tag for this route. Address Prefixes are defined using the CIDR format, while Service tags are predefined identifiers that represent a category of IP addresses, which are managed by Azure. |

### Parameter: `routingConfigurations.ruleCollections.rules.destination.destinationAddress`

The destination IP addresses or Service Tag for this route. For IP addresses, it is the IP address range in CIDR notation that this route applies to. If the destination IP address of a packet falls in this range, it matches this route. As for Service Tags, valid identifiers can be "AzureCloud", "Storage.AustraliaEast", etc. See https://docs.microsoft.com/en-us/azure/virtual-network/service-tags-overview for more information on service tags.

- Required: Yes
- Type: string

### Parameter: `routingConfigurations.ruleCollections.rules.destination.type`

The destination type can be IP addresses or Service Tag for this route. Address Prefixes are defined using the CIDR format, while Service tags are predefined identifiers that represent a category of IP addresses, which are managed by Azure.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AddressPrefix'
    'ServiceTag'
  ]
  ```

### Parameter: `routingConfigurations.ruleCollections.rules.name`

The name of the rule.

- Required: Yes
- Type: string

### Parameter: `routingConfigurations.ruleCollections.rules.nextHop`

The next hop handles the matching packets for this route. It can be the virtual network, the virtual network gateway, the internet, a virtual appliance, or none. Virtual network gateways cannot be used if the address prefix is IPv6. If the next hop type is VirtualAppliance, the next hop address must be specified.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`nextHopType`](#parameter-routingconfigurationsrulecollectionsrulesnexthopnexthoptype) | string | The next hop handles the matching packets for this route. It can be the virtual network, the virtual network gateway, the internet, a virtual appliance, or none. Virtual network gateways cannot be used if the address prefix is IPv6. If the next hop type is VirtualAppliance, the next hop address must be specified. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`nextHopAddress`](#parameter-routingconfigurationsrulecollectionsrulesnexthopnexthopaddress) | string | The IP address of the next hop. Required if the next hop type is VirtualAppliance. |

### Parameter: `routingConfigurations.ruleCollections.rules.nextHop.nextHopType`

The next hop handles the matching packets for this route. It can be the virtual network, the virtual network gateway, the internet, a virtual appliance, or none. Virtual network gateways cannot be used if the address prefix is IPv6. If the next hop type is VirtualAppliance, the next hop address must be specified.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Internet'
    'NoNextHop'
    'VirtualAppliance'
    'VirtualNetworkGateway'
    'VnetLocal'
  ]
  ```

### Parameter: `routingConfigurations.ruleCollections.rules.nextHop.nextHopAddress`

The IP address of the next hop. Required if the next hop type is VirtualAppliance.

- Required: No
- Type: string

### Parameter: `routingConfigurations.ruleCollections.rules.description`

A description of the rule.

- Required: No
- Type: string

### Parameter: `scopeConnections`

Scope Connections to create for the network manager. Allows network manager to manage resources from another tenant. Supports management groups or subscriptions from another tenant.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-scopeconnectionsname) | string | The name of the scope connection. |
| [`resourceId`](#parameter-scopeconnectionsresourceid) | string | Enter the subscription or management group resource ID that you want to add to this network manager's scope. |
| [`tenantId`](#parameter-scopeconnectionstenantid) | string | Tenant ID of the subscription or management group that you want to manage. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-scopeconnectionsdescription) | string | A description of the scope connection. |

### Parameter: `scopeConnections.name`

The name of the scope connection.

- Required: Yes
- Type: string

### Parameter: `scopeConnections.resourceId`

Enter the subscription or management group resource ID that you want to add to this network manager's scope.

- Required: Yes
- Type: string

### Parameter: `scopeConnections.tenantId`

Tenant ID of the subscription or management group that you want to manage.

- Required: Yes
- Type: string

### Parameter: `scopeConnections.description`

A description of the scope connection.

- Required: No
- Type: string

### Parameter: `securityAdminConfigurations`

Security Admin Configurations requires enabling the "SecurityAdmin" feature on Network Manager. A security admin configuration contains a set of rule collections. Each rule collection contains one or more security admin rules. You then associate the rule collection with the network groups that you want to apply the security admin rules to.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`applyOnNetworkIntentPolicyBasedServices`](#parameter-securityadminconfigurationsapplyonnetworkintentpolicybasedservices) | array | Apply on network intent policy based services. |
| [`name`](#parameter-securityadminconfigurationsname) | string | The name of the security admin configuration. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-securityadminconfigurationsdescription) | string | A description of the security admin configuration. |
| [`ruleCollections`](#parameter-securityadminconfigurationsrulecollections) | array | Rule collections to create for the security admin configuration. |

### Parameter: `securityAdminConfigurations.applyOnNetworkIntentPolicyBasedServices`

Apply on network intent policy based services.

- Required: Yes
- Type: array
- Allowed:
  ```Bicep
  [
    'All'
    'AllowRulesOnly'
    'None'
  ]
  ```

### Parameter: `securityAdminConfigurations.name`

The name of the security admin configuration.

- Required: Yes
- Type: string

### Parameter: `securityAdminConfigurations.description`

A description of the security admin configuration.

- Required: No
- Type: string

### Parameter: `securityAdminConfigurations.ruleCollections`

Rule collections to create for the security admin configuration.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appliesToGroups`](#parameter-securityadminconfigurationsrulecollectionsappliestogroups) | array | List of network groups for configuration. An admin rule collection must be associated to at least one network group. |
| [`name`](#parameter-securityadminconfigurationsrulecollectionsname) | string | The name of the admin rule collection. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-securityadminconfigurationsrulecollectionsdescription) | string | A description of the admin rule collection. |
| [`rules`](#parameter-securityadminconfigurationsrulecollectionsrules) | array | List of rules for the admin rules collection. Security admin rules allows enforcing security policy criteria that matches the conditions set. Warning: A rule collection without rule will cause a deployment configuration for security admin goal state in network manager to fail. |

### Parameter: `securityAdminConfigurations.ruleCollections.appliesToGroups`

List of network groups for configuration. An admin rule collection must be associated to at least one network group.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`networkGroupResourceId`](#parameter-securityadminconfigurationsrulecollectionsappliestogroupsnetworkgroupresourceid) | string | The resource ID of the network group. |

### Parameter: `securityAdminConfigurations.ruleCollections.appliesToGroups.networkGroupResourceId`

The resource ID of the network group.

- Required: Yes
- Type: string

### Parameter: `securityAdminConfigurations.ruleCollections.name`

The name of the admin rule collection.

- Required: Yes
- Type: string

### Parameter: `securityAdminConfigurations.ruleCollections.description`

A description of the admin rule collection.

- Required: No
- Type: string

### Parameter: `securityAdminConfigurations.ruleCollections.rules`

List of rules for the admin rules collection. Security admin rules allows enforcing security policy criteria that matches the conditions set. Warning: A rule collection without rule will cause a deployment configuration for security admin goal state in network manager to fail.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`access`](#parameter-securityadminconfigurationsrulecollectionsrulesaccess) | string | Indicates the access allowed for this particular rule. "Allow" means traffic matching this rule will be allowed. "Deny" means traffic matching this rule will be blocked. "AlwaysAllow" means that traffic matching this rule will be allowed regardless of other rules with lower priority or user-defined NSGs. |
| [`direction`](#parameter-securityadminconfigurationsrulecollectionsrulesdirection) | string | Indicates if the traffic matched against the rule in inbound or outbound. |
| [`name`](#parameter-securityadminconfigurationsrulecollectionsrulesname) | string | The name of the rule. |
| [`priority`](#parameter-securityadminconfigurationsrulecollectionsrulespriority) | int | The priority of the rule. The value can be between 1 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule. |
| [`protocol`](#parameter-securityadminconfigurationsrulecollectionsrulesprotocol) | string | Network protocol this rule applies to. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-securityadminconfigurationsrulecollectionsrulesdescription) | string | A description of the rule. |
| [`destinationPortRanges`](#parameter-securityadminconfigurationsrulecollectionsrulesdestinationportranges) | array | List of destination port ranges. This specifies on which ports traffic will be allowed or denied by this rule. Provide an (*) to allow traffic on any port. Port ranges are between 1-65535. |
| [`destinations`](#parameter-securityadminconfigurationsrulecollectionsrulesdestinations) | array | The destnations filter can be an IP Address or a service tag. Each filter contains the properties AddressPrefixType (IPPrefix or ServiceTag) and AddressPrefix (using CIDR notation (e.g. 192.168.99.0/24 or 2001:1234::/64) or a service tag (e.g. AppService.WestEurope)). Combining CIDR and Service tags in one rule filter is not permitted. |
| [`sourcePortRanges`](#parameter-securityadminconfigurationsrulecollectionsrulessourceportranges) | array | List of destination port ranges. This specifies on which ports traffic will be allowed or denied by this rule. Provide an (*) to allow traffic on any port. Port ranges are between 1-65535. |
| [`sources`](#parameter-securityadminconfigurationsrulecollectionsrulessources) | array | The source filter can be an IP Address or a service tag. Each filter contains the properties AddressPrefixType (IPPrefix or ServiceTag) and AddressPrefix (using CIDR notation (e.g. 192.168.99.0/24 or 2001:1234::/64) or a service tag (e.g. AppService.WestEurope)). Combining CIDR and Service tags in one rule filter is not permitted. |

### Parameter: `securityAdminConfigurations.ruleCollections.rules.access`

Indicates the access allowed for this particular rule. "Allow" means traffic matching this rule will be allowed. "Deny" means traffic matching this rule will be blocked. "AlwaysAllow" means that traffic matching this rule will be allowed regardless of other rules with lower priority or user-defined NSGs.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Allow'
    'AlwaysAllow'
    'Deny'
  ]
  ```

### Parameter: `securityAdminConfigurations.ruleCollections.rules.direction`

Indicates if the traffic matched against the rule in inbound or outbound.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Inbound'
    'Outbound'
  ]
  ```

### Parameter: `securityAdminConfigurations.ruleCollections.rules.name`

The name of the rule.

- Required: Yes
- Type: string

### Parameter: `securityAdminConfigurations.ruleCollections.rules.priority`

The priority of the rule. The value can be between 1 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule.

- Required: Yes
- Type: int
- MinValue: 1
- MaxValue: 4096

### Parameter: `securityAdminConfigurations.ruleCollections.rules.protocol`

Network protocol this rule applies to.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Ah'
    'Any'
    'Esp'
    'Icmp'
    'Tcp'
    'Udp'
  ]
  ```
- MinValue: 1
- MaxValue: 4096

### Parameter: `securityAdminConfigurations.ruleCollections.rules.description`

A description of the rule.

- Required: No
- Type: string
- MinValue: 1
- MaxValue: 4096

### Parameter: `securityAdminConfigurations.ruleCollections.rules.destinationPortRanges`

List of destination port ranges. This specifies on which ports traffic will be allowed or denied by this rule. Provide an (*) to allow traffic on any port. Port ranges are between 1-65535.

- Required: No
- Type: array
- MinValue: 1
- MaxValue: 4096

### Parameter: `securityAdminConfigurations.ruleCollections.rules.destinations`

The destnations filter can be an IP Address or a service tag. Each filter contains the properties AddressPrefixType (IPPrefix or ServiceTag) and AddressPrefix (using CIDR notation (e.g. 192.168.99.0/24 or 2001:1234::/64) or a service tag (e.g. AppService.WestEurope)). Combining CIDR and Service tags in one rule filter is not permitted.

- Required: No
- Type: array
- MinValue: 1
- MaxValue: 4096

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addressPrefix`](#parameter-securityadminconfigurationsrulecollectionsrulesdestinationsaddressprefix) | string | Address prefix. |
| [`addressPrefixType`](#parameter-securityadminconfigurationsrulecollectionsrulesdestinationsaddressprefixtype) | string | Address prefix type. |

### Parameter: `securityAdminConfigurations.ruleCollections.rules.destinations.addressPrefix`

Address prefix.

- Required: Yes
- Type: string
- MinValue: 1
- MaxValue: 4096

### Parameter: `securityAdminConfigurations.ruleCollections.rules.destinations.addressPrefixType`

Address prefix type.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'IPPrefix'
    'ServiceTag'
  ]
  ```
- MinValue: 1
- MaxValue: 4096

### Parameter: `securityAdminConfigurations.ruleCollections.rules.sourcePortRanges`

List of destination port ranges. This specifies on which ports traffic will be allowed or denied by this rule. Provide an (*) to allow traffic on any port. Port ranges are between 1-65535.

- Required: No
- Type: array
- MinValue: 1
- MaxValue: 4096

### Parameter: `securityAdminConfigurations.ruleCollections.rules.sources`

The source filter can be an IP Address or a service tag. Each filter contains the properties AddressPrefixType (IPPrefix or ServiceTag) and AddressPrefix (using CIDR notation (e.g. 192.168.99.0/24 or 2001:1234::/64) or a service tag (e.g. AppService.WestEurope)). Combining CIDR and Service tags in one rule filter is not permitted.

- Required: No
- Type: array
- MinValue: 1
- MaxValue: 4096

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addressPrefix`](#parameter-securityadminconfigurationsrulecollectionsrulessourcesaddressprefix) | string | Address prefix. |
| [`addressPrefixType`](#parameter-securityadminconfigurationsrulecollectionsrulessourcesaddressprefixtype) | string | Address prefix type. |

### Parameter: `securityAdminConfigurations.ruleCollections.rules.sources.addressPrefix`

Address prefix.

- Required: Yes
- Type: string
- MinValue: 1
- MaxValue: 4096

### Parameter: `securityAdminConfigurations.ruleCollections.rules.sources.addressPrefixType`

Address prefix type.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'IPPrefix'
    'ServiceTag'
  ]
  ```
- MinValue: 1
- MaxValue: 4096

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the network manager. |
| `resourceGroupName` | string | The resource group the network manager was deployed into. |
| `resourceId` | string | The resource ID of the network manager. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.4.1` | Remote reference |

## Notes

In order to deploy a Network Manager with the `networkManagerScopes` property set to `managementGroups`, you need to register the `Microsoft.Network` resource provider at the Management Group first ([ref](https://learn.microsoft.com/en-us/rest/api/resources/providers/register-at-management-group-scope)).

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
