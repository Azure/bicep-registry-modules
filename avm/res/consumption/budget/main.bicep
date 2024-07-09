metadata name = 'Consumption Budgets'
metadata description = 'This module deploys a Consumption Budget for Subscriptions.'
metadata owner = 'Azure/module-maintainers'

targetScope = 'subscription'

@description('Required. The name of the budget.')
param name string

@allowed([
  'Cost'
  'Usage'
])
@description('Optional. The category of the budget, whether the budget tracks cost or usage.')
param category string = 'Cost'

@description('Required. The total amount of cost or usage to track with the budget.')
param amount int

@allowed([
  'Monthly'
  'Quarterly'
  'Annually'
  'BillingMonth'
  'BillingQuarter'
  'BillingAnnual'
])
@description('Optional. The time covered by a budget. Tracking of the amount will be reset based on the time grain. BillingMonth, BillingQuarter, and BillingAnnual are only supported by WD customers.')
param resetPeriod string = 'Monthly'

@description('Optional. The start date for the budget. Start date should be the first day of the month and cannot be in the past (except for the current month).')
param startDate string = '${utcNow('yyyy')}-${utcNow('MM')}-01T00:00:00Z'

@description('Optional. The end date for the budget. If not provided, it will default to 10 years from the start date.')
param endDate string = ''

@allowed([
  'EqualTo'
  'GreaterThan'
  'GreaterThanOrEqualTo'
])
@description('Required. The comparison operator. The operator can be either `EqualTo`, `GreaterThan`, or `GreaterThanOrEqualTo`.')
param operator string = 'GreaterThan'

@maxLength(5)
@description('Optional. Percent thresholds of budget for when to get a notification. Can be up to 5 thresholds, where each must be between 1 and 1000.')
param thresholds array = [
  50
  75
  90
  100
  110
]

@description('Conditional. The list of email addresses to send the budget notification to when the thresholds are exceeded. Required if neither `contactRoles` nor `actionGroups` was provided.')
param contactEmails array?

@description('Conditional. The list of contact roles to send the budget notification to when the thresholds are exceeded. Required if neither `contactEmails` nor `actionGroups` was provided.')
param contactRoles array?

@description('Conditional. List of action group resource IDs that will receive the alert. Required if neither `contactEmails` nor `contactEmails` was provided.')
param actionGroups array?

@allowed([
  'Actual'
  'Forecasted'
])
@description('Required. The type of threshold to use for the budget. The threshold type can be either `Actual` or `Forecasted`.')
param thresholdType string = 'Actual'

@description('Optional. The filter to use for restricting which resources are considered within the budget.')
param filter object?

@description('Optional. The list of resource groups that contain the resources that are to be considered within the budget.')
param resourceGroupFilter string[] = []

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Location deployment metadata.')
param location string = deployment().location

var notificationsArray = [
  for threshold in thresholds: {
    'Actual_GreaterThan_${threshold}_Percentage': {
      enabled: true
      operator: operator
      threshold: threshold
      contactEmails: contactEmails
      contactRoles: contactRoles
      contactGroups: actionGroups
      thresholdType: thresholdType
    }
  }
]

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.consumption-budget.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  location: location
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

resource budget 'Microsoft.Consumption/budgets@2023-11-01' = {
  name: name
  properties: {
    category: category
    amount: amount
    timeGrain: resetPeriod
    timePeriod: {
      startDate: startDate
      endDate: endDate
    }
    filter: filter ?? (!empty(resourceGroupFilter)
      ? {
          dimensions: {
            name: 'ResourceGroupName'
            operator: 'In'
            values: resourceGroupFilter
          }
        }
      : {})
    notifications: json(replace(replace(replace(string(notificationsArray), '[{', '{'), '}]', '}'), '}},{', '},'))
  }
}

@description('The name of the budget.')
output name string = budget.name

@description('The resource ID of the budget.')
output resourceId string = budget.id

@description('The subscription the budget was deployed into.')
output subscriptionName string = subscription().displayName
