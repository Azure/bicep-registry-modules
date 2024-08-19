# Consumption Budgets `[Microsoft.Consumption/budgets]`

This module deploys a Consumption Budget for Subscriptions.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Consumption/budgets` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Consumption/budgets) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/consumption/budget:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using `thresholdType` `Forecasted`](#example-2-using-thresholdtype-forecasted)
- [Using large parameter set](#example-3-using-large-parameter-set)
- [WAF-aligned](#example-4-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module budget 'br/public:avm/res/consumption/budget:<version>' = {
  name: 'budgetDeployment'
  params: {
    // Required parameters
    amount: 500
    name: 'cbmin001'
    // Non-required parameters
    contactEmails: [
      'dummy@contoso.com'
    ]
    location: '<location>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "amount": {
      "value": 500
    },
    "name": {
      "value": "cbmin001"
    },
    // Non-required parameters
    "contactEmails": {
      "value": [
        "dummy@contoso.com"
      ]
    },
    "location": {
      "value": "<location>"
    }
  }
}
```

</details>
<p>

### Example 2: _Using `thresholdType` `Forecasted`_

This instance deploys the module with the minimum set of required parameters and `thresholdType` `Forecasted`.


<details>

<summary>via Bicep module</summary>

```bicep
module budget 'br/public:avm/res/consumption/budget:<version>' = {
  name: 'budgetDeployment'
  params: {
    // Required parameters
    amount: 500
    name: 'cbfcst001'
    // Non-required parameters
    contactEmails: [
      'dummy@contoso.com'
    ]
    location: '<location>'
    thresholdType: 'Forecasted'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "amount": {
      "value": 500
    },
    "name": {
      "value": "cbfcst001"
    },
    // Non-required parameters
    "contactEmails": {
      "value": [
        "dummy@contoso.com"
      ]
    },
    "location": {
      "value": "<location>"
    },
    "thresholdType": {
      "value": "Forecasted"
    }
  }
}
```

</details>
<p>

### Example 3: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module budget 'br/public:avm/res/consumption/budget:<version>' = {
  name: 'budgetDeployment'
  params: {
    // Required parameters
    amount: 500
    name: 'cbmax001'
    // Non-required parameters
    contactEmails: [
      'dummy@contoso.com'
    ]
    location: '<location>'
    resourceGroupFilter: [
      'rg-group1'
      'rg-group2'
    ]
    thresholds: [
      50
      75
      90
      100
      110
    ]
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "amount": {
      "value": 500
    },
    "name": {
      "value": "cbmax001"
    },
    // Non-required parameters
    "contactEmails": {
      "value": [
        "dummy@contoso.com"
      ]
    },
    "location": {
      "value": "<location>"
    },
    "resourceGroupFilter": {
      "value": [
        "rg-group1",
        "rg-group2"
      ]
    },
    "thresholds": {
      "value": [
        50,
        75,
        90,
        100,
        110
      ]
    }
  }
}
```

</details>
<p>

### Example 4: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module budget 'br/public:avm/res/consumption/budget:<version>' = {
  name: 'budgetDeployment'
  params: {
    // Required parameters
    amount: 500
    name: 'cbwaf001'
    // Non-required parameters
    contactEmails: [
      'dummy@contoso.com'
    ]
    location: '<location>'
    thresholds: [
      50
      75
      90
      100
      110
    ]
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "amount": {
      "value": 500
    },
    "name": {
      "value": "cbwaf001"
    },
    // Non-required parameters
    "contactEmails": {
      "value": [
        "dummy@contoso.com"
      ]
    },
    "location": {
      "value": "<location>"
    },
    "thresholds": {
      "value": [
        50,
        75,
        90,
        100,
        110
      ]
    }
  }
}
```

</details>
<p>


## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`amount`](#parameter-amount) | int | The total amount of cost or usage to track with the budget. |
| [`name`](#parameter-name) | string | The name of the budget. |
| [`operator`](#parameter-operator) | string | The comparison operator. The operator can be either `EqualTo`, `GreaterThan`, or `GreaterThanOrEqualTo`. |
| [`thresholdType`](#parameter-thresholdtype) | string | The type of threshold to use for the budget. The threshold type can be either `Actual` or `Forecasted`. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`actionGroups`](#parameter-actiongroups) | array | List of action group resource IDs that will receive the alert. Required if neither `contactEmails` nor `contactEmails` was provided. |
| [`contactEmails`](#parameter-contactemails) | array | The list of email addresses to send the budget notification to when the thresholds are exceeded. Required if neither `contactRoles` nor `actionGroups` was provided. |
| [`contactRoles`](#parameter-contactroles) | array | The list of contact roles to send the budget notification to when the thresholds are exceeded. Required if neither `contactEmails` nor `actionGroups` was provided. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-category) | string | The category of the budget, whether the budget tracks cost or usage. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`endDate`](#parameter-enddate) | string | The end date for the budget. If not provided, it will default to 10 years from the start date. |
| [`filter`](#parameter-filter) | object | The filter to use for restricting which resources are considered within the budget. |
| [`location`](#parameter-location) | string | Location deployment metadata. |
| [`resetPeriod`](#parameter-resetperiod) | string | The time covered by a budget. Tracking of the amount will be reset based on the time grain. BillingMonth, BillingQuarter, and BillingAnnual are only supported by WD customers. |
| [`resourceGroupFilter`](#parameter-resourcegroupfilter) | array | The list of resource groups that contain the resources that are to be considered within the budget. |
| [`startDate`](#parameter-startdate) | string | The start date for the budget. Start date should be the first day of the month and cannot be in the past (except for the current month). |
| [`thresholds`](#parameter-thresholds) | array | Percent thresholds of budget for when to get a notification. Can be up to 5 thresholds, where each must be between 1 and 1000. |

### Parameter: `amount`

The total amount of cost or usage to track with the budget.

- Required: Yes
- Type: int

### Parameter: `name`

The name of the budget.

- Required: Yes
- Type: string

### Parameter: `operator`

The comparison operator. The operator can be either `EqualTo`, `GreaterThan`, or `GreaterThanOrEqualTo`.

- Required: No
- Type: string
- Default: `'GreaterThan'`
- Allowed:
  ```Bicep
  [
    'EqualTo'
    'GreaterThan'
    'GreaterThanOrEqualTo'
  ]
  ```

### Parameter: `thresholdType`

The type of threshold to use for the budget. The threshold type can be either `Actual` or `Forecasted`.

- Required: No
- Type: string
- Default: `'Actual'`
- Allowed:
  ```Bicep
  [
    'Actual'
    'Forecasted'
  ]
  ```

### Parameter: `actionGroups`

List of action group resource IDs that will receive the alert. Required if neither `contactEmails` nor `contactEmails` was provided.

- Required: No
- Type: array

### Parameter: `contactEmails`

The list of email addresses to send the budget notification to when the thresholds are exceeded. Required if neither `contactRoles` nor `actionGroups` was provided.

- Required: No
- Type: array

### Parameter: `contactRoles`

The list of contact roles to send the budget notification to when the thresholds are exceeded. Required if neither `contactEmails` nor `actionGroups` was provided.

- Required: No
- Type: array

### Parameter: `category`

The category of the budget, whether the budget tracks cost or usage.

- Required: No
- Type: string
- Default: `'Cost'`
- Allowed:
  ```Bicep
  [
    'Cost'
    'Usage'
  ]
  ```

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `endDate`

The end date for the budget. If not provided, it will default to 10 years from the start date.

- Required: No
- Type: string
- Default: `''`

### Parameter: `filter`

The filter to use for restricting which resources are considered within the budget.

- Required: No
- Type: object

### Parameter: `location`

Location deployment metadata.

- Required: No
- Type: string
- Default: `[deployment().location]`

### Parameter: `resetPeriod`

The time covered by a budget. Tracking of the amount will be reset based on the time grain. BillingMonth, BillingQuarter, and BillingAnnual are only supported by WD customers.

- Required: No
- Type: string
- Default: `'Monthly'`
- Allowed:
  ```Bicep
  [
    'Annually'
    'BillingAnnual'
    'BillingMonth'
    'BillingQuarter'
    'Monthly'
    'Quarterly'
  ]
  ```

### Parameter: `resourceGroupFilter`

The list of resource groups that contain the resources that are to be considered within the budget.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `startDate`

The start date for the budget. Start date should be the first day of the month and cannot be in the past (except for the current month).

- Required: No
- Type: string
- Default: `[format('{0}-{1}-01T00:00:00Z', utcNow('yyyy'), utcNow('MM'))]`

### Parameter: `thresholds`

Percent thresholds of budget for when to get a notification. Can be up to 5 thresholds, where each must be between 1 and 1000.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    50
    75
    90
    100
    110
  ]
  ```


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the budget. |
| `resourceId` | string | The resource ID of the budget. |
| `subscriptionName` | string | The subscription the budget was deployed into. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
