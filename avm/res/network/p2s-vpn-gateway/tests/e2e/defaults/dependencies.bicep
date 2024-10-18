@description('Required. The name of the virtual WAN to create.')
param virtualWANName string

@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

resource virtualWan 'Microsoft.Network/virtualWans@2024-01-01' = {
  name: virtualWANName
  location: location
}

resource vpnServerConfiguration 'Microsoft.Network/vpnServerConfigurations@2024-01-01' = {
  name: '${virtualWANName}-${location}-vpnServerConfiguration'
  location: location
  properties: {
    name: '${virtualWANName}-${location}-VPNConfig'
    vpnAuthenticationTypes: [
      'AAD'
    ]
    vpnProtocols: [
      'OpenVPN'
    ]
  }
}

resource virtualHub 'Microsoft.Network/virtualHubs@2024-01-01' = {
  name: '${virtualWANName}-${location}-hub'
  location: location
  properties: {
    addressPrefix: '10.0.0.0/23'
    virtualWan: {
      id: virtualWan.id
    }
  }
}

@description('The resource ID of the created Virtual WAN.')
output virtualWANResourceId string = virtualWan.id

@description('The name of the created Virtual WAN.')
output virtualWANName string = virtualWan.name

@description('The resource ID of the created Virtual Hub.')
output virtualHubResourceId string = virtualHub.id

@description('The name of the created Virtual Hub.')
output virtualHubName string = virtualHub.name

@description('The resource ID of the created VPN Server Configuration.')
output vpnServerConfigurationResourceId string = vpnServerConfiguration.id

@description('The name of the created VPN Server Configuration.')
output vpnServerConfigurationName string = vpnServerConfiguration.name
