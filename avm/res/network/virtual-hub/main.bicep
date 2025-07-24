metadata name = 'Virtual Hubs'
metadata description = '''This module deploys a Virtual Hub.
If you are planning to deploy a Secure Virtual Hub (with an Azure Firewall integrated), please refer to the Azure Firewall module.'''

@description('Required. The virtual hub name.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object?

@description('Required. Address-prefix for this VirtualHub.')
param addressPrefix string

@description('Optional. Flag to control transit for VirtualRouter hub.')
param allowBranchToBranchTraffic bool = true

@description('Optional. Resource ID of the Azure Firewall to link to.')
param azureFirewallResourceId string?

@description('Optional. Resource ID of the Express Route Gateway to link to.')
param expressRouteGatewayResourceId string?

@description('Optional. Resource ID of the Point-to-Site VPN Gateway to link to.')
param p2SVpnGatewayResourceId string?

@description('Optional. The preferred routing preference for this virtual hub.')
@allowed([
  'ASPath'
  'ExpressRoute'
  'VpnGateway'
])
param hubRoutingPreference string?

@description('Optional. The preferred routing gateway types.')
@allowed([
  'ExpressRoute'
  'None'
  'VpnGateway'
])
param preferredRoutingGateway string?

@description('Optional. VirtualHub route tables.')
param routeTableRoutes array?

@description('Optional. ID of the Security Partner Provider to link to.')
param securityPartnerProviderResourceId string = ''

@description('Optional. The Security Provider name.')
param securityProviderName string = ''

@allowed([
  'Basic'
  'Standard'
])
@description('Optional. The sku of this VirtualHub.')
param sku string = 'Standard'

@description('Optional. List of all virtual hub route table v2s associated with this VirtualHub.')
param virtualHubRouteTableV2s array = []

@description('Optional. VirtualRouter ASN.')
param virtualRouterAsn int?

@description('Optional. VirtualRouter IPs.')
param virtualRouterIps array?

@description('Optional. The auto scale configuration for the virtual router.')
param virtualRouterAutoScaleConfiguration {
  @description('Required. The minimum number of virtual routers in the scale set.')
  minCount: int
}?

@description('Required. Resource ID of the virtual WAN to link to.')
param virtualWanResourceId string

@description('Optional. Resource ID of the VPN Gateway to link to.')
param vpnGatewayResourceId string?

@description('Optional. The routing intent configuration to create for the virtual hub.')
param routingIntent routingIntentType?

@description('Optional. Route tables to create for the virtual hub.')
param hubRouteTables hubRouteTableType[]?

@description('Optional. Virtual network connections to create for the virtual hub.')
param hubVirtualNetworkConnections hubVirtualNetworkConnectionType[]?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: take(
    '46d3xbcp.res.network-virtualhub.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}',
    64
  )
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

resource virtualHub 'Microsoft.Network/virtualHubs@2024-05-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    addressPrefix: addressPrefix
    allowBranchToBranchTraffic: allowBranchToBranchTraffic
    azureFirewall: !empty(azureFirewallResourceId)
      ? {
          id: azureFirewallResourceId
        }
      : null
    expressRouteGateway: !empty(expressRouteGatewayResourceId)
      ? {
          id: expressRouteGatewayResourceId
        }
      : null
    p2SVpnGateway: !empty(p2SVpnGatewayResourceId)
      ? {
          id: p2SVpnGatewayResourceId
        }
      : null
    hubRoutingPreference: hubRoutingPreference
    preferredRoutingGateway: preferredRoutingGateway
    routeTable: !empty(routeTableRoutes)
      ? {
          routes: routeTableRoutes
        }
      : null
    securityPartnerProvider: !empty(securityPartnerProviderResourceId)
      ? {
          id: securityPartnerProviderResourceId
        }
      : null
    securityProviderName: securityProviderName
    sku: sku
    virtualHubRouteTableV2s: virtualHubRouteTableV2s
    virtualRouterAsn: virtualRouterAsn
    virtualRouterIps: virtualRouterIps
    virtualRouterAutoScaleConfiguration: {
      minCapacity: virtualRouterAutoScaleConfiguration.?minCount
    }
    virtualWan: {
      id: virtualWanResourceId
    }
    vpnGateway: !empty(vpnGatewayResourceId)
      ? {
          id: vpnGatewayResourceId
        }
      : null
  }
}

