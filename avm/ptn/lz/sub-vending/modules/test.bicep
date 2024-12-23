param virtualNetworkName string = 'vnet001'
param virtualNetworkEnabled bool = true
param virtualNetworkLocation string = 'eastus2'
param virtualNetworkDdosPlanResourceId string = ''

param virtualNetworkSubnets subnetType[] = [
  {
    name: 'subnet001'
    addressPrefix: '10.0.1.0/24'
    associateWithNatGateway: true
  }
]

@sys.description('The NAT Gateway configuration object.')
param natGatewayConfiguration natGatewayType = {
  name: 'nat-gw-${virtualNetworkName}-gw'
  zone: 3
  publicIPAddressProperties: [
    {
      name: 'nat-gw-${virtualNetworkName}-pip-param'
      zones: [
        1
        2
      ]
    }
  ]
}

var natGatewayPublicIpZonesList = pickZones('Microsoft.Network', 'publicIPAddresses', virtualNetworkLocation, 3) ?? null

var natGatewayPublicIpZones = [for item in natGatewayPublicIpZonesList: int(item)]

module createLzVnet 'br/public:avm/res/network/virtual-network:0.5.1' = if (virtualNetworkEnabled) {
  name: 'vnet001'
  params: {
    name: virtualNetworkName
    location: virtualNetworkLocation
    addressPrefixes: ['10.0.0.0/16']
  }
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' = [
  for (subnet, i) in virtualNetworkSubnets: if (!empty(virtualNetworkSubnets)) {
    name: '${virtualNetworkName}/${subnet.name}'
    properties: {
      addressPrefix: subnet.addressPrefix
      natGateway: ((subnet.?associateWithNatGateway ?? false) && !empty(natGatewayConfiguration) && virtualNetworkEnabled)
        ? {
            id: createNatGateway.outputs.resourceId
          }
        : null
    }
  }
]

module createNatGateway 'br/public:avm/res/network/nat-gateway:1.2.1' = if (!empty(natGatewayConfiguration) && virtualNetworkEnabled) {
  name: 'natgw'
  params: {
    name: 'nat-gw-${createLzVnet.outputs.name}'
    zone: natGatewayConfiguration.?zone ?? 0
    location: virtualNetworkLocation
    publicIPAddressObjects: [
      for publicIp in natGatewayConfiguration.?publicIPAddressProperties ?? []: {
        name: publicIp.?name ?? '${natGatewayConfiguration.?name}-pip'
        publicIPAddressSku: 'Standard'
        publicIPAddressVersion: 'IPv4'
        publicIPAllocationMethod: 'Static'
        zones: publicIp.?zones ?? [1, 2]
        skuTier: 'Regional'
        ddosSettings: !empty(virtualNetworkDdosPlanResourceId)
          ? {
              ddosProtectionPlan: {
                id: virtualNetworkDdosPlanResourceId
              }
              protectionMode: 'Enabled'
            }
          : null
        idleTimeoutInMinutes: 4
      }
    ]
    publicIPPrefixObjects: [
      for publicIpPrefix in natGatewayConfiguration.?publicIPAddressPrefixesProperties ?? []: {
        name: publicIpPrefix.?name ?? '${natGatewayConfiguration.?name}-prefix'
        location: virtualNetworkLocation
        prefixLength: publicIpPrefix.?prefixLength
        customIPPrefix: publicIpPrefix.?customIPPrefix
      }
    ]
  }
}

@export()
type natGatewayType = {
  @description('The name of the NAT gateway.')
  name: string?

  @description('The availability zone of the NAT gateway.')
  zone: 0 | 1 | 2 | 3?

  @description('The Public IP address(es) properties to be attached to the NAT gateway.')
  publicIPAddressProperties: natGatewayPublicIPAddressType?

  @description('The Public IP address(es) prefixes properties to be attached to the NAT gateway.')
  publicIPAddressPrefixesProperties: natGatewayPublicIPAddressPrefixType?
}

@export()
type natGatewayPublicIPAddressType = {
  @description('The name of the public IP address.')
  name: string?

  @description('The availability zones of the public IP address.')
  zones: (1 | 2 | 3)[]?
}[]?

@export()
type natGatewayPublicIPAddressPrefixType = {
  @description('The name of the public IP address prefix.')
  name: string

  @description('The prefix length of the public IP address prefix.')
  prefixLength: int

  @description('The custom IP prefix of the public IP address prefix.')
  customIPPrefix: string
}[]?

@export()
type subnetType = {
  @description('Required. The Name of the subnet resource.')
  name: string

  @description('Conditional. The address prefix for the subnet. Required if `addressPrefixes` is empty.')
  addressPrefix: string?

  @description('Conditional. List of address prefixes for the subnet. Required if `addressPrefix` is empty.')
  addressPrefixes: string[]?

  @description('Optional. Application gateway IP configurations of virtual network resource.')
  applicationGatewayIPConfigurations: object[]?

  @description('Optional. The delegation to enable on the subnet.')
  delegation: string?

  @description('Optional. Option to assosciate with NAT gatway.')
  associateWithNatGateway: bool?

  @description('Optional. The resource ID of the network security group to assign to the subnet.')
  networkSecurityGroupResourceId: string?

  @description('Optional. enable or disable apply network policies on private endpoint in the subnet.')
  privateEndpointNetworkPolicies: ('Disabled' | 'Enabled' | 'NetworkSecurityGroupEnabled' | 'RouteTableEnabled')?

  @description('Optional. enable or disable apply network policies on private link service in the subnet.')
  privateLinkServiceNetworkPolicies: ('Disabled' | 'Enabled')?

  @description('Optional. The resource ID of the route table to assign to the subnet.')
  routeTableResourceId: string?

  @description('Optional. An array of service endpoint policies.')
  serviceEndpointPolicies: object[]?

  @description('Optional. The service endpoints to enable on the subnet.')
  serviceEndpoints: string[]?

  @description('Optional. Set this property to false to disable default outbound connectivity for all VMs in the subnet. This property can only be set at the time of subnet creation and cannot be updated for an existing subnet.')
  defaultOutboundAccess: bool?

  @description('Optional. Set this property to Tenant to allow sharing subnet with other subscriptions in your AAD tenant. This property can only be set if defaultOutboundAccess is set to false, both properties can only be set if subnet is empty.')
  sharingScope: ('DelegatedServices' | 'Tenant')?
}
