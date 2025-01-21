metadata name = 'P2S VPN Gateway'
metadata description = 'This module deploys a Virtual Hub P2S Gateway.'

@description('Required. The name of the P2S VPN Gateway.')
param name string

@description('Optional. Location where all resources will be created.')
param location string = resourceGroup().location

@allowed([
  'noneRouteTable'
  'defaultRouteTable'
])
@description('Conditional. The name of the associated route table. Required if deploying in a Secure Virtual Hub; cannot be a custom route table.')
param associatedRouteTableName string?

@description('Optional. The names of the route tables to propagate to the P2S VPN Gateway.')
param propagatedRouteTableNames string[] = []

@description('Optional. The custom DNS servers for the P2S VPN Gateway.')
param customDnsServers array = []

@description('Optional. The routing preference for the P2S VPN Gateway, Internet or Microsoft network.')
param isRoutingPreferenceInternet bool?

@description('Optional. The name of the P2S Connection Configuration.')
param p2SConnectionConfigurationsName string?

@description('Optional. Enable/Disable Internet Security; "Propagate Default Route".')
param enableInternetSecurity bool?

@description('Optional. The Resource ID of the inbound route map.')
param inboundRouteMapResourceId string?

@description('Optional. The Resource ID of the outbound route map.')
param outboundRouteMapResourceId string?

@description('Optional. The Labels to propagate routes to.')
param propagatedLabelNames string[] = []

@description('Optional. The routes from the virtual hub to virtual network connections.')
param vnetRoutesStaticRoutes vnetRoutesStaticRoutesType?

@description('Optional. The address prefixes for the VPN Client Address Pool.')
param vpnClientAddressPoolAddressPrefixes array = []

@description('Required. The resource ID of the gateways virtual hub.')
param virtualHubResourceId string

@description('Optional. The scale unit of the VPN Gateway.')
param vpnGatewayScaleUnit int?

@description('Optional. The resource ID of the VPN Server Configuration.')
param vpnServerConfigurationResourceId string?

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

// =============== //

@description('Extract the virtual hub name from the virtual hub ID.')
var virtualHubName = split(virtualHubResourceId, '/')[8]

// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: take(
    '46d3xbcp.res.network-p2svpngateway.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}',
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

resource p2sVpnGateway 'Microsoft.Network/p2svpnGateways@2024-01-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    customDnsServers: customDnsServers
    isRoutingPreferenceInternet: isRoutingPreferenceInternet
    p2SConnectionConfigurations: [
      {
        name: p2SConnectionConfigurationsName
        properties: {
          enableInternetSecurity: enableInternetSecurity
          routingConfiguration: {
            associatedRouteTable: {
              id: resourceId(
                'Microsoft.Network/virtualHubs/hubRouteTables',
                '${virtualHubName}',
                '${associatedRouteTableName}'
              )
            }
            inboundRouteMap: (!empty(inboundRouteMapResourceId))
              ? {
                  id: inboundRouteMapResourceId
                }
              : null
            outboundRouteMap: (!empty(outboundRouteMapResourceId))
              ? {
                  id: outboundRouteMapResourceId
                }
              : null
            propagatedRouteTables: {
              ids: [
                for table in (propagatedRouteTableNames): {
                  id: resourceId('Microsoft.Network/virtualHubs/hubRouteTables', '${virtualHubName}', '${table}')
                }
              ]
              labels: propagatedLabelNames
            }
            vnetRoutes: vnetRoutesStaticRoutes
          }
          vpnClientAddressPool: {
            addressPrefixes: vpnClientAddressPoolAddressPrefixes
          }
        }
      }
    ]
    virtualHub: {
      id: virtualHubResourceId
    }
    vpnGatewayScaleUnit: vpnGatewayScaleUnit
    vpnServerConfiguration: {
      id: vpnServerConfigurationResourceId
    }
  }
}

resource vpnGateway_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: p2sVpnGateway
}

@description('The name of the user VPN configuration.')
output name string = p2sVpnGateway.name

@description('The resource ID of the user VPN configuration.')
output resourceId string = p2sVpnGateway.id

@description('The name of the resource group the user VPN configuration was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = p2sVpnGateway.location

// =============== //
//   Definitions   //
// =============== //

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

@export()
@description('Optional. A Type representing the VNET static routes for the P2S VPN Gateway.')
type vnetRoutesStaticRoutesType = {
  @description('Optional. The static route configuration for the P2S VPN Gateway.')
  staticRoutes: {
    @description('Optional. The address prefixes of the static route.')
    addressPrefixes: string[]?

    @description('Optional. The name of the static route.')
    name: string?

    @description('Optional. The next hop IP of the static route.')
    nextHopIpAddress: string?
  }[]?
  @description('Optional. The static route configuration for the P2S VPN Gateway.')
  staticRoutesConfig: {
    @description('Optional. Determines whether the NVA in a SPOKE VNET is bypassed for traffic with destination in spoke.')
    vnetLocalRouteOverrideCriteria: string?
  }?
}
