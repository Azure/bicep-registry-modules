/****************************************************************************************************************************/
// Networking - NSGs, VNET and Subnets for Content Generation Solution
/****************************************************************************************************************************/
@description('Name of the virtual network.')
param vnetName string

@description('Azure region to deploy resources.')
param vnetLocation string = resourceGroup().location

@description('Required. An Array of 1 or more IP Address Prefixes for the Virtual Network.')
param vnetAddressPrefixes array = ['10.0.0.0/20']

@description('Optional. Deploy Azure Bastion and Jumpbox subnets for VM-based administration.')
param deployBastionAndJumpbox bool = false

@description('An array of subnets to be created within the virtual network.')
// Core subnets: web (App Service), peps (Private Endpoints), aci (Container Instance)
// Optional: AzureBastionSubnet and jumpbox (only when deployBastionAndJumpbox is true)
var coreSubnets = [
  {
    name: 'web'
    addressPrefixes: ['10.0.0.0/23']
    delegation: 'Microsoft.Web/serverFarms'
    networkSecurityGroup: {
      name: 'nsg-web'
      securityRules: [
        {
          name: 'AllowHttpsInbound'
          properties: {
            access: 'Allow'
            direction: 'Inbound'
            priority: 100
            protocol: 'Tcp'
            sourcePortRange: '*'
            destinationPortRange: '443'
            sourceAddressPrefixes: ['0.0.0.0/0']
            destinationAddressPrefixes: ['10.0.0.0/23']
          }
        }
        {
          name: 'AllowIntraSubnetTraffic'
          properties: {
            access: 'Allow'
            direction: 'Inbound'
            priority: 200
            protocol: '*'
            sourcePortRange: '*'
            destinationPortRange: '*'
            sourceAddressPrefixes: ['10.0.0.0/23']
            destinationAddressPrefixes: ['10.0.0.0/23']
          }
        }
        {
          name: 'AllowAzureLoadBalancer'
          properties: {
            access: 'Allow'
            direction: 'Inbound'
            priority: 300
            protocol: '*'
            sourcePortRange: '*'
            destinationPortRange: '*'
            sourceAddressPrefix: 'AzureLoadBalancer'
            destinationAddressPrefix: '10.0.0.0/23'
          }
        }
      ]
    }
  }
  {
    name: 'peps'
    addressPrefixes: ['10.0.2.0/23']
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Disabled'
    networkSecurityGroup: {
      name: 'nsg-peps'
      securityRules: []
    }
  }
  {
    name: 'aci'
    addressPrefixes: ['10.0.4.0/24']
    delegation: 'Microsoft.ContainerInstance/containerGroups'
    networkSecurityGroup: {
      name: 'nsg-aci'
      securityRules: [
        {
          name: 'AllowHttpsInbound'
          properties: {
            access: 'Allow'
            direction: 'Inbound'
            priority: 100
            protocol: 'Tcp'
            sourcePortRange: '*'
            destinationPortRange: '8000'
            sourceAddressPrefixes: ['10.0.0.0/20']
            destinationAddressPrefixes: ['10.0.4.0/24']
          }
        }
      ]
    }
  }
]

// Optional Bastion and Jumpbox subnets (only deployed when needed for VM administration)
var bastionSubnets = deployBastionAndJumpbox
  ? [
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
  : []

var vnetSubnets = concat(coreSubnets, bastionSubnets)

@description('Optional. Tags to be applied to the resources.')
param tags object?

@description('Optional. The resource ID of the Log Analytics Workspace to send diagnostic logs to.')
param logAnalyticsWorkspaceId string = ''

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Required. Suffix for resource naming.')
param resourceSuffix string

// Create NSGs for subnets using AVM Network Security Group module
@batchSize(1)
#disable-next-line use-recent-module-versions // 0.5.3 is the latest available version
module nsgs 'br/public:avm/res/network/network-security-group:0.5.3' = [
  for (subnet, i) in vnetSubnets: if (!empty(subnet.?networkSecurityGroup)) {
    name: take('avm.res.network.network-security-group.${subnet.?networkSecurityGroup.name}.${resourceSuffix}', 64)
    params: {
      name: '${subnet.?networkSecurityGroup.name}-${resourceSuffix}'
      location: vnetLocation
      securityRules: subnet.?networkSecurityGroup.securityRules
      tags: tags
      enableTelemetry: enableTelemetry
    }
  }
]

// Create VNet and subnets using AVM Virtual Network module
module virtualNetwork 'br/public:avm/res/network/virtual-network:0.8.1' = {
  name: take('avm.res.network.virtual-network.${vnetName}', 64)
  params: {
    name: vnetName
    location: vnetLocation
    addressPrefixes: vnetAddressPrefixes
    subnets: [
      for (subnet, i) in vnetSubnets: {
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
      : []
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

output name string = virtualNetwork.outputs.name
output resourceId string = virtualNetwork.outputs.resourceId

// Core subnet outputs (always present)
output webSubnetResourceId string = contains(map(vnetSubnets, subnet => subnet.name), 'web')
  ? virtualNetwork.outputs.subnetResourceIds[indexOf(map(vnetSubnets, subnet => subnet.name), 'web')]
  : ''
output pepsSubnetResourceId string = contains(map(vnetSubnets, subnet => subnet.name), 'peps')
  ? virtualNetwork.outputs.subnetResourceIds[indexOf(map(vnetSubnets, subnet => subnet.name), 'peps')]
  : ''
output aciSubnetResourceId string = contains(map(vnetSubnets, subnet => subnet.name), 'aci')
  ? virtualNetwork.outputs.subnetResourceIds[indexOf(map(vnetSubnets, subnet => subnet.name), 'aci')]
  : ''

// Optional bastion/jumpbox subnet outputs (only present when deployBastionAndJumpbox is true)
output bastionSubnetResourceId string = deployBastionAndJumpbox && contains(
    map(vnetSubnets, subnet => subnet.name),
    'AzureBastionSubnet'
  )
  ? virtualNetwork.outputs.subnetResourceIds[indexOf(map(vnetSubnets, subnet => subnet.name), 'AzureBastionSubnet')]
  : ''
output jumpboxSubnetResourceId string = deployBastionAndJumpbox && contains(
    map(vnetSubnets, subnet => subnet.name),
    'jumpbox'
  )
  ? virtualNetwork.outputs.subnetResourceIds[indexOf(map(vnetSubnets, subnet => subnet.name), 'jumpbox')]
  : ''
