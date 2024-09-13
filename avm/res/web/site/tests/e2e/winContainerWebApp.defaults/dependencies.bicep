@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Server Farm to create.')
param serverFarmName string

resource serverFarm 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: serverFarmName
  location: location
  kind: 'windows'
  sku: {
    name: 'P1v3'
    tier: 'Premium'
    size: 'P1'
    family: 'P'
    capacity: 1
  }
  properties: {
    hyperV: true
  }
}

@description('The resource ID of the created Server Farm.')
output serverFarmResourceId string = serverFarm.id
