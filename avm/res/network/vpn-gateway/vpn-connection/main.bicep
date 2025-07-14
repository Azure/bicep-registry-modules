metadata name = 'VPN Gateway VPN Connections'
metadata description = 'This module deploys a VPN Gateway VPN Connection.'

@description('Required. The name of the VPN connection.')
param name string

@description('Conditional. The name of the parent VPN gateway this VPN connection is associated with. Required if the template is used in a standalone deployment.')
param vpnGatewayName string

@description('Optional. The IPSec policies to be considered by this connection.')
param ipsecPolicies ipsecPolicyType[] = []

@description('Optional. The traffic selector policies to be considered by this connection.')
param trafficSelectorPolicies trafficSelectorPolicyType[] = []

@description('Optional. List of all VPN site link connections to the gateway.')
param vpnLinkConnections vpnSiteLinkConnectionType[] = []

@description('Optional. Routing configuration indicating the associated and propagated route tables for this connection.')
param routingConfiguration routingConfigurationType?

@description('Optional. Enable policy-based traffic selectors.')
param usePolicyBasedTrafficSelectors bool = false

@description('Optional. Use local Azure IP to initiate connection.')
param useLocalAzureIpAddress bool = false

@description('Optional. Enable rate limiting.')
param enableRateLimiting bool = false

@description('Optional. Enable internet security.')
param enableInternetSecurity bool = false

@description('Optional. Enable BGP flag.')
param enableBgp bool = false

@description('Optional. Routing weight for VPN connection.')
param routingWeight int = 0

@description('Optional. Expected bandwidth in MBPS. This parameter is deprecated and should be avoided in favor of VpnSiteLinkConnection configuration.')
param connectionBandwidth int?

@description('Optional. Gateway connection protocol.')
@allowed([
  'IKEv1'
  'IKEv2'
])
param vpnConnectionProtocolType string = 'IKEv2'

@description('Optional. SharedKey for the VPN connection.')
@secure()
param sharedKey string = ''

@description('Optional. Reference to a VPN site to link to.')
param remoteVpnSiteResourceId string = ''

resource vpnGateway 'Microsoft.Network/vpnGateways@2024-07-01' existing = {
  name: vpnGatewayName
}

resource vpnConnection 'Microsoft.Network/vpnGateways/vpnConnections@2024-07-01' = {
  name: name
  parent: vpnGateway
  properties: {
    connectionBandwidth: connectionBandwidth
    enableBgp: enableBgp
    enableInternetSecurity: enableInternetSecurity
    enableRateLimiting: enableRateLimiting
    ipsecPolicies: ipsecPolicies
    remoteVpnSite: !empty(remoteVpnSiteResourceId)
      ? {
          id: remoteVpnSiteResourceId
        }
      : null
    routingConfiguration: routingConfiguration
    routingWeight: routingWeight
    sharedKey: sharedKey
    trafficSelectorPolicies: trafficSelectorPolicies
    useLocalAzureIpAddress: useLocalAzureIpAddress
    usePolicyBasedTrafficSelectors: usePolicyBasedTrafficSelectors
    vpnConnectionProtocolType: vpnConnectionProtocolType
    vpnLinkConnections: vpnLinkConnections
  }
}

@description('The name of the VPN connection.')
output name string = vpnConnection.name

@description('The resource ID of the VPN connection.')
output resourceId string = vpnConnection.id

@description('The name of the resource group the VPN connection was deployed into.')
output resourceGroupName string = resourceGroup().name

// =============== //
//   Definitions   //
// =============== //

