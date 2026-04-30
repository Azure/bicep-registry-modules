metadata name = 'Azure Virtual WAN'
metadata description = 'This pattern will create a Virtual WAN and optionally create Virtual Hubs, Azure Firewalls, and VPN/ExpressRoute Gateways.'

@description('Optional. Azure region where the Virtual WAN will be created.')
param location string = resourceGroup().location

@description('Required. The parameters for the Virtual WAN.')
param virtualWanParameters virtualWanParameterType

@description('Required. The parameters for the Virtual Hubs and associated networking components, required if configuring Virtual Hubs.')
param virtualHubParameters virtualHubParameterType[]

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.7.0'
@description('Optional. The lock settings for the Virtual WAN and associated components.')
param lock lockType?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Tags to be applied to all resources.')
param tags resourceInput<'Microsoft.Network/virtualWans@2025-01-01'>.tags = {}

// ============ //
// Variables    //
// ============ //

@description('Combined tags for all resources.')
var combinedTags = union(tags ?? {}, virtualWanParameters.?tags ?? {})

@description('Computed lock settings for consistent application.')
var computedLock = virtualWanParameters.?lock ?? lock ?? {}

@description('Virtual WAN location with fallback.')
var virtualWanLocation = virtualWanParameters.?location ?? location

@description('Whether P2S VPN Server Configuration should be created.')
var createP2sVpnServerConfig = virtualWanParameters.?p2sVpnParameters.?createP2sVpnServerConfiguration ?? false

@description('Hub deployment configurations with computed flags.')
var hubConfigurations = [
  for (hub, i) in virtualHubParameters!: {
    hub: hub
    index: i
    deploySecureHub: hub.?secureHubParameters.?deploySecureHub ?? false
    deployP2sGateway: hub.?p2sVpnParameters.?deployP2SVpnGateway ?? false
    deployS2sGateway: hub.?s2sVpnParameters.?deployS2SVpnGateway ?? false
    deployExpressRoute: hub.?expressRouteParameters.?deployExpressRouteGateway ?? false
    hubTags: union(combinedTags, hub.?tags ?? {})
    hubLocation: hub.hubLocation
  }
]

module virtualWan 'br/public:avm/res/network/virtual-wan:0.4.3' = {
  name: '${uniqueString(deployment().name, location)}-${virtualWanParameters.virtualWanName}'
  params: {
    // Required parameters
    name: virtualWanParameters.virtualWanName
    // Optional parameters
    location: virtualWanLocation
    allowBranchToBranchTraffic: virtualWanParameters.?allowBranchToBranchTraffic
    enableTelemetry: enableTelemetry
    lock: computedLock
    roleAssignments: virtualWanParameters.?roleAssignments
    tags: combinedTags
    type: virtualWanParameters.?type
  }
}

module virtualHubModule 'br/public:avm/res/network/virtual-hub:0.4.3' = [
  for config in hubConfigurations: {
    name: '${uniqueString(deployment().name, location)}-${config.hub.hubName}'
    params: {
      // Required parameters
      name: config.hub.hubName
      addressPrefix: config.hub.hubAddressPrefix
      location: config.hubLocation
      virtualWanResourceId: virtualWan.outputs.resourceId
      // Optional parameters
      allowBranchToBranchTraffic: config.hub.?allowBranchToBranchTraffic
      enableTelemetry: enableTelemetry
      hubRoutingPreference: config.hub.?hubRoutingPreference
      hubRouteTables: config.hub.?hubRouteTables
      hubVirtualNetworkConnections: config.hub.?hubVirtualNetworkConnections
      lock: computedLock
      // Note: routingIntent is deployed separately after firewall creation
      sku: config.hub.?sku
      tags: config.hubTags
      virtualRouterAsn: config.hub.?virtualRouterAsn
      virtualRouterAutoScaleConfiguration: config.hub.?virtualRouterAutoScaleConfiguration
      virtualRouterIps: config.hub.?virtualRouterIps
    }
  }
]

