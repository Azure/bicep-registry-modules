targetScope = 'subscription'

metadata name = 'Using custom notifications (Subscription scope)'
metadata description = 'This instance deploys the module using per-threshold notification control with mixed actual and forecasted notifications.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'rcbsubnot'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. The name of the budget. Includes a date-based suffix so a re-run in a new month creates a new budget instead of failing to update the immutable start date of a leftover budget.')
param budgetName string = '${namePrefix}${serviceShort}${utcNow('yyMM')}'

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../sub-scope/main.bicep' = {
  name: '${uniqueString(deployment().name)}-test-${serviceShort}'
  params: {
    name: budgetName
    location: resourceLocation
    amount: 500
    contactEmails: [
      'dummy@contoso.com'
    ]
    notifications: [
      {
        operator: 'GreaterThan'
        threshold: 75
        thresholdType: 'Actual'
      }
      {
        operator: 'GreaterThanOrEqualTo'
        threshold: 100
        thresholdType: 'Forecasted'
      }
    ]
  }
}
