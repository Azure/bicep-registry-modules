@description('Required. The name of the virtual WAN to create.')
param virtualWANName string

@description('Required. The name of the virtual Hub to create.')
param virtualHubName string

@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

resource virtualWan 'Microsoft.Network/virtualWans@2023-04-01' = {
  name: virtualWANName
  location: location
}

resource virtualHub 'Microsoft.Network/virtualHubs@2023-04-01' = {
  name: virtualHubName
  location: location
  properties: {
    addressPrefix: '10.0.0.0/16'
    virtualWan: {
      id: virtualWan.id
    }
  }
}

@description('The resource ID of the created Virtual Hub.')
output virtualHubResourceId string = virtualHub.id

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId
