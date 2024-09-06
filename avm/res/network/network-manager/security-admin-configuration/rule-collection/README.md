# Network Manager Security Admin Configuration Rule Collections `[Microsoft.Network/networkManagers/securityAdminConfigurations/ruleCollections]`

This module deploys an Network Manager Security Admin Configuration Rule Collection.
A security admin configuration contains a set of rule collections. Each rule collection contains one or more security admin rules. Security admin rules allows enforcing security policy criteria that matches the conditions set. Warning: A rule collection without rule will cause a deployment configuration for security admin goal state in network manager to fail.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/networkManagers/securityAdminConfigurations/ruleCollections` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/networkManagers/securityAdminConfigurations/ruleCollections) |
| `Microsoft.Network/networkManagers/securityAdminConfigurations/ruleCollections/rules` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/networkManagers/securityAdminConfigurations/ruleCollections/rules) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appliesToGroups`](#parameter-appliestogroups) | array | List of network groups for configuration. An admin rule collection must be associated to at least one network group. |
| [`name`](#parameter-name) | string | The name of the admin rule collection. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`networkManagerName`](#parameter-networkmanagername) | string | The name of the parent network manager. Required if the template is used in a standalone deployment. |
| [`securityAdminConfigurationName`](#parameter-securityadminconfigurationname) | string | The name of the parent security admin configuration. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-description) | string | A description of the admin rule collection. |
| [`rules`](#parameter-rules) | array | List of rules for the admin rules collection. Security admin rules allows enforcing security policy criteria that matches the conditions set. Warning: A rule collection without rule will cause a deployment configuration for security admin goal state in network manager to fail. |

### Parameter: `appliesToGroups`

List of network groups for configuration. An admin rule collection must be associated to at least one network group.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`networkGroupResourceId`](#parameter-appliestogroupsnetworkgroupresourceid) | string | The resource ID of the network group. |

### Parameter: `appliesToGroups.networkGroupResourceId`

The resource ID of the network group.

- Required: Yes
- Type: string

### Parameter: `name`

The name of the admin rule collection.

- Required: Yes
- Type: string

### Parameter: `networkManagerName`

The name of the parent network manager. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `securityAdminConfigurationName`

The name of the parent security admin configuration. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `description`

A description of the admin rule collection.

- Required: No
- Type: string

### Parameter: `rules`

List of rules for the admin rules collection. Security admin rules allows enforcing security policy criteria that matches the conditions set. Warning: A rule collection without rule will cause a deployment configuration for security admin goal state in network manager to fail.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`access`](#parameter-rulesaccess) | string | Indicates the access allowed for this particular rule. "Allow" means traffic matching this rule will be allowed. "Deny" means traffic matching this rule will be blocked. "AlwaysAllow" means that traffic matching this rule will be allowed regardless of other rules with lower priority or user-defined NSGs. |
| [`direction`](#parameter-rulesdirection) | string | Indicates if the traffic matched against the rule in inbound or outbound. |
| [`name`](#parameter-rulesname) | string | The name of the rule. |
| [`priority`](#parameter-rulespriority) | int | The priority of the rule. The value can be between 1 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule. |
| [`protocol`](#parameter-rulesprotocol) | string | Network protocol this rule applies to. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-rulesdescription) | string | A description of the rule. |
| [`destinationPortRanges`](#parameter-rulesdestinationportranges) | array | List of destination port ranges. This specifies on which ports traffic will be allowed or denied by this rule. Provide an (*) to allow traffic on any port. Port ranges are between 1-65535. |
| [`destinations`](#parameter-rulesdestinations) | array | The destnations filter can be an IP Address or a service tag. Each filter contains the properties AddressPrefixType (IPPrefix or ServiceTag) and AddressPrefix (using CIDR notation (e.g. 192.168.99.0/24 or 2001:1234::/64) or a service tag (e.g. AppService.WestEurope)). Combining CIDR and Service tags in one rule filter is not permitted. |
| [`sourcePortRanges`](#parameter-rulessourceportranges) | array | List of destination port ranges. This specifies on which ports traffic will be allowed or denied by this rule. Provide an (*) to allow traffic on any port. Port ranges are between 1-65535. |
| [`sources`](#parameter-rulessources) | array | The source filter can be an IP Address or a service tag. Each filter contains the properties AddressPrefixType (IPPrefix or ServiceTag) and AddressPrefix (using CIDR notation (e.g. 192.168.99.0/24 or 2001:1234::/64) or a service tag (e.g. AppService.WestEurope)). Combining CIDR and Service tags in one rule filter is not permitted. |

### Parameter: `rules.access`

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

### Parameter: `rules.direction`

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

### Parameter: `rules.name`

The name of the rule.

- Required: Yes
- Type: string

### Parameter: `rules.priority`

The priority of the rule. The value can be between 1 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule.

- Required: Yes
- Type: int

### Parameter: `rules.protocol`

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

### Parameter: `rules.description`

A description of the rule.

- Required: No
- Type: string

### Parameter: `rules.destinationPortRanges`

List of destination port ranges. This specifies on which ports traffic will be allowed or denied by this rule. Provide an (*) to allow traffic on any port. Port ranges are between 1-65535.

- Required: No
- Type: array

### Parameter: `rules.destinations`

The destnations filter can be an IP Address or a service tag. Each filter contains the properties AddressPrefixType (IPPrefix or ServiceTag) and AddressPrefix (using CIDR notation (e.g. 192.168.99.0/24 or 2001:1234::/64) or a service tag (e.g. AppService.WestEurope)). Combining CIDR and Service tags in one rule filter is not permitted.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addressPrefix`](#parameter-rulesdestinationsaddressprefix) | string | Address prefix. |
| [`addressPrefixType`](#parameter-rulesdestinationsaddressprefixtype) | string | Address prefix type. |

### Parameter: `rules.destinations.addressPrefix`

Address prefix.

- Required: Yes
- Type: string

### Parameter: `rules.destinations.addressPrefixType`

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

### Parameter: `rules.sourcePortRanges`

List of destination port ranges. This specifies on which ports traffic will be allowed or denied by this rule. Provide an (*) to allow traffic on any port. Port ranges are between 1-65535.

- Required: No
- Type: array

### Parameter: `rules.sources`

The source filter can be an IP Address or a service tag. Each filter contains the properties AddressPrefixType (IPPrefix or ServiceTag) and AddressPrefix (using CIDR notation (e.g. 192.168.99.0/24 or 2001:1234::/64) or a service tag (e.g. AppService.WestEurope)). Combining CIDR and Service tags in one rule filter is not permitted.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addressPrefix`](#parameter-rulessourcesaddressprefix) | string | Address prefix. |
| [`addressPrefixType`](#parameter-rulessourcesaddressprefixtype) | string | Address prefix type. |

### Parameter: `rules.sources.addressPrefix`

Address prefix.

- Required: Yes
- Type: string

### Parameter: `rules.sources.addressPrefixType`

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

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed admin rule collection. |
| `resourceGroupName` | string | The resource group the admin rule collection was deployed into. |
| `resourceId` | string | The resource ID of the deployed admin rule collection. |
