targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'cbmax'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    name: '${uniqueString(deployment().name)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      location: resourceLocation
      amount: 500
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
]
