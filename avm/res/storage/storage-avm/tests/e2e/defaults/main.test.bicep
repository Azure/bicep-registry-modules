targetScope = 'resourceGroup'

metadata name = 'Storage Account - Default Deployment Test'
metadata description = 'Tests the Storage Account module with default parameters'

@description('Location for test resources')
param location string = resourceGroup().location

// Test the module with default parameters
module testDefault '../../../main.bicep' = {
  name: '${uniqueString(deployment().name)}-test-default'
  params: {
    name: 'stg${uniqueString(resourceGroup().id)}'
    location: location
    sku: 'Standard_LRS'
    kind: 'StorageV2'
    accessTier: 'Hot'
    httpsOnly: true
    tags: {
      environment: 'test'
      scenario: 'defaults'
    }
  }
}

@description('Storage Account resource ID')
output resourceId string = testDefault.outputs.resourceId

@description('Storage Account name')
output name string = testDefault.outputs.name

@description('Primary blob endpoint')
output primaryBlobEndpoint string = testDefault.outputs.primaryBlobEndpoint