module firewallModule 'br/public:avm/res/network/azure-firewall:0.10.1' = [
  for config in hubConfigurations: if (config.deploySecureHub) {
    name: config.hub.?secureHubParameters.?azureFirewallName!
    params: {
      name: config.hub.?secureHubParameters.?azureFirewallName!
      azureSkuTier: config.hub.?secureHubParameters.?azureFirewallSku
      virtualHubResourceId: virtualHubModule[config.index].outputs.resourceId
      firewallPolicyId: config.hub.?secureHubParameters.?firewallPolicyResourceId
      location: virtualHubModule[config.index].outputs.location
      hubIPAddresses: {
        publicIPs: {
          count: config.hub.?secureHubParameters.?azureFirewallPublicIPCount
        }
      }
      autoscaleMaxCapacity: config.hub.?secureHubParameters.?autoscaleMaxCapacity
      autoscaleMinCapacity: config.hub.?secureHubParameters.?autoscaleMinCapacity
      threatIntelMode: config.hub.?secureHubParameters.?threatIntelMode
      maintenanceConfiguration: config.hub.?secureHubParameters.?maintenanceConfiguration
      enableTelemetry: enableTelemetry
      availabilityZones: config.hub.?secureHubParameters.?availabilityZones
      diagnosticSettings: config.hub.?secureHubParameters.?diagnosticSettings
      tags: config.hubTags
      lock: computedLock
    }
  }
]

module vpnServerConfiguration 'br/public:avm/res/network/vpn-server-configuration:0.2.0' = if (createP2sVpnServerConfig) {
  name: virtualWanParameters.?p2sVpnParameters.p2sVpnServerConfigurationName!
  params: {
    name: virtualWanParameters.?p2sVpnParameters.p2sVpnServerConfigurationName!
    location: virtualWanLocation
    aadAudience: virtualWanParameters.?p2sVpnParameters.?aadAudience
    aadIssuer: virtualWanParameters.?p2sVpnParameters.?aadIssuer
    aadTenant: virtualWanParameters.?p2sVpnParameters.?aadTenant
    enableTelemetry: enableTelemetry
    lock: computedLock
    p2sConfigurationPolicyGroups: virtualWanParameters.?p2sVpnParameters.?p2sConfigurationPolicyGroups
    radiusClientRootCertificates: virtualWanParameters.?p2sVpnParameters.?radiusClientRootCertificates
    radiusServerAddress: virtualWanParameters.?p2sVpnParameters.?radiusServerAddress
    radiusServerRootCertificates: virtualWanParameters.?p2sVpnParameters.?radiusServerRootCertificates
    radiusServerSecret: virtualWanParameters.?p2sVpnParameters.?radiusServerSecret
    radiusServers: virtualWanParameters.?p2sVpnParameters.?radiusServers
    tags: combinedTags
    vpnAuthenticationTypes: virtualWanParameters.?p2sVpnParameters.?vpnAuthenticationTypes
    vpnClientIpsecPolicies: virtualWanParameters.?p2sVpnParameters.?vpnClientIpsecPolicies
    vpnClientRevokedCertificates: virtualWanParameters.?p2sVpnParameters.?vpnClientRevokedCertificates
    vpnClientRootCertificates: virtualWanParameters.?p2sVpnParameters.?vpnClientRootCertificates
    vpnProtocols: virtualWanParameters.?p2sVpnParameters.?vpnProtocols ?? ['OpenVPN']
  }
}

