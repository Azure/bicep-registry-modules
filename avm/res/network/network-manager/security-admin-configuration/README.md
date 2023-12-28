# Network Manager Security Admin Configurations `[Microsoft.Network/networkManagers/securityAdminConfigurations]`

This module deploys an Network Manager Security Admin Configuration.
A security admin configuration contains a set of rule collections. Each rule collection contains one or more security admin rules.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/networkManagers/securityAdminConfigurations` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/networkManagers/securityAdminConfigurations) |
| `Microsoft.Network/networkManagers/securityAdminConfigurations/ruleCollections` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/networkManagers/securityAdminConfigurations/ruleCollections) |
| `Microsoft.Network/networkManagers/securityAdminConfigurations/ruleCollections/rules` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/networkManagers/securityAdminConfigurations/ruleCollections/rules) |

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

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    'None'
  ]
  ```
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
- Default: `''`

### Parameter: `ruleCollections`

A security admin configuration contains a set of rule collections that are applied to network groups. Each rule collection contains one or more security admin rules.

- Required: No
- Type: array
- Default: `[]`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed security admin configuration. |
| `resourceGroupName` | string | The resource group the security admin configuration was deployed into. |
| `resourceId` | string | The resource ID of the deployed security admin configuration. |

## Cross-referenced modules

_None_
