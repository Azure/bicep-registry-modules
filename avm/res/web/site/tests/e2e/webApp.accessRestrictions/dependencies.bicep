@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the App Service Plan to create.')
param serverFarmName string

// ============== //
// Resources      //
// ============== //

resource serverFarm 'Microsoft.Web/serverfarms@2025-03-01' = {
  name: serverFarmName
  location: location
  sku: {
    name: 'S1'
    tier: 'Standard'
    size: 'S1'
    family: 'S'
    capacity: 1
  }
  properties: {
    reserved: false
  }
}

@description('The resource ID of the created App Service Plan.')
output serverFarmResourceId string = serverFarm.id
