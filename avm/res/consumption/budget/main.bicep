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
param contactEmails array = []

@description('Conditional. The list of contact roles to send the budget notification to when the thresholds are exceeded. Required if neither `contactEmails` nor `actionGroups` was provided.')
param contactRoles array = []

@description('Conditional. List of action group resource IDs that will receive the alert. Required if neither `contactEmails` nor `contactEmails` was provided.')
param actionGroups array = []

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@sys.description('Optional. Location deployment metadata.')
param location string = deployment().location

var notificationsArray = [for threshold in thresholds: {
  'Actual_GreaterThan_${threshold}_Percentage': {
    enabled: true
    operator: 'GreaterThan'
    threshold: threshold
    contactEmails: empty(contactEmails) ? null : array(contactEmails)
    contactRoles: empty(contactRoles) ? null : array(contactRoles)
    contactGroups: empty(actionGroups) ? null : array(actionGroups)
    thresholdType: 'Actual'
  }
}]

var notifications = json(replace(replace(replace(string(notificationsArray), '[{', '{'), '}]', '}'), '}},{', '},'))

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  location: location
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource budget 'Microsoft.Consumption/budgets@2021-10-01' = {
  name: name
  properties: {
    category: category
    amount: amount
    timeGrain: resetPeriod
    timePeriod: {
      startDate: startDate
      endDate: endDate
    }
    filter: {}
    notifications: notifications
  }
}

@description('The name of the budget.')
output name string = budget.name

@description('The resource ID of the budget.')
output resourceId string = budget.id

@description('The subscription the budget was deployed into.')
output subscriptionName string = subscription().displayName
