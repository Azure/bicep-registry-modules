metadata name = 'VPN Gateways'
metadata description = 'This module deploys a VPN Gateway.'

@description('Required. Name of the VPN gateway.')
param name string

@description('Optional. Location where all resources will be created.')
param location string = resourceGroup().location

@description('Optional. The VPN connections to create in the VPN gateway.')
param vpnConnections vpnConnectionType[]?

@description('Optional. List of all the NAT Rules to associate with the gateway.')
param natRules natRuleType[]?

@description('Required. The resource ID of a virtual Hub to connect to. Note: The virtual Hub and Gateway must be deployed into the same location.')
param virtualHubResourceId string

@description('Optional. BGP settings details. You can specify either bgpPeeringAddress (for custom IPs outside APIPA ranges) OR bgpPeeringAddresses (for APIPA ranges 169.254.21.*/169.254.22.*), but not both simultaneously.')
param bgpSettings resourceInput<'Microsoft.Network/vpnGateways@2024-07-01'>.properties.bgpSettings?

@description('Optional. Enable BGP routes translation for NAT on this VPN gateway.')
param enableBgpRouteTranslationForNat bool = false

@description('Optional. Enable routing preference property for the public IP interface of the VPN gateway.')
param isRoutingPreferenceInternet bool = false

@description('Optional. The scale unit for this VPN gateway.')
param vpnGatewayScaleUnit int = 2

@description('Optional. Tags of the resource.')
param tags resourceInput<'Microsoft.Network/vpnGateways@2024-07-01'>.tags?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.7.0'
@description('Optional. The lock settings of the service.')
param lock lockType?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

// ================//
// Variables       //
// ================//

// If both are provided, bgpPeeringAddresses takes precedence and bgpPeeringAddress is ignored
var finalBgpSettings = bgpSettings != null
  ? {
      asn: bgpSettings!.asn
      peerWeight: bgpSettings!.?peerWeight
      bgpPeeringAddress: bgpSettings!.?bgpPeeringAddresses == null ? bgpSettings!.?bgpPeeringAddress : null
      bgpPeeringAddresses: bgpSettings!.?bgpPeeringAddress == null ? bgpSettings!.?bgpPeeringAddresses : null
    }
  : null

// ================//
// Deployments     //
// ================//

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
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

resource vpnGateway 'Microsoft.Network/vpnGateways@2024-07-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    bgpSettings: finalBgpSettings
    enableBgpRouteTranslationForNat: enableBgpRouteTranslationForNat
    isRoutingPreferenceInternet: isRoutingPreferenceInternet
    vpnGatewayScaleUnit: vpnGatewayScaleUnit
    // Remove connections from main resource - handle via child modules only
    // This prevents NAT rule reference issues during initial deployment
    virtualHub: {
      id: virtualHubResourceId
    }
  }
}

resource vpnGateway_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?notes ?? (lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.')
  }
  scope: vpnGateway
}

module vpnGateway_natRules 'nat-rule/main.bicep' = [
  for (natRule, index) in (natRules ?? []): {
    name: '${deployment().name}-NATRule-${index}'
    params: {
      name: natRule.name
      vpnGatewayName: vpnGateway.name
      externalMappings: natRule.?externalMappings
      internalMappings: natRule.?internalMappings
      ipConfigurationId: natRule.?ipConfigurationId
      mode: natRule.?mode
      type: natRule.?type
    }
  }
]

module vpnGateway_vpnConnections 'vpn-connection/main.bicep' = [
  for (connection, index) in (vpnConnections ?? []): {
    name: '${deployment().name}-Connection-${index}'
    dependsOn: vpnGateway_natRules
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
      ipsecPolicies: connection.?ipsecPolicies
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

@description('The resource IDs of the NAT rules.')
output natRuleResourceIds string[] = [
  for (natRule, index) in (natRules ?? []): vpnGateway_natRules[index].outputs.resourceId
]

@description('The resource IDs of the VPN connections.')
output vpnConnectionResourceIds string[] = [
  #disable-next-line outputs-should-not-contain-secrets // Not containing any secret but just exporting resource Ids
  for (connection, index) in (vpnConnections ?? []): vpnGateway_vpnConnections[index].outputs.resourceId
]

// =============== //
//   Definitions   //
// =============== //

@export()
@description('The type of VPN connection for VPN Gateway.')
type vpnConnectionType = {
  @description('Required. The name of the VPN connection.')
  name: string

  @description('Optional. Connection bandwidth in MBPS.')
  connectionBandwidth: int?

  @description('Optional. Enable BGP flag.')
  enableBgp: bool?

  @description('Optional. Enable internet security.')
  enableInternetSecurity: bool?

  @description('Optional. Remote VPN site resource ID.')
  remoteVpnSiteResourceId: string?

  @description('Optional. Enable rate limiting.')
  enableRateLimiting: bool?

  @description('Optional. Routing weight.')
  routingWeight: int?

  @description('Optional. Shared key.')
  @secure()
  sharedKey: string?

  @description('Optional. Use local Azure IP address.')
  useLocalAzureIpAddress: bool?

  @description('Optional. Use policy-based traffic selectors.')
  usePolicyBasedTrafficSelectors: bool?

  @description('Optional. VPN connection protocol type.')
  vpnConnectionProtocolType: ('IKEv1' | 'IKEv2')?

  @description('Optional. The IPSec policies to be considered by this connection.')
  ipsecPolicies: resourceInput<'Microsoft.Network/vpnGateways/vpnConnections@2024-07-01'>.properties.ipsecPolicies?

  @description('Optional. The traffic selector policies to be considered by this connection.')
  trafficSelectorPolicies: resourceInput<'Microsoft.Network/vpnGateways/vpnConnections@2024-07-01'>.properties.trafficSelectorPolicies?

  @description('Optional. List of all VPN site link connections to the gateway.')
  vpnLinkConnections: resourceInput<'Microsoft.Network/vpnGateways/vpnConnections@2024-07-01'>.properties.vpnLinkConnections?

  @description('Optional. Routing configuration indicating the associated and propagated route tables for this connection.')
  routingConfiguration: resourceInput<'Microsoft.Network/vpnGateways/vpnConnections@2024-07-01'>.properties.routingConfiguration?
}

@export()
@description('The type of NAT rule for VPN Gateway.')
type natRuleType = {
  @description('Required. The name of the NAT rule.')
  name: string

  @description('Optional. External mappings.')
  externalMappings: resourceInput<'Microsoft.Network/vpnGateways/natRules@2024-07-01'>.properties.externalMappings?

  @description('Optional. An address prefix range of source IPs on the inside network that will be mapped to a set of external IPs. In other words, your pre-NAT address prefix range.')
  internalMappings: resourceInput<'Microsoft.Network/vpnGateways/natRules@2024-07-01'>.properties.internalMappings?

  @description('Optional. IP configuration ID.')
  ipConfigurationId: string?

  @description('Optional. NAT rule mode.')
  mode: ('EgressSnat' | 'IngressSnat')?

  @description('Optional. NAT rule type.')
  type: ('Dynamic' | 'Static')?
}
