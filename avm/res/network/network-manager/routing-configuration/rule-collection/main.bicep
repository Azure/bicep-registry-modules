metadata name = 'Network Manager Routing Configuration Rule Collections'
metadata description = '''This module deploys an Network Manager Routing Configuration Rule Collection.
Routing configurations are the building blocks of UDR management. They're used to describe the desired routing behavior for a network group. Each routing configuration contains one ore more rule collections. Warning: A rule collection without a rule will cause a deployment of routing configuration to fail in network manager.'''

@sys.description('Conditional. The name of the parent network manager. Required if the template is used in a standalone deployment.')
param networkManagerName string

@sys.description('Conditional. The name of the parent Routing Configuration. Required if the template is used in a standalone deployment.')
param routingConfigurationName string

@maxLength(64)
@sys.description('Required. The name of the routing rule collection.')
param name string

@maxLength(500)
@sys.description('Optional. A description of the routing rule collection.')
param description string = ''

@sys.description('Required. List of network groups for configuration. A routing rule collection must be associated to at least one network group.')
param appliesTo appliesToType

@sys.description('Optional. Determines whether BGP route propagation is enabled for the routing rule collection. Defaults to true.')
param disableBgpRoutePropagation bool = true

@sys.description('Optional. List of rules for the routing rules collection. Warning: A rule collection without a rule will cause a deployment of routing configuration to fail in network manager.')
param rules rulesType

resource networkManager 'Microsoft.Network/networkManagers@2024-05-01' existing = {
  name: networkManagerName

  resource routingConfiguration 'routingConfigurations' existing = {
    name: routingConfigurationName
  }
}

resource ruleCollection 'Microsoft.Network/networkManagers/routingConfigurations/ruleCollections@2024-05-01' = {
  name: name
  parent: networkManager::routingConfiguration
  properties: {
    description: description
    appliesTo: map(appliesTo, (group) => {
      networkGroupId: any(group.networkGroupResourceId)
    })
    disableBgpRoutePropagation: string(disableBgpRoutePropagation)
  }
}

module ruleCollection_rules 'rule/main.bicep' = [
  for (rule, index) in rules ?? []: {
    name: '${uniqueString(deployment().name)}-RuleCollections-Rules-${index}'
    params: {
      networkManagerName: networkManager.name
      routingConfigurationName: routingConfigurationName
      ruleCollectionName: ruleCollection.name
      name: rule.name
      description: rule.?description
      destination: rule.destination
      nextHop: rule.nextHop
    }
  }
]

@sys.description('The name of the deployed routing rule collection.')
output name string = ruleCollection.name

@sys.description('The resource ID of the deployed routing rule collection.')
output resourceId string = ruleCollection.id

@sys.description('The resource group the routing rule collection was deployed into.')
output resourceGroupName string = resourceGroup().name

// =============== //
//   Definitions   //
// =============== //

@export()
type appliesToType = {
  @sys.description('Required. The resource ID of the network group.')
  networkGroupResourceId: string
}[]

import { destinationType, nextHopType } from 'rule/main.bicep'
@export()
type rulesType = {
  @sys.description('Required. The name of the rule.')
  name: string

  @sys.description('Optional. A description of the rule.')
  description: string?

  @sys.description('Required. The destination can be IP addresses or Service Tag for this route. Address Prefixes are defined using the CIDR format, while Service tags are predefined identifiers that represent a category of IP addresses, which are managed by Azure.')
  destination: destinationType

  @sys.description('Required. The next hop handles the matching packets for this route. It can be the virtual network, the virtual network gateway, the internet, a virtual appliance, or none. Virtual network gateways cannot be used if the address prefix is IPv6. If the next hop type is VirtualAppliance, the next hop address must be specified.')
  nextHop: nextHopType
}[]?
