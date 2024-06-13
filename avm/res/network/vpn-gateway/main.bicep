metadata name = 'VPN Gateways'
metadata description = 'This module deploys a VPN Gateway.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the VPN gateway.')
param name string

@description('Optional. Location where all resources will be created.')
param location string = resourceGroup().location

@description('Optional. The VPN connections to create in the VPN gateway.')
param vpnConnections array = []

@description('Optional. List of all the NAT Rules to associate with the gateway.')
param natRules array = []

@description('Required. The resource ID of a virtual Hub to connect to. Note: The virtual Hub and Gateway must be deployed into the same location.')
param virtualHubResourceId string

@description('Optional. BGP settings details.')
param bgpSettings object = {}

@description('Optional. Enable BGP routes translation for NAT on this VPN gateway.')
param enableBgpRouteTranslationForNat bool = false

@description('Optional. Enable routing preference property for the public IP interface of the VPN gateway.')
param isRoutingPreferenceInternet bool = false

@description('Optional. The scale unit for this VPN gateway.')
param vpnGatewayScaleUnit int = 2

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: take(
    '46d3xbcp.res.network-vpngateway.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}',
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

resource vpnGateway 'Microsoft.Network/vpnGateways@2023-04-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    bgpSettings: bgpSettings
    enableBgpRouteTranslationForNat: enableBgpRouteTranslationForNat
    isRoutingPreferenceInternet: isRoutingPreferenceInternet
    vpnGatewayScaleUnit: vpnGatewayScaleUnit
    connections: [
      for (connection, index) in vpnConnections: {
        name: connection.name
        properties: {
          connectionBandwidth: connection.?connectionBandwidth
          enableBgp: connection.?enableBgp
          enableInternetSecurity: connection.?enableInternetSecurity
          remoteVpnSite: contains(connection, 'remoteVpnSiteResourceId')
            ? {
                id: connection.remoteVpnSiteResourceId
              }
            : null
          enableRateLimiting: connection.?enableRateLimiting
          routingConfiguration: connection.?routingConfiguration
          routingWeight: connection.?routingWeight
          sharedKey: connection.?sharedKey
          useLocalAzureIpAddress: connection.?useLocalAzureIpAddress
          usePolicyBasedTrafficSelectors: connection.?usePolicyBasedTrafficSelectors
          vpnConnectionProtocolType: connection.?vpnConnectionProtocolType
          ipsecPolicies: connection.?ipsecPolicies
          trafficSelectorPolicies: connection.?trafficSelectorPolicies
          vpnLinkConnections: connection.?vpnLinkConnections
        }
      }
    ]
    virtualHub: {
      id: virtualHubResourceId
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
  scope: vpnGateway
}

module vpnGateway_natRules 'nat-rule/main.bicep' = [
  for (natRule, index) in natRules: {
    name: '${deployment().name}-NATRule-${index}'
    params: {
      name: natRule.name
      vpnGatewayName: vpnGateway.name
      externalMappings: contains(natRule, 'externalMappings') ? natRule.externalMappings : []
      internalMappings: contains(natRule, 'internalMappings') ? natRule.internalMappings : []
      ipConfigurationId: contains(natRule, 'ipConfigurationId') ? natRule.ipConfigurationId : ''
      mode: natRule.?mode
      type: natRule.?type
    }
  }
]

module vpnGateway_vpnConnections 'vpn-connection/main.bicep' = [
  for (connection, index) in vpnConnections: {
    name: '${deployment().name}-Connection-${index}'
    params: {
      name: connection.name
      vpnGatewayName: vpnGateway.name
      connectionBandwidth: connection.?connectionBandwidth
      enableBgp: connection.?enableBgp
      enableInternetSecurity: connection.?enableInternetSecurity
      remoteVpnSiteResourceId: connection.?remoteVpnSiteResourceId
      enableRateLimiting: connection.?enableRateLimiting
      routingConfiguration: connection.?routingConfiguration
      routingWeight: connection.?routingWeight
      sharedKey: connection.?sharedKey
      useLocalAzureIpAddress: connection.?useLocalAzureIpAddress
      usePolicyBasedTrafficSelectors: connection.?usePolicyBasedTrafficSelectors
      vpnConnectionProtocolType: connection.?vpnConnectionProtocolType
      trafficSelectorPolicies: connection.?trafficSelectorPolicies
      vpnLinkConnections: connection.?vpnLinkConnections
    }
  }
]

@description('The name of the VPN gateway.')
output name string = vpnGateway.name

@description('The resource ID of the VPN gateway.')
output resourceId string = vpnGateway.id

@description('The name of the resource group the VPN gateway was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = vpnGateway.location

// =============== //
//   Definitions   //
// =============== //

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?
