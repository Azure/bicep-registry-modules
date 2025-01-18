# Network Manager Routing configuration Rule Collection Rules `[Microsoft.Network/networkManagers/routingConfigurations/ruleCollections/rules]`

This module deploys an Azure Virtual Network Manager (AVNM) Routing Configuration Rule Collection Rule.
A Routing configuration contains a set of rule collections. Each rule collection contains one or more routing rules.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/networkManagers/routingConfigurations/ruleCollections/rules` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/networkManagers/routingConfigurations/ruleCollections/rules) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`destination`](#parameter-destination) | object | The destination can be IP addresses or Service Tag for this route. Address Prefixes are defined using the CIDR format, while Service tags are predefined identifiers that represent a category of IP addresses, which are managed by Azure. |
| [`name`](#parameter-name) | string | The name of the rule. |
| [`nextHop`](#parameter-nexthop) | object | The next hop handles the matching packets for this route. It can be the virtual network, the virtual network gateway, the internet, a virtual appliance, or none. Virtual network gateways cannot be used if the address prefix is IPv6. If the next hop type is VirtualAppliance, the next hop address must be specified. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`networkManagerName`](#parameter-networkmanagername) | string | The name of the parent network manager. Required if the template is used in a standalone deployment. |
| [`routingConfigurationName`](#parameter-routingconfigurationname) | string | The name of the parent Routing configuration. Required if the template is used in a standalone deployment. |
| [`ruleCollectionName`](#parameter-rulecollectionname) | string | The name of the parent rule collection. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-description) | string | A description of the rule. |

### Parameter: `destination`

The destination can be IP addresses or Service Tag for this route. Address Prefixes are defined using the CIDR format, while Service tags are predefined identifiers that represent a category of IP addresses, which are managed by Azure.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`destinationAddress`](#parameter-destinationdestinationaddress) | string | The destination IP addresses or Service Tag for this route. For IP addresses, it is the IP address range in CIDR notation that this route applies to. If the destination IP address of a packet falls in this range, it matches this route. As for Service Tags, valid identifiers can be "AzureCloud", "Storage.AustraliaEast", etc. See https://docs.microsoft.com/en-us/azure/virtual-network/service-tags-overview for more information on service tags. |
| [`type`](#parameter-destinationtype) | string | The destination type can be IP addresses or Service Tag for this route. Address Prefixes are defined using the CIDR format, while Service tags are predefined identifiers that represent a category of IP addresses, which are managed by Azure. |

### Parameter: `destination.destinationAddress`

The destination IP addresses or Service Tag for this route. For IP addresses, it is the IP address range in CIDR notation that this route applies to. If the destination IP address of a packet falls in this range, it matches this route. As for Service Tags, valid identifiers can be "AzureCloud", "Storage.AustraliaEast", etc. See https://docs.microsoft.com/en-us/azure/virtual-network/service-tags-overview for more information on service tags.

- Required: Yes
- Type: string

### Parameter: `destination.type`

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

### Parameter: `name`

The name of the rule.

- Required: Yes
- Type: string

### Parameter: `nextHop`

The next hop handles the matching packets for this route. It can be the virtual network, the virtual network gateway, the internet, a virtual appliance, or none. Virtual network gateways cannot be used if the address prefix is IPv6. If the next hop type is VirtualAppliance, the next hop address must be specified.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`nextHopType`](#parameter-nexthopnexthoptype) | string | The next hop handles the matching packets for this route. It can be the virtual network, the virtual network gateway, the internet, a virtual appliance, or none. Virtual network gateways cannot be used if the address prefix is IPv6. If the next hop type is VirtualAppliance, the next hop address must be specified. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`nextHopAddress`](#parameter-nexthopnexthopaddress) | string | The IP address of the next hop. Required if the next hop type is VirtualAppliance. |

### Parameter: `nextHop.nextHopType`

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

### Parameter: `nextHop.nextHopAddress`

The IP address of the next hop. Required if the next hop type is VirtualAppliance.

- Required: No
- Type: string

### Parameter: `networkManagerName`

The name of the parent network manager. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `routingConfigurationName`

The name of the parent Routing configuration. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `ruleCollectionName`

The name of the parent rule collection. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `description`

A description of the rule.

- Required: No
- Type: string
- Default: `''`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed rule. |
| `resourceGroupName` | string | The resource group the rule was deployed into. |
| `resourceId` | string | The resource ID of the deployed rule. |
