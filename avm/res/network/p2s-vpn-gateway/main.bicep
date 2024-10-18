metadata name = 'P2S VPN Gateway'
metadata description = 'This module deploys a Virtual Hub P2S Gateway.'
metadata owner = 'Azure/module-maintainers'

param name string

param location string

param customDnsServers array = []

param isRoutingPreferenceInternet bool?

param virtualHubId string

param vpnGatewayScaleUnit int?

param vpnServerConfigurationId string?

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

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
    /*p2SConnectionConfigurations: [
      {
        id:
        name:
        properties: {
          enableInternetSecurity:
          routingConfiguration: {
            associatedRouteTable: {
              id:
            }
            inboundRouteMap: {
              id:
            }
            outboundRouteMap: {
              id: 
            }
            propagatedRouteTables: {
              ids: [
                {
                  id:
                }
              ]
              labels: [
              ]
            }
            vnetRoutes: {
              staticRoutes: [
                {
                  addressPrefixes: [
                  ]
                  name:
                  nextHopIpAddress:
                }
              ]
              staticRoutesConfig: {
                vnetLocalRouteOverrideCriteria:
              }
            }
          }
          vpnClientAddressPool: {
            addressPrefixes: [
            ]
          }
        }
      }
    ]*/
    virtualHub: {
      id: virtualHubId
    }
    vpnGatewayScaleUnit: vpnGatewayScaleUnit
    vpnServerConfiguration: {
      id: vpnServerConfigurationId
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