resource virtualHub_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: virtualHub
}

module virtualHub_routingIntent 'routing-intent/main.bicep' = if (!empty(azureFirewallResourceId) && !empty(routingIntent)) {
  name: '${uniqueString(deployment().name, location)}-routingIntent'
  params: {
    virtualHubName: virtualHub.name
    azureFirewallResourceId: azureFirewallResourceId!
    internetToFirewall: routingIntent.?internetToFirewall
    privateToFirewall: routingIntent.?privateToFirewall
  }
}

// Initially create the route tables without routes
module virtualHub_routeTables 'hub-route-table/main.bicep' = [
  for (routeTable, index) in (hubRouteTables ?? []): {
    name: '${uniqueString(deployment().name, location)}-routeTable-${index}'
    params: {
      virtualHubName: virtualHub.name
      name: routeTable.name
      labels: routeTable.?labels
      routes: routeTable.?routes
    }
  }
]

module virtualHub_hubVirtualNetworkConnections 'hub-virtual-network-connection/main.bicep' = [
  for (virtualNetworkConnection, index) in (hubVirtualNetworkConnections ?? []): {
    name: '${uniqueString(deployment().name, location)}-connection-${index}'
    params: {
      virtualHubName: virtualHub.name
      name: virtualNetworkConnection.name
      enableInternetSecurity: virtualNetworkConnection.?enableInternetSecurity
      remoteVirtualNetworkResourceId: virtualNetworkConnection.remoteVirtualNetworkResourceId
      routingConfiguration: virtualNetworkConnection.?routingConfiguration
    }
    dependsOn: [
      virtualHub_routeTables
    ]
  }
]

@description('The resource group the virtual hub was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the virtual hub.')
output resourceId string = virtualHub.id

@description('The name of the virtual hub.')
output name string = virtualHub.name

@description('The location the resource was deployed into.')
output location string = virtualHub.location

// =============== //
//   Definitions   //
// =============== //

@export()
@description('The type of a virtual hub route table.')
type hubRouteTableType = {
  @description('Required. The route table name.')
  name: string

  @description('Optional. List of labels associated with this route table.')
  labels: array?

  @description('Optional. List of all routes.')
  routes: {
    @description('Required. The address prefix for the route.')
    destinations: string[]

    @description('Required. The destination type for the route.')
    destinationType: ('CIDR')

    @description('Required. The name of the route.')
    name: string

    @description('Required. The next hop type for the route.')
    nextHopType: ('ResourceId')

    @description('Required. The next hop IP address for the route.')
    nextHop: string
  }[]?
}

@export()
@description('The type of a routing intent.')
type routingIntentType = {
  @description('Optional. Configures Routing Intent to forward Private traffic to the firewall (RFC1918).')
  privateToFirewall: bool?

  @description('Optional. Configures Routing Intent to Forward Internet traffic to the firewall (0.0.0.0/0).')
  internetToFirewall: bool?
}

@export()
@description('The type of a hub virtual network connection.')
type hubVirtualNetworkConnectionType = {
  @description('Required. The connection name.')
  name: string

  @description('Optional. Enable internet security.')
  enableInternetSecurity: bool?

  @description('Required. Resource ID of the virtual network to link to.')
  remoteVirtualNetworkResourceId: string

  @description('Optional. Routing Configuration indicating the associated and propagated route tables for this connection.')
  routingConfiguration: object?
}
