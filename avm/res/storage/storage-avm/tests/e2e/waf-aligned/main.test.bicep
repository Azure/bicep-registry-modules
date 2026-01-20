targetScope = 'resourceGroup'

metadata name = 'Storage Account - WAF Aligned Deployment Test'
metadata description = 'Tests the Storage Account module with Well-Architected Framework (WAF) aligned best practices'

@description('Location for test resources')
param location string = resourceGroup().location

// Test the module with WAF-aligned configuration
module testWafAligned '../../../main.bicep' = {
  name: '${uniqueString(deployment().name)}-test-waf'
  params: {
    name: 'stgwaf${uniqueString(resourceGroup().id)}'
    location: location
    sku: 'Standard_ZRS'  // Zone-redundant for high availability
    kind: 'StorageV2'
    accessTier: 'Hot'
    httpsOnly: true      // Security best practice
    publicNetworkAccess: 'Disabled'  // Security best practice
    tags: {
      environment: 'production'
      scenario: 'waf-aligned'
      owner: 'cloud-architecture'
      businessUnit: 'engineering'
      workload: 'data-storage'
    }
  }
}

@description('Storage Account resource ID')
output resourceId string = testWafAligned.outputs.resourceId

@description('Storage Account name')
output name string = testWafAligned.outputs.name

@description('Primary blob endpoint')
output primaryBlobEndpoint string = testWafAligned.outputs.primaryBlobEndpoint

@description('Storage Account location')
output location string = testWafAligned.outputs.location
