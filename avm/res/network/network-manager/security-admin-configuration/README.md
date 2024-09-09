# Network Manager Security Admin Configurations `[Microsoft.Network/networkManagers/securityAdminConfigurations]`

This module deploys an Network Manager Security Admin Configuration.
A security admin configuration contains a set of rule collections. Each rule collection contains one or more security admin rules.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/networkManagers/securityAdminConfigurations` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/networkManagers/securityAdminConfigurations) |
| `Microsoft.Network/networkManagers/securityAdminConfigurations/ruleCollections` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/networkManagers/securityAdminConfigurations/ruleCollections) |
| `Microsoft.Network/networkManagers/securityAdminConfigurations/ruleCollections/rules` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/networkManagers/securityAdminConfigurations/ruleCollections/rules) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`applyOnNetworkIntentPolicyBasedServices`](#parameter-applyonnetworkintentpolicybasedservices) | array | Enum list of network intent policy based services. |
| [`name`](#parameter-name) | string | The name of the security admin configuration. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`networkManagerName`](#parameter-networkmanagername) | string | The name of the parent network manager. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-description) | string | A description of the security admin configuration. |
| [`ruleCollections`](#parameter-rulecollections) | array | A security admin configuration contains a set of rule collections that are applied to network groups. Each rule collection contains one or more security admin rules. |

### Parameter: `applyOnNetworkIntentPolicyBasedServices`

Enum list of network intent policy based services.

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

### Parameter: `name`

The name of the security admin configuration.

- Required: Yes
- Type: string

### Parameter: `networkManagerName`

The name of the parent network manager. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `description`

A description of the security admin configuration.

- Required: No
- Type: string

### Parameter: `ruleCollections`

A security admin configuration contains a set of rule collections that are applied to network groups. Each rule collection contains one or more security admin rules.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appliesToGroups`](#parameter-rulecollectionsappliestogroups) | array | List of network groups for configuration. An admin rule collection must be associated to at least one network group. |
| [`name`](#parameter-rulecollectionsname) | string | The name of the admin rule collection. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-rulecollectionsdescription) | string | A description of the admin rule collection. |
| [`rules`](#parameter-rulecollectionsrules) | array | List of rules for the admin rules collection. Security admin rules allows enforcing security policy criteria that matches the conditions set. Warning: A rule collection without rule will cause a deployment configuration for security admin goal state in network manager to fail. |

### Parameter: `ruleCollections.appliesToGroups`

List of network groups for configuration. An admin rule collection must be associated to at least one network group.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`networkGroupResourceId`](#parameter-rulecollectionsappliestogroupsnetworkgroupresourceid) | string | The resource ID of the network group. |

### Parameter: `ruleCollections.appliesToGroups.networkGroupResourceId`

The resource ID of the network group.

- Required: Yes
- Type: string

### Parameter: `ruleCollections.name`

The name of the admin rule collection.

- Required: Yes
- Type: string

### Parameter: `ruleCollections.description`

A description of the admin rule collection.

- Required: No
- Type: string

### Parameter: `ruleCollections.rules`

List of rules for the admin rules collection. Security admin rules allows enforcing security policy criteria that matches the conditions set. Warning: A rule collection without rule will cause a deployment configuration for security admin goal state in network manager to fail.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`access`](#parameter-rulecollectionsrulesaccess) | string | Indicates the access allowed for this particular rule. "Allow" means traffic matching this rule will be allowed. "Deny" means traffic matching this rule will be blocked. "AlwaysAllow" means that traffic matching this rule will be allowed regardless of other rules with lower priority or user-defined NSGs. |
| [`direction`](#parameter-rulecollectionsrulesdirection) | string | Indicates if the traffic matched against the rule in inbound or outbound. |
| [`name`](#parameter-rulecollectionsrulesname) | string | The name of the rule. |
| [`priority`](#parameter-rulecollectionsrulespriority) | int | The priority of the rule. The value can be between 1 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule. |
| [`protocol`](#parameter-rulecollectionsrulesprotocol) | string | Network protocol this rule applies to. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-rulecollectionsrulesdescription) | string | A description of the rule. |
| [`destinationPortRanges`](#parameter-rulecollectionsrulesdestinationportranges) | array | List of destination port ranges. This specifies on which ports traffic will be allowed or denied by this rule. Provide an (*) to allow traffic on any port. Port ranges are between 1-65535. |
| [`destinations`](#parameter-rulecollectionsrulesdestinations) | array | The destnations filter can be an IP Address or a service tag. Each filter contains the properties AddressPrefixType (IPPrefix or ServiceTag) and AddressPrefix (using CIDR notation (e.g. 192.168.99.0/24 or 2001:1234::/64) or a service tag (e.g. AppService.WestEurope)). Combining CIDR and Service tags in one rule filter is not permitted. |
| [`sourcePortRanges`](#parameter-rulecollectionsrulessourceportranges) | array | List of destination port ranges. This specifies on which ports traffic will be allowed or denied by this rule. Provide an (*) to allow traffic on any port. Port ranges are between 1-65535. |
| [`sources`](#parameter-rulecollectionsrulessources) | array | The source filter can be an IP Address or a service tag. Each filter contains the properties AddressPrefixType (IPPrefix or ServiceTag) and AddressPrefix (using CIDR notation (e.g. 192.168.99.0/24 or 2001:1234::/64) or a service tag (e.g. AppService.WestEurope)). Combining CIDR and Service tags in one rule filter is not permitted. |

### Parameter: `ruleCollections.rules.access`

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

### Parameter: `ruleCollections.rules.direction`

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

### Parameter: `ruleCollections.rules.name`

The name of the rule.

- Required: Yes
- Type: string

### Parameter: `ruleCollections.rules.priority`

The priority of the rule. The value can be between 1 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule.

- Required: Yes
- Type: int

### Parameter: `ruleCollections.rules.protocol`

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

### Parameter: `ruleCollections.rules.description`

A description of the rule.

- Required: No
- Type: string

### Parameter: `ruleCollections.rules.destinationPortRanges`

List of destination port ranges. This specifies on which ports traffic will be allowed or denied by this rule. Provide an (*) to allow traffic on any port. Port ranges are between 1-65535.

- Required: No
- Type: array

### Parameter: `ruleCollections.rules.destinations`

The destnations filter can be an IP Address or a service tag. Each filter contains the properties AddressPrefixType (IPPrefix or ServiceTag) and AddressPrefix (using CIDR notation (e.g. 192.168.99.0/24 or 2001:1234::/64) or a service tag (e.g. AppService.WestEurope)). Combining CIDR and Service tags in one rule filter is not permitted.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addressPrefix`](#parameter-rulecollectionsrulesdestinationsaddressprefix) | string | Address prefix. |
| [`addressPrefixType`](#parameter-rulecollectionsrulesdestinationsaddressprefixtype) | string | Address prefix type. |

### Parameter: `ruleCollections.rules.destinations.addressPrefix`

Address prefix.

- Required: Yes
- Type: string

### Parameter: `ruleCollections.rules.destinations.addressPrefixType`

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

### Parameter: `ruleCollections.rules.sourcePortRanges`

List of destination port ranges. This specifies on which ports traffic will be allowed or denied by this rule. Provide an (*) to allow traffic on any port. Port ranges are between 1-65535.

- Required: No
- Type: array

### Parameter: `ruleCollections.rules.sources`

The source filter can be an IP Address or a service tag. Each filter contains the properties AddressPrefixType (IPPrefix or ServiceTag) and AddressPrefix (using CIDR notation (e.g. 192.168.99.0/24 or 2001:1234::/64) or a service tag (e.g. AppService.WestEurope)). Combining CIDR and Service tags in one rule filter is not permitted.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addressPrefix`](#parameter-rulecollectionsrulessourcesaddressprefix) | string | Address prefix. |
| [`addressPrefixType`](#parameter-rulecollectionsrulessourcesaddressprefixtype) | string | Address prefix type. |

### Parameter: `ruleCollections.rules.sources.addressPrefix`

Address prefix.

- Required: Yes
- Type: string

### Parameter: `ruleCollections.rules.sources.addressPrefixType`

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
| `name` | string | The name of the deployed security admin configuration. |
| `resourceGroupName` | string | The resource group the security admin configuration was deployed into. |
| `resourceId` | string | The resource ID of the deployed security admin configuration. |
