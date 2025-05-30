targetScope = 'resourceGroup'

// reference to the BICEP naming module
param naming object

@description('Azure region where the resources will be deployed in')
param location string = resourceGroup().location

@description('Required. Whether to enable deployment telemetry.')
param enableTelemetry bool

@description('Optional, default is false. Set to true if you want to deploy ASE v3 instead of Multitenant App Service Plan.')
param deployAseV3 bool = false

@description('CIDR of the SPOKE vnet i.e. 192.168.0.0/24')
param vnetSpokeAddressSpace string

@description('CIDR of the subnet that will hold the app services plan')
param subnetSpokeAppSvcAddressSpace string

@description('CIDR of the subnet that will hold the private endpoints of the supporting services')
param subnetSpokePrivateEndpointAddressSpace string

@description('Internal IP of the Azure firewall deployed in Hub. Used for creating UDR to route all vnet egress traffic through Firewall. If empty no UDR')
param firewallInternalIp string = ''

@description('Resource tags that we might need to add to all resources (i.e. Environment, Cost center, application name etc)')
param tags object

@description('Create (or not) a UDR for the App Service Subnet, to route all egress traffic through Hub Azure Firewall')
param enableEgressLockdown bool

param logAnalyticsWorkspaceId string

param hubVnetResourceId string = ''

var resourceNames = {
  vnetSpoke: take('${naming.virtualNetwork.name}-spoke', 80)
  snetAppSvc: 'snet-appSvc-${naming.virtualNetwork.name}-spoke'
  snetDevOps: 'snet-devOps-${naming.virtualNetwork.name}-spoke'
  snetPe: 'snet-pe-${naming.virtualNetwork.name}-spoke'
  pepNsg: take('${naming.networkSecurityGroup.name}-pep', 80)
  aseNsg: take('${naming.networkSecurityGroup.name}-ase', 80)
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

var subnets = [
  {
    name: resourceNames.snetAppSvc
    addressPrefix: subnetSpokeAppSvcAddressSpace
    privateEndpointNetworkPolicies: !(deployAseV3) ? 'Enabled' : 'Disabled'
    delegation: !(deployAseV3) ? 'Microsoft.Web/serverfarms' : 'Microsoft.Web/hostingEnvironments'
    networkSecurityGroupResourceId: !(deployAseV3) ? nsgPep.outputs.resourceId : nsgAse.outputs.resourceId
    routeTableResourceId: !empty(firewallInternalIp) && (enableEgressLockdown)
      ? routeTableToFirewall.outputs.resourceId
      : null
  }
  {
    name: resourceNames.snetPe
    addressPrefix: subnetSpokePrivateEndpointAddressSpace
    privateEndpointNetworkPolicies: 'Disabled'
    networkSecurityGroupResourceId: nsgPep.outputs.resourceId
  }
]

module vnetSpoke 'br/public:avm/res/network/virtual-network:0.5.4' = {
  name: '${uniqueString(deployment().name, location)}-spokevnet'
  params: {
    name: resourceNames.vnetSpoke
    location: location
    enableTelemetry: enableTelemetry
    tags: tags
    addressPrefixes: [
      vnetSpokeAddressSpace
    ]
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

module routeTableToFirewall 'br/public:avm/res/network/route-table:0.4.0' = if (!empty(firewallInternalIp) && (enableEgressLockdown)) {
  name: '${uniqueString(deployment().name, location)}-rt'
  params: {
    name: resourceNames.routeTable
    location: location
    enableTelemetry: enableTelemetry
    tags: tags
    routes: udrRoutes
  }
}

@description('NSG for the private endpoint subnet.')
module nsgPep 'br/public:avm/res/network/network-security-group:0.5.0' = {
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
module nsgAse 'br/public:avm/res/network/network-security-group:0.5.0' = if (deployAseV3) {
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

output vnetSpokeResourceId string = vnetSpoke.outputs.resourceId
output vnetSpokeName string = vnetSpoke.outputs.name
output snetAppSvcResourceId string = vnetSpoke.outputs.subnetResourceIds[0]
output snetPeResourceId string = vnetSpoke.outputs.subnetResourceIds[1]
output snetPeName string = vnetSpoke.outputs.subnetNames[1]
