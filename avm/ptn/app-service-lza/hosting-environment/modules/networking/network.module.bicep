targetScope = 'resourceGroup'

import { NamingOutput } from '../naming/naming.module.bicep'
import {
  lockType
  diagnosticSettingFullType
  roleAssignmentType
} from 'br/public:avm/utl/types/avm-common-types:0.7.0'

@description('Required. The naming convention output object from the naming module.')
param naming NamingOutput

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Required. Whether to enable deployment telemetry.')
param enableTelemetry bool

@description('Optional, default is false. Set to true if you want to deploy ASE v3 instead of Multitenant App Service Plan.')
param deployAseV3 bool = false

@description('Required. CIDR of the SPOKE vnet i.e. 192.168.0.0/24.')
param vnetSpokeAddressSpace string

@description('Required. CIDR of the subnet that will hold the app services plan.')
param subnetSpokeAppSvcAddressSpace string

@description('Required. CIDR of the subnet that will hold the private endpoints of the supporting services.')
param subnetSpokePrivateEndpointAddressSpace string

@description('Optional. CIDR of the subnet that will hold the Application Gateway. Required if networkingOption is "applicationGateway".')
param subnetSpokeAppGwAddressSpace string = ''

@description('Optional. Internal IP of the Azure firewall deployed in Hub. Used for creating UDR to route all vnet egress traffic through Firewall. If empty no UDR.')
param firewallInternalIp string = ''

@description('Optional. Resource tags that we might need to add to all resources (i.e. Environment, Cost center, application name etc).')
param tags object

@description('Required. Create (or not) a UDR for the App Service Subnet, to route all egress traffic through Hub Azure Firewall.')
param enableEgressLockdown bool

@description('Optional. The networking option to use. Options: frontDoor, applicationGateway, none.')
@allowed(['frontDoor', 'applicationGateway', 'none'])
param networkingOption string = 'frontDoor'

@description('Required. The resource ID of the Log Analytics workspace for diagnostic settings.')
param logAnalyticsWorkspaceId string

@description('Optional. The resource ID of the hub VNet. If not empty, VNet peering will be configured.')
param hubVnetResourceId string = ''

@description('Optional. Custom DNS servers for the spoke VNet. If empty, Azure-provided DNS is used.')
param dnsServers string[] = []

@description('Optional. The resource ID of a DDoS Protection Plan to associate with the spoke VNet.')
param ddosProtectionPlanResourceId string = ''

@description('Optional. Diagnostic Settings for the spoke virtual network.')
param vnetDiagnosticSettings diagnosticSettingFullType[]?

@description('Optional. Specify the type of resource lock for the spoke virtual network.')
param vnetLock lockType?

@description('Optional. Whether to disable BGP route propagation on the route table. Defaults to true to prevent BGP-learned routes from bypassing the firewall.')
param disableBgpRoutePropagation bool = true

@description('Optional. Role assignments for the spoke virtual network.')
param vnetRoleAssignments roleAssignmentType[]?

@description('Optional. Enable VNet encryption.')
param vnetEncryption bool = false

@description('Optional. VNet encryption enforcement. Only used when vnetEncryption is true.')
@allowed(['AllowUnencrypted', 'DropUnencrypted'])
param vnetEncryptionEnforcement string = 'AllowUnencrypted'

@description('Optional. The flow timeout in minutes for the VNet (max 30). 0 means disabled.')
param flowTimeoutInMinutes int = 0

@description('Optional. Enable VM protection for the VNet.')
param enableVmProtection bool?

@description('Optional. The BGP community for the VNet.')
param virtualNetworkBgpCommunity string?

var deployAppGw = networkingOption == 'applicationGateway'

var resourceNames = {
  vnetSpoke: take('${naming.virtualNetwork.name}-spoke', 80)
  snetAppSvc: 'snet-appSvc-${naming.virtualNetwork.name}-spoke'
  snetDevOps: 'snet-devOps-${naming.virtualNetwork.name}-spoke'
  snetPe: 'snet-pe-${naming.virtualNetwork.name}-spoke'
  snetAppGw: 'snet-appGw-${naming.virtualNetwork.name}-spoke'
  pepNsg: take('${naming.networkSecurityGroup.name}-pep', 80)
  aseNsg: take('${naming.networkSecurityGroup.name}-ase', 80)
  appGwNsg: take('${naming.networkSecurityGroup.name}-appGw', 80)
  routeTable: naming.routeTable.name
  routeEgressLockdown: '${naming.route.name}-egress-lockdown'
}

var udrRoutes = [
  {
    name: 'defaultEgressLockdown'
    properties: {
      addressPrefix: '0.0.0.0/0'
      nextHopIpAddress: firewallInternalIp
      nextHopType: 'VirtualAppliance'
    }
  }
]

var baseSubnets = [
  {
    name: resourceNames.snetAppSvc
    addressPrefix: subnetSpokeAppSvcAddressSpace
    privateEndpointNetworkPolicies: !(deployAseV3) ? 'Enabled' : 'Disabled'
    delegation: !(deployAseV3) ? 'Microsoft.Web/serverfarms' : 'Microsoft.Web/hostingEnvironments'
    networkSecurityGroupResourceId: deployAseV3
      ? (nsgAse.?outputs.?resourceId ?? '')
      : nsgPep.outputs.resourceId
    routeTableResourceId: routeTableToFirewall.?outputs.?resourceId
  }
  {
    name: resourceNames.snetPe
    addressPrefix: subnetSpokePrivateEndpointAddressSpace
    privateEndpointNetworkPolicies: 'Disabled'
    networkSecurityGroupResourceId: nsgPep.outputs.resourceId
  }
]

