# Network Manager Security Admin Configuration Rule Collection Rules `[Microsoft.Network/networkManagers/securityAdminConfigurations/ruleCollections/rules]`

This module deploys an Azure Virtual Network Manager (AVNM) Security Admin Configuration Rule Collection Rule.
A security admin configuration contains a set of rule collections. Each rule collection contains one or more security admin rules.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/networkManagers/securityAdminConfigurations/ruleCollections/rules` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/networkManagers/securityAdminConfigurations/ruleCollections/rules) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`access`](#parameter-access) | string | Indicates the access allowed for this particular rule. "Allow" means traffic matching this rule will be allowed. "Deny" means traffic matching this rule will be blocked. "AlwaysAllow" means that traffic matching this rule will be allowed regardless of other rules with lower priority or user-defined NSGs. |
| [`direction`](#parameter-direction) | string | Indicates if the traffic matched against the rule in inbound or outbound. |
| [`name`](#parameter-name) | string | The name of the rule. |
| [`priority`](#parameter-priority) | int | The priority of the rule. The value can be between 1 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule. |
| [`protocol`](#parameter-protocol) | string | Network protocol this rule applies to. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`networkManagerName`](#parameter-networkmanagername) | string | The name of the parent network manager. Required if the template is used in a standalone deployment. |
| [`ruleCollectionName`](#parameter-rulecollectionname) | string | The name of the parent rule collection. Required if the template is used in a standalone deployment. |
| [`securityAdminConfigurationName`](#parameter-securityadminconfigurationname) | string | The name of the parent security admin configuration. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-description) | string | A description of the rule. |
| [`destinationPortRanges`](#parameter-destinationportranges) | array | List of destination port ranges. This specifies on which ports traffic will be allowed or denied by this rule. Provide an (*) to allow traffic on any port. Port ranges are between 1-65535. |
| [`destinations`](#parameter-destinations) | array | The destnations filter can be an IP Address or a service tag. Each filter contains the properties AddressPrefixType (IPPrefix or ServiceTag) and AddressPrefix (using CIDR notation (e.g. 192.168.99.0/24 or 2001:1234::/64) or a service tag (e.g. AppService.WestEurope)). Combining CIDR and Service tags in one rule filter is not permitted. |
| [`sourcePortRanges`](#parameter-sourceportranges) | array | List of destination port ranges. This specifies on which ports traffic will be allowed or denied by this rule. Provide an (*) to allow traffic on any port. Port ranges are between 1-65535. |
| [`sources`](#parameter-sources) | array | The source filter can be an IP Address or a service tag. Each filter contains the properties AddressPrefixType (IPPrefix or ServiceTag) and AddressPrefix (using CIDR notation (e.g. 192.168.99.0/24 or 2001:1234::/64) or a service tag (e.g. AppService.WestEurope)). Combining CIDR and Service tags in one rule filter is not permitted. |

### Parameter: `access`

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

### Parameter: `direction`

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

### Parameter: `name`

The name of the rule.

- Required: Yes
- Type: string

### Parameter: `priority`

The priority of the rule. The value can be between 1 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule.

- Required: Yes
- Type: int

### Parameter: `protocol`

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

### Parameter: `networkManagerName`

The name of the parent network manager. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `ruleCollectionName`

The name of the parent rule collection. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `securityAdminConfigurationName`

The name of the parent security admin configuration. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `description`

A description of the rule.

- Required: No
- Type: string

### Parameter: `destinationPortRanges`

List of destination port ranges. This specifies on which ports traffic will be allowed or denied by this rule. Provide an (*) to allow traffic on any port. Port ranges are between 1-65535.

- Required: No
- Type: array

### Parameter: `destinations`

The destnations filter can be an IP Address or a service tag. Each filter contains the properties AddressPrefixType (IPPrefix or ServiceTag) and AddressPrefix (using CIDR notation (e.g. 192.168.99.0/24 or 2001:1234::/64) or a service tag (e.g. AppService.WestEurope)). Combining CIDR and Service tags in one rule filter is not permitted.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addressPrefix`](#parameter-destinationsaddressprefix) | string | Address prefix. |
| [`addressPrefixType`](#parameter-destinationsaddressprefixtype) | string | Address prefix type. |

### Parameter: `destinations.addressPrefix`

Address prefix.

- Required: Yes
- Type: string

### Parameter: `destinations.addressPrefixType`

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

### Parameter: `sourcePortRanges`

List of destination port ranges. This specifies on which ports traffic will be allowed or denied by this rule. Provide an (*) to allow traffic on any port. Port ranges are between 1-65535.

- Required: No
- Type: array

### Parameter: `sources`

The source filter can be an IP Address or a service tag. Each filter contains the properties AddressPrefixType (IPPrefix or ServiceTag) and AddressPrefix (using CIDR notation (e.g. 192.168.99.0/24 or 2001:1234::/64) or a service tag (e.g. AppService.WestEurope)). Combining CIDR and Service tags in one rule filter is not permitted.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addressPrefix`](#parameter-sourcesaddressprefix) | string | Address prefix. |
| [`addressPrefixType`](#parameter-sourcesaddressprefixtype) | string | Address prefix type. |

### Parameter: `sources.addressPrefix`

Address prefix.

- Required: Yes
- Type: string

### Parameter: `sources.addressPrefixType`

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
| `name` | string | The name of the deployed rule. |
| `resourceGroupName` | string | The resource group the rule was deployed into. |
| `resourceId` | string | The resource ID of the deployed rule. |
