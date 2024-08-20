targetScope = 'subscription'

metadata name = 'Using `thresholdType` `Forecasted`'
metadata description = 'This instance deploys the module with the minimum set of required parameters and `thresholdType` `Forecasted`.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'cbfcst'

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
      thresholdType: 'Forecasted'
    }
  }
]
