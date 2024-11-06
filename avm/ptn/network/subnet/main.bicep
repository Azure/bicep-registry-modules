metadata name = 'avm/ptn/network/subnet'
metadata description = 'Subnet module for landingzones with existing VNETs'
metadata owner = 'Dylan-Prins'

@description('Optional. Azure region where the each of the Private Link Private DNS Zones created will be deployed, default to Resource Group location if not specified.')
param location string = resourceGroup().location

import { lockType, roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@description('Optional. The lock settings for the Private Link Private DNS Zones created.')
param lock lockType?

@description('Optional. Tags of the Private Link Private DNS Zones created.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Required. name of the subnet')
param name string

@description('Required. address prefix of the subnet')
param addressPrefix string

@description('Required. ID of the virtual network.')
param virtualNetworkResourceId string

@description('Optional. The default outbound access for the subnet.')
param defaultOutboundAccess bool = false

@description('Optional. Enable/Disable private link network policies.')
@allowed([
  'Enabled'
  'Disabled'
])
param privateLinkServiceNetworkPolicies string = 'Disabled'

@description('The delegations for the subnet.')
param delegations array = []

@description('Optional. An array of service endpoints.')
param serviceEndpoints array = []

@description('Optional. The name of the route table.')
param routeTableName string = ''

@description('Optional. Disable BGP route propagation.')
param disableBgpRoutePropagation bool = false

@description('Optional. The routes for the route table.')
param routes routeType

@description('Optional. The name of the network security group.')
param networkSecurityGroupName string = ''

@description('Optional. The security rules for the network security group.')
param securityRules securityRulesType

module routeTable 'br/public:avm/res/network/route-table:0.4.0' = {
  name: '${uniqueString(deployment().name, location)}-rt'
  params: {
    name: routeTableName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    lock: lock
    disableBgpRoutePropagation: disableBgpRoutePropagation
    routes: routes
  }
}

module networkSecurityGroup 'br/public:avm/res/network/network-security-group:0.5.0' = {
  name: '${uniqueString(deployment().name, location)}-nsg'
  params: {
    name: networkSecurityGroupName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    securityRules: securityRules
  }
}

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2023-07-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.network-privatelinkprivatednszones.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-01-01' existing = {
  name: last(split(virtualNetworkResourceId, '/'))
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2024-01-01' = {
  parent: virtualNetwork
  name: name
  properties: {
    addressPrefix: addressPrefix
    networkSecurityGroup: !empty(securityRules)
      ? {
          id: networkSecurityGroup.outputs.resourceId
        }
      : null
    routeTable: !empty(routes)
      ? {
          id:  routeTable.outputs.resourceId
        }
      : null
    defaultOutboundAccess: defaultOutboundAccess
    delegations: delegations
    privateLinkServiceNetworkPolicies: privateLinkServiceNetworkPolicies
    privateEndpointNetworkPolicies: privateLinkServiceNetworkPolicies
    serviceEndpoints: serviceEndpoints
  }
}

// ============ //
// Outputs      //
// ============ //

@description('The resource ID of the subnet.')
output ResourceId string = subnet.id

@description('The name of the subnet.')
output name string = subnet.name

@description('The name of the subnet.')
output addressPrefix string = subnet.properties.addressPrefix

@description('The resource ID of the resource group that the Private DNS Zones are deployed into.')
output resourceGroupResourceId string = resourceGroup().id

@description('The name of the resource group that the Private DNS Zones are deployed into.')
output resourceGroupName string = resourceGroup().name



type routeType = {
  @description('Required. Name of the route.')
  name: string

  @description('Required. Properties of the route.')
  properties: {
    @description('Required. The type of Azure hop the packet should be sent to.')
    nextHopType: ('VirtualAppliance' | 'VnetLocal' | 'Internet' | 'VirtualNetworkGateway' | 'None')

    @description('Optional. The destination CIDR to which the route applies.')
    addressPrefix: string?

    @description('Optional. A value indicating whether this route overrides overlapping BGP routes regardless of LPM.')
    hasBgpOverride: bool?

    @description('Optional. The IP address packets should be forwarded to. Next hop values are only allowed in routes where the next hop type is VirtualAppliance.')
    nextHopIpAddress: string?
  }
}[]?

type securityRulesType = {
  @description('Required. The name of the security rule.')
  name: string

  @description('Required. The properties of the security rule.')
  properties: {
    @description('Required. Whether network traffic is allowed or denied.')
    access: ('Allow' | 'Deny')

    @description('Optional. The description of the security rule.')
    description: string?

    @description('Optional. Optional. The destination address prefix. CIDR or destination IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used.')
    destinationAddressPrefix: string?

    @description('Optional. The destination address prefixes. CIDR or destination IP ranges.')
    destinationAddressPrefixes: string[]?

    @description('Optional. The resource IDs of the application security groups specified as destination.')
    destinationApplicationSecurityGroupResourceIds: string[]?

    @description('Optional. The destination port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports.')
    destinationPortRange: string?

    @description('Optional. The destination port ranges.')
    destinationPortRanges: string[]?

    @description('Required. The direction of the rule. The direction specifies if rule will be evaluated on incoming or outgoing traffic.')
    direction: ('Inbound' | 'Outbound')

    @minValue(100)
    @maxValue(4096)
    @description('Required. Required. The priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule.')
    priority: int

    @description('Required. Network protocol this rule applies to.')
    protocol: ('Ah' | 'Esp' | 'Icmp' | 'Tcp' | 'Udp' | '*')

    @description('Optional. The CIDR or source IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used. If this is an ingress rule, specifies where network traffic originates from.')
    sourceAddressPrefix: string?

    @description('Optional. The CIDR or source IP ranges.')
    sourceAddressPrefixes: string[]?

    @description('Optional. The resource IDs of the application security groups specified as source.')
    sourceApplicationSecurityGroupResourceIds: string[]?

    @description('Optional. The source port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports.')
    sourcePortRange: string?

    @description('Optional. The source port ranges.')
    sourcePortRanges: string[]?
  }
}[]?
