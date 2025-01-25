# Network Manager Routing Configurations `[Microsoft.Network/networkManagers/routingConfigurations]`

This module deploys an Network Manager Routing Configuration.
Routing configurations are the building blocks of UDR management. They're used to describe the desired routing behavior for a network group.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/networkManagers/routingConfigurations` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/networkManagers/routingConfigurations) |
| `Microsoft.Network/networkManagers/routingConfigurations/ruleCollections` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/networkManagers/routingConfigurations/ruleCollections) |
| `Microsoft.Network/networkManagers/routingConfigurations/ruleCollections/rules` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/networkManagers/routingConfigurations/ruleCollections/rules) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the routing configuration. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`networkManagerName`](#parameter-networkmanagername) | string | The name of the parent network manager. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-description) | string | A description of the routing configuration. |
| [`ruleCollections`](#parameter-rulecollections) | array | A routing configuration contains a set of rule collections that are applied to network groups. Each rule collection contains one or more routing rules. |

### Parameter: `name`

The name of the routing configuration.

- Required: Yes
- Type: string

### Parameter: `networkManagerName`

The name of the parent network manager. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `description`

A description of the routing configuration.

- Required: No
- Type: string
- Default: `''`

### Parameter: `ruleCollections`

A routing configuration contains a set of rule collections that are applied to network groups. Each rule collection contains one or more routing rules.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appliesTo`](#parameter-rulecollectionsappliesto) | array | List of network groups for configuration. A routing rule collection must be associated to at least one network group. |
| [`name`](#parameter-rulecollectionsname) | string | The name of the rule collection. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-rulecollectionsdescription) | string | A description of the rule collection. |
| [`disableBgpRoutePropagation`](#parameter-rulecollectionsdisablebgproutepropagation) | bool | Disables BGP route propagation for the rule collection. Defaults to true. |
| [`rules`](#parameter-rulecollectionsrules) | array | List of rules for the routing rules collection. Warning: A rule collection without a rule will cause a deployment of routing configuration to fail in network manager. |

### Parameter: `ruleCollections.appliesTo`

List of network groups for configuration. A routing rule collection must be associated to at least one network group.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`networkGroupResourceId`](#parameter-rulecollectionsappliestonetworkgroupresourceid) | string | The resource ID of the network group. |

### Parameter: `ruleCollections.appliesTo.networkGroupResourceId`

The resource ID of the network group.

- Required: Yes
- Type: string

### Parameter: `ruleCollections.name`

The name of the rule collection.

- Required: Yes
- Type: string

### Parameter: `ruleCollections.description`

A description of the rule collection.

- Required: No
- Type: string

### Parameter: `ruleCollections.disableBgpRoutePropagation`

Disables BGP route propagation for the rule collection. Defaults to true.

- Required: No
- Type: bool

### Parameter: `ruleCollections.rules`

List of rules for the routing rules collection. Warning: A rule collection without a rule will cause a deployment of routing configuration to fail in network manager.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`destination`](#parameter-rulecollectionsrulesdestination) | object | The destination can be IP addresses or Service Tag for this route. Address Prefixes are defined using the CIDR format, while Service tags are predefined identifiers that represent a category of IP addresses, which are managed by Azure. |
| [`name`](#parameter-rulecollectionsrulesname) | string | The name of the rule. |
| [`nextHop`](#parameter-rulecollectionsrulesnexthop) | object | The next hop handles the matching packets for this route. It can be the virtual network, the virtual network gateway, the internet, a virtual appliance, or none. Virtual network gateways cannot be used if the address prefix is IPv6. If the next hop type is VirtualAppliance, the next hop address must be specified. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-rulecollectionsrulesdescription) | string | A description of the rule. |

### Parameter: `ruleCollections.rules.destination`

The destination can be IP addresses or Service Tag for this route. Address Prefixes are defined using the CIDR format, while Service tags are predefined identifiers that represent a category of IP addresses, which are managed by Azure.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`destinationAddress`](#parameter-rulecollectionsrulesdestinationdestinationaddress) | string | The destination IP addresses or Service Tag for this route. For IP addresses, it is the IP address range in CIDR notation that this route applies to. If the destination IP address of a packet falls in this range, it matches this route. As for Service Tags, valid identifiers can be "AzureCloud", "Storage.AustraliaEast", etc. See https://docs.microsoft.com/en-us/azure/virtual-network/service-tags-overview for more information on service tags. |
| [`type`](#parameter-rulecollectionsrulesdestinationtype) | string | The destination type can be IP addresses or Service Tag for this route. Address Prefixes are defined using the CIDR format, while Service tags are predefined identifiers that represent a category of IP addresses, which are managed by Azure. |

### Parameter: `ruleCollections.rules.destination.destinationAddress`

The destination IP addresses or Service Tag for this route. For IP addresses, it is the IP address range in CIDR notation that this route applies to. If the destination IP address of a packet falls in this range, it matches this route. As for Service Tags, valid identifiers can be "AzureCloud", "Storage.AustraliaEast", etc. See https://docs.microsoft.com/en-us/azure/virtual-network/service-tags-overview for more information on service tags.

- Required: Yes
- Type: string

### Parameter: `ruleCollections.rules.destination.type`

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

### Parameter: `ruleCollections.rules.name`

The name of the rule.

- Required: Yes
- Type: string

### Parameter: `ruleCollections.rules.nextHop`

The next hop handles the matching packets for this route. It can be the virtual network, the virtual network gateway, the internet, a virtual appliance, or none. Virtual network gateways cannot be used if the address prefix is IPv6. If the next hop type is VirtualAppliance, the next hop address must be specified.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`nextHopType`](#parameter-rulecollectionsrulesnexthopnexthoptype) | string | The next hop handles the matching packets for this route. It can be the virtual network, the virtual network gateway, the internet, a virtual appliance, or none. Virtual network gateways cannot be used if the address prefix is IPv6. If the next hop type is VirtualAppliance, the next hop address must be specified. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`nextHopAddress`](#parameter-rulecollectionsrulesnexthopnexthopaddress) | string | The IP address of the next hop. Required if the next hop type is VirtualAppliance. |

### Parameter: `ruleCollections.rules.nextHop.nextHopType`

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

### Parameter: `ruleCollections.rules.nextHop.nextHopAddress`

The IP address of the next hop. Required if the next hop type is VirtualAppliance.

- Required: No
- Type: string

### Parameter: `ruleCollections.rules.description`

A description of the rule.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed routing configuration. |
| `resourceGroupName` | string | The resource group the routing configuration was deployed into. |
| `resourceId` | string | The resource ID of the deployed routing configuration. |
