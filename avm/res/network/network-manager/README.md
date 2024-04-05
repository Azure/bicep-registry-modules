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
| `Microsoft.Network/networkManagers` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/networkManagers) |
| `Microsoft.Network/networkManagers/connectivityConfigurations` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/networkManagers/connectivityConfigurations) |
| `Microsoft.Network/networkManagers/networkGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/networkManagers/networkGroups) |
| `Microsoft.Network/networkManagers/networkGroups/staticMembers` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/networkManagers/networkGroups/staticMembers) |
| `Microsoft.Network/networkManagers/scopeConnections` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/networkManagers/scopeConnections) |
| `Microsoft.Network/networkManagers/securityAdminConfigurations` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/networkManagers/securityAdminConfigurations) |
| `Microsoft.Network/networkManagers/securityAdminConfigurations/ruleCollections` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/networkManagers/securityAdminConfigurations/ruleCollections) |
| `Microsoft.Network/networkManagers/securityAdminConfigurations/ruleCollections/rules` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/networkManagers/securityAdminConfigurations/ruleCollections/rules) |

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
    networkManagerScopeAccesses: [
      'Connectivity'
    ]
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

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "nnmmin001"
    },
    "networkManagerScopeAccesses": {
      "value": [
        "Connectivity"
      ]
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
    networkManagerScopeAccesses: [
      'Connectivity'
      'SecurityAdmin'
    ]
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
            isGlobal: 'False'
            networkGroupId: '<networkGroupId>'
            useHubGateway: 'False'
          }
        ]
        connectivityTopology: 'HubAndSpoke'
        deleteExistingPeering: 'True'
        description: 'hubSpokeConnectivity description'
        hubs: [
          {
            resourceId: '<resourceId>'
            resourceType: 'Microsoft.Network/virtualNetworks'
          }
        ]
        isGlobal: 'True'
        name: 'hubSpokeConnectivity'
      }
      {
        appliesToGroups: [
          {
            groupConnectivity: 'None'
            isGlobal: 'False'
            networkGroupId: '<networkGroupId>'
            useHubGateway: 'False'
          }
        ]
        connectivityTopology: 'Mesh'
        deleteExistingPeering: 'True'
        description: 'MeshConnectivity description'
        isGlobal: 'True'
        name: 'MeshConnectivity'
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
        name: 'network-group-spokes'
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
    scopeConnections: [
      {
        description: 'description of the scope connection'
        name: 'scope-connection-test'
        resourceId: '<resourceId>'
        tenantid: '<tenantid>'
      }
    ]
    securityAdminConfigurations: [
      {
        applyOnNetworkIntentPolicyBasedServices: [
          'AllowRulesOnly'
        ]
        description: 'description of the security admin config'
        name: 'test-security-admin-config'
        ruleCollections: [
          {
            appliesToGroups: [
              {
                networkGroupId: '<networkGroupId>'
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
                networkGroupId: '<networkGroupId>'
              }
            ]
            description: 'test-rule-collection-description'
            name: 'test-rule-collection-2'
            rules: [
              {
                access: 'Allow'
                description: 'test-inbound-allow-rule-3-description'
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

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "<name>"
    },
    "networkManagerScopeAccesses": {
      "value": [
        "Connectivity",
        "SecurityAdmin"
      ]
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
              "isGlobal": "False",
              "networkGroupId": "<networkGroupId>",
              "useHubGateway": "False"
            }
          ],
          "connectivityTopology": "HubAndSpoke",
          "deleteExistingPeering": "True",
          "description": "hubSpokeConnectivity description",
          "hubs": [
            {
              "resourceId": "<resourceId>",
              "resourceType": "Microsoft.Network/virtualNetworks"
            }
          ],
          "isGlobal": "True",
          "name": "hubSpokeConnectivity"
        },
        {
          "appliesToGroups": [
            {
              "groupConnectivity": "None",
              "isGlobal": "False",
              "networkGroupId": "<networkGroupId>",
              "useHubGateway": "False"
            }
          ],
          "connectivityTopology": "Mesh",
          "deleteExistingPeering": "True",
          "description": "MeshConnectivity description",
          "isGlobal": "True",
          "name": "MeshConnectivity"
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
          "name": "network-group-spokes",
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
    "scopeConnections": {
      "value": [
        {
          "description": "description of the scope connection",
          "name": "scope-connection-test",
          "resourceId": "<resourceId>",
          "tenantid": "<tenantid>"
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
          "name": "test-security-admin-config",
          "ruleCollections": [
            {
              "appliesToGroups": [
                {
                  "networkGroupId": "<networkGroupId>"
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
                  "networkGroupId": "<networkGroupId>"
                }
              ],
              "description": "test-rule-collection-description",
              "name": "test-rule-collection-2",
              "rules": [
                {
                  "access": "Allow",
                  "description": "test-inbound-allow-rule-3-description",
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
    networkManagerScopeAccesses: [
      'SecurityAdmin'
    ]
    networkManagerScopes: {
      subscriptions: [
        '<id>'
      ]
    }
    // Non-required parameters
    location: '<location>'
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
      "value": "nnmwaf001"
    },
    "networkManagerScopeAccesses": {
      "value": [
        "SecurityAdmin"
      ]
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
| [`name`](#parameter-name) | string | Name of the Network Manager. |
| [`networkManagerScopeAccesses`](#parameter-networkmanagerscopeaccesses) | array | Scope Access. String array containing any of "Connectivity", "SecurityAdmin". The connectivity feature allows you to create network topologies at scale. The security admin feature lets you create high-priority security rules, which take precedence over NSGs. |
| [`networkManagerScopes`](#parameter-networkmanagerscopes) | object | Scope of Network Manager. Contains a list of management groups or a list of subscriptions. This defines the boundary of network resources that this Network Manager instance can manage. If using Management Groups, ensure that the "Microsoft.Network" resource provider is registered for those Management Groups prior to deployment. |

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
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`scopeConnections`](#parameter-scopeconnections) | array | Scope Connections to create for the network manager. Allows network manager to manage resources from another tenant. Supports management groups or subscriptions from another tenant. |
| [`securityAdminConfigurations`](#parameter-securityadminconfigurations) | array | Security Admin Configurations, Rule Collections and Rules to create for the network manager. Azure Virtual Network Manager provides two different types of configurations you can deploy across your virtual networks, one of them being a SecurityAdmin configuration. A security admin configuration contains a set of rule collections. Each rule collection contains one or more security admin rules. You then associate the rule collection with the network groups that you want to apply the security admin rules to. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `name`

Name of the Network Manager.

- Required: Yes
- Type: string

### Parameter: `networkManagerScopeAccesses`

Scope Access. String array containing any of "Connectivity", "SecurityAdmin". The connectivity feature allows you to create network topologies at scale. The security admin feature lets you create high-priority security rules, which take precedence over NSGs.

- Required: Yes
- Type: array

### Parameter: `networkManagerScopes`

Scope of Network Manager. Contains a list of management groups or a list of subscriptions. This defines the boundary of network resources that this Network Manager instance can manage. If using Management Groups, ensure that the "Microsoft.Network" resource provider is registered for those Management Groups prior to deployment.

- Required: Yes
- Type: object

### Parameter: `networkGroups`

Network Groups and static members to create for the network manager. Required if using "connectivityConfigurations" or "securityAdminConfigurations" parameters. A network group is global container that includes a set of virtual network resources from any region. Then, configurations are applied to target the network group, which applies the configuration to all members of the group. The two types are group memberships are static and dynamic memberships. Static membership allows you to explicitly add virtual networks to a group by manually selecting individual virtual networks, and is available as a child module, while dynamic membership is defined through Azure policy. See [How Azure Policy works with Network Groups](https://learn.microsoft.com/en-us/azure/virtual-network-manager/concept-azure-policy-integration) for more details.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `connectivityConfigurations`

Connectivity Configurations to create for the network manager. Network manager must contain at least one network group in order to define connectivity configurations.

- Required: No
- Type: array
- Default: `[]`

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

### Parameter: `roleAssignments`

Array of role assignments to create.

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

### Parameter: `scopeConnections`

Scope Connections to create for the network manager. Allows network manager to manage resources from another tenant. Supports management groups or subscriptions from another tenant.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `securityAdminConfigurations`

Security Admin Configurations, Rule Collections and Rules to create for the network manager. Azure Virtual Network Manager provides two different types of configurations you can deploy across your virtual networks, one of them being a SecurityAdmin configuration. A security admin configuration contains a set of rule collections. Each rule collection contains one or more security admin rules. You then associate the rule collection with the network groups that you want to apply the security admin rules to.

- Required: No
- Type: array
- Default: `[]`

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

_None_

## Notes

In order to deploy a Network Manager with the `networkManagerScopes` property set to `managementGroups`, you need to register the `Microsoft.Network` resource provider at the Management Group first ([ref](https://learn.microsoft.com/en-us/rest/api/resources/providers/register-at-management-group-scope)).

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
