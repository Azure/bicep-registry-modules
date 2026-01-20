targetScope = 'resourceGroup'

metadata name = 'Storage Account - Maximum Features Test'
metadata description = 'Tests the Storage Account module with maximum configuration options'

@description('Location for test resources')
param location string = resourceGroup().location

// Test the module with maximum features
module testMax '../../../main.bicep' = {
  name: '${uniqueString(deployment().name)}-test-max'
  params: {
    name: 'stgmax${uniqueString(resourceGroup().id)}'
    location: location
    sku: 'Standard_GRS'
    kind: 'StorageV2'
    accessTier: 'Cool'
    httpsOnly: true
    publicNetworkAccess: 'Enabled'
    tags: {
      environment: 'production'
      scenario: 'max'
      owner: 'avm-team'
      costCenter: '12345'
    }
  }
}

@description('Storage Account resource ID')
output resourceId string = testMax.outputs.resourceId

@description('Storage Account name')
output name string = testMax.outputs.name

@description('Primary blob endpoint')
output primaryBlobEndpoint string = testMax.outputs.primaryBlobEndpoint

@description('Storage Account location')
output location string = testMax.outputs.location