module p2sVpnGatewayModule 'br/public:avm/res/network/p2s-vpn-gateway:0.1.4' = [
  for config in hubConfigurations: if (config.deployP2sGateway && createP2sVpnServerConfig) {
    name: config.hub.?p2sVpnParameters.?vpnGatewayName!
    params: {
      name: config.hub.?p2sVpnParameters.?vpnGatewayName!
      location: virtualHubModule[config.index].outputs.location
      virtualHubResourceId: virtualHubModule[config.index].outputs.resourceId
      vpnServerConfigurationResourceId: vpnServerConfiguration.?outputs.?resourceId!
      associatedRouteTableName: config.hub.?p2sVpnParameters.?vpnGatewayAssociatedRouteTable
      vpnGatewayScaleUnit: config.hub.?p2sVpnParameters.?vpnGatewayScaleUnit
      vpnClientAddressPoolAddressPrefixes: config.hub.?p2sVpnParameters.?vpnClientAddressPoolAddressPrefixes
      p2SConnectionConfigurationsName: config.hub.?p2sVpnParameters.?connectionConfigurationsName
      customDnsServers: config.hub.?p2sVpnParameters.?customDnsServers
      enableInternetSecurity: config.hub.?p2sVpnParameters.?enableInternetSecurity
      enableTelemetry: enableTelemetry
      inboundRouteMapResourceId: config.hub.?p2sVpnParameters.?inboundRouteMapResourceId
      isRoutingPreferenceInternet: config.hub.?p2sVpnParameters.?isRoutingPreferenceInternet
      lock: computedLock
      outboundRouteMapResourceId: config.hub.?p2sVpnParameters.?outboundRouteMapResourceId
      propagatedLabelNames: config.hub.?p2sVpnParameters.?propagatedLabelNames
      propagatedRouteTableNames: config.hub.?p2sVpnParameters.?propagatedRouteTableNames
      tags: config.hubTags
      vnetRoutesStaticRoutes: config.hub.?p2sVpnParameters.?vnetRoutesStaticRoutes
    }
  }
]

module s2sVpnGatewayModule 'br/public:avm/res/network/vpn-gateway:0.3.0' = [
  for config in hubConfigurations: if (config.deployS2sGateway) {
    name: config.hub.?s2sVpnParameters.?vpnGatewayName!
    params: {
      // Required parameters
      name: config.hub.?s2sVpnParameters.?vpnGatewayName!
      location: virtualHubModule[config.index].outputs.location
      virtualHubResourceId: virtualHubModule[config.index].outputs.resourceId
      // Optional parameters
      bgpSettings: config.hub.?s2sVpnParameters.?bgpSettings
      enableBgpRouteTranslationForNat: config.hub.?s2sVpnParameters.?enableBgpRouteTranslationForNat
      isRoutingPreferenceInternet: config.hub.?s2sVpnParameters.?isRoutingPreferenceInternet
      natRules: config.hub.?s2sVpnParameters.?natRules
      vpnConnections: config.hub.?s2sVpnParameters.?vpnConnections ?? []
      vpnGatewayScaleUnit: config.hub.?s2sVpnParameters.?vpnGatewayScaleUnit
      enableTelemetry: enableTelemetry
      tags: config.hubTags
      lock: computedLock
    }
  }
]

module expressRouteGatewayModule 'br/public:avm/res/network/express-route-gateway:0.8.0' = [
  for config in hubConfigurations: if (config.deployExpressRoute) {
    name: config.hub.?expressRouteParameters.?expressRouteGatewayName!
    params: {
      // Required parameters
      name: config.hub.?expressRouteParameters.?expressRouteGatewayName!
      location: virtualHubModule[config.index].outputs.location
      virtualHubResourceId: virtualHubModule[config.index].outputs.resourceId
      // Optional parameters
      allowNonVirtualWanTraffic: config.hub.?expressRouteParameters.?allowNonVirtualWanTraffic
      autoScaleConfigurationBoundsMin: config.hub.?expressRouteParameters.?autoScaleConfigurationBoundsMin
      autoScaleConfigurationBoundsMax: config.hub.?expressRouteParameters.?autoScaleConfigurationBoundsMax
      expressRouteConnections: config.hub.?expressRouteParameters.?expressRouteConnections
      enableTelemetry: enableTelemetry
      tags: config.hubTags
      lock: computedLock
    }
  }
]

