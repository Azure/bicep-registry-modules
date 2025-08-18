targetScope = 'subscription'

metadata name = 'Using subscription scope deployment'
metadata description = 'This instance deploys the module at subscription scope without requiring a resource group.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'essub'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// ============== //
// Test Execution //
// ============== //

// Create a resource group for the Edge Site
resource testResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: '${namePrefix}${serviceShort}-rg'
  location: resourceLocation
}

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      location: resourceLocation
      deploymentScope: 'subscription'
      displayName: 'Subscription-Scoped Edge Site'
      siteDescription: 'Edge site deployed at subscription scope'
      siteAddress: {
        country: 'United States'
      }
      labels: {
        environment: 'test'
        deploymentScope: 'subscription'
        region: 'west-us'
      }
    }
  }
]
