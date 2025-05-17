# CDN Profiles Rules `[Microsoft.Cdn/profiles/ruleSets/rules]`

This module deploys a CDN Profile rule.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Cdn/profiles/ruleSets/rules` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2023-05-01/profiles/ruleSets/rules) |

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