// Deploy routing intent after firewall is created
resource routingIntent 'Microsoft.Network/virtualHubs/routingIntent@2025-01-01' = [
  for config in hubConfigurations: if (config.deploySecureHub && config.hub.?secureHubParameters.?routingIntent != null) {
    name: '${config.hub.hubName}/routingIntent'
    properties: {
      routingPolicies: concat(
        config.hub.?secureHubParameters.?routingIntent.?internetToFirewall == true
          ? [
              {
                name: 'InternetTrafficPolicy'
                destinations: ['Internet']
                nextHop: firewallModule[config.index].?outputs.resourceId!
              }
            ]
          : [],
        config.hub.?secureHubParameters.?routingIntent.?privateToFirewall == true
          ? [
              {
                name: 'PrivateTrafficPolicy'
                destinations: ['PrivateTraffic']
                nextHop: firewallModule[config.index].?outputs.resourceId!
              }
            ]
          : []
      )
    }
    dependsOn: [
      virtualHubModule[config.index]
      firewallModule[config.index]
      p2sVpnGatewayModule[config.index]
      s2sVpnGatewayModule[config.index]
      expressRouteGatewayModule[config.index]
    ]
  }
]

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.network-virtualwan.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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
// ============ //
// Outputs      //
// ============ //

@description('The resource ID of the Virtual WAN.')
output resourceId string = virtualWan.outputs.resourceId

@description('The name of the Virtual WAN.')
output name string = virtualWan.outputs.name

@description('The location of the Virtual WAN.')
output location string = virtualWan.outputs.location

@description('The resource group where the resource is deployed.')
output resourceGroupName string = resourceGroup().name

@description('The array containing the Virtual Hub information with deployment status.')
output virtualHubs array = [
  #disable-next-line outputs-should-not-contain-secrets // hubConfigurations references @secure() authorizationKey/sharedKey but this output only exposes resource IDs and deployment flags
  for config in hubConfigurations: {
    name: virtualHubModule[config.index].outputs.name
    resourceId: virtualHubModule[config.index].outputs.resourceId
    resourceGroupName: virtualHubModule[config.index].outputs.resourceGroupName
    location: virtualHubModule[config.index].outputs.location
    deploymentStatus: {
      hasSecureHub: config.deploySecureHub
      hasP2sGateway: config.deployP2sGateway
      hasS2sGateway: config.deployS2sGateway
      hasExpressRoute: config.deployExpressRoute
    }
  }
]

@description('The resource ID of the VPN Server Configuration, if created.')
output vpnServerConfigurationResourceId string = createP2sVpnServerConfig
  ? vpnServerConfiguration!.outputs.resourceId
  : ''

@description('Deployment summary with component counts.')
#disable-next-line outputs-should-not-contain-secrets // hubConfigurations references @secure() authorizationKey/sharedKey but this output only exposes counts and flags
output deploymentSummary object = {
  virtualWanName: virtualWan.outputs.name
  virtualWanType: virtualWanParameters.?type ?? 'Standard'
  #disable-next-line outputs-should-not-contain-secrets // false positive - only computing length, not exposing secrets
  totalHubs: length(virtualHubParameters ?? [])
  p2sVpnServerConfigured: createP2sVpnServerConfig
  componentCounts: {
    #disable-next-line outputs-should-not-contain-secrets // false positive - only computing count, not exposing secrets
    secureHubs: length(filter(hubConfigurations, config => config.deploySecureHub))
    #disable-next-line outputs-should-not-contain-secrets // false positive - only computing count, not exposing secrets
    p2sGateways: length(filter(hubConfigurations, config => config.deployP2sGateway))
    #disable-next-line outputs-should-not-contain-secrets // false positive - only computing count, not exposing secrets
    s2sGateways: length(filter(hubConfigurations, config => config.deployS2sGateway))
    #disable-next-line outputs-should-not-contain-secrets // false positive - only computing count, not exposing secrets
    expressRouteGateways: length(filter(hubConfigurations, config => config.deployExpressRoute))
  }
}

