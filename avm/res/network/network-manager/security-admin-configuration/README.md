# Network Manager Security Admin Configurations `[Microsoft.Network/networkManagers/securityAdminConfigurations]`

This module deploys an Network Manager Security Admin Configuration.
A security admin configuration contains a set of rule collections. Each rule collection contains one or more security admin rules.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

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

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
