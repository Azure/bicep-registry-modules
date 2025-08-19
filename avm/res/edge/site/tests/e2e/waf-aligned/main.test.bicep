targetScope = 'subscription'

metadata name = 'Using Well-Architected Framework aligned parameters'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-edge.site-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'eswaf'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-11-01' = {
  name: resourceGroupName
  location: resourceLocation
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      resourceGroupName: resourceGroupName
      location: resourceLocation
      displayName: 'Production Edge Site'
      siteDescription: 'Production edge site for region deployment'
      siteAddress: {
        city: 'New York'
        country: 'US'
        postalCode: '10001'
        stateOrProvince: 'New York'
        streetAddress1: '350 Fifth Avenue'
        streetAddress2: 'Floor 34'
      }
      labels: {
        environment: 'production'
        businessUnit: 'IT'
        costCenter: 'CC-1234'
        project: 'EdgeDeployment'
      }
    }
  }
]
