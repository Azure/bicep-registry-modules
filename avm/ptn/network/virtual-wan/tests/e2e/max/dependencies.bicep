@description('The name of the Azure Firewall Policy.')
param azureFirewallPolicyName string

@description('The name of the first virtual network.')
param virtualNetwork1Name string

@description('The location of the first virtual network.')
param virtualNetwork1Location string

@description('The name of the second virtual network.')
param virtualNetwork2Name string

@description('The location of the second virtual network.')
param virtualNetwork2Location string

resource azureFirewallPolicy 'Microsoft.Network/firewallPolicies@2024-07-01' = {
  name: azureFirewallPolicyName
  location: resourceGroup().location
  properties: {
    sku: {
      tier: 'Standard'
    }
  }
}

resource vnet1 'Microsoft.Network/virtualNetworks@2024-07-01' = {
  name: virtualNetwork1Name
  location: virtualNetwork1Location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.1.0.0/24'
      ]
    }
  }
}

resource vnet2 'Microsoft.Network/virtualNetworks@2024-07-01' = {
  name: virtualNetwork2Name
  location: virtualNetwork2Location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.2.0.0/24'
      ]
    }
  }
}

@description('The ID of the Azure Firewall Policy.')
output azureFirewallPolicyId string = azureFirewallPolicy.id

@description('The resource ID of the first virtual network.')
output virtualNetwork1Id string = vnet1.id

@description('The resource ID of the second virtual network.')
output virtualNetwork2Id string = vnet2.id