var appGwSubnet = deployAppGw && !empty(subnetSpokeAppGwAddressSpace)
  ? [
      {
        name: resourceNames.snetAppGw
        addressPrefix: subnetSpokeAppGwAddressSpace
        networkSecurityGroupResourceId: nsgAppGw.?outputs.?resourceId ?? ''
      }
    ]
  : []

var subnets = union(baseSubnets, appGwSubnet)

module vnetSpoke 'br/public:avm/res/network/virtual-network:0.7.2' = {
  name: '${uniqueString(deployment().name, location)}-spokevnet'
  params: {
    name: resourceNames.vnetSpoke
    location: location
    enableTelemetry: enableTelemetry
    tags: tags
    addressPrefixes: [
      vnetSpokeAddressSpace
    ]
    dnsServers: !empty(dnsServers) ? dnsServers : []
    ddosProtectionPlanResourceId: !empty(ddosProtectionPlanResourceId) ? ddosProtectionPlanResourceId : ''
    diagnosticSettings: vnetDiagnosticSettings
    lock: vnetLock
    roleAssignments: vnetRoleAssignments
    vnetEncryption: vnetEncryption
    vnetEncryptionEnforcement: vnetEncryption ? vnetEncryptionEnforcement : 'AllowUnencrypted'
    flowTimeoutInMinutes: flowTimeoutInMinutes
    enableVmProtection: enableVmProtection
    virtualNetworkBgpCommunity: virtualNetworkBgpCommunity
    subnets: subnets
    peerings: !empty(hubVnetResourceId)
      ? [
          {
            remoteVirtualNetworkResourceId: hubVnetResourceId
            allowVirtualNetworkAccess: true
            allowForwardedTraffic: false
            allowGatewayTransit: false
            useRemoteGateways: false
          }
        ]
      : []
  }
}

module routeTableToFirewall 'br/public:avm/res/network/route-table:0.5.0' = if (!empty(firewallInternalIp) && (enableEgressLockdown)) {
  name: '${uniqueString(deployment().name, location)}-rt'
  params: {
    name: resourceNames.routeTable
    location: location
    enableTelemetry: enableTelemetry
    tags: tags
    routes: udrRoutes
    disableBgpRoutePropagation: disableBgpRoutePropagation
  }
}

@description('NSG for the private endpoint subnet.')
module nsgPep 'br/public:avm/res/network/network-security-group:0.5.2' = {
  name: '${uniqueString(deployment().name, location)}-nsgpep'
  params: {
    name: resourceNames.pepNsg
    location: location
    enableTelemetry: enableTelemetry
    tags: tags
    securityRules: [
      {
        name: 'deny-hop-outbound'
        properties: {
          priority: 200
          access: 'Deny'
          protocol: '*'
          direction: 'Outbound'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRanges: [
            '3389'
            '22'
          ]
        }
      }
    ]
    diagnosticSettings: [
      {
        workspaceResourceId: logAnalyticsWorkspaceId
      }
    ]
  }
}

@description('NSG for ASE subnet')
module nsgAse 'br/public:avm/res/network/network-security-group:0.5.2' = if (deployAseV3) {
  name: '${uniqueString(deployment().name, location)}-nsgase'
  params: {
    name: resourceNames.aseNsg
    location: location
    enableTelemetry: enableTelemetry
    tags: tags
    securityRules: [
      {
        name: 'SSL_WEB_443'
        properties: {
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '443'
          priority: 100
        }
      }
    ]
    diagnosticSettings: [
      {
        workspaceResourceId: logAnalyticsWorkspaceId
      }
    ]
  }
}

@description('NSG for Application Gateway subnet')
module nsgAppGw 'br/public:avm/res/network/network-security-group:0.5.2' = if (deployAppGw) {
  name: '${uniqueString(deployment().name, location)}-nsgappgw'
  params: {
    name: resourceNames.appGwNsg
    location: location
    enableTelemetry: enableTelemetry
    tags: tags
    securityRules: [
      {
        name: 'AllowGatewayManager'
        properties: {
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: 'GatewayManager'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '65200-65535'
          priority: 100
        }
      }
      {
        name: 'AllowHTTPS'
        properties: {
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: 'Internet'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '443'
          priority: 110
        }
      }
      {
        name: 'AllowHTTP'
        properties: {
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: 'Internet'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '80'
          priority: 120
        }
      }
      {
        name: 'AllowAzureLoadBalancer'
        properties: {
          direction: 'Inbound'
          access: 'Allow'
          protocol: '*'
          sourceAddressPrefix: 'AzureLoadBalancer'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
          priority: 130
        }
      }
    ]
    diagnosticSettings: [
      {
        workspaceResourceId: logAnalyticsWorkspaceId
      }
    ]
  }
}

@description('The resource ID of the spoke virtual network.')
output vnetSpokeResourceId string = vnetSpoke.outputs.resourceId

@description('The name of the spoke virtual network.')
output vnetSpokeName string = vnetSpoke.outputs.name

@description('The resource ID of the App Service subnet.')
output snetAppSvcResourceId string = vnetSpoke.outputs.subnetResourceIds[0]

@description('The resource ID of the private endpoint subnet.')
output snetPeResourceId string = vnetSpoke.outputs.subnetResourceIds[1]

@description('The name of the private endpoint subnet.')
output snetPeName string = vnetSpoke.outputs.subnetNames[1]

@description('The resource ID of the Application Gateway subnet. Empty if not deployed.')
output snetAppGwResourceId string = deployAppGw && !empty(subnetSpokeAppGwAddressSpace) ? vnetSpoke.outputs.subnetResourceIds[2] : ''

@description('The name of the Application Gateway subnet. Empty if not deployed.')
output snetAppGwName string = deployAppGw && !empty(subnetSpokeAppGwAddressSpace) ? vnetSpoke.outputs.subnetNames[2] : ''
