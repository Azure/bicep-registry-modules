targetScope = 'managementGroup'

metadata name = 'Using large parameter set (Management Group scope)'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'rcbmgmax'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../mg-scope/main.bicep' = {
  name: '${uniqueString(deployment().name)}-test-${serviceShort}'
  params: {
    name: '${namePrefix}${serviceShort}001'
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
