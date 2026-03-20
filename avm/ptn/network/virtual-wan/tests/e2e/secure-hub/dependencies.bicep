@description('The name of the Azure Firewall Policy.')
param azureFirewallPolicyName string

resource azureFirewallPolicy 'Microsoft.Network/firewallPolicies@2024-10-01' = {
  name: azureFirewallPolicyName
  location: resourceGroup().location
  properties: {
    sku: {
      tier: 'Standard'
    }
  }
}

@description('The ID of the Azure Firewall Policy.')
output azureFirewallPolicyId string = azureFirewallPolicy.id
