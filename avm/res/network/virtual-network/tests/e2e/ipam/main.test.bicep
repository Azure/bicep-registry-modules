targetScope = 'subscription'

metadata name = 'Using IPAM Pool Prefix Allocations'
metadata description = 'This instance deploys the module with IP Addresses allocated from the IPAM Pool'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.virtualnetworks-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nvnipam'

@description('Optional. A token to inject into the name of each resource.')
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
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  scope: resourceGroup
  params: {
    location: resourceLocation
    networkManagerName: 'dep-${namePrefix}-vnm-${serviceShort}'
    addressPrefixes: [
      '172.16.0.0/22'
    ]
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
      addressPrefixes: [
        nestedDependencies.outputs.networkManagerIpamPoolId
      ]
      ipamPoolNumberOfIpAddresses: '254'
      subnets: [
        {
          name: 'subnet-1'
          ipamPoolPrefixAllocations: [
            {
              pool: {
                id: nestedDependencies.outputs.networkManagerIpamPoolId
              }
              numberOfIpAddresses: '64'
            }
          ]
        }
        {
          name: 'subnet-2'
          ipamPoolPrefixAllocations: [
            {
              pool: {
                id: nestedDependencies.outputs.networkManagerIpamPoolId
              }
              numberOfIpAddresses: '16'
            }
          ]
        }
        {
          name: 'subnet-3'
          ipamPoolPrefixAllocations: [
            {
              pool: {
                id: nestedDependencies.outputs.networkManagerIpamPoolId
              }
              numberOfIpAddresses: '8'
            }
          ]
        }
      ]
    }
  }
]
