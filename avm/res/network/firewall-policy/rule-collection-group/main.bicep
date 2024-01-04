metadata name = 'Firewall Policy Rule Collection Groups'
metadata description = 'This module deploys a Firewall Policy Rule Collection Group.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent Firewall Policy. Required if the template is used in a standalone deployment.')
param firewallPolicyName string

@description('Required. The name of the rule collection group to deploy.')
param name string

@description('Required. Priority of the Firewall Policy Rule Collection Group resource.')
param priority int

@description('Optional. Group of Firewall Policy rule collections.')
param ruleCollections array?

resource firewallPolicy 'Microsoft.Network/firewallPolicies@2023-04-01' existing = {
  name: firewallPolicyName
}

resource ruleCollectionGroup 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2023-04-01' = {
  name: name
  parent: firewallPolicy
  properties: {
    priority: priority
    ruleCollections: ruleCollections ?? []
  }
}

@description('The name of the deployed rule collection group.')
output name string = ruleCollectionGroup.name

@description('The resource ID of the deployed rule collection group.')
output resourceId string = ruleCollectionGroup.id

@description('The resource group of the deployed rule collection group.')
output resourceGroupName string = resourceGroup().name