@description('Imports the VPN client IPsec policies type from the VPN server configuration module.')
import { vpnClientIpsecPoliciesType } from 'br/public:avm/res/network/vpn-server-configuration:0.1.2'

@description('Imports the VNet routes static routes type from the P2S VPN gateway module.')
import { vnetRoutesStaticRoutesType } from 'br/public:avm/res/network/p2s-vpn-gateway:0.1.3'

@description('Imports types from the Virtual Hub module.')
import { hubVirtualNetworkConnectionType, routingIntentType, hubRouteTableType } from 'br/public:avm/res/network/virtual-hub:0.4.3'

@description('Imports the full diagnostic setting type from the AVM common types module.')
import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.7.0'

type virtualWanParameterType = {
  @description('Required. The name of the Virtual WAN.')
  virtualWanName: string

  @description('Optional. The Azure region where the Virtual WAN will be created. Defaults to the resource group location if not specified.')
  location: string?

  @description('Optional. Whether to allow branch-to-branch traffic within the Virtual WAN.')
  allowBranchToBranchTraffic: bool?

  @description('Optional. Lock settings for the Virtual WAN and associated resources.')
  lock: lockType?

  @description('Optional. Point-to-site VPN server configuration parameters for the Virtual WAN.')
  p2sVpnParameters: {
    @description('Required. Whether to create a new P2S VPN server configuration.')
    createP2sVpnServerConfiguration: bool

    @description('Optional. Name of the P2S VPN server configuration.')
    p2sVpnServerConfigurationName: string?

    @description('Conditional. Entra ID audience for VPN authentication. Required if using Entra ID audience for VPN authentication.')
    aadAudience: string?

    @description('Conditional. Entra ID issuer for VPN authentication. Required if using Entra ID authentication.')
    aadIssuer: string?

    @description('Conditional. Entra ID tenant for VPN authentication. Required if using Entra ID authentication.')
    aadTenant: string?

    @description('Conditional. Configure user groups and IP Address Pools. Required if using Entra ID authentication.')
    p2sConfigurationPolicyGroups: array?

    @description('Conditional. List of RADIUS client root certificates. Required if using RADIUS authentication.')
    radiusClientRootCertificates: array?

    @description('Conditional. RADIUS server address. Required if using RADIUS authentication.')
    radiusServerAddress: string?

    @description('Conditional. List of RADIUS server root certificates. Required if using RADIUS authentication.')
    radiusServerRootCertificates: array?

    @description('Conditional. RADIUS server secret. Required if using RADIUS authentication.')
    @secure()
    radiusServerSecret: string?

    @description('Conditional. List of RADIUS servers. Required if using RADIUS authentication.')
    radiusServers: array?

    @description('Optional. VPN authentication types supported.')
    vpnAuthenticationTypes: ['AAD' | 'Certificate' | 'Radius']?

    @description('Optional. List of VPN client IPsec policies.')
    vpnClientIpsecPolicies: vpnClientIpsecPoliciesType[]?

    @description('Optional. List of revoked VPN client certificates.')
    vpnClientRevokedCertificates: array?

    @description('Optional. List of VPN client root certificates.')
    vpnClientRootCertificates: array?

    @description('Optional. Supported VPN protocols.')
    vpnProtocols: ('IkeV2' | 'OpenVPN')[]?
  }?

  @description('Optional. Role assignments to be applied to the Virtual WAN.')
  roleAssignments: {
    @description('Optional. The name (as GUID) of the role assignment. If not provided, a GUID will be generated.')
    name: string?

    @description('Required. The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
    roleDefinitionIdOrName: string

    @description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
    principalId: string

    @description('Optional. The principal type of the assigned principal ID.')
    principalType: ('ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup' | 'Device')?

    @description('Optional. The description of the role assignment.')
    description: string?

    @description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".')
    condition: string?

    @description('Optional. Version of the condition.')
    conditionVersion: '2.0'?

    @description('Optional. The Resource Id of the delegated managed identity resource.')
    delegatedManagedIdentityResourceId: string?
  }[]?

  @description('Optional. Tags to be applied to the Virtual WAN.')
  tags: resourceInput<'Microsoft.Network/virtualWans@2025-01-01'>.tags?

  @description('Optional. The type of Virtual WAN. Allowed values are Standard or Basic.')
  type: ('Standard' | 'Basic')?
}

type virtualHubParameterType = {
  @description('Required. The name of the Virtual Hub.')
  hubName: string

  @description('Required. The Azure region where the Virtual Hub will be created.')
  hubLocation: string

  @description('Required. The address prefix for the Virtual Hub.')
  hubAddressPrefix: string

  @description('Optional. Whether to allow branch-to-branch traffic within the Virtual Hub.')
  allowBranchToBranchTraffic: bool?

  @description('Optional. The routing preference for the Virtual Hub.')
  hubRoutingPreference: ('ASPath' | 'ExpressRoute' | 'VpnGateway')?

  @description('Optional. The route tables for the Virtual Hub.')
  hubRouteTables: hubRouteTableType[]?

  @description('Optional. The virtual network connections for the Virtual Hub.')
  hubVirtualNetworkConnections: hubVirtualNetworkConnectionType[]?

  @description('Optional. Point-to-site VPN parameters for the Virtual Hub.')
  p2sVpnParameters: {
    @description('Required. Whether to deploy a P2S VPN Gateway.')
    deployP2SVpnGateway: bool

    @description('Conditional. Name of the connection configurations. Required if deployP2SVpnGateway is true.')
    connectionConfigurationsName: string?

    @description('Optional. Custom DNS servers for the P2S VPN Gateway.')
    customDnsServers: array?

    @description('Optional. Enable internet security for the P2S VPN Gateway.')
    enableInternetSecurity: bool?

    @description('Optional. Resource ID of the inbound route map.')
    inboundRouteMapResourceId: string?

    @description('Optional. Whether routing preference is internet.')
    isRoutingPreferenceInternet: bool?

    @description('Optional. Resource ID of the outbound route map.')
    outboundRouteMapResourceId: string?

    @description('Optional. Names of propagated labels.')
    propagatedLabelNames: array?

    @description('Optional. Names of propagated route tables.')
    propagatedRouteTableNames: array?

    @description('Optional. Static routes for VNet routes.')
    vnetRoutesStaticRoutes: vnetRoutesStaticRoutesType?

    @description('Conditional. Name of the VPN Gateway. Required if deployP2SVpnGateway is true.')
    vpnGatewayName: string?

    @description('Conditional. Address prefixes for the VPN client address pool. Required if deployP2SVpnGateway is true.')
    vpnClientAddressPoolAddressPrefixes: array?

    @description('Optional. Scale unit for the VPN Gateway.')
    vpnGatewayScaleUnit: int?

    @description('Optional. Associated route table for the VPN Gateway.')
    vpnGatewayAssociatedRouteTable: ('noneRouteTable' | 'defaultRouteTable')?
  }?

  @description('Optional. Site-to-site VPN parameters for the Virtual Hub.')
  s2sVpnParameters: {
    @description('Required. Whether to deploy a S2S VPN Gateway.')
    deployS2SVpnGateway: bool

    @description('Conditional. Name of the VPN Gateway. Required if deployS2SVpnGateway is true.')
    vpnGatewayName: string?

    @description('Optional. Scale unit for the VPN Gateway.')
    vpnGatewayScaleUnit: int?

    @description('Optional. BGP settings for the VPN Gateway.')
    bgpSettings: {
      @description('Required. ASN for BGP. The default Azure VPN Gateway ASN is 65515. Custom ASN values require contacting Azure Support to enable ASN modification on the VPN Gateway.')
      asn: int

      @description('Optional. BGP peering address.')
      bgpPeeringAddress: string?

      @description('Optional. BGP peering addresses.')
      bgpPeeringAddresses: {
        @description('Optional. IP configuration ID.')
        ipconfigurationId: string?

        @description('Optional. Custom BGP IP addresses.')
        customBgpIpAddresses: string[]?
      }[]?

      @description('Optional. Peer weight for BGP.')
      peerWeight: int?
    }?

    @description('Optional. Enable BGP route translation for NAT.')
    enableBgpRouteTranslationForNat: bool?

    @description('Optional. Whether routing preference is internet.')
    isRoutingPreferenceInternet: bool?

    @description('Optional. Lock settings for the VPN Gateway.')
    lock: lockType?

    @description('Optional. NAT rules for the VPN Gateway.')
    natRules: {
      @description('Conditional. External mappings for NAT rule. Required if defining NAT rules.')
      externalMappings: {
        @description('Required. Address space for external mapping.')
        addressSpace: string
      }[]?

      @description('Conditional. Internal mappings for NAT rule. Required if defining NAT rules.')
      internalMappings: {
        @description('Required. Address space for internal mapping.')
        addressSpace: string
      }[]?

      @description('Conditional. Mode for NAT rule. Required if defining NAT rules.')
      mode: ('EgressSnat' | 'IngressSnat')?

      @description('Required. Name of the NAT rule.')
      name: string

      @description('Conditional. Type of NAT rule. Required if defining NAT rules.')
      type: ('Static' | 'Dynamic')?

      @description('Optional. IP configuration ID.')
      ipConfigurationId: string?
    }[]?

    @description('Optional. VPN connections for the VPN Gateway.')
    vpnConnections: {
      @description('Required. Name of the VPN connection.')
      name: string

      @description('Optional. Connection bandwidth.')
      connectionBandwidth: int?

      @description('Optional. Enable BGP for the connection.')
      enableBgp: bool?

      @description('Optional. Enable internet security for the connection.')
      enableInternetSecurity: bool?

      @description('Optional. Resource ID of the remote VPN site.')
      remoteVpnSiteResourceId: string?

      @description('Optional. Enable rate limiting.')
      enableRateLimiting: bool?

      @description('Optional. Routing configuration for the connection.')
      routingConfiguration: resourceInput<'Microsoft.Network/vpnGateways/vpnConnections@2025-01-01'>.properties.routingConfiguration?

      @description('Optional. Routing weight for the connection.')
      routingWeight: int?

      @description('Optional. Shared key for the connection.')
      @secure()
      sharedKey: string?

      @description('Optional. Use local Azure IP address.')
      useLocalAzureIpAddress: bool?

      @description('Optional. Use policy-based traffic selectors.')
      usePolicyBasedTrafficSelectors: bool?

      @description('Optional. VPN connection protocol type.')
      vpnConnectionProtocolType: ('IKEv1' | 'IKEv2')?

      @description('Optional. IPsec policies for the connection.')
      ipsecPolicies: array?

      @description('Optional. Traffic selector policies for the connection.')
      trafficSelectorPolicies: array?

      @description('Optional. VPN link connections for the connection.')
      vpnLinkConnections: array?
    }[]?
  }?

  @description('Optional. ExpressRoute parameters for the Virtual Hub.')
  expressRouteParameters: {
    @description('Required. Whether to deploy an ExpressRoute Gateway.')
    deployExpressRouteGateway: bool

    @description('Conditional. Name of the ExpressRoute Gateway. Required if deployExpressRouteGateway is true.')
    expressRouteGatewayName: string?

    @description('Optional. Allow non-Virtual WAN traffic.')
    allowNonVirtualWanTraffic: bool?

    @description('Optional. Minimum bound for autoscale configuration.')
    autoScaleConfigurationBoundsMin: int?

    @description('Optional. Maximum bound for autoscale configuration.')
    autoScaleConfigurationBoundsMax: int?

    @description('Optional. ExpressRoute connections. Note: This array is passed directly to the ExpressRoute Gateway module and must match the Azure ARM API schema.')
    expressRouteConnections: {
      @description('Required. Name of the ExpressRoute connection.')
      name: string

      @description('Required. Properties of the ExpressRoute connection.')
      properties: {
        @description('Required. Reference to the ExpressRoute circuit peering.')
        expressRouteCircuitPeering: {
          @description('Required. Resource ID of the ExpressRoute circuit peering (e.g., /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/AzurePrivatePeering).')
          id: string
        }

        @description('Optional. Authorization key for the connection.')
        @secure()
        authorizationKey: string?

        @description('Optional. Routing weight for the connection (0-32000).')
        routingWeight: int?

        @description('Optional. Enable internet security for the connection.')
        enableInternetSecurity: bool?

        @description('Optional. Enable FastPath to vWan Firewall hub.')
        expressRouteGatewayBypass: bool?

        @description('Optional. Enable private link fast path.')
        enablePrivateLinkFastPath: bool?

        @description('Optional. Routing configuration for the connection.')
        routingConfiguration: resourceInput<'Microsoft.Network/expressRouteGateways/expressRouteConnections@2025-01-01'>.properties.routingConfiguration?
      }
    }[]?
  }?

  @description('Optional. Secure Hub parameters for the Virtual Hub.')
  secureHubParameters: {
    @description('Required. Whether to deploy a Secure Hub.')
    deploySecureHub: bool

    @description('Optional. Resource ID of the firewall policy.')
    firewallPolicyResourceId: string?

    @description('Conditional. Name of the Azure Firewall. Required if deploySecureHub is true.')
    azureFirewallName: string?

    @description('Conditional. SKU for the Azure Firewall. Required if deploySecureHub is true.')
    azureFirewallSku: ('Premium' | 'Standard' | 'Basic')?

    @minValue(1)
    @maxValue(100)
    @description('Conditional. Number of public IPs for the Azure Firewall (1-100). Required if deploySecureHub is true.')
    azureFirewallPublicIPCount: int?

    @description('Optional. Routing intent for the Azure Firewall.')
    routingIntent: routingIntentType?

    @description('Optional. The maximum number of capacity units for the Azure Firewall. Use null to reset to the service default.')
    autoscaleMaxCapacity: int?

    @description('Optional. The minimum number of capacity units for the Azure Firewall. Use null to reset to the service default.')
    autoscaleMinCapacity: int?

    @description('Optional. The operation mode for Threat Intelligence.')
    threatIntelMode: ('Alert' | 'Deny' | 'Off')?

    @description('Optional. The maintenance configuration to assign to the Azure Firewall.')
    maintenanceConfiguration: {
      @description('Required. The name of the maintenance configuration assignment.')
      assignmentName: string

      @description('Required. The resource ID of the maintenance configuration to assign to the Azure Firewall.')
      maintenanceConfigurationResourceId: string
    }?

    @description('Optional. Zone numbers e.g. 1,2,3.')
    availabilityZones: (1 | 2 | 3)[]?

    @description('Optional. Diagnostic settings for the Azure Firewall in the Secure Hub.')
    diagnosticSettings: diagnosticSettingFullType[]?
  }?
  @description('Optional. SKU for the Virtual Hub.')
  sku: ('Standard' | 'Basic')?

  @description('Optional. Tags to be applied to the Virtual Hub.')
  tags: resourceInput<'Microsoft.Network/virtualHubs@2025-01-01'>.tags?

  @description('Optional. ASN for the Virtual Router.')
  virtualRouterAsn: int?

  @description('Optional. The autoscale configuration for the Virtual Router, defining the minimum number of Routing Infrastructure Units. Each unit supports ~1000 VMs and ~1 Gbps throughput (minimum 2).')
  virtualRouterAutoScaleConfiguration: {
    @description('Required. The minimum number of Routing Infrastructure Units for the Virtual Hub Router.')
    minCount: int
  }?

  @description('Optional. IP addresses for the Virtual Router.')
  virtualRouterIps: array?
}
