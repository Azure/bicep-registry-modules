@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Virtual WAN to create.')
param virtualWanName string

@description('Required. The name of the Virtual Hub to create.')
param virtualHubName string

@description('Required. The name of the Public IP to create.')
param publicIPName string

resource virtualWan 'Microsoft.Network/virtualWans@2024-05-01' = {
  name: virtualWanName
  location: location
  properties: {
    disableVpnEncryption: false
    allowBranchToBranchTraffic: true
    type: 'Standard'
  }
}

resource virtualHub 'Microsoft.Network/virtualHubs@2024-05-01' = {
  name: virtualHubName
  location: location
  properties: {
    addressPrefix: '10.1.0.0/16'
    virtualWan: {
      id: virtualWan.id
    }
  }
}

resource publicIP 'Microsoft.Network/publicIPAddresses@2024-05-01' = {
  name: publicIPName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
  zones: [
    '1'
    '2'
    '3'
  ]
}

@description('The resource ID of the created Virtual Hub.')
output virtualHubResourceId string = virtualHub.id

@description('The resource ID of the created Public IP.')
output publicIPResourceId string = publicIP.id
