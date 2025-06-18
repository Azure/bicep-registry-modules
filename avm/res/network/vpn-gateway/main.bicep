metadata name = 'VPN Gateways'
metadata description = 'This module deploys a VPN Gateway.'

@description('Required. Name of the VPN gateway.')
param name string

@description('Optional. Location where all resources will be created.')
param location string = resourceGroup().location

@description('Optional. The VPN connections to create in the VPN gateway.')
param vpnConnections vpnConnectionType[] = []

@description('Optional. List of all the NAT Rules to associate with the gateway.')
param natRules natRuleType[] = []

@description('Required. The resource ID of a virtual Hub to connect to. Note: The virtual Hub and Gateway must be deployed into the same location.')
param virtualHubResourceId string

@description('Optional. BGP settings details.')
param bgpSettings bgpSettingsType?

@description('Optional. Enable BGP routes translation for NAT on this VPN gateway.')
param enableBgpRouteTranslationForNat bool = false

@description('Optional. Enable routing preference property for the public IP interface of the VPN gateway.')
param isRoutingPreferenceInternet bool = false

@description('Optional. The scale unit for this VPN gateway.')
param vpnGatewayScaleUnit int = 2

@description('Optional. Tags of the resource.')
param tags resourceInput<'Microsoft.Network/vpnGateways@2024-07-01'>.tags?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

// Import types from child modules
import { ipsecPolicyType, trafficSelectorPolicyType, vpnSiteLinkConnectionType } from 'vpn-connection/main.bicep'
import { vpnNatRuleMappingType } from 'nat-rule/main.bicep'

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

resource vpnGateway 'Microsoft.Network/vpnGateways@2024-07-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    bgpSettings: bgpSettings
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
      externalMappings: natRule.?externalMappings
      internalMappings: natRule.?internalMappings
      ipConfigurationId: natRule.?ipConfigurationId
      mode: natRule.?mode
      type: natRule.?type
    }
  }
]

module vpnGateway_vpnConnections 'vpn-connection/main.bicep' = [
  for (connection, index) in vpnConnections: {
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
output natRuleResourceIds array = [
  for (natRule, index) in natRules: vpnGateway_natRules[index].outputs.resourceId
]

@description('The resource IDs of the VPN connections.')
output vpnConnectionResourceIds array = [
  for (connection, index) in vpnConnections: vpnGateway_vpnConnections[index].outputs.resourceId
]

// =============== //
//   Definitions   //
// =============== //

@export()
@description('The type of BGP settings for VPN Gateway.')
type bgpSettingsType = {
  @description('Required. The BGP speaker\'s ASN (Autonomous System Number).')
  @minValue(0)
  @maxValue(4294967295)
  asn: int

  @description('Optional. The weight added to routes learned from this BGP speaker.')
  @minValue(0)
  @maxValue(100)
  peerWeight: int?

  @description('Optional. BGP peering addresses for this VPN Gateway.')
  bgpPeeringAddresses: {
    @description('Optional. The IP configuration ID.')
    ipconfigurationId: string?
    
    @description('Optional. The custom BGP peering addresses.')
    customBgpIpAddresses: string[]?
  }[]?
}

@export()
@description('The type of routing configuration for VPN connections.')
type routingConfigurationType = {
  @description('Optional. The associated route table for this connection.')
  associatedRouteTable: {
    @description('Required. The resource ID of the route table.')
    id: string
  }?

  @description('Optional. The propagated route tables for this connection.')
  propagatedRouteTables: {
    @description('Optional. The list of route table resource IDs to propagate to.')
    ids: {
      @description('Required. The resource ID of the route table.')
      id: string
    }[]?
    
    @description('Optional. The list of labels to propagate to.')
    labels: string[]?
  }?

  @description('Optional. The virtual network routes for this connection.')
  vnetRoutes: {
    @description('Optional. The list of static routes.')
    staticRoutes: {
      @description('Optional. The name of the static route.')
      name: string?
      
      @description('Optional. The address prefixes for the static route.')
      addressPrefixes: string[]?
      
      @description('Optional. The next hop IP address for the static route.')
      nextHopIpAddress: string?
    }[]?
    
    @description('Optional. Static routes configuration.')
    staticRoutesConfig: {
      @description('Optional. Determines whether the NVA in a SPOKE VNET is bypassed for traffic with destination in spoke.')
      vnetLocalRouteOverrideCriteria: ('Contains' | 'Equal')?
    }?
  }?
}

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
  
  @description('Optional. Routing configuration.')
  routingConfiguration: routingConfigurationType?
  
  @description('Optional. Routing weight.')
  routingWeight: int?
  
  @description('Optional. Shared key.')
  sharedKey: string?
  
  @description('Optional. Use local Azure IP address.')
  useLocalAzureIpAddress: bool?
  
  @description('Optional. Use policy-based traffic selectors.')
  usePolicyBasedTrafficSelectors: bool?
  
  @description('Optional. VPN connection protocol type.')
  vpnConnectionProtocolType: ('IKEv1' | 'IKEv2')?
  
  @description('Optional. IPSec policies.')
  ipsecPolicies: ipsecPolicyType[]?
  
  @description('Optional. Traffic selector policies.')
  trafficSelectorPolicies: trafficSelectorPolicyType[]?
  
  @description('Optional. VPN link connections.')
  vpnLinkConnections: vpnSiteLinkConnectionType[]?
}

@export()
@description('The type of NAT rule for VPN Gateway.')
type natRuleType = {
  @description('Required. The name of the NAT rule.')
  name: string
  
  @description('Optional. External mappings.')
  externalMappings: vpnNatRuleMappingType[]?
  
  @description('Optional. Internal mappings.')
  internalMappings: vpnNatRuleMappingType[]?
  
  @description('Optional. IP configuration ID.')
  ipConfigurationId: string?
  
  @description('Optional. NAT rule mode.')
  mode: ('EgressSnat' | 'IngressSnat')?
  
  @description('Optional. NAT rule type.')
  type: ('Dynamic' | 'Static')?
}
