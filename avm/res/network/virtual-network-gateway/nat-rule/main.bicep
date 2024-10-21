metadata name = 'VPN Gateway NAT Rules'
metadata description = 'This module deploys a Virtual Network Gateway NAT Rule.'

@description('Required. The name of the NAT rule.')
param name string

@description('Conditional. The name of the parent Virtual Network Gateway this NAT rule is associated with. Required if the template is used in a standalone deployment.')
param virtualNetworkGatewayName string

@description('Optional. An address prefix range of destination IPs on the outside network that source IPs will be mapped to. In other words, your post-NAT address prefix range.')
param externalMappings array = []

@description('Optional. An address prefix range of source IPs on the inside network that will be mapped to a set of external IPs. In other words, your pre-NAT address prefix range.')
param internalMappings array = []

@description('Optional. A NAT rule must be configured to a specific Virtual Network Gateway instance. This is applicable to Dynamic NAT only. Static NAT rules are automatically applied to both Virtual Network Gateway instances.')
param ipConfigurationId string = ''

@description('Optional. The type of NAT rule for Virtual Network NAT. IngressSnat mode (also known as Ingress Source NAT) is applicable to traffic entering the Azure hub\'s site-to-site Virtual Network gateway. EgressSnat mode (also known as Egress Source NAT) is applicable to traffic leaving the Azure hub\'s Site-to-site Virtual Network gateway.')
@allowed([
  ''
  'EgressSnat'
  'IngressSnat'
])
param mode string = ''

@description('Optional. The type of NAT rule for Virtual Network NAT. Static one-to-one NAT establishes a one-to-one relationship between an internal address and an external address while Dynamic NAT assigns an IP and port based on availability.')
@allowed([
  ''
  'Dynamic'
  'Static'
])
param type string = ''

resource virtualNetworkGateway 'Microsoft.Network/virtualNetworkGateways@2023-04-01' existing = {
  name: virtualNetworkGatewayName
}

resource natRule 'Microsoft.Network/virtualNetworkGateways/natRules@2023-04-01' = {
  name: name
  parent: virtualNetworkGateway
  properties: {
    externalMappings: externalMappings
    internalMappings: internalMappings
    ipConfigurationId: !empty(ipConfigurationId) ? ipConfigurationId : null
    mode: !empty(mode) ? any(mode) : null
    type: !empty(type) ? any(type) : null
  }
}

@description('The name of the NAT rule.')
output name string = natRule.name

@description('The resource ID of the NAT rule.')
output resourceId string = natRule.id

@description('The name of the resource group the NAT rule was deployed into.')
output resourceGroupName string = resourceGroup().name
