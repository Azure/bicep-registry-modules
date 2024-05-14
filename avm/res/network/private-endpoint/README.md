# Private Endpoints `[Microsoft.Network/privateEndpoints]`

This module deploys a Private Endpoint.

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
| `Microsoft.Network/privateEndpoints` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints/privateDnsZoneGroups) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/network/private-endpoint:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module privateEndpoint 'br/public:avm/res/network/private-endpoint:<version>' = {
  name: 'privateEndpointDeployment'
  params: {
    // Required parameters
    name: 'npemin001'
    subnetResourceId: '<subnetResourceId>'
    // Non-required parameters
    applicationSecurityGroupResourceIds: []
    customDnsConfigs: []
    customNetworkInterfaceName: ''
    ipConfigurations: []
    location: '<location>'
    lock: {}
    manualPrivateLinkServiceConnections: []
    privateDnsZoneGroupName: ''
    privateDnsZoneResourceIds: []
    privateLinkServiceConnections: [
      {
        name: 'npemin001'
        properties: {
          groupIds: [
            'vault'
          ]
          privateLinkServiceId: '<privateLinkServiceId>'
        }
      }
    ]
    roleAssignments: []
    tags: {}
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
      "value": "npemin001"
    },
    "subnetResourceId": {
      "value": "<subnetResourceId>"
    },
    // Non-required parameters
    "applicationSecurityGroupResourceIds": {
      "value": []
    },
    "customDnsConfigs": {
      "value": []
    },
    "customNetworkInterfaceName": {
      "value": ""
    },
    "ipConfigurations": {
      "value": []
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": {}
    },
    "manualPrivateLinkServiceConnections": {
      "value": []
    },
    "privateDnsZoneGroupName": {
      "value": ""
    },
    "privateDnsZoneResourceIds": {
      "value": []
    },
    "privateLinkServiceConnections": {
      "value": [
        {
          "name": "npemin001",
          "properties": {
            "groupIds": [
              "vault"
            ],
            "privateLinkServiceId": "<privateLinkServiceId>"
          }
        }
      ]
    },
    "roleAssignments": {
      "value": []
    },
    "tags": {
      "value": {}
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
module privateEndpoint 'br/public:avm/res/network/private-endpoint:<version>' = {
  name: 'privateEndpointDeployment'
  params: {
    // Required parameters
    name: 'npemax001'
    subnetResourceId: '<subnetResourceId>'
    // Non-required parameters
    applicationSecurityGroupResourceIds: [
      '<applicationSecurityGroupResourceId>'
    ]
    customDnsConfigs: [
      {
        fqdn: 'abc.keyvault.com'
        ipAddresses: [
          '10.0.0.10'
        ]
      }
    ]
    customNetworkInterfaceName: 'npemax001nic'
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
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    manualPrivateLinkServiceConnections: []
    privateDnsZoneGroupName: 'default'
    privateDnsZoneResourceIds: [
      '<privateDNSZoneResourceId>'
    ]
    privateLinkServiceConnections: [
      {
        name: 'npemax001'
        properties: {
          groupIds: [
            'vault'
          ]
          privateLinkServiceId: '<privateLinkServiceId>'
          requestMessage: 'Hey there'
        }
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
      "value": "npemax001"
    },
    "subnetResourceId": {
      "value": "<subnetResourceId>"
    },
    // Non-required parameters
    "applicationSecurityGroupResourceIds": {
      "value": [
        "<applicationSecurityGroupResourceId>"
      ]
    },
    "customDnsConfigs": {
      "value": [
        {
          "fqdn": "abc.keyvault.com",
          "ipAddresses": [
            "10.0.0.10"
          ]
        }
      ]
    },
    "customNetworkInterfaceName": {
      "value": "npemax001nic"
    },
    "ipConfigurations": {
      "value": [
        {
          "name": "myIPconfig",
          "properties": {
            "groupId": "vault",
            "memberName": "default",
            "privateIPAddress": "10.0.0.10"
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
    "manualPrivateLinkServiceConnections": {
      "value": []
    },
    "privateDnsZoneGroupName": {
      "value": "default"
    },
    "privateDnsZoneResourceIds": {
      "value": [
        "<privateDNSZoneResourceId>"
      ]
    },
    "privateLinkServiceConnections": {
      "value": [
        {
          "name": "npemax001",
          "properties": {
            "groupIds": [
              "vault"
            ],
            "privateLinkServiceId": "<privateLinkServiceId>",
            "requestMessage": "Hey there"
          }
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

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module privateEndpoint 'br/public:avm/res/network/private-endpoint:<version>' = {
  name: 'privateEndpointDeployment'
  params: {
    // Required parameters
    name: 'npewaf001'
    subnetResourceId: '<subnetResourceId>'
    // Non-required parameters
    applicationSecurityGroupResourceIds: [
      '<applicationSecurityGroupResourceId>'
    ]
    customDnsConfigs: []
    customNetworkInterfaceName: 'npewaf001nic'
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
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    manualPrivateLinkServiceConnections: []
    privateDnsZoneGroupName: 'default'
    privateDnsZoneResourceIds: [
      '<privateDNSZoneResourceId>'
    ]
    privateLinkServiceConnections: [
      {
        name: 'npewaf001'
        properties: {
          groupIds: [
            'vault'
          ]
          privateLinkServiceId: '<privateLinkServiceId>'
        }
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
      "value": "npewaf001"
    },
    "subnetResourceId": {
      "value": "<subnetResourceId>"
    },
    // Non-required parameters
    "applicationSecurityGroupResourceIds": {
      "value": [
        "<applicationSecurityGroupResourceId>"
      ]
    },
    "customDnsConfigs": {
      "value": []
    },
    "customNetworkInterfaceName": {
      "value": "npewaf001nic"
    },
    "ipConfigurations": {
      "value": [
        {
          "name": "myIPconfig",
          "properties": {
            "groupId": "vault",
            "memberName": "default",
            "privateIPAddress": "10.0.0.10"
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
    "manualPrivateLinkServiceConnections": {
      "value": []
    },
    "privateDnsZoneGroupName": {
      "value": "default"
    },
    "privateDnsZoneResourceIds": {
      "value": [
        "<privateDNSZoneResourceId>"
      ]
    },
    "privateLinkServiceConnections": {
      "value": [
        {
          "name": "npewaf001",
          "properties": {
            "groupIds": [
              "vault"
            ],
            "privateLinkServiceId": "<privateLinkServiceId>"
          }
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
| [`name`](#parameter-name) | string | Name of the private endpoint resource to create. |
| [`subnetResourceId`](#parameter-subnetresourceid) | string | Resource ID of the subnet where the endpoint needs to be created. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`applicationSecurityGroupResourceIds`](#parameter-applicationsecuritygroupresourceids) | array | Application security groups in which the private endpoint IP configuration is included. |
| [`customDnsConfigs`](#parameter-customdnsconfigs) | array | Custom DNS configurations. |
| [`customNetworkInterfaceName`](#parameter-customnetworkinterfacename) | string | The custom name of the network interface attached to the private endpoint. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`ipConfigurations`](#parameter-ipconfigurations) | array | A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`manualPrivateLinkServiceConnections`](#parameter-manualprivatelinkserviceconnections) | array | A grouping of information about the connection to the remote resource. Used when the network admin does not have access to approve connections to the remote resource. |
| [`privateDnsZoneGroupName`](#parameter-privatednszonegroupname) | string | The name of the private DNS zone group to create if `privateDnsZoneResourceIds` were provided. |
| [`privateDnsZoneResourceIds`](#parameter-privatednszoneresourceids) | array | The private DNS zone groups to associate the private endpoint. A DNS zone group can support up to 5 DNS zones. |
| [`privateLinkServiceConnections`](#parameter-privatelinkserviceconnections) | array | A grouping of information about the connection to the remote resource. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-tags) | object | Tags to be applied on all resources/resource groups in this deployment. |

### Parameter: `name`

Name of the private endpoint resource to create.

- Required: Yes
- Type: string

### Parameter: `subnetResourceId`

Resource ID of the subnet where the endpoint needs to be created.

- Required: Yes
- Type: string

### Parameter: `applicationSecurityGroupResourceIds`

Application security groups in which the private endpoint IP configuration is included.

- Required: No
- Type: array

### Parameter: `customDnsConfigs`

Custom DNS configurations.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`fqdn`](#parameter-customdnsconfigsfqdn) | string | Fqdn that resolves to private endpoint IP address. |
| [`ipAddresses`](#parameter-customdnsconfigsipaddresses) | array | A list of private IP addresses of the private endpoint. |

### Parameter: `customDnsConfigs.fqdn`

Fqdn that resolves to private endpoint IP address.

- Required: Yes
- Type: string

### Parameter: `customDnsConfigs.ipAddresses`

A list of private IP addresses of the private endpoint.

- Required: Yes
- Type: array

### Parameter: `customNetworkInterfaceName`

The custom name of the network interface attached to the private endpoint.

- Required: No
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `ipConfigurations`

A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-ipconfigurationsname) | string | The name of the resource that is unique within a resource group. |
| [`properties`](#parameter-ipconfigurationsproperties) | object | Properties of private endpoint IP configurations. |

### Parameter: `ipConfigurations.name`

The name of the resource that is unique within a resource group.

- Required: Yes
- Type: string

### Parameter: `ipConfigurations.properties`

Properties of private endpoint IP configurations.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`groupId`](#parameter-ipconfigurationspropertiesgroupid) | string | The ID of a group obtained from the remote resource that this private endpoint should connect to. |
| [`memberName`](#parameter-ipconfigurationspropertiesmembername) | string | The member name of a group obtained from the remote resource that this private endpoint should connect to. |
| [`privateIPAddress`](#parameter-ipconfigurationspropertiesprivateipaddress) | string | A private IP address obtained from the private endpoint's subnet. |

### Parameter: `ipConfigurations.properties.groupId`

The ID of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: string

### Parameter: `ipConfigurations.properties.memberName`

The member name of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: string

### Parameter: `ipConfigurations.properties.privateIPAddress`

A private IP address obtained from the private endpoint's subnet.

- Required: Yes
- Type: string

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

### Parameter: `manualPrivateLinkServiceConnections`

A grouping of information about the connection to the remote resource. Used when the network admin does not have access to approve connections to the remote resource.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-manualprivatelinkserviceconnectionsname) | string | The name of the private link service connection. |
| [`properties`](#parameter-manualprivatelinkserviceconnectionsproperties) | object | Properties of private link service connection. |

### Parameter: `manualPrivateLinkServiceConnections.name`

The name of the private link service connection.

- Required: Yes
- Type: string

### Parameter: `manualPrivateLinkServiceConnections.properties`

Properties of private link service connection.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`groupIds`](#parameter-manualprivatelinkserviceconnectionspropertiesgroupids) | array | The ID of a group obtained from the remote resource that this private endpoint should connect to. |
| [`privateLinkServiceId`](#parameter-manualprivatelinkserviceconnectionspropertiesprivatelinkserviceid) | string | The resource id of private link service. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`requestMessage`](#parameter-manualprivatelinkserviceconnectionspropertiesrequestmessage) | string | A message passed to the owner of the remote resource with this connection request. Restricted to 140 chars. |

### Parameter: `manualPrivateLinkServiceConnections.properties.groupIds`

The ID of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: array

### Parameter: `manualPrivateLinkServiceConnections.properties.privateLinkServiceId`

The resource id of private link service.

- Required: Yes
- Type: string

### Parameter: `manualPrivateLinkServiceConnections.properties.requestMessage`

A message passed to the owner of the remote resource with this connection request. Restricted to 140 chars.

- Required: Yes
- Type: string

### Parameter: `privateDnsZoneGroupName`

The name of the private DNS zone group to create if `privateDnsZoneResourceIds` were provided.

- Required: No
- Type: string

### Parameter: `privateDnsZoneResourceIds`

The private DNS zone groups to associate the private endpoint. A DNS zone group can support up to 5 DNS zones.

- Required: No
- Type: array

### Parameter: `privateLinkServiceConnections`

A grouping of information about the connection to the remote resource.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-privatelinkserviceconnectionsname) | string | The name of the private link service connection. |
| [`properties`](#parameter-privatelinkserviceconnectionsproperties) | object | Properties of private link service connection. |

### Parameter: `privateLinkServiceConnections.name`

The name of the private link service connection.

- Required: Yes
- Type: string

### Parameter: `privateLinkServiceConnections.properties`

Properties of private link service connection.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`groupIds`](#parameter-privatelinkserviceconnectionspropertiesgroupids) | array | The ID of a group obtained from the remote resource that this private endpoint should connect to. |
| [`privateLinkServiceId`](#parameter-privatelinkserviceconnectionspropertiesprivatelinkserviceid) | string | The resource id of private link service. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`requestMessage`](#parameter-privatelinkserviceconnectionspropertiesrequestmessage) | string | A message passed to the owner of the remote resource with this connection request. Restricted to 140 chars. |

### Parameter: `privateLinkServiceConnections.properties.groupIds`

The ID of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: array

### Parameter: `privateLinkServiceConnections.properties.privateLinkServiceId`

The resource id of private link service.

- Required: Yes
- Type: string

### Parameter: `privateLinkServiceConnections.properties.requestMessage`

A message passed to the owner of the remote resource with this connection request. Restricted to 140 chars.

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

### Parameter: `tags`

Tags to be applied on all resources/resource groups in this deployment.

- Required: No
- Type: object


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `groupId` | string | The group Id for the private endpoint Group. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the private endpoint. |
| `resourceGroupName` | string | The resource group the private endpoint was deployed into. |
| `resourceId` | string | The resource ID of the private endpoint. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
