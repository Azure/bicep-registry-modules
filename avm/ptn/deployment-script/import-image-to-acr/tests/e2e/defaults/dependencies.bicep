@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('The name of the Azure Container Registry.')
param acrName string

resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: acrName
  location: location
  sku: {
    name: 'Standard'
  }
}

@description('The name of the created Azure Container Registry.')
output acrName string = acr.name
