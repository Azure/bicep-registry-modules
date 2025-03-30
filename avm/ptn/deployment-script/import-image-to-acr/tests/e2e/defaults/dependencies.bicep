@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('The name of the Azure Container Registry.')
param acrName string

var tags = {
  module: 'ptn/deployment-script/import-image-to-acr'
  test: 'waf-aligned'
}

resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: acrName
  location: location
  tags: tags
  sku: {
    name: 'Standard'
  }
}

@description('The name of the created Azure Container Registry.')
output acrName string = acr.name
