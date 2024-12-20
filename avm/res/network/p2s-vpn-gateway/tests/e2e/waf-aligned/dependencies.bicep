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
    aadAuthenticationParameters: {
      aadAudience: '11111111-1234-4321-1234-111111111111'
      aadIssuer: 'https://sts.windows.net/11111111-1111-1111-1111-111111111111/'
      aadTenant: 'https://login.microsoftonline.com/11111111-1111-1111-1111-111111111111'
    }
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

resource azureFirewall 'Microsoft.Network/azureFirewalls@2024-01-01' = {
  name: '${virtualWANName}-${location}-hub'
  location: location
  properties: {
    sku: {
      name: 'AZFW_Hub'
      tier: 'Premium'
    }
    virtualHub: {
      id: virtualHub.id
    }
    hubIPAddresses: {
      publicIPs: {
        count: 1
      }
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

@description('The resource ID of the created hub Azure Firewall')
output azureFirewallResourceId string = azureFirewall.id

@description('The name of the created hub Azure Firewall')
output azureFirewallName string = azureFirewall.name
