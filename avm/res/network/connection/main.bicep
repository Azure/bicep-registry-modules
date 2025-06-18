metadata name = 'Virtual Network Gateway Connections'
metadata description = 'This module deploys a Virtual Network Gateway Connection.'

@description('Required. Remote connection name.')
param name string

@description('Optional. Specifies a VPN shared key. The same value has to be specified on both Virtual Network Gateways.')
@secure()
param vpnSharedKey string = ''

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Gateway connection connectionType.')
@allowed([
  'IPsec'
  'Vnet2Vnet'
  'ExpressRoute'
  'VPNClient'
])
param connectionType string = 'IPsec'

@description('Optional. Value to specify if BGP is enabled or not.')
param enableBgp bool = false

@allowed([
  'Default'
  'InitiatorOnly'
  'ResponderOnly'
])
@description('Optional. The connection connectionMode for this connection. Available for IPSec connections.')
param connectionMode string = 'Default'

@allowed([
  'IKEv1'
  'IKEv2'
])
@description('Optional. Connection connectionProtocol used for this connection. Available for IPSec connections.')
param connectionProtocol string = 'IKEv2'

@minValue(9)
@maxValue(3600)
@description('Optional. The dead peer detection timeout of this connection in seconds. Setting the timeout to shorter periods will cause IKE to rekey more aggressively, causing the connection to appear to be disconnected in some instances. The general recommendation is to set the timeout between 30 to 45 seconds.')
param dpdTimeoutSeconds int = 45

@description('Optional. Enable policy-based traffic selectors.')
param usePolicyBasedTrafficSelectors bool = false

@description('Optional. The traffic selector policies to be considered by this connection.')
param trafficSelectorPolicies trafficSelectorPolicyType[] = []

@description('Optional. Bypass the ExpressRoute gateway when accessing private-links. ExpressRoute FastPath (expressRouteGatewayBypass) must be enabled. Only available when connection connectionType is Express Route.')
param enablePrivateLinkFastPath bool = false

@description('Optional. Bypass ExpressRoute Gateway for data forwarding. Only available when connection connectionType is Express Route.')
param expressRouteGatewayBypass bool = false

@description('Optional. Use private local Azure IP for the connection. Only available for IPSec Virtual Network Gateways that use the Azure Private IP Property.')
param useLocalAzureIpAddress bool = false

@description('Optional. The IPSec Policies to be considered by this connection.')
param customIPSecPolicy customIPSecPolicyType = {
  saLifeTimeSeconds: 0
  saDataSizeKilobytes: 0
  ipsecEncryption: 'None'
  ipsecIntegrity: 'MD5'
  ikeEncryption: 'DES'
  ikeIntegrity: 'MD5'
  dhGroup: 'None'
  pfsGroup: 'None'
}

@description('Optional. The weight added to routes learned from this BGP speaker.')
param routingWeight int?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

@description('Optional. Tags of the resource.')
param tags resourceInput<'Microsoft.Network/connections@2024-05-01'>.tags?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Required. The primary Virtual Network Gateway.')
param virtualNetworkGateway1 virtualNetworkGatewayType

@description('Optional. The remote Virtual Network Gateway resource ID. Used for connection connectionType [Vnet2Vnet].')
param virtualNetworkGateway2ResourceId string = ''

@description('Optional. The remote peer resource ID. Used for connection connectionType [ExpressRoute].')
param peerResourceId string = ''

@description('Optional. The Authorization Key to connect to an Express Route Circuit. Used for connection type [ExpressRoute].')
@secure()
param authorizationKey string = ''

@description('Optional. The local network gateway resource ID. Used for connection type [IPsec].')
param localNetworkGateway2ResourceId string = ''

