# Network Manager Security Admin Configuration Rule Collections `[Microsoft.Network/networkManagers/securityAdminConfigurations/ruleCollections]`

This module deploys an Network Manager Security Admin Configuration Rule Collection.
A security admin configuration contains a set of rule collections. Each rule collection contains one or more security admin rules. Security admin rules allows enforcing security policy criteria that matches the conditions set. Warning: A rule collection without rule will cause a deployment configuration for security admin goal state in network manager to fail.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

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
