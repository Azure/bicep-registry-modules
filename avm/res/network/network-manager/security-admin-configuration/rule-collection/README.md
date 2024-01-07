# Network Manager Security Admin Configuration Rule Collections `[Microsoft.Network/networkManagers/securityAdminConfigurations/ruleCollections]`

This module deploys an Network Manager Security Admin Configuration Rule Collection.
A security admin configuration contains a set of rule collections. Each rule collection contains one or more security admin rules. Security admin rules allows enforcing security policy criteria that matches the conditions set. Warning: A rule collection without rule will cause a deployment configuration for security admin goal state in network manager to fail.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/networkManagers/securityAdminConfigurations/ruleCollections` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/networkManagers/securityAdminConfigurations/ruleCollections) |
| `Microsoft.Network/networkManagers/securityAdminConfigurations/ruleCollections/rules` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/networkManagers/securityAdminConfigurations/ruleCollections/rules) |

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
- Default: `''`

### Parameter: `rules`

List of rules for the admin rules collection. Security admin rules allows enforcing security policy criteria that matches the conditions set. Warning: A rule collection without rule will cause a deployment configuration for security admin goal state in network manager to fail.

- Required: Yes
- Type: array


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed admin rule collection. |
| `resourceGroupName` | string | The resource group the admin rule collection was deployed into. |
| `resourceId` | string | The resource ID of the deployed admin rule collection. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
