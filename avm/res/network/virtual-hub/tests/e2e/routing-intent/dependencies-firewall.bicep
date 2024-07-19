@description('Optional. The name of the Azure Firewall to create.')
param azureFirewallName string

@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

param virtualHubResourceId string

resource firewallPolicy 'Microsoft.Network/firewallPolicies@2023-11-01' = {
  name: 'azureFirewallPolicy'
  location: location
  properties: {
    threatIntelMode: 'Alert'
  }
}

resource azureFirewall 'Microsoft.Network/azureFirewalls@2023-04-01' = {
  name: azureFirewallName
  location: location
  properties: {
    sku: {
      name: 'AZFW_Hub'
      tier: 'Premium'
    }
    hubIPAddresses: {
      publicIPs: {
        count: 1
      }
    }
    firewallPolicy: {
      id: firewallPolicy.id
    }
    virtualHub: {
      id: virtualHubResourceId
    }
  }
}

@description('The resource ID of the created Azure Firewall Policy')
output firewallPolicy string = firewallPolicy.id

@description('The resource ID of the created Azure Firewall')
output azureFirewallResourceId string = azureFirewall.id
