metadata name = 'Virtual Hub Routing Intent'
metadata description = 'This module configures Routing Intent for a Virtual Hub.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Hub firewall Resource ID ')
param azureFirewallResourceId string

@description('Required. Name of the Virtual Hub')
param virtualHubName string

@description('Required. Forward Private traffic to the Azure firewall (RFC1918)')
param privateToFirewall bool

@description('Required. orward Internet traffic to the Azure firewall (0.0.0.0/0)')
param internetToFirewall bool

resource virtualHub 'Microsoft.Network/virtualHubs@2022-11-01' existing = {
  name: virtualHubName
}

resource routingintent 'Microsoft.Network/virtualHubs/routingIntent@2023-04-01' = {
  name: 'defaultRouteTable'
  parent : virtualHub
  properties: {
    routingPolicies: (internetToFirewall == true && privateToFirewall == true) ? [
      {
        name: 'PublicTraffic'
        destinations: [
          'Internet'
        ]
        nextHop: azureFirewallResourceId
      }
      {
        name: 'PrivateTraffic'
        destinations: [
          'PrivateTraffic'
        ]
        nextHop: azureFirewallResourceId
      }
    ] : (internetToFirewall == true && privateToFirewall == false) ? [
      {
        name: 'PublicTraffic'
        destinations: [
          'Internet'
        ]
        nextHop: azureFirewallResourceId
      }
    ] : (internetToFirewall == false && privateToFirewall == true) ? [
      {
        name: 'PrivateTraffic'
        destinations: [
          'PrivateTraffic'
        ]
        nextHop: azureFirewallResourceId
      }
    ]
  : null
  }
}
