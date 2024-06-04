@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

param acrName string

resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: acrName
  location: location
  sku: {
    name: 'Standard'
  }
}

output acrName string = acr.name
