# Network Manager Routing Configuration Rule Collections `[Microsoft.Network/networkManagers/routingConfigurations/ruleCollections]`

This module deploys an Network Manager Routing Configuration Rule Collection.
Routing configurations are the building blocks of UDR management. They're used to describe the desired routing behavior for a network group. Each routing configuration contains one ore more rule collections. Warning: A rule collection without a rule will cause a deployment of routing configuration to fail in network manager.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/networkManagers/routingConfigurations/ruleCollections` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/networkManagers/routingConfigurations/ruleCollections) |
| `Microsoft.Network/networkManagers/routingConfigurations/ruleCollections/rules` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/networkManagers/routingConfigurations/ruleCollections/rules) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appliesTo`](#parameter-appliesto) | array | List of network groups for configuration. A routing rule collection must be associated to at least one network group. |
| [`name`](#parameter-name) | string | The name of the routing rule collection. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`networkManagerName`](#parameter-networkmanagername) | string | The name of the parent network manager. Required if the template is used in a standalone deployment. |
| [`routingConfigurationName`](#parameter-routingconfigurationname) | string | The name of the parent Routing Configuration. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-description) | string | A description of the routing rule collection. |
| [`disableBgpRoutePropagation`](#parameter-disablebgproutepropagation) | bool | Determines whether BGP route propagation is enabled for the routing rule collection. Defaults to true. |
| [`rules`](#parameter-rules) | array | List of rules for the routing rules collection. Warning: A rule collection without a rule will cause a deployment of routing configuration to fail in network manager. |

### Parameter: `appliesTo`

List of network groups for configuration. A routing rule collection must be associated to at least one network group.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`networkGroupResourceId`](#parameter-appliestonetworkgroupresourceid) | string | The resource ID of the network group. |

### Parameter: `appliesTo.networkGroupResourceId`

The resource ID of the network group.

- Required: Yes
- Type: string

### Parameter: `name`

The name of the routing rule collection.

- Required: Yes
- Type: string

### Parameter: `networkManagerName`

The name of the parent network manager. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `routingConfigurationName`

The name of the parent Routing Configuration. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `description`

A description of the routing rule collection.

- Required: No
- Type: string
- Default: `''`

### Parameter: `disableBgpRoutePropagation`

Determines whether BGP route propagation is enabled for the routing rule collection. Defaults to true.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `rules`

List of rules for the routing rules collection. Warning: A rule collection without a rule will cause a deployment of routing configuration to fail in network manager.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`destination`](#parameter-rulesdestination) | object | The destination can be IP addresses or Service Tag for this route. Address Prefixes are defined using the CIDR format, while Service tags are predefined identifiers that represent a category of IP addresses, which are managed by Azure. |
| [`name`](#parameter-rulesname) | string | The name of the rule. |
| [`nextHop`](#parameter-rulesnexthop) | object | The next hop handles the matching packets for this route. It can be the virtual network, the virtual network gateway, the internet, a virtual appliance, or none. Virtual network gateways cannot be used if the address prefix is IPv6. If the next hop type is VirtualAppliance, the next hop address must be specified. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-rulesdescription) | string | A description of the rule. |

### Parameter: `rules.destination`

The destination can be IP addresses or Service Tag for this route. Address Prefixes are defined using the CIDR format, while Service tags are predefined identifiers that represent a category of IP addresses, which are managed by Azure.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`destinationAddress`](#parameter-rulesdestinationdestinationaddress) | string | The destination IP addresses or Service Tag for this route. For IP addresses, it is the IP address range in CIDR notation that this route applies to. If the destination IP address of a packet falls in this range, it matches this route. As for Service Tags, valid identifiers can be "AzureCloud", "Storage.AustraliaEast", etc. See https://docs.microsoft.com/en-us/azure/virtual-network/service-tags-overview for more information on service tags. |
| [`type`](#parameter-rulesdestinationtype) | string | The destination type can be IP addresses or Service Tag for this route. Address Prefixes are defined using the CIDR format, while Service tags are predefined identifiers that represent a category of IP addresses, which are managed by Azure. |

### Parameter: `rules.destination.destinationAddress`

The destination IP addresses or Service Tag for this route. For IP addresses, it is the IP address range in CIDR notation that this route applies to. If the destination IP address of a packet falls in this range, it matches this route. As for Service Tags, valid identifiers can be "AzureCloud", "Storage.AustraliaEast", etc. See https://docs.microsoft.com/en-us/azure/virtual-network/service-tags-overview for more information on service tags.

- Required: Yes
- Type: string

### Parameter: `rules.destination.type`

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

### Parameter: `rules.name`

The name of the rule.

- Required: Yes
- Type: string

### Parameter: `rules.nextHop`

The next hop handles the matching packets for this route. It can be the virtual network, the virtual network gateway, the internet, a virtual appliance, or none. Virtual network gateways cannot be used if the address prefix is IPv6. If the next hop type is VirtualAppliance, the next hop address must be specified.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`nextHopType`](#parameter-rulesnexthopnexthoptype) | string | The next hop handles the matching packets for this route. It can be the virtual network, the virtual network gateway, the internet, a virtual appliance, or none. Virtual network gateways cannot be used if the address prefix is IPv6. If the next hop type is VirtualAppliance, the next hop address must be specified. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`nextHopAddress`](#parameter-rulesnexthopnexthopaddress) | string | The IP address of the next hop. Required if the next hop type is VirtualAppliance. |

### Parameter: `rules.nextHop.nextHopType`

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

### Parameter: `rules.nextHop.nextHopAddress`

The IP address of the next hop. Required if the next hop type is VirtualAppliance.

- Required: No
- Type: string

### Parameter: `rules.description`

A description of the rule.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed routing rule collection. |
| `resourceGroupName` | string | The resource group the routing rule collection was deployed into. |
| `resourceId` | string | The resource ID of the deployed routing rule collection. |
