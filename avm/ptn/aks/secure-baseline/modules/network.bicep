metadata name = 'AKS Network Foundation'
metadata description = 'Deploys the network security group, NAT gateway, public IP prefixes, virtual network, and AKS subnet.'

@description('Required. The name of the AKS managed cluster.')
param clusterName string

@description('Required. The Azure region in which to deploy the network resources.')
param location string

@description('Required. The availability zones used by the public IP prefixes.')
param availabilityZones (1 | 2 | 3)[]

@description('Required. The address prefixes assigned to the virtual network.')
param virtualNetworkAddressPrefixes string[]

@description('Required. The IPv4 address prefix assigned to the AKS node subnet.')
param aksSubnetAddressPrefix string

@description('Optional. Service endpoints enabled on the AKS node subnet.')
param aksSubnetServiceEndpoints string[] = []

@description('Required. Deploy the subnet and network security group required by Azure Bastion.')
param deployBastion bool

@description('Required. The IPv4 address prefix assigned to AzureBastionSubnet.')
param bastionSubnetAddressPrefix string

@description('Optional. A FirstPartyUsage service tag applied to the public IP prefixes.')
param serviceTag string = ''

@description('Required. The SKU used by the NAT gateway and public IP prefixes.')
param networkSku ('Standard' | 'StandardV2')

@description('Optional. Tags supplied by the module consumer.')
param tags resourceInput<'Microsoft.Resources/resourceGroups@2025-04-01'>.tags = {}

@description('Optional. Enable/Disable usage telemetry for referenced AVM modules.')
param enableTelemetry bool = true

var virtualNetworkName = 'vnet-${clusterName}'
var networkSecurityGroupName = 'nsg-${clusterName}'
var aksSubnetName = 'snet-${clusterName}'
var natGatewayName = 'ng-${clusterName}'
var serviceTagNameSuffix = !empty(serviceTag) ? '-st' : ''
var outboundPublicIpPrefixName = 'ippre-v4-ob-${clusterName}${serviceTagNameSuffix}'
var ingressPublicIpPrefixName = 'ippre-v4-${clusterName}-ingress${serviceTagNameSuffix}'
var bastionNetworkSecurityGroupName = 'nsg-bastion-${clusterName}'

var networkSecurityGroupResourceId = resourceId('Microsoft.Network/networkSecurityGroups', networkSecurityGroupName)
var natGatewayResourceId = resourceId('Microsoft.Network/natGateways', natGatewayName)
var virtualNetworkResourceId = resourceId('Microsoft.Network/virtualNetworks', virtualNetworkName)
var ingressPublicIpPrefixResourceId = resourceId('Microsoft.Network/publicIPPrefixes', ingressPublicIpPrefixName)
var bastionNetworkSecurityGroupResourceId = resourceId(
  'Microsoft.Network/networkSecurityGroups',
  bastionNetworkSecurityGroupName
)

var publicIpPrefixTags = !empty(serviceTag) ? union(tags, { 'service-tag': serviceTag }) : tags
var publicIpPrefixIpTags = !empty(serviceTag)
  ? [
      {
        ipTagType: 'FirstPartyUsage'
        tag: serviceTag
      }
    ]
  : null