@export()
@description('The type for IPSec policy.')
type ipsecPolicyType = {
  @description('Required. The DH Group used in IKE Phase 1 for initial SA.')
  dhGroup: ('None' | 'DHGroup1' | 'DHGroup2' | 'DHGroup14' | 'DHGroup2048' | 'ECP256' | 'ECP384' | 'DHGroup24')

  @description('Required. The IKE encryption algorithm (IKE phase 2).')
  ikeEncryption: ('DES' | 'DES3' | 'AES128' | 'AES192' | 'AES256' | 'GCMAES256' | 'GCMAES128')

  @description('Required. The IKE integrity algorithm (IKE phase 2).')
  ikeIntegrity: ('MD5' | 'SHA1' | 'SHA256' | 'SHA384' | 'GCMAES256' | 'GCMAES128')

  @description('Required. The IPSec encryption algorithm (IKE phase 1).')
  ipsecEncryption: ('None' | 'DES' | 'DES3' | 'AES128' | 'AES192' | 'AES256' | 'GCMAES128' | 'GCMAES192' | 'GCMAES256')

  @description('Required. The IPSec integrity algorithm (IKE phase 1).')
  ipsecIntegrity: ('MD5' | 'SHA1' | 'SHA256' | 'GCMAES128' | 'GCMAES192' | 'GCMAES256')

  @description('Required. The Pfs Group used in IKE Phase 2 for new child SA.')
  pfsGroup: ('None' | 'PFS1' | 'PFS2' | 'PFS2048' | 'ECP256' | 'ECP384' | 'PFS24' | 'PFS14' | 'PFSMM')

  @description('Required. The IPSec Security Association payload size in KB for a site to site VPN tunnel.')
  saDataSizeKilobytes: int

  @description('Required. The IPSec Security Association lifetime in seconds for a site to site VPN tunnel.')
  saLifeTimeSeconds: int
}

@export()
@description('The type for traffic selector policy.')
type trafficSelectorPolicyType = {
  @description('Required. A collection of local address spaces in CIDR format.')
  localAddressRanges: string[]

  @description('Required. A collection of remote address spaces in CIDR format.')
  remoteAddressRanges: string[]
}

@export()
@description('The type for VPN site link connection.')
type vpnSiteLinkConnectionType = {
  @description('Optional. The name of the VPN site link connection.')
  name: string?

  @description('Optional. Properties of the VPN site link connection.')
  properties: {
    @description('Optional. Expected bandwidth in MBPS.')
    connectionBandwidth: int?

    @description('Optional. Dead Peer Detection timeout in seconds for VPN link connection.')
    dpdTimeoutSeconds: int?

    @description('Optional. EnableBgp flag.')
    enableBgp: bool?

    @description('Optional. EnableBgp flag for rate limiting.')
    enableRateLimiting: bool?

    @description('Optional. The IPSec Policies to be considered by this connection.')
    ipsecPolicies: ipsecPolicyType[]?

    @description('Optional. Routing weight for VPN connection.')
    routingWeight: int?

    @description('Optional. SharedKey for the VPN connection.')
    sharedKey: string?

    @description('Optional. Use local azure ip to initiate connection.')
    useLocalAzureIpAddress: bool?

    @description('Optional. Enable policy-based traffic selectors.')
    usePolicyBasedTrafficSelectors: bool?

    @description('Optional. Connection protocol used for this connection.')
    vpnConnectionProtocolType: ('IKEv2' | 'IKEv1')?

    @description('Optional. VPN link connection mode.')
    vpnLinkConnectionMode: ('Default' | 'ResponderOnly' | 'InitiatorOnly')?

    @description('Optional. Id of the connected VPN site link.')
    vpnSiteLink: {
      @description('Required. Resource ID of the VPN site link.')
      id: string
    }?

    @description('Optional. List of egress NAT rules.')
    egressNatRules: {
      @description('Required. Resource ID of the egress NAT rule.')
      id: string
    }[]?

    @description('Optional. List of ingress NAT rules.')
    ingressNatRules: {
      @description('Required. Resource ID of the ingress NAT rule.')
      id: string
    }[]?

    @description('Optional. VPN gateway custom BGP addresses used by this connection.')
    vpnGatewayCustomBgpAddresses: {
      @description('Required. The custom BgpPeeringAddress which belongs to IpconfigurationId.')
      customBgpIpAddress: string

      @description('Required. The IpconfigurationId of ipconfiguration which belongs to gateway.')
      ipConfigurationId: string
    }[]?
  }?
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
