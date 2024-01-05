@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Optional. The location to deploy the first App Service Plan to.')
param location01 string

@description('Optional. The location to deploy the second App Service Plan to.')
param location02 string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

resource serverFarm01 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: serverFarmName01
  location: location01
  sku: {
    name: 'S1'
    tier: 'Standard'
    size: 'S1'
    family: 'S'
    capacity: 1
  }
  properties: {}
}

resource serverFarm02 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: serverFarmName02
  location: location02
  sku: {
    name: 'S1'
    tier: 'Standard'
    size: 'S1'
    family: 'S'
    capacity: 1
  }
  properties: {}
}

resource webApp01 'Microsoft.Web/sites@2022-09-01' = {
  name: webApp01Name
  location: location01
  kind: 'app'
  properties: {
    serverFarmId: serverFarm01.id
  }
}

resource webApp02 'Microsoft.Web/sites@2022-09-01' = {
  name: webApp02Name
  location: location02
  kind: 'app'
  properties: {
    serverFarmId: serverFarm02.id
  }
}

@description('Required. The name of the first App Service Plan to create.')
param serverFarmName01 string

@description('Required. The name of the second App Service Plan to create.')
param serverFarmName02 string

@description('Required. The name of the first Web Applicaton to create.')
param webApp01Name string

@description('Required. The name of the second Web Applicaton to create.')
param webApp02Name string

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the first created Web Application')
output webApp01ResourceId string = webApp01.id

@description('The resource ID of the second created Web Application')
output webApp02ResourceId string = webApp02.id
