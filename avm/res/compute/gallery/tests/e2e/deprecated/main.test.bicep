targetScope = 'subscription'

metadata name = 'Using deprecated parameters'
metadata description = 'This instance deploys the module with deprecated parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-compute.galleries-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'cgdep'

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
      images: [
        {
          name: '${namePrefix}-az-imgd-us-001'
          hyperVGeneration: 'V2'
          maxRecommendedMemory: 32
          maxRecommendedvCPUs: 4
          minRecommendedMemory: 4
          minRecommendedvCPUs: 1
          isAcceleratedNetworkSupported: true
          offer: '0001-com-ubuntu-server-focal'
          osState: 'Generalized'
          osType: 'Linux'
          publisher: 'canonical'
          sku: '20_04-lts-gen2'
        }
        // {
        //   name: '${namePrefix}-az-imgd-ws-001'
        //   offer: 'WindowsServer'
        //   osType: 'Windows'
        //   publisher: 'MicrosoftWindowsServer'
        //   sku: '2022-datacenter-azure-edition'
        // }
      ]
    }
  }
]
