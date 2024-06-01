metadata name = 'Network Manager Security Admin Configuration Rule Collections'
metadata description = '''This module deploys an Network Manager Security Admin Configuration Rule Collection.
A security admin configuration contains a set of rule collections. Each rule collection contains one or more security admin rules. Security admin rules allows enforcing security policy criteria that matches the conditions set. Warning: A rule collection without rule will cause a deployment configuration for security admin goal state in network manager to fail.'''
metadata owner = 'Azure/module-maintainers'

@sys.description('Conditional. The name of the parent network manager. Required if the template is used in a standalone deployment.')
param networkManagerName string

@sys.description('Conditional. The name of the parent security admin configuration. Required if the template is used in a standalone deployment.')
param securityAdminConfigurationName string

@maxLength(64)
@sys.description('Required. The name of the admin rule collection.')
param name string

@maxLength(500)
@sys.description('Optional. A description of the admin rule collection.')
param description string?

@sys.description('Required. List of network groups for configuration. An admin rule collection must be associated to at least one network group.')
param appliesToGroups appliesToGroupsType

@sys.description('Optional. List of rules for the admin rules collection. Security admin rules allows enforcing security policy criteria that matches the conditions set. Warning: A rule collection without rule will cause a deployment configuration for security admin goal state in network manager to fail.')
param rules rulesType

resource networkManager 'Microsoft.Network/networkManagers@2023-04-01' existing = {
  name: networkManagerName

  resource securityAdminConfiguration 'securityAdminConfigurations@2023-04-01' existing = {
    name: securityAdminConfigurationName
  }
}

resource ruleCollection 'Microsoft.Network/networkManagers/securityAdminConfigurations/ruleCollections@2023-04-01' = {
  name: name
  parent: networkManager::securityAdminConfiguration
  properties: {
    description: description ?? ''
    appliesToGroups: map(appliesToGroups, (group) => {
      networkGroupId: any(group.networkGroupResourceId)
    })
  }
}

module securityAdminConfigurations_rules 'rule/main.bicep' = [
  for (rule, index) in rules ?? []: {
    name: '${uniqueString(deployment().name)}-RuleCollections-Rules-${index}'
    params: {
      networkManagerName: networkManager.name
      securityAdminConfigurationName: securityAdminConfigurationName
      ruleCollectionName: ruleCollection.name
      name: rule.name
      access: rule.access
      description: rule.?description ?? ''
      destinationPortRanges: rule.?destinationPortRanges ?? []
      destinations: rule.?destinations ?? []
      direction: rule.direction
      priority: rule.priority
      protocol: rule.protocol
      sourcePortRanges: rule.?sourcePortRanges ?? []
      sources: rule.?sources ?? []
    }
  }
]

@sys.description('The name of the deployed admin rule collection.')
output name string = ruleCollection.name

@sys.description('The resource ID of the deployed admin rule collection.')
output resourceId string = ruleCollection.id

@sys.description('The resource group the admin rule collection was deployed into.')
output resourceGroupName string = resourceGroup().name

// =============== //
//   Definitions   //
// =============== //

type appliesToGroupsType = {
  @sys.description('Required. The resource ID of the network group.')
  networkGroupResourceId: string
}[]

type rulesType = {
  @sys.description('Required. The name of the rule.')
  name: string

  @sys.description('Required. Indicates the access allowed for this particular rule. "Allow" means traffic matching this rule will be allowed. "Deny" means traffic matching this rule will be blocked. "AlwaysAllow" means that traffic matching this rule will be allowed regardless of other rules with lower priority or user-defined NSGs.')
  access: 'Allow' | 'AlwaysAllow' | 'Deny'

  @sys.description('Optional. A description of the rule.')
  description: string?

  @sys.description('Optional. List of destination port ranges. This specifies on which ports traffic will be allowed or denied by this rule. Provide an (*) to allow traffic on any port. Port ranges are between 1-65535.')
  destinationPortRanges: string[]?

  @sys.description('Optional. The destnations filter can be an IP Address or a service tag. Each filter contains the properties AddressPrefixType (IPPrefix or ServiceTag) and AddressPrefix (using CIDR notation (e.g. 192.168.99.0/24 or 2001:1234::/64) or a service tag (e.g. AppService.WestEurope)). Combining CIDR and Service tags in one rule filter is not permitted.')
  destinations: {
    @sys.description('Required. Address prefix type.')
    addressPrefixType: 'IPPrefix' | 'ServiceTag'

    @sys.description('Required. Address prefix.')
    addressPrefix: string
  }[]?

  @sys.description('Required. Indicates if the traffic matched against the rule in inbound or outbound.')
  direction: 'Inbound' | 'Outbound'

  @minValue(1)
  @maxValue(4096)
  @sys.description('Required. The priority of the rule. The value can be between 1 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule.')
  priority: int

  @sys.description('Required. Network protocol this rule applies to.')
  protocol: 'Ah' | 'Any' | 'Esp' | 'Icmp' | 'Tcp' | 'Udp'

  @sys.description('Optional. List of destination port ranges. This specifies on which ports traffic will be allowed or denied by this rule. Provide an (*) to allow traffic on any port. Port ranges are between 1-65535.')
  sourcePortRanges: string[]?

  @sys.description('Optional. The source filter can be an IP Address or a service tag. Each filter contains the properties AddressPrefixType (IPPrefix or ServiceTag) and AddressPrefix (using CIDR notation (e.g. 192.168.99.0/24 or 2001:1234::/64) or a service tag (e.g. AppService.WestEurope)). Combining CIDR and Service tags in one rule filter is not permitted.')
  sources: {
    @sys.description('Required. Address prefix type.')
    addressPrefixType: 'IPPrefix' | 'ServiceTag'

    @sys.description('Required. Address prefix.')
    addressPrefix: string
  }[]?
}[]?
