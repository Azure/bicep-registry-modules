targetScope = 'subscription'

metadata name = 'Using private link service'
metadata description = 'This instance deploys the module with a private link service to test the application of an empty list of string for `groupIds`.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.privateendpoints-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'npepls'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    privateLinkServiceName: 'dep-${namePrefix}-pls-${serviceShort}'
    loadbalancerName: 'dep-${namePrefix}-lb-${serviceShort}'
    location: resourceLocation
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      location: resourceLocation
      subnetResourceId: nestedDependencies.outputs.subnetResourceId
      ipConfigurations: [
        {
          name: 'myIPconfig'
          properties: {
            groupId: ''
            memberName: ''
            privateIPAddress: '10.0.0.10'
          }
        }
      ]
      privateLinkServiceConnections: [
        {
          name: '${namePrefix}${serviceShort}001'
          properties: {
            privateLinkServiceId: nestedDependencies.outputs.privateLinkServiceResourceId
            groupIds: []
          }
        }
      ]
    }
  }
]
