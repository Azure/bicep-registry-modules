@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Server Farm to create.')
param serverFarmName string

resource serverFarm 'Microsoft.Web/serverfarms@2025-03-01' = {
  name: serverFarmName
  location: location
  sku: {
    name: 'P1v2'
    tier: 'PremiumV2'
    size: 'P1v2'
    family: 'Pv2'
    capacity: 1
  }
  properties: {}
}

@description('The resource ID of the created Server Farm.')
output serverFarmResourceId string = serverFarm.id