@description('Optional. GatewayCustomBgpIpAddresses to be used for virtual network gateway Connection. Enables APIPA (Automatic Private IP Addressing) for custom BGP IP addresses on both Azure and on-premises sides.')
param gatewayCustomBgpIpAddresses gatewayCustomBgpIpAddressType[] = []

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.network-connection.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource connection 'Microsoft.Network/connections@2024-05-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    connectionType: connectionType
    connectionMode: connectionType == 'IPsec' ? connectionMode : null
    connectionProtocol: connectionType == 'IPsec' ? connectionProtocol : null
    dpdTimeoutSeconds: connectionType == 'IPsec' ? dpdTimeoutSeconds : null
    enablePrivateLinkFastPath: connectionType == 'ExpressRoute' ? enablePrivateLinkFastPath : null
    expressRouteGatewayBypass: connectionType == 'ExpressRoute' ? expressRouteGatewayBypass : null
    virtualNetworkGateway1: virtualNetworkGateway1
    virtualNetworkGateway2: connectionType == 'Vnet2Vnet' && !empty(virtualNetworkGateway2ResourceId) ? any({ id: virtualNetworkGateway2ResourceId }) : null
    localNetworkGateway2: connectionType == 'IPsec' && !empty(localNetworkGateway2ResourceId) ? any({ id: localNetworkGateway2ResourceId }) : null
    peer: connectionType == 'ExpressRoute' && !empty(peerResourceId) ? { id: peerResourceId } : null
    authorizationKey: connectionType == 'ExpressRoute' && !empty(authorizationKey) ? authorizationKey : null
    sharedKey: connectionType != 'ExpressRoute' ? vpnSharedKey : null
    trafficSelectorPolicies: trafficSelectorPolicies
    usePolicyBasedTrafficSelectors: usePolicyBasedTrafficSelectors
    ipsecPolicies: customIPSecPolicy.ipsecEncryption != 'None'
      ? [
          {
            saLifeTimeSeconds: customIPSecPolicy.saLifeTimeSeconds
            saDataSizeKilobytes: customIPSecPolicy.saDataSizeKilobytes
            ipsecEncryption: customIPSecPolicy.ipsecEncryption
            ipsecIntegrity: customIPSecPolicy.ipsecIntegrity
            ikeEncryption: customIPSecPolicy.ikeEncryption
            ikeIntegrity: customIPSecPolicy.ikeIntegrity
            dhGroup: customIPSecPolicy.dhGroup
            pfsGroup: customIPSecPolicy.pfsGroup
          }
        ]
      : null
    routingWeight: routingWeight
    enableBgp: enableBgp
    useLocalAzureIpAddress: connectionType == 'IPsec' ? useLocalAzureIpAddress : null
    gatewayCustomBgpIpAddresses: connectionType == 'IPsec' && !empty(gatewayCustomBgpIpAddresses) ? gatewayCustomBgpIpAddresses : null
  }
}

resource connection_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: connection
}

// ================//
// Outputs         //
// ================//
@description('The resource group the remote connection was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the remote connection.')
output name string = connection.name

@description('The resource ID of the remote connection.')
output resourceId string = connection.id

@description('The location the resource was deployed into.')
output location string = connection.location


// =============== //
//   Definitions   //
// =============== //

@export()
@description('The custom IPSec policy configuration for the connection.')
type customIPSecPolicyType = {
  @description('Required. The IPSec Security Association (also called Quick Mode or Phase 2 SA) lifetime in seconds for a site to site VPN tunnel.')
  saLifeTimeSeconds: int

  @description('Required. The IPSec Security Association (also called Quick Mode or Phase 2 SA) payload size in KB for a site to site VPN tunnel.')
  saDataSizeKilobytes: int

  @description('Required. The IPSec encryption algorithm (IKE phase 1).')
  ipsecEncryption: 'None' | 'DES' | 'DES3' | 'AES128' | 'AES192' | 'AES256' | 'GCMAES128' | 'GCMAES192' | 'GCMAES256'

  @description('Required. The IPSec integrity algorithm (IKE phase 1).')
  ipsecIntegrity: 'MD5' | 'SHA1' | 'SHA256' | 'GCMAES128' | 'GCMAES192' | 'GCMAES256'

  @description('Required. The IKE encryption algorithm (IKE phase 2).')
  ikeEncryption: 'DES' | 'DES3' | 'AES128' | 'AES192' | 'AES256' | 'GCMAES256' | 'GCMAES128'

  @description('Required. The IKE integrity algorithm (IKE phase 2).')
  ikeIntegrity: 'MD5' | 'SHA1' | 'SHA256' | 'SHA384' | 'GCMAES256' | 'GCMAES128'

  @description('Required. The DH Group used in IKE Phase 1 for initial SA.')
  dhGroup: 'None' | 'DHGroup1' | 'DHGroup2' | 'DHGroup14' | 'DHGroup2048' | 'ECP256' | 'ECP384' | 'DHGroup24'

  @description('Required. The Pfs Group used in IKE Phase 2 for new child SA.')
  pfsGroup: 'None' | 'PFS1' | 'PFS2' | 'PFS2048' | 'ECP256' | 'ECP384' | 'PFS24' | 'PFS14' | 'PFSMM'
}

@export()
@description('The virtual network gateway configuration.')
type virtualNetworkGatewayType = {
  @description('Required. Resource ID of the virtual network gateway.')
  id: string
}

@export()
@description('Gateway custom BGP IP address configuration for APIPA.')
type gatewayCustomBgpIpAddressType = {
  @description('Required. The custom BgpPeeringAddress which belongs to IpconfigurationId.')
  customBgpIpAddress: string

  @description('Required. The IpconfigurationId of ipconfiguration which belongs to gateway.')
  ipConfigurationId: string
}

@export()
@description('Traffic selector policy configuration.')
type trafficSelectorPolicyType = {
  @description('Required. A collection of local address spaces in CIDR format.')
  localAddressRanges: string[]

  @description('Required. A collection of remote address spaces in CIDR format.')
  remoteAddressRanges: string[]
}

