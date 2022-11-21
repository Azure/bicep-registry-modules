@description('Deployment Location')
param location string = resourceGroup().location

module noDeployment '../main.bicep' = {
  name: 'NoResources'
  params: {
    location: location
  }
}
