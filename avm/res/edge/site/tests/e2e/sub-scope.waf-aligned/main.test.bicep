targetScope = 'subscription'

metadata name = 'Using subscription scope deployment'
metadata description = 'This instance deploys the module at subscription scope without requiring a resource group.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'essubwaf'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../sub-scope/main.bicep' = [
  for iteration in ['init', 'idem']: {
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      location: resourceLocation
      displayName: 'Test Edge Site'
      description: 'Test edge site for region deployment'
      siteAddress: {
        city: 'New York'
        country: 'US'
        postalCode: '10001'
        stateOrProvince: 'New York'
        streetAddress1: '350 Fifth Avenue'
        streetAddress2: 'Floor 34'
      }
      labels: {
        environment: 'test'
        businessUnit: 'IT'
        costCenter: 'CC-1234'
        project: 'EdgeDeployment'
      }
    }
  }
]
