# Network Interface `[Microsoft.Network/networkInterfaces]`

This module deploys a Network Interface.

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
| `Microsoft.Network/networkInterfaces` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/networkInterfaces) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/network/network-interface:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module networkInterface 'br/public:avm/res/network/network-interface:<version>' = {
  name: 'networkInterfaceDeployment'
  params: {
    // Required parameters
    ipConfigurations: [
      {
        name: 'ipconfig01'
        subnetResourceId: '<subnetResourceId>'
      }
    ]
    name: 'nnimin001'
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
    "ipConfigurations": {
      "value": [
        {
          "name": "ipconfig01",
          "subnetResourceId": "<subnetResourceId>"
        }
      ]
    },
    "name": {
      "value": "nnimin001"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/network-interface:<version>'

// Required parameters
param ipConfigurations = [
  {
    name: 'ipconfig01'
    subnetResourceId: '<subnetResourceId>'
  }
]
param name = 'nnimin001'
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module networkInterface 'br/public:avm/res/network/network-interface:<version>' = {
  name: 'networkInterfaceDeployment'
  params: {
    // Required parameters
    ipConfigurations: [
      {
        applicationSecurityGroups: [
          {
            id: '<id>'
          }
        ]
        loadBalancerBackendAddressPools: [
          {
            id: '<id>'
          }
        ]
        name: 'myIpconfig01'
        subnetResourceId: '<subnetResourceId>'
      }
      {
        applicationSecurityGroups: [
          {
            id: '<id>'
          }
        ]
        publicIPAddressResourceId: '<publicIPAddressResourceId>'
        subnetResourceId: '<subnetResourceId>'
      }
      {
        name: 'myIpV6Config'
        privateIPAddressVersion: 'IPv6'
        publicIPAddressResourceId: '<publicIPAddressResourceId>'
        subnetResourceId: '<subnetResourceId>'
      }
    ]
    name: 'nnimax001'
    // Non-required parameters
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
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
    roleAssignments: [
      {
        name: '026b830f-441f-469a-8cf3-c3ea9f5bcfe1'
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
    "ipConfigurations": {
      "value": [
        {
          "applicationSecurityGroups": [
            {
              "id": "<id>"
            }
          ],
          "loadBalancerBackendAddressPools": [
            {
              "id": "<id>"
            }
          ],
          "name": "myIpconfig01",
          "subnetResourceId": "<subnetResourceId>"
        },
        {
          "applicationSecurityGroups": [
            {
              "id": "<id>"
            }
          ],
          "publicIPAddressResourceId": "<publicIPAddressResourceId>",
          "subnetResourceId": "<subnetResourceId>"
        },
        {
          "name": "myIpV6Config",
          "privateIPAddressVersion": "IPv6",
          "publicIPAddressResourceId": "<publicIPAddressResourceId>",
          "subnetResourceId": "<subnetResourceId>"
        }
      ]
    },
    "name": {
      "value": "nnimax001"
    },
    // Non-required parameters
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
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
    "roleAssignments": {
      "value": [
        {
          "name": "026b830f-441f-469a-8cf3-c3ea9f5bcfe1",
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
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/network-interface:<version>'

// Required parameters
param ipConfigurations = [
  {
    applicationSecurityGroups: [
      {
        id: '<id>'
      }
    ]
    loadBalancerBackendAddressPools: [
      {
        id: '<id>'
      }
    ]
    name: 'myIpconfig01'
    subnetResourceId: '<subnetResourceId>'
  }
  {
    applicationSecurityGroups: [
      {
        id: '<id>'
      }
    ]
    publicIPAddressResourceId: '<publicIPAddressResourceId>'
    subnetResourceId: '<subnetResourceId>'
  }
  {
    name: 'myIpV6Config'
    privateIPAddressVersion: 'IPv6'
    publicIPAddressResourceId: '<publicIPAddressResourceId>'
    subnetResourceId: '<subnetResourceId>'
  }
]
param name = 'nnimax001'
// Non-required parameters
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    name: 'customSetting'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param roleAssignments = [
  {
    name: '026b830f-441f-469a-8cf3-c3ea9f5bcfe1'
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
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module networkInterface 'br/public:avm/res/network/network-interface:<version>' = {
  name: 'networkInterfaceDeployment'
  params: {
    // Required parameters
    ipConfigurations: [
      {
        applicationSecurityGroups: [
          {
            id: '<id>'
          }
        ]
        loadBalancerBackendAddressPools: [
          {
            id: '<id>'
          }
        ]
        name: 'ipconfig01'
        subnetResourceId: '<subnetResourceId>'
      }
      {
        applicationSecurityGroups: [
          {
            id: '<id>'
          }
        ]
        subnetResourceId: '<subnetResourceId>'
      }
    ]
    name: 'nniwaf001'
    // Non-required parameters
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
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
    "ipConfigurations": {
      "value": [
        {
          "applicationSecurityGroups": [
            {
              "id": "<id>"
            }
          ],
          "loadBalancerBackendAddressPools": [
            {
              "id": "<id>"
            }
          ],
          "name": "ipconfig01",
          "subnetResourceId": "<subnetResourceId>"
        },
        {
          "applicationSecurityGroups": [
            {
              "id": "<id>"
            }
          ],
          "subnetResourceId": "<subnetResourceId>"
        }
      ]
    },
    "name": {
      "value": "nniwaf001"
    },
    // Non-required parameters
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
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
using 'br/public:avm/res/network/network-interface:<version>'

// Required parameters
param ipConfigurations = [
  {
    applicationSecurityGroups: [
      {
        id: '<id>'
      }
    ]
    loadBalancerBackendAddressPools: [
      {
        id: '<id>'
      }
    ]
    name: 'ipconfig01'
    subnetResourceId: '<subnetResourceId>'
  }
  {
    applicationSecurityGroups: [
      {
        id: '<id>'
      }
    ]
    subnetResourceId: '<subnetResourceId>'
  }
]
param name = 'nniwaf001'
// Non-required parameters
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    name: 'customSetting'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
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

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ipConfigurations`](#parameter-ipconfigurations) | array | A list of IPConfigurations of the network interface. |
| [`name`](#parameter-name) | string | The name of the network interface. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`auxiliaryMode`](#parameter-auxiliarymode) | string | Auxiliary mode of Network Interface resource. Not all regions are enabled for Auxiliary Mode Nic. |
| [`auxiliarySku`](#parameter-auxiliarysku) | string | Auxiliary sku of Network Interface resource. Not all regions are enabled for Auxiliary Mode Nic. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`disableTcpStateTracking`](#parameter-disabletcpstatetracking) | bool | Indicates whether to disable tcp state tracking. Subscription must be registered for the Microsoft.Network/AllowDisableTcpStateTracking feature before this property can be set to true. |
| [`dnsServers`](#parameter-dnsservers) | array | List of DNS servers IP addresses. Use 'AzureProvidedDNS' to switch to azure provided DNS resolution. 'AzureProvidedDNS' value cannot be combined with other IPs, it must be the only value in dnsServers collection. |
| [`enableAcceleratedNetworking`](#parameter-enableacceleratednetworking) | bool | If the network interface is accelerated networking enabled. |
| [`enableIPForwarding`](#parameter-enableipforwarding) | bool | Indicates whether IP forwarding is enabled on this network interface. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`networkSecurityGroupResourceId`](#parameter-networksecuritygroupresourceid) | string | The network security group (NSG) to attach to the network interface. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-tags) | object | Resource tags. |

### Parameter: `ipConfigurations`

A list of IPConfigurations of the network interface.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`subnetResourceId`](#parameter-ipconfigurationssubnetresourceid) | string | The resource ID of the subnet. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`applicationGatewayBackendAddressPools`](#parameter-ipconfigurationsapplicationgatewaybackendaddresspools) | array | The reference to Application Gateway Backend Address Pools. |
| [`applicationSecurityGroups`](#parameter-ipconfigurationsapplicationsecuritygroups) | array | Application security groups in which the IP configuration is included. |
| [`gatewayLoadBalancer`](#parameter-ipconfigurationsgatewayloadbalancer) | object | The reference to gateway load balancer frontend IP. |
| [`loadBalancerBackendAddressPools`](#parameter-ipconfigurationsloadbalancerbackendaddresspools) | array | Array of load balancer backend address pools. |
| [`loadBalancerInboundNatRules`](#parameter-ipconfigurationsloadbalancerinboundnatrules) | array | A list of references of LoadBalancerInboundNatRules. |
| [`name`](#parameter-ipconfigurationsname) | string | The name of the IP configuration. |
| [`privateIPAddress`](#parameter-ipconfigurationsprivateipaddress) | string | The private IP address. |
| [`privateIPAddressVersion`](#parameter-ipconfigurationsprivateipaddressversion) | string | Whether the specific IP configuration is IPv4 or IPv6. |
| [`privateIPAllocationMethod`](#parameter-ipconfigurationsprivateipallocationmethod) | string | The private IP address allocation method. |
| [`publicIPAddressResourceId`](#parameter-ipconfigurationspublicipaddressresourceid) | string | The resource ID of the public IP address. |
| [`virtualNetworkTaps`](#parameter-ipconfigurationsvirtualnetworktaps) | array | The reference to Virtual Network Taps. |

### Parameter: `ipConfigurations.subnetResourceId`

The resource ID of the subnet.

- Required: Yes
- Type: string

### Parameter: `ipConfigurations.applicationGatewayBackendAddressPools`

The reference to Application Gateway Backend Address Pools.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-ipconfigurationsapplicationgatewaybackendaddresspoolsid) | string | Resource ID of the backend address pool. |
| [`name`](#parameter-ipconfigurationsapplicationgatewaybackendaddresspoolsname) | string | Name of the backend address pool that is unique within an Application Gateway. |
| [`properties`](#parameter-ipconfigurationsapplicationgatewaybackendaddresspoolsproperties) | object | Properties of the application gateway backend address pool. |

### Parameter: `ipConfigurations.applicationGatewayBackendAddressPools.id`

Resource ID of the backend address pool.

- Required: No
- Type: string

### Parameter: `ipConfigurations.applicationGatewayBackendAddressPools.name`

Name of the backend address pool that is unique within an Application Gateway.

- Required: No
- Type: string

### Parameter: `ipConfigurations.applicationGatewayBackendAddressPools.properties`

Properties of the application gateway backend address pool.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`backendAddresses`](#parameter-ipconfigurationsapplicationgatewaybackendaddresspoolspropertiesbackendaddresses) | array | Backend addresses. |

### Parameter: `ipConfigurations.applicationGatewayBackendAddressPools.properties.backendAddresses`

Backend addresses.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`fqdn`](#parameter-ipconfigurationsapplicationgatewaybackendaddresspoolspropertiesbackendaddressesfqdn) | string | FQDN of the backend address. |
| [`ipAddress`](#parameter-ipconfigurationsapplicationgatewaybackendaddresspoolspropertiesbackendaddressesipaddress) | string | IP address of the backend address. |

### Parameter: `ipConfigurations.applicationGatewayBackendAddressPools.properties.backendAddresses.fqdn`

FQDN of the backend address.

- Required: No
- Type: string

### Parameter: `ipConfigurations.applicationGatewayBackendAddressPools.properties.backendAddresses.ipAddress`

IP address of the backend address.

- Required: No
- Type: string

### Parameter: `ipConfigurations.applicationSecurityGroups`

Application security groups in which the IP configuration is included.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-ipconfigurationsapplicationsecuritygroupsid) | string | Resource ID of the application security group. |
| [`location`](#parameter-ipconfigurationsapplicationsecuritygroupslocation) | string | Location of the application security group. |
| [`properties`](#parameter-ipconfigurationsapplicationsecuritygroupsproperties) | object | Properties of the application security group. |
| [`tags`](#parameter-ipconfigurationsapplicationsecuritygroupstags) | object | Tags of the application security group. |

### Parameter: `ipConfigurations.applicationSecurityGroups.id`

Resource ID of the application security group.

- Required: No
- Type: string

### Parameter: `ipConfigurations.applicationSecurityGroups.location`

Location of the application security group.

- Required: No
- Type: string

### Parameter: `ipConfigurations.applicationSecurityGroups.properties`

Properties of the application security group.

- Required: No
- Type: object

### Parameter: `ipConfigurations.applicationSecurityGroups.tags`

Tags of the application security group.

- Required: No
- Type: object

### Parameter: `ipConfigurations.gatewayLoadBalancer`

The reference to gateway load balancer frontend IP.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-ipconfigurationsgatewayloadbalancerid) | string | Resource ID of the sub resource. |

### Parameter: `ipConfigurations.gatewayLoadBalancer.id`

Resource ID of the sub resource.

- Required: No
- Type: string

### Parameter: `ipConfigurations.loadBalancerBackendAddressPools`

Array of load balancer backend address pools.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-ipconfigurationsloadbalancerbackendaddresspoolsid) | string | The resource ID of the backend address pool. |
| [`name`](#parameter-ipconfigurationsloadbalancerbackendaddresspoolsname) | string | The name of the backend address pool. |
| [`properties`](#parameter-ipconfigurationsloadbalancerbackendaddresspoolsproperties) | object | The properties of the backend address pool. |

### Parameter: `ipConfigurations.loadBalancerBackendAddressPools.id`

The resource ID of the backend address pool.

- Required: No
- Type: string

### Parameter: `ipConfigurations.loadBalancerBackendAddressPools.name`

The name of the backend address pool.

- Required: No
- Type: string

### Parameter: `ipConfigurations.loadBalancerBackendAddressPools.properties`

The properties of the backend address pool.

- Required: No
- Type: object

### Parameter: `ipConfigurations.loadBalancerInboundNatRules`

A list of references of LoadBalancerInboundNatRules.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-ipconfigurationsloadbalancerinboundnatrulesid) | string | Resource ID of the inbound NAT rule. |
| [`name`](#parameter-ipconfigurationsloadbalancerinboundnatrulesname) | string | Name of the resource that is unique within the set of inbound NAT rules used by the load balancer. This name can be used to access the resource. |
| [`properties`](#parameter-ipconfigurationsloadbalancerinboundnatrulesproperties) | object | Properties of the inbound NAT rule. |

### Parameter: `ipConfigurations.loadBalancerInboundNatRules.id`

Resource ID of the inbound NAT rule.

- Required: No
- Type: string

### Parameter: `ipConfigurations.loadBalancerInboundNatRules.name`

Name of the resource that is unique within the set of inbound NAT rules used by the load balancer. This name can be used to access the resource.

- Required: No
- Type: string

### Parameter: `ipConfigurations.loadBalancerInboundNatRules.properties`

Properties of the inbound NAT rule.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`backendAddressPool`](#parameter-ipconfigurationsloadbalancerinboundnatrulespropertiesbackendaddresspool) | object | A reference to backendAddressPool resource. |
| [`backendPort`](#parameter-ipconfigurationsloadbalancerinboundnatrulespropertiesbackendport) | int | The port used for the internal endpoint. Acceptable values range from 1 to 65535. |
| [`enableFloatingIP`](#parameter-ipconfigurationsloadbalancerinboundnatrulespropertiesenablefloatingip) | bool | Configures a virtual machine's endpoint for the floating IP capability required to configure a SQL AlwaysOn Availability Group. This setting is required when using the SQL AlwaysOn Availability Groups in SQL server. This setting can't be changed after you create the endpoint. |
| [`enableTcpReset`](#parameter-ipconfigurationsloadbalancerinboundnatrulespropertiesenabletcpreset) | bool | Receive bidirectional TCP Reset on TCP flow idle timeout or unexpected connection termination. This element is only used when the protocol is set to TCP. |
| [`frontendIPConfiguration`](#parameter-ipconfigurationsloadbalancerinboundnatrulespropertiesfrontendipconfiguration) | object | A reference to frontend IP addresses. |
| [`frontendPort`](#parameter-ipconfigurationsloadbalancerinboundnatrulespropertiesfrontendport) | int | The port for the external endpoint. Port numbers for each rule must be unique within the Load Balancer. Acceptable values range from 1 to 65534. |
| [`frontendPortRangeEnd`](#parameter-ipconfigurationsloadbalancerinboundnatrulespropertiesfrontendportrangeend) | int | The port range end for the external endpoint. This property is used together with BackendAddressPool and FrontendPortRangeStart. Individual inbound NAT rule port mappings will be created for each backend address from BackendAddressPool. Acceptable values range from 1 to 65534. |
| [`frontendPortRangeStart`](#parameter-ipconfigurationsloadbalancerinboundnatrulespropertiesfrontendportrangestart) | int | The port range start for the external endpoint. This property is used together with BackendAddressPool and FrontendPortRangeEnd. Individual inbound NAT rule port mappings will be created for each backend address from BackendAddressPool. Acceptable values range from 1 to 65534. |
| [`protocol`](#parameter-ipconfigurationsloadbalancerinboundnatrulespropertiesprotocol) | string | The reference to the transport protocol used by the load balancing rule. |

### Parameter: `ipConfigurations.loadBalancerInboundNatRules.properties.backendAddressPool`

A reference to backendAddressPool resource.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-ipconfigurationsloadbalancerinboundnatrulespropertiesbackendaddresspoolid) | string | Resource ID of the sub resource. |

### Parameter: `ipConfigurations.loadBalancerInboundNatRules.properties.backendAddressPool.id`

Resource ID of the sub resource.

- Required: No
- Type: string

### Parameter: `ipConfigurations.loadBalancerInboundNatRules.properties.backendPort`

The port used for the internal endpoint. Acceptable values range from 1 to 65535.

- Required: No
- Type: int

### Parameter: `ipConfigurations.loadBalancerInboundNatRules.properties.enableFloatingIP`

Configures a virtual machine's endpoint for the floating IP capability required to configure a SQL AlwaysOn Availability Group. This setting is required when using the SQL AlwaysOn Availability Groups in SQL server. This setting can't be changed after you create the endpoint.

- Required: No
- Type: bool

### Parameter: `ipConfigurations.loadBalancerInboundNatRules.properties.enableTcpReset`

Receive bidirectional TCP Reset on TCP flow idle timeout or unexpected connection termination. This element is only used when the protocol is set to TCP.

- Required: No
- Type: bool

### Parameter: `ipConfigurations.loadBalancerInboundNatRules.properties.frontendIPConfiguration`

A reference to frontend IP addresses.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-ipconfigurationsloadbalancerinboundnatrulespropertiesfrontendipconfigurationid) | string | Resource ID of the sub resource. |

### Parameter: `ipConfigurations.loadBalancerInboundNatRules.properties.frontendIPConfiguration.id`

Resource ID of the sub resource.

- Required: No
- Type: string

### Parameter: `ipConfigurations.loadBalancerInboundNatRules.properties.frontendPort`

The port for the external endpoint. Port numbers for each rule must be unique within the Load Balancer. Acceptable values range from 1 to 65534.

- Required: No
- Type: int

### Parameter: `ipConfigurations.loadBalancerInboundNatRules.properties.frontendPortRangeEnd`

The port range end for the external endpoint. This property is used together with BackendAddressPool and FrontendPortRangeStart. Individual inbound NAT rule port mappings will be created for each backend address from BackendAddressPool. Acceptable values range from 1 to 65534.

- Required: No
- Type: int

### Parameter: `ipConfigurations.loadBalancerInboundNatRules.properties.frontendPortRangeStart`

The port range start for the external endpoint. This property is used together with BackendAddressPool and FrontendPortRangeEnd. Individual inbound NAT rule port mappings will be created for each backend address from BackendAddressPool. Acceptable values range from 1 to 65534.

- Required: No
- Type: int

### Parameter: `ipConfigurations.loadBalancerInboundNatRules.properties.protocol`

The reference to the transport protocol used by the load balancing rule.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'All'
    'Tcp'
    'Udp'
  ]
  ```

### Parameter: `ipConfigurations.name`

The name of the IP configuration.

- Required: No
- Type: string

### Parameter: `ipConfigurations.privateIPAddress`

The private IP address.

- Required: No
- Type: string

### Parameter: `ipConfigurations.privateIPAddressVersion`

Whether the specific IP configuration is IPv4 or IPv6.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'IPv4'
    'IPv6'
  ]
  ```

### Parameter: `ipConfigurations.privateIPAllocationMethod`

The private IP address allocation method.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Dynamic'
    'Static'
  ]
  ```

### Parameter: `ipConfigurations.publicIPAddressResourceId`

The resource ID of the public IP address.

- Required: No
- Type: string

### Parameter: `ipConfigurations.virtualNetworkTaps`

The reference to Virtual Network Taps.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-ipconfigurationsvirtualnetworktapsid) | string | Resource ID of the virtual network tap. |
| [`location`](#parameter-ipconfigurationsvirtualnetworktapslocation) | string | Location of the virtual network tap. |
| [`properties`](#parameter-ipconfigurationsvirtualnetworktapsproperties) | object | Properties of the virtual network tap. |
| [`tags`](#parameter-ipconfigurationsvirtualnetworktapstags) | object | Tags of the virtual network tap. |

### Parameter: `ipConfigurations.virtualNetworkTaps.id`

Resource ID of the virtual network tap.

- Required: No
- Type: string

### Parameter: `ipConfigurations.virtualNetworkTaps.location`

Location of the virtual network tap.

- Required: No
- Type: string

### Parameter: `ipConfigurations.virtualNetworkTaps.properties`

Properties of the virtual network tap.

- Required: No
- Type: object

### Parameter: `ipConfigurations.virtualNetworkTaps.tags`

Tags of the virtual network tap.

- Required: No
- Type: object

### Parameter: `name`

The name of the network interface.

- Required: Yes
- Type: string

### Parameter: `auxiliaryMode`

Auxiliary mode of Network Interface resource. Not all regions are enabled for Auxiliary Mode Nic.

- Required: No
- Type: string
- Default: `'None'`
- Allowed:
  ```Bicep
  [
    'Floating'
    'MaxConnections'
    'None'
  ]
  ```

### Parameter: `auxiliarySku`

Auxiliary sku of Network Interface resource. Not all regions are enabled for Auxiliary Mode Nic.

- Required: No
- Type: string
- Default: `'None'`
- Allowed:
  ```Bicep
  [
    'A1'
    'A2'
    'A4'
    'A8'
    'None'
  ]
  ```

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

### Parameter: `disableTcpStateTracking`

Indicates whether to disable tcp state tracking. Subscription must be registered for the Microsoft.Network/AllowDisableTcpStateTracking feature before this property can be set to true.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `dnsServers`

List of DNS servers IP addresses. Use 'AzureProvidedDNS' to switch to azure provided DNS resolution. 'AzureProvidedDNS' value cannot be combined with other IPs, it must be the only value in dnsServers collection.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `enableAcceleratedNetworking`

If the network interface is accelerated networking enabled.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableIPForwarding`

Indicates whether IP forwarding is enabled on this network interface.

- Required: No
- Type: bool
- Default: `False`

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

### Parameter: `networkSecurityGroupResourceId`

The network security group (NSG) to attach to the network interface.

- Required: No
- Type: string
- Default: `''`

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'DNS Resolver Contributor'`
  - `'DNS Zone Contributor'`
  - `'Network Contributor'`
  - `'Owner'`
  - `'Private DNS Zone Contributor'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`

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

Resource tags.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `ipConfigurations` | array | The list of IP configurations of the network interface. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed resource. |
| `resourceGroupName` | string | The resource group of the deployed resource. |
| `resourceId` | string | The resource ID of the deployed resource. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
