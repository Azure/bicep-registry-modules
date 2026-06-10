targetScope = 'managementGroup'

metadata name = 'Using only defaults (Management Group scope)'
metadata description = 'This instance deploys the module with the minimum set of required parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'rcbmgmin'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. The name of the budget. Includes a date-based suffix so a re-run in a new month creates a new budget instead of failing to update the immutable start date of a leftover budget.')
param budgetName string = '${namePrefix}${serviceShort}${utcNow('yyMM')}'

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../mg-scope/main.bicep' = {
  name: '${uniqueString(deployment().name)}-test-${serviceShort}'
  params: {
    name: budgetName
    amount: 500
    contactEmails: [
      'dummy@contoso.com'
    ]
  }
}
