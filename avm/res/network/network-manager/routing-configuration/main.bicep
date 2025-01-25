metadata name = 'Network Manager Routing Configurations'
metadata description = '''This module deploys an Network Manager Routing Configuration.
Routing configurations are the building blocks of UDR management. They're used to describe the desired routing behavior for a network group.'''

@sys.description('Conditional. The name of the parent network manager. Required if the template is used in a standalone deployment.')
param networkManagerName string

@maxLength(64)
@sys.description('Required. The name of the routing configuration.')
param name string

@maxLength(500)
@sys.description('Optional. A description of the routing configuration.')
param description string = ''

@sys.description('Optional. A routing configuration contains a set of rule collections that are applied to network groups. Each rule collection contains one or more routing rules.')
param ruleCollections routingConfigurationRuleCollectionType

resource networkManager 'Microsoft.Network/networkManagers@2024-05-01' existing = {
  name: networkManagerName
}

resource routingConfigurations 'Microsoft.Network/networkManagers/routingConfigurations@2024-05-01' = {
  name: name
  parent: networkManager
  properties: {
    description: description
  }
}

module routingConfigurations_ruleCollections 'rule-collection/main.bicep' = [
  for (ruleCollection, index) in ruleCollections ?? []: {
    name: '${uniqueString(deployment().name)}-RoutingConfigurations-RuleCollections-${index}'
    params: {
      networkManagerName: networkManager.name
      routingConfigurationName: routingConfigurations.name
      name: ruleCollection.name
      description: ruleCollection.?description
      appliesTo: ruleCollection.appliesTo
      disableBgpRoutePropagation: ruleCollection.?disableBgpRoutePropagation
      rules: ruleCollection.?rules ?? []
    }
  }
]

@sys.description('The name of the deployed routing configuration.')
output name string = routingConfigurations.name

@sys.description('The resource ID of the deployed routing configuration.')
output resourceId string = routingConfigurations.id

@sys.description('The resource group the routing configuration was deployed into.')
output resourceGroupName string = resourceGroup().name

// =============== //
//   Definitions   //
// =============== //

import { appliesToType, rulesType } from 'rule-collection/main.bicep'
@export()
type routingConfigurationRuleCollectionType = {
  @sys.description('Required. The name of the rule collection.')
  name: string

  @sys.description('Optional. A description of the rule collection.')
  description: string?

  @sys.description('Required. List of network groups for configuration. A routing rule collection must be associated to at least one network group.')
  appliesTo: appliesToType

  @sys.description('Optional. Disables BGP route propagation for the rule collection. Defaults to true.')
  disableBgpRoutePropagation: bool?

  @sys.description('Optional. List of rules for the routing rules collection. Warning: A rule collection without a rule will cause a deployment of routing configuration to fail in network manager.')
  rules: rulesType?
}[]?
