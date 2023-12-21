# Consumption Budgets `[Microsoft.Consumption/budgets]`

This module deploys a Consumption Budget for Subscriptions.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Consumption/budgets` | [2021-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Consumption/2021-10-01/budgets) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/consumption.budget:1.0.0`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module budget 'br:bicep/modules/consumption.budget:1.0.0' = {
  name: '${uniqueString(deployment().name)}-test-cbmin'
  params: {
    // Required parameters
    amount: 500
    name: 'cbmin001'
    // Non-required parameters
    contactEmails: [
      'dummy@contoso.com'
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
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
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    }
  }
}
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module budget 'br:bicep/modules/consumption.budget:1.0.0' = {
  name: '${uniqueString(deployment().name)}-test-cbmax'
  params: {
    // Required parameters
    amount: 500
    name: 'cbmax001'
    // Non-required parameters
    contactEmails: [
      'dummy@contoso.com'
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
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
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
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

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module budget 'br:bicep/modules/consumption.budget:1.0.0' = {
  name: '${uniqueString(deployment().name)}-test-cbwaf'
  params: {
    // Required parameters
    amount: 500
    name: 'cbwaf001'
    // Non-required parameters
    contactEmails: [
      'dummy@contoso.com'
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
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
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
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
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`endDate`](#parameter-enddate) | string | The end date for the budget. If not provided, it will default to 10 years from the start date. |
| [`location`](#parameter-location) | string | Location deployment metadata. |
| [`resetPeriod`](#parameter-resetperiod) | string | The time covered by a budget. Tracking of the amount will be reset based on the time grain. BillingMonth, BillingQuarter, and BillingAnnual are only supported by WD customers. |
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

### Parameter: `actionGroups`

List of action group resource IDs that will receive the alert. Required if neither `contactEmails` nor `contactEmails` was provided.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `contactEmails`

The list of email addresses to send the budget notification to when the thresholds are exceeded. Required if neither `contactRoles` nor `actionGroups` was provided.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `contactRoles`

The list of contact roles to send the budget notification to when the thresholds are exceeded. Required if neither `contactEmails` nor `actionGroups` was provided.

- Required: No
- Type: array
- Default: `[]`

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

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).

- Required: No
- Type: bool
- Default: `True`

### Parameter: `endDate`

The end date for the budget. If not provided, it will default to 10 years from the start date.

- Required: No
- Type: string
- Default: `''`

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
