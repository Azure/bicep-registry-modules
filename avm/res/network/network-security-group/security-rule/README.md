# Network Security Group (NSG) Security Rules `[Microsoft.Network/networkSecurityGroups/securityRules]`

This module deploys a Network Security Group (NSG) Security Rule.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/networkSecurityGroups/securityRules` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/networkSecurityGroups/securityRules) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`direction`](#parameter-direction) | string | The direction of the rule. The direction specifies if rule will be evaluated on incoming or outgoing traffic. |
| [`name`](#parameter-name) | string | The name of the security rule. |
| [`priority`](#parameter-priority) | int | The priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule. |
| [`protocol`](#parameter-protocol) | string | Network protocol this rule applies to. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`networkSecurityGroupName`](#parameter-networksecuritygroupname) | string | The name of the parent network security group to deploy the security rule into. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`access`](#parameter-access) | string | Whether network traffic is allowed or denied. |
| [`description`](#parameter-description) | string | A description for this rule. |
| [`destinationAddressPrefix`](#parameter-destinationaddressprefix) | string | The destination address prefix. CIDR or destination IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used. |
| [`destinationAddressPrefixes`](#parameter-destinationaddressprefixes) | array | The destination address prefixes. CIDR or destination IP ranges. |
| [`destinationApplicationSecurityGroups`](#parameter-destinationapplicationsecuritygroups) | array | The application security group specified as destination. |
| [`destinationPortRange`](#parameter-destinationportrange) | string | The destination port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports. |
| [`destinationPortRanges`](#parameter-destinationportranges) | array | The destination port ranges. |
| [`sourceAddressPrefix`](#parameter-sourceaddressprefix) | string | The CIDR or source IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used. If this is an ingress rule, specifies where network traffic originates from. |
| [`sourceAddressPrefixes`](#parameter-sourceaddressprefixes) | array | The CIDR or source IP ranges. |
| [`sourceApplicationSecurityGroups`](#parameter-sourceapplicationsecuritygroups) | array | The application security group specified as source. |
| [`sourcePortRange`](#parameter-sourceportrange) | string | The source port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports. |
| [`sourcePortRanges`](#parameter-sourceportranges) | array | The source port ranges. |

### Parameter: `direction`

The direction of the rule. The direction specifies if rule will be evaluated on incoming or outgoing traffic.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Inbound'
    'Outbound'
  ]
  ```

### Parameter: `name`

The name of the security rule.

- Required: Yes
- Type: string

### Parameter: `priority`

The priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule.

- Required: Yes
- Type: int

### Parameter: `protocol`

Network protocol this rule applies to.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    '*'
    'Ah'
    'Esp'
    'Icmp'
    'Tcp'
    'Udp'
  ]
  ```

### Parameter: `networkSecurityGroupName`

The name of the parent network security group to deploy the security rule into. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `access`

Whether network traffic is allowed or denied.

- Required: No
- Type: string
- Default: `'Deny'`
- Allowed:
  ```Bicep
  [
    'Allow'
    'Deny'
  ]
  ```

### Parameter: `description`

A description for this rule.

- Required: No
- Type: string
- Default: `''`

### Parameter: `destinationAddressPrefix`

The destination address prefix. CIDR or destination IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used.

- Required: No
- Type: string
- Default: `''`

### Parameter: `destinationAddressPrefixes`

The destination address prefixes. CIDR or destination IP ranges.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `destinationApplicationSecurityGroups`

The application security group specified as destination.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `destinationPortRange`

The destination port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports.

- Required: No
- Type: string
- Default: `''`

### Parameter: `destinationPortRanges`

The destination port ranges.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `sourceAddressPrefix`

The CIDR or source IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used. If this is an ingress rule, specifies where network traffic originates from.

- Required: No
- Type: string
- Default: `''`

### Parameter: `sourceAddressPrefixes`

The CIDR or source IP ranges.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `sourceApplicationSecurityGroups`

The application security group specified as source.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `sourcePortRange`

The source port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports.

- Required: No
- Type: string
- Default: `''`

### Parameter: `sourcePortRanges`

The source port ranges.

- Required: No
- Type: array
- Default: `[]`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the security rule. |
| `resourceGroupName` | string | The resource group the security rule was deployed into. |
| `resourceId` | string | The resource ID of the security rule. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
