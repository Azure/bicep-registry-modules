metadata name = 'Network Manager Security Admin Configurations'
metadata description = '''This module deploys an Network Manager Security Admin Configuration.
A security admin configuration contains a set of rule collections. Each rule collection contains one or more security admin rules.'''

@sys.description('Conditional. The name of the parent network manager. Required if the template is used in a standalone deployment.')
param networkManagerName string

@maxLength(64)
@sys.description('Required. The name of the security admin configuration.')
param name string

@maxLength(500)
@sys.description('Optional. A description of the security admin configuration.')
param description string = ''

@sys.description('Required. Enum list of network intent policy based services.')
param applyOnNetworkIntentPolicyBasedServices applyOnNetworkIntentPolicyBasedServicesType

@allowed([
  'None'
  'Manual'
])
@sys.description('Optional. Determine update behavior for changes to network groups referenced within the rules in this configuration.')
param networkGroupAddressSpaceAggregationOption string = 'None'

@sys.description('Optional. A security admin configuration contains a set of rule collections that are applied to network groups. Each rule collection contains one or more security admin rules.')
param ruleCollections securityAdminConfigurationRuleCollectionType

resource networkManager 'Microsoft.Network/networkManagers@2024-05-01' existing = {
  name: networkManagerName
}

resource securityAdminConfigurations 'Microsoft.Network/networkManagers/securityAdminConfigurations@2024-05-01' = {
  name: name
  parent: networkManager
  properties: {
    description: description
    applyOnNetworkIntentPolicyBasedServices: applyOnNetworkIntentPolicyBasedServices
    networkGroupAddressSpaceAggregationOption: networkGroupAddressSpaceAggregationOption
  }
}

module securityAdminConfigurations_ruleCollections 'rule-collection/main.bicep' = [
  for (ruleCollection, index) in ruleCollections ?? []: {
    name: '${uniqueString(deployment().name)}-SecurityAdminConfigurations-RuleCollections-${index}'
    params: {
      networkManagerName: networkManager.name
      securityAdminConfigurationName: securityAdminConfigurations.name
      name: ruleCollection.name
      description: ruleCollection.?description
      appliesToGroups: ruleCollection.appliesToGroups
      rules: ruleCollection.?rules ?? []
    }
  }
]

@sys.description('The name of the deployed security admin configuration.')
output name string = securityAdminConfigurations.name

@sys.description('The resource ID of the deployed security admin configuration.')
output resourceId string = securityAdminConfigurations.id

@sys.description('The resource group the security admin configuration was deployed into.')
output resourceGroupName string = resourceGroup().name

// =============== //
//   Definitions   //
// =============== //

@export()
type applyOnNetworkIntentPolicyBasedServicesType = ('None' | 'All' | 'AllowRulesOnly')[]

import { appliesToGroupsType, rulesType } from './rule-collection/main.bicep'
@export()
type securityAdminConfigurationRuleCollectionType = {
  @sys.description('Required. The name of the admin rule collection.')
  name: string

  @sys.description('Optional. A description of the admin rule collection.')
  description: string?

  @sys.description('Required. List of network groups for configuration. An admin rule collection must be associated to at least one network group.')
  appliesToGroups: appliesToGroupsType

  @sys.description('Optional. List of rules for the admin rules collection. Security admin rules allows enforcing security policy criteria that matches the conditions set. Warning: A rule collection without rule will cause a deployment configuration for security admin goal state in network manager to fail.')
  rules: rulesType?
}[]?
