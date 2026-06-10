targetScope = 'subscription'

metadata name = 'WAF-aligned (Subscription scope)'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'rcbsubwaf'

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
    amount: 500
    contactEmails: [
      'dummy@contoso.com'
    ]
  }
}
