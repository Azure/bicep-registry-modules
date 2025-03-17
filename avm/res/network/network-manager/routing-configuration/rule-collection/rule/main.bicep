metadata name = 'Network Manager Routing configuration Rule Collection Rules'
metadata description = '''This module deploys an Azure Virtual Network Manager (AVNM) Routing Configuration Rule Collection Rule.
A Routing configuration contains a set of rule collections. Each rule collection contains one or more routing rules.'''

@sys.description('Conditional. The name of the parent network manager. Required if the template is used in a standalone deployment.')
param networkManagerName string

@sys.description('Conditional. The name of the parent Routing configuration. Required if the template is used in a standalone deployment.')
param routingConfigurationName string

@sys.description('Conditional. The name of the parent rule collection. Required if the template is used in a standalone deployment.')
param ruleCollectionName string

@maxLength(64)
@sys.description('Required. The name of the rule.')
param name string

@maxLength(500)
@sys.description('Optional. A description of the rule.')
param description string = ''

@sys.description('Required. The destination can be IP addresses or Service Tag for this route. Address Prefixes are defined using the CIDR format, while Service tags are predefined identifiers that represent a category of IP addresses, which are managed by Azure.')
param destination destinationType

@sys.description('Required. The next hop handles the matching packets for this route. It can be the virtual network, the virtual network gateway, the internet, a virtual appliance, or none. Virtual network gateways cannot be used if the address prefix is IPv6. If the next hop type is VirtualAppliance, the next hop address must be specified.')
param nextHop nextHopType

resource networkManager 'Microsoft.Network/networkManagers@2024-05-01' existing = {
  name: networkManagerName

  resource routingConfiguration 'routingConfigurations' existing = {
    name: routingConfigurationName

    resource ruleCollection 'ruleCollections' existing = {
      name: ruleCollectionName
    }
  }
}

resource rule 'Microsoft.Network/networkManagers/routingConfigurations/ruleCollections/rules@2024-05-01' = {
  name: name
  parent: networkManager::routingConfiguration::ruleCollection
  properties: {
    description: description
    destination: destination
    nextHop: nextHop
  }
}

@sys.description('The name of the deployed rule.')
output name string = rule.name

@sys.description('The resource ID of the deployed rule.')
output resourceId string = rule.id

@sys.description('The resource group the rule was deployed into.')
output resourceGroupName string = resourceGroup().name

// =============== //
//   Definitions   //
// =============== //

@export()
type destinationType = {
  @sys.description('Required. The destination type can be IP addresses or Service Tag for this route. Address Prefixes are defined using the CIDR format, while Service tags are predefined identifiers that represent a category of IP addresses, which are managed by Azure.')
  type: 'AddressPrefix' | 'ServiceTag'

  @sys.description('Required. The destination IP addresses or Service Tag for this route. For IP addresses, it is the IP address range in CIDR notation that this route applies to. If the destination IP address of a packet falls in this range, it matches this route. As for Service Tags, valid identifiers can be "AzureCloud", "Storage.AustraliaEast", etc. See https://docs.microsoft.com/en-us/azure/virtual-network/service-tags-overview for more information on service tags.')
  destinationAddress: string
}

@export()
type nextHopType = {
  @sys.description('Required. The next hop handles the matching packets for this route. It can be the virtual network, the virtual network gateway, the internet, a virtual appliance, or none. Virtual network gateways cannot be used if the address prefix is IPv6. If the next hop type is VirtualAppliance, the next hop address must be specified.')
  nextHopType: 'Internet' | 'NoNextHop' | 'VirtualAppliance' | 'VirtualNetworkGateway' | 'VnetLocal'

  @sys.description('Conditional. The IP address of the next hop. Required if the next hop type is VirtualAppliance.')
  nextHopAddress: string?
}
