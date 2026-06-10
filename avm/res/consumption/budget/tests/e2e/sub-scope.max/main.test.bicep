targetScope = 'subscription'

metadata name = 'Using large parameter set (Subscription scope)'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'rcbsubmax'

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
    thresholdType: 'Forecasted'
    contactEmails: [
      'dummy@contoso.com'
    ]
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
