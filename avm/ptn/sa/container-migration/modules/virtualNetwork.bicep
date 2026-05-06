// ========================================================================== //
// Virtual Network with NSG-protected subnets for Container Migration pattern  //
// Subnets:                                                                    //
//   - containers       (delegated to Microsoft.App/environments)              //
//   - backend          (private endpoints)                                    //
//   - AzureBastionSubnet                                                      //
//   - jumpbox                                                                 //
// ========================================================================== //

@description('Required. Name of the virtual network.')
param name string

@description('Optional. Azure region in which to deploy the virtual network and its subnets. Defaults to the resource group location.')
param location string = resourceGroup().location

@description('Required. An array of one or more IP address prefixes for the virtual network.')
param addressPrefixes array

@description('Optional. The subnet definitions for the virtual network. Each subnet may have its own NSG.')
param subnets subnetType[] = [
  {
    name: 'containers'
    addressPrefixes: ['10.0.2.0/24']
    delegation: 'Microsoft.App/environments'
    networkSecurityGroup: {
      name: 'nsg-containers'
      securityRules: [
        {
          name: 'AllowHttpsInbound'
          properties: {
            access: 'Allow'
            direction: 'Inbound'
            priority: 100
            protocol: 'Tcp'
            sourceAddressPrefix: 'Internet'
            sourcePortRange: '*'
            destinationPortRanges: ['443', '80']
            destinationAddressPrefixes: ['10.0.2.0/24']
          }
        }
        {
          name: 'AllowAzureLoadBalancerInbound'
          properties: {
            access: 'Allow'
            direction: 'Inbound'
            priority: 102
            protocol: '*'
            sourceAddressPrefix: 'AzureLoadBalancer'
            sourcePortRange: '*'
            destinationPortRanges: ['30000-32767']
            destinationAddressPrefixes: ['10.0.2.0/24']
          }
        }
        {
          name: 'AllowSideCarsInbound'
          properties: {
            access: 'Allow'
            direction: 'Inbound'
            priority: 103
            protocol: '*'
            sourcePortRange: '*'
            sourceAddressPrefixes: ['10.0.2.0/24']
            destinationPortRange: '*'
            destinationAddressPrefix: '*'
          }
        }
        {
          name: 'AllowOutboundToAzureServices'
          properties: {
            access: 'Allow'
            direction: 'Outbound'
            priority: 200
            protocol: '*'
            sourceAddressPrefixes: ['10.0.2.0/24']
            sourcePortRange: '*'
            destinationPortRange: '*'
            destinationAddressPrefix: '*'
          }
        }
        {
          name: 'deny-hop-outbound'
          properties: {
            access: 'Deny'
            direction: 'Outbound'
            priority: 100
            protocol: '*'
            sourcePortRange: '*'
            destinationPortRanges: ['3389', '22']
            sourceAddressPrefix: 'VirtualNetwork'
            destinationAddressPrefix: '*'
          }
        }
      ]
    }
  }
  {
    name: 'backend'
    addressPrefixes: ['10.0.0.0/24']
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Disabled'
    networkSecurityGroup: {
      name: 'nsg-backend'
      securityRules: [
        {
          name: 'Deny-hop-outbound'
          properties: {
            access: 'Deny'
            direction: 'Outbound'
            priority: 200
            protocol: '*'
            sourcePortRange: '*'
            destinationPortRanges: ['3389', '22']
            sourceAddressPrefix: 'VirtualNetwork'
            destinationAddressPrefix: '*'
          }
        }
      ]
    }
  }
  {
    name: 'AzureBastionSubnet'
    addressPrefixes: ['10.0.10.0/26']
    networkSecurityGroup: {
      name: 'nsg-bastion'
      securityRules: [
        {
          name: 'AllowGatewayManager'
          properties: {
            access: 'Allow'
            direction: 'Inbound'
            priority: 2702
            protocol: '*'
            sourcePortRange: '*'
            destinationPortRange: '443'
            sourceAddressPrefix: 'GatewayManager'
            destinationAddressPrefix: '*'
          }
        }
        {
          name: 'AllowHttpsInBound'
          properties: {
            access: 'Allow'
            direction: 'Inbound'
            priority: 2703
            protocol: '*'
            sourcePortRange: '*'
            destinationPortRange: '443'
            sourceAddressPrefix: 'Internet'
            destinationAddressPrefix: '*'
          }
        }
        {
          name: 'AllowSshRdpOutbound'
          properties: {
            access: 'Allow'
            direction: 'Outbound'
            priority: 100
            protocol: '*'
            sourcePortRange: '*'
            destinationPortRanges: ['22', '3389']
            sourceAddressPrefix: '*'
            destinationAddressPrefix: 'VirtualNetwork'
          }
        }
        {
          name: 'AllowAzureCloudOutbound'
          properties: {
            access: 'Allow'
            direction: 'Outbound'
            priority: 110
            protocol: 'Tcp'
            sourcePortRange: '*'
            destinationPortRange: '443'
            sourceAddressPrefix: '*'
            destinationAddressPrefix: 'AzureCloud'
          }
        }
      ]
    }
  }
  {
    name: 'jumpbox'
    addressPrefixes: ['10.0.12.0/23']
    networkSecurityGroup: {
      name: 'nsg-jumpbox'
      securityRules: [
        {
          name: 'AllowRdpFromBastion'
          properties: {
            access: 'Allow'
            direction: 'Inbound'
            priority: 100
            protocol: 'Tcp'
            sourcePortRange: '*'
            destinationPortRange: '3389'
            sourceAddressPrefixes: ['10.0.10.0/26']
            destinationAddressPrefixes: ['10.0.12.0/23']
          }
        }
      ]
    }
  }
]

