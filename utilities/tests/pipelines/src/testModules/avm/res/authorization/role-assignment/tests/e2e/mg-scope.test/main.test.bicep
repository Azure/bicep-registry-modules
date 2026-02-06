targetScope = 'subscription'

metadata name = 'Test case name'
metadata description = 'This file deploys the module with some example parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'test'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../sub-scope/main.bicep' = [
  for iteration in ['init', 'idem']: {
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${iteration}'
    params: {
      requiredParam: '${serviceShort}-${namePrefix}'
      optionalParam: 'opt'
    }
  }
]
