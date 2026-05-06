# CDN Profiles Rules `[Microsoft.Cdn/profiles/ruleSets/rules]`

This module deploys a CDN Profile rule.

You can reference the module as follows:
```bicep
module profile 'br/public:avm/res/cdn/profile/rule-set/rule:<version>' = {
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
| `Microsoft.Cdn/profiles/ruleSets/rules` | 2025-04-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cdn_profiles_rulesets_rules.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2025-04-15/profiles/ruleSets/rules)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the rule. |
| [`order`](#parameter-order) | int | The order in which this rule will be applied. Rules with a lower order are applied before rules with a higher order. |
| [`profileName`](#parameter-profilename) | string | The name of the profile. |
| [`ruleSetName`](#parameter-rulesetname) | string | The name of the rule set. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`actions`](#parameter-actions) | array | A list of actions that are executed when all the conditions of a rule are satisfied. |
| [`conditions`](#parameter-conditions) | array | A list of conditions that must be matched for the actions to be executed. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`matchProcessingBehavior`](#parameter-matchprocessingbehavior) | string | If this rule is a match should the rules engine continue running the remaining rules or stop. If not present, defaults to Continue. |

### Parameter: `name`

The name of the rule.

- Required: Yes
- Type: string

### Parameter: `order`

The order in which this rule will be applied. Rules with a lower order are applied before rules with a higher order.

- Required: Yes
- Type: int

### Parameter: `profileName`

The name of the profile.

- Required: Yes
- Type: string

### Parameter: `ruleSetName`

The name of the rule set.

- Required: Yes
- Type: string

### Parameter: `actions`

A list of actions that are executed when all the conditions of a rule are satisfied.

- Required: No
- Type: array

### Parameter: `conditions`

A list of conditions that must be matched for the actions to be executed.

- Required: No
- Type: array

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `matchProcessingBehavior`

If this rule is a match should the rules engine continue running the remaining rules or stop. If not present, defaults to Continue.

- Required: No
- Type: string
- Default: `'Continue'`
- Allowed:
  ```Bicep
  [
    'Continue'
    'Stop'
  ]
  ```

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the rule. |
| `resourceGroupName` | string | The name of the resource group the custom domain was created in. |
| `resourceId` | string | The resource id of the rule. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