@description('Optional. Tags to apply to the resources.')
param tags object = {}

@description('Required. The resource ID of the Log Analytics Workspace to send diagnostic logs to. Pass an empty string to disable diagnostics.')
param logAnalyticsWorkspaceId string

@description('Optional. Enable/Disable usage telemetry for the AVM resource modules deployed by this submodule.')
param enableTelemetry bool = true

@description('Required. Suffix appended to NSG resource names to keep them unique within the resource group.')
param resourceSuffix string

// 1. Create per-subnet NSGs (one batch at a time).
@batchSize(1)
module nsgs 'br/public:avm/res/network/network-security-group:0.5.2' = [
  for (subnet, i) in subnets: if (!empty(subnet.?networkSecurityGroup)) {
    name: take('avm.res.network.network-security-group.${subnet.?networkSecurityGroup.name}.${resourceSuffix}', 64)
    params: {
      name: '${subnet.?networkSecurityGroup.name}-${resourceSuffix}'
      location: location
      securityRules: subnet.?networkSecurityGroup.securityRules
      tags: tags
      enableTelemetry: enableTelemetry
    }
  }
]

// 2. Create the VNet and attach NSGs to subnets.
module virtualNetwork 'br/public:avm/res/network/virtual-network:0.7.1' = {
  name: take('avm.res.network.virtual-network.${name}', 64)
  params: {
    name: name
    location: location
    addressPrefixes: addressPrefixes
    subnets: [
      for (subnet, i) in subnets: {
        name: subnet.name
        addressPrefixes: subnet.?addressPrefixes
        networkSecurityGroupResourceId: !empty(subnet.?networkSecurityGroup) ? nsgs[i]!.outputs.resourceId : null
        privateEndpointNetworkPolicies: subnet.?privateEndpointNetworkPolicies
        privateLinkServiceNetworkPolicies: subnet.?privateLinkServiceNetworkPolicies
        delegation: subnet.?delegation
      }
    ]
    diagnosticSettings: !empty(logAnalyticsWorkspaceId)
      ? [
          {
            name: 'vnetDiagnostics'
            workspaceResourceId: logAnalyticsWorkspaceId
            logCategoriesAndGroups: [
              {
                categoryGroup: 'allLogs'
                enabled: true
              }
            ]
            metricCategories: [
              {
                category: 'AllMetrics'
                enabled: true
              }
            ]
          }
        ]
      : null
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

@description('Name of the deployed virtual network.')
output name string = virtualNetwork.outputs.name

@description('Resource ID of the deployed virtual network.')
output resourceId string = virtualNetwork.outputs.resourceId

@description('Combined output array containing subnet details and the associated NSG (if any).')
output subnets subnetOutputType[] = [
  for (subnet, i) in subnets: {
    name: subnet.name
    resourceId: virtualNetwork.outputs.subnetResourceIds[i]
    nsgName: !empty(subnet.?networkSecurityGroup) ? subnet.?networkSecurityGroup.name : null
    nsgResourceId: !empty(subnet.?networkSecurityGroup) ? nsgs[i]!.outputs.resourceId : null
  }
]

@description('Resource ID of the containers subnet (delegated to Microsoft.App/environments).')
output containersSubnetResourceId string = contains(map(subnets, subnet => subnet.name), 'containers')
  ? virtualNetwork.outputs.subnetResourceIds[indexOf(map(subnets, subnet => subnet.name), 'containers')]
  : ''

@description('Resource ID of the backend subnet (private endpoints).')
output backendSubnetResourceId string = contains(map(subnets, subnet => subnet.name), 'backend')
  ? virtualNetwork.outputs.subnetResourceIds[indexOf(map(subnets, subnet => subnet.name), 'backend')]
  : ''

@description('Resource ID of the Azure Bastion subnet.')
output bastionSubnetResourceId string = contains(map(subnets, subnet => subnet.name), 'AzureBastionSubnet')
  ? virtualNetwork.outputs.subnetResourceIds[indexOf(map(subnets, subnet => subnet.name), 'AzureBastionSubnet')]
  : ''

@description('Resource ID of the jumpbox subnet.')
output jumpboxSubnetResourceId string = contains(map(subnets, subnet => subnet.name), 'jumpbox')
  ? virtualNetwork.outputs.subnetResourceIds[indexOf(map(subnets, subnet => subnet.name), 'jumpbox')]
  : ''

@export()
@description('Custom type definition for subnet resource information as output.')
type subnetOutputType = {
  @description('The name of the subnet.')
  name: string

  @description('The resource ID of the subnet.')
  resourceId: string

  @description('The name of the associated network security group, if any.')
  nsgName: string?

  @description('The resource ID of the associated network security group, if any.')
  nsgResourceId: string?
}

@export()
@description('Custom type definition for subnet configuration.')
type subnetType = {
  @description('Required. The name of the subnet resource.')
  name: string

  @description('Required. Address prefixes for the subnet.')
  addressPrefixes: string[]

  @description('Optional. The delegation to enable on the subnet.')
  delegation: string?

  @description('Optional. Enable or disable applying network policies on private endpoints in the subnet.')
  privateEndpointNetworkPolicies: ('Disabled' | 'Enabled' | 'NetworkSecurityGroupEnabled' | 'RouteTableEnabled')?

  @description('Optional. Enable or disable applying network policies on private link services in the subnet.')
  privateLinkServiceNetworkPolicies: ('Disabled' | 'Enabled')?

  @description('Optional. Network Security Group configuration for the subnet.')
  networkSecurityGroup: networkSecurityGroupType?

  @description('Optional. The resource ID of the route table to assign to the subnet.')
  routeTableResourceId: string?

  @description('Optional. An array of service endpoint policies.')
  serviceEndpointPolicies: object[]?

  @description('Optional. The service endpoints to enable on the subnet.')
  serviceEndpoints: string[]?

  @description('Optional. Set this property to false to disable default outbound connectivity for all VMs in the subnet. This property can only be set at the time of subnet creation and cannot be updated for an existing subnet.')
  defaultOutboundAccess: bool?
}

@export()
@description('Custom type definition for network security group configuration.')
type networkSecurityGroupType = {
  @description('Required. The name of the network security group.')
  name: string

  @description('Required. The security rules for the network security group.')
  securityRules: object[]
}
