metadata name = 'Virtual Hubs'
metadata description = '''This module deploys a Virtual Hub.
If you are planning to deploy a Secure Virtual Hub (with an Azure Firewall integrated), please refer to the Azure Firewall module.'''
metadata owner = 'Azure/module-maintainers'

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
param azureFirewallResourceId string = ''

@description('Optional. Resource ID of the Express Route Gateway to link to.')
param expressRouteGatewayId string = ''

@description('Optional. Resource ID of the Point-to-Site VPN Gateway to link to.')
param p2SVpnGatewayId string = ''

@description('Optional. The preferred routing preference for this virtual hub.')
@allowed([
  'ASPath'
  'ExpressRoute'
  'VpnGateway'
  ''
])
param hubRoutingPreference string = ''

@description('Optional. The preferred routing gateway types.')
@allowed([
  'ExpressRoute'
  'None'
  'VpnGateway'
  ''
])
param preferredRoutingGateway string = ''

@description('Optional. VirtualHub route tables.')
param routeTableRoutes array = []

@description('Optional. ID of the Security Partner Provider to link to.')
param securityPartnerProviderId string = ''

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
param virtualRouterIps array = []

@description('Required. Resource ID of the virtual WAN to link to.')
param virtualWanId string

@description('Optional. Resource ID of the VPN Gateway to link to.')
param vpnGatewayId string = ''

@description('Optional. Configures Routing Intent to forward Internet traffic (0.0.0.0/0) to Azure Firewall. Default is true.')
param internetToFirewall bool = true

@description('Optional. Configures Routing Intent to forward Private traffic (RFC 1918) to Azure Firewall. Default is true.')
param privateToFirewall bool = true

@description('Optional. Route tables to create for the virtual hub.')
param hubRouteTables array = []

@description('Optional. Virtual network connections to create for the virtual hub.')
param hubVirtualNetworkConnections array = []

@description('Optional. The lock settings of the service.')
param lock lockType

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

resource virtualHub 'Microsoft.Network/virtualHubs@2023-11-01' = {
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
    expressRouteGateway: !empty(expressRouteGatewayId)
      ? {
          id: expressRouteGatewayId
        }
      : null
    p2SVpnGateway: !empty(p2SVpnGatewayId)
      ? {
          id: p2SVpnGatewayId
        }
      : null
    hubRoutingPreference: !empty(hubRoutingPreference) ? any(hubRoutingPreference) : null
    preferredRoutingGateway: !empty(preferredRoutingGateway) ? any(preferredRoutingGateway) : null
    routeTable: !empty(routeTableRoutes)
      ? {
          routes: routeTableRoutes
        }
      : null
    securityPartnerProvider: !empty(securityPartnerProviderId)
      ? {
          id: securityPartnerProviderId
        }
      : null
    securityProviderName: securityProviderName
    sku: sku
    virtualHubRouteTableV2s: virtualHubRouteTableV2s
    virtualRouterAsn: virtualRouterAsn
    virtualRouterIps: !empty(virtualRouterIps) ? virtualRouterIps : null
    virtualWan: {
      id: virtualWanId
    }
    vpnGateway: !empty(vpnGatewayId)
      ? {
          id: vpnGatewayId
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

module virtualHub_routingIntent 'hub-routing-intent/main.bicep' = if (!empty(azureFirewallResourceId) && (internetToFirewall || privateToFirewall)) {
  name: '${uniqueString(deployment().name, location)}-routingIntent'
  params: {
    virtualHubName: virtualHub.name
    azureFirewallResourceId: azureFirewallResourceId
    internetToFirewall: internetToFirewall
    privateToFirewall: privateToFirewall
  }
}

module virtualHub_routeTables 'hub-route-table/main.bicep' = [
  for (routeTable, index) in (hubRouteTables ?? []): {
    name: '${uniqueString(deployment().name, location)}-routeTable-${index}'
    params: {
      virtualHubName: virtualHub.name
      name: routeTable.name
      labels: contains(routeTable, 'labels') ? routeTable.labels : []
      routes: contains(routeTable, 'routes') ? routeTable.routes : []
    }
  }
]

module virtualHub_hubVirtualNetworkConnections 'hub-virtual-network-connection/main.bicep' = [
  for (virtualNetworkConnection, index) in hubVirtualNetworkConnections: {
    name: '${uniqueString(deployment().name, location)}-connection-${index}'
    params: {
      virtualHubName: virtualHub.name
      name: virtualNetworkConnection.name
      enableInternetSecurity: contains(virtualNetworkConnection, 'enableInternetSecurity')
        ? virtualNetworkConnection.enableInternetSecurity
        : true
      remoteVirtualNetworkId: virtualNetworkConnection.remoteVirtualNetworkId
      routingConfiguration: contains(virtualNetworkConnection, 'routingConfiguration')
        ? virtualNetworkConnection.routingConfiguration
        : {}
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

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?