module networkSecurityGroup 'br/public:avm/res/network/network-security-group:0.5.3' = {
  name: '${uniqueString(networkSecurityGroupResourceId, location)}-NetworkSecurityGroup'
  params: {
    name: networkSecurityGroupName
    location: location
    securityRules: []
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

module outboundNatGateway 'br/public:avm/res/network/nat-gateway:2.1.1' = {
  name: '${uniqueString(natGatewayResourceId, location)}-NatGateway'
  params: {
    name: natGatewayName
    location: location
    availabilityZone: -1
    natGatewaySku: networkSku
    idleTimeoutInMinutes: 4
    publicIPPrefixes: [
      {
        name: outboundPublicIpPrefixName
        prefixLength: 28
        publicIPAddressVersion: 'IPv4'
        skuName: networkSku
        availabilityZones: availabilityZones
        ipTags: publicIpPrefixIpTags
        tags: publicIpPrefixTags
      }
    ]
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

module ingressPublicIpPrefix 'br/public:avm/res/network/public-ip-prefix:0.8.0' = {
  name: '${uniqueString(ingressPublicIpPrefixResourceId, location)}-IngressPublicIpPrefix'
  params: {
    name: ingressPublicIpPrefixName
    location: location
    prefixLength: 28
    publicIPAddressVersion: 'IPv4'
    skuName: networkSku
    availabilityZones: availabilityZones
    ipTags: publicIpPrefixIpTags
    tags: publicIpPrefixTags
    enableTelemetry: enableTelemetry
  }
}

module bastionNetworkSecurityGroup 'br/public:avm/res/network/network-security-group:0.5.3' = if (deployBastion) {
  name: '${uniqueString(bastionNetworkSecurityGroupResourceId, location)}-BastionNetworkSecurityGroup'
  params: {
    name: bastionNetworkSecurityGroupName
    location: location
    securityRules: [
      {
        name: 'AllowHttpsInBound'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: 'Internet'
          destinationPortRange: '443'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 200
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowGatewayManagerInBound'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: 'GatewayManager'
          destinationPortRange: '443'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 210
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowLoadBalancerInBound'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: 'AzureLoadBalancer'
          destinationPortRange: '443'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 220
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowBastionHostCommunicationInBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationPortRanges: [
            '8080'
            '5701'
          ]
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 230
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowSshRdpOutBound'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationPortRanges: [
            '22'
            '3389'
          ]
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 200
          direction: 'Outbound'
        }
      }
      {
        name: 'AllowAzureCloudCommunicationOutBound'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationPortRange: '443'
          destinationAddressPrefix: 'AzureCloud'
          access: 'Allow'
          priority: 210
          direction: 'Outbound'
        }
      }
      {
        name: 'AllowBastionHostCommunicationOutBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationPortRanges: [
            '8080'
            '5701'
          ]
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 220
          direction: 'Outbound'
        }
      }
      {
        name: 'AllowGetSessionInformationOutBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'Internet'
          destinationPortRanges: [
            '80'
            '443'
          ]
          access: 'Allow'
          priority: 230
          direction: 'Outbound'
        }
      }
    ]
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

module virtualNetwork 'br/public:avm/res/network/virtual-network:0.10.2' = {
  name: '${uniqueString(virtualNetworkResourceId, location)}-VirtualNetwork'
  params: {
    name: virtualNetworkName
    location: location
    addressPrefixes: virtualNetworkAddressPrefixes
    subnets: concat(
      [
        {
          name: aksSubnetName
          addressPrefix: aksSubnetAddressPrefix
          defaultOutboundAccess: false
          natGatewayResourceId: outboundNatGateway.outputs.resourceId
          networkSecurityGroupResourceId: networkSecurityGroup.outputs.resourceId
          serviceEndpoints: aksSubnetServiceEndpoints
        }
      ],
      deployBastion
        ? [
            {
              name: 'AzureBastionSubnet'
              addressPrefix: bastionSubnetAddressPrefix
              defaultOutboundAccess: false
              networkSecurityGroupResourceId: bastionNetworkSecurityGroup!.outputs.resourceId
            }
          ]
        : []
    )
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

@description('The resource ID of the virtual network.')
output virtualNetworkResourceId string = virtualNetwork.outputs.resourceId

@description('The resource ID of the AKS node subnet.')
output aksSubnetResourceId string = virtualNetwork.outputs.subnetResourceIds[0]

@description('The resource ID of the outbound NAT gateway.')
output natGatewayResourceId string = outboundNatGateway.outputs.resourceId

@description('The resource ID of the public IP prefix reserved for ingress.')
output ingressPublicIpPrefixResourceId string = ingressPublicIpPrefix.outputs.resourceId
