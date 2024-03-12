metadata name = 'Dns Forwarding Rulesets Virtual Network Links'
metadata description = 'This template deploys Virtual Network Link in a Dns Forwarding Ruleset.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent DNS Fowarding Rule Set. Required if the template is used in a standalone deployment.')
param dnsForwardingRulesetName string

@description('Optional. The name of the virtual network link.')
param name string?

@description('Required. Link to another virtual network resource ID.')
param virtualNetworkResourceId string

@description('Optional. Metadata attached to the forwarding rule.')
param metadata object?

resource dnsForwardingRuleset 'Microsoft.Network/dnsForwardingRulesets@2022-07-01' existing = {
  name: dnsForwardingRulesetName
}

resource virtualNetworkLink 'Microsoft.Network/dnsForwardingRulesets/virtualNetworkLinks@2022-07-01' = {
  name: name ?? '${last(split(virtualNetworkResourceId, '/'))}-vnetlink'
  parent: dnsForwardingRuleset
  properties: {
    virtualNetwork: {
      id: virtualNetworkResourceId
    }
    metadata: metadata
  }
}

@description('The name of the deployed virtual network link.')
output name string = virtualNetworkLink.name

@description('The resource ID of the deployed virtual network link.')
output resourceId string = virtualNetworkLink.id

@description('The resource group of the deployed virtual network link.')
output resourceGroupName string = resourceGroup().name
