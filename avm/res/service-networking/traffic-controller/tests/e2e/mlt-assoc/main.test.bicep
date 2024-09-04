targetScope = 'subscription'

metadata name = 'Using multiple associations'
metadata description = 'This instance deploys the module with multiple associations.'
metadata note = 'Please note that this test is not idempotent. When deploying multiple associations, the deployment will fail on the second deployment attempt.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-servicenetworking-trafficcontrollers-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'sntcma'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    location: resourceLocation
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
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
      frontends: [
        {
          name: 'frontend1'
        }
        {
          name: 'frontend2'
        }
      ]
      associations: [
        {
          name: 'association1'
          subnetResourceId: nestedDependencies.outputs.defaultSubnetResourceId
        }
        {
          name: 'association2'
          subnetResourceId: nestedDependencies.outputs.customSubnetResourceId
        }
        {
          name: 'association3'
          subnetResourceId: nestedDependencies.outputs.customSubnet2ResourceId
        }
      ]
    }
  }
]
