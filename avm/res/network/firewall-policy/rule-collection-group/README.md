# Firewall Policy Rule Collection Groups `[Microsoft.Network/firewallPolicies/ruleCollectionGroups]`

This module deploys a Firewall Policy Rule Collection Group.

You can reference the module as follows:
```bicep
module firewallPolicy 'br/public:avm/res/network/firewall-policy/rule-collection-group:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Network/firewallPolicies/ruleCollectionGroups` | 2024-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_firewallpolicies_rulecollectiongroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-10-01/firewallPolicies/ruleCollectionGroups)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the rule collection group to deploy. |
| [`priority`](#parameter-priority) | int | Priority of the Firewall Policy Rule Collection Group resource. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`firewallPolicyName`](#parameter-firewallpolicyname) | string | The name of the parent Firewall Policy. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`ruleCollections`](#parameter-rulecollections) | array | Group of Firewall Policy rule collections. |

### Parameter: `name`

The name of the rule collection group to deploy.

- Required: Yes
- Type: string

### Parameter: `priority`

Priority of the Firewall Policy Rule Collection Group resource.

- Required: Yes
- Type: int

### Parameter: `firewallPolicyName`

The name of the parent Firewall Policy. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `ruleCollections`

Group of Firewall Policy rule collections.

- Required: No
- Type: array

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed rule collection group. |
| `resourceGroupName` | string | The resource group of the deployed rule collection group. |
| `resourceId` | string | The resource ID of the deployed rule collection group. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
