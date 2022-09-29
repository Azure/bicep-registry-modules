@description('Deployment Location')
param location string = 'eastus2'

// Test Case 1
module testDeploy '../main.bicep' = {
  name: 'testDeploy'
  params: {
    location: location
  }
}
