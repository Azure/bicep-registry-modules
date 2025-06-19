metadata name = 'Azure Virtual WAN'
metadata description = 'This pattern will create a Virtual WAN and optionally create Virtual Hubs, Azure Firewalls, and VPN/ExpressRoute Gateways.'

@description('Required. Azure region where the Virtual WAN will be created.')
param location string = resourceGroup().location

@description('Required. The parameters for the Virtual WAN.')
param virtualWanParameters virtualWanParameterType

@description('Optional. The parameters for the Virtual Hubs and associated networking components, required if configuring Virtual Hubs.')
param virtualHubParameters virtualHubParameterType?
import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'

@description('Optional. The lock settings for the Virtual WAN and associated components.')
param lock lockType?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

module virtualWan 'br/public:avm/res/network/virtual-wan:0.3.1' = {
  name: '${uniqueString(deployment().name, location)}-${virtualWanParameters.virtualWanName}'
  params: {
    // Required parameters
    name: virtualWanParameters.virtualWanName
    // Optional parameters
    location: virtualWanParameters.?location
    allowBranchToBranchTraffic: virtualWanParameters.?allowBranchToBranchTraffic
    allowVnetToVnetTraffic: virtualWanParameters.?allowVnetToVnetTraffic
    disableVpnEncryption: virtualWanParameters.?disableVpnEncryption
    enableTelemetry: enableTelemetry
    lock: virtualWanParameters.?lock ?? {}
    roleAssignments: virtualWanParameters.?roleAssignments
    tags: virtualWanParameters.?tags
    type: virtualWanParameters.?type
  }
}

module virtualHubModule 'br/public:avm/res/network/virtual-hub:0.3.0' = [
  for (virtualHub, i) in virtualHubParameters: {
    name: '${uniqueString(deployment().name, location)}-${virtualHub.hubName}'
    params: {
      // Required parameters
      name: virtualHub.hubName
      addressPrefix: virtualHub.hubAddressPrefix
      location: virtualHub.hubLocation
      virtualWanResourceId: virtualWan.outputs.resourceId
      // Optional parameters
      allowBranchToBranchTraffic: virtualHub.?allowBranchToBranchTraffic
      enableTelemetry: enableTelemetry
      hubRoutingPreference: virtualHub.?hubRoutingPreference
      hubRouteTables: virtualHub.?hubRouteTables
      hubVirtualNetworkConnections: virtualHub.?hubVirtualNetworkConnections
      lock: lock ?? {}
      sku: virtualHub.?sku
      tags: virtualHub.?tags
      virtualRouterAsn: virtualHub.?virtualRouterAsn
      virtualRouterIps: virtualHub.?virtualRouterIps
    }
  }
]

module firewallModule 'br/public:avm/res/network/azure-firewall:0.6.0' = [
  for (virtualHub, i) in virtualHubParameters!: if (virtualHub.?secureHubParameters.?deploySecureHub!) {
    name: virtualHub.?secureHubParameters.?azureFirewallName!
    params: {
      name: virtualHub.?secureHubParameters.?azureFirewallName!
      azureSkuTier: virtualHub.?secureHubParameters.?azureFirewallSku
      virtualHubId: virtualHubModule[i].outputs.resourceId
      firewallPolicyId: virtualHub.?secureHubParameters.?firewallPolicyResourceId
      location: virtualHubModule[i].outputs.location
      hubIPAddresses: {
        publicIPs: {
          count: virtualHub.?secureHubParameters.?azureFirewallPublicIPCount
        }
      }
      publicIPAddressObject: virtualHub.?secureHubParameters.?publicIPAddressObject
      publicIPResourceID: virtualHub.?secureHubParameters.?publicIPResourceID
      additionalPublicIpConfigurations: virtualHub.?secureHubParameters.?additionalPublicIpConfigurationResourceIds
      //enableForcedTunneling: virtualHub.?secureHubParameters.?enableForcedTunneling
      //managementIPAddressObject: virtualHub.?secureHubParameters.?managementIPAddressObject
      //managementIPResourceID: virtualHub.?secureHubParameters.?managementIPResourceID
      enableTelemetry: enableTelemetry
      diagnosticSettings: virtualHub.?secureHubParameters.?diagnosticSettings
      /*
      roleAssignments:
      tags:*/
      lock: lock ?? {}
    }
  }
]

module vpnServerConfiguration 'br/public:avm/res/network/vpn-server-configuration:0.1.1' = if (virtualWanParameters.?p2sVpnParameters.?createP2sVpnServerConfiguration == true) {
  name: virtualWanParameters.?p2sVpnParameters.p2sVpnServerConfigurationName!
  params: {
    name: virtualWanParameters.?p2sVpnParameters.p2sVpnServerConfigurationName!
    location: virtualWan.outputs.location
    aadAudience: virtualWanParameters.?p2sVpnParameters.?aadAudience
    aadIssuer: virtualWanParameters.?p2sVpnParameters.?aadIssuer
    aadTenant: virtualWanParameters.?p2sVpnParameters.?aadTenant
    enableTelemetry: enableTelemetry
    lock: lock ?? {}
    p2sConfigurationPolicyGroups: virtualWanParameters.?p2sVpnParameters.?p2sConfigurationPolicyGroups
    radiusClientRootCertificates: virtualWanParameters.?p2sVpnParameters.?radiusClientRootCertificates
    radiusServerAddress: virtualWanParameters.?p2sVpnParameters.?radiusServerAddress
    radiusServerRootCertificates: virtualWanParameters.?p2sVpnParameters.?radiusServerRootCertificates
    radiusServerSecret: virtualWanParameters.?p2sVpnParameters.?radiusServerSecret
    radiusServers: virtualWanParameters.?p2sVpnParameters.?radiusServers
    //tags:
    vpnAuthenticationTypes: virtualWanParameters.?p2sVpnParameters.?vpnAuthenticationTypes
    vpnClientIpsecPolicies: virtualWanParameters.?p2sVpnParameters.?vpnClientIpsecPolicies
    vpnClientRevokedCertificates: virtualWanParameters.?p2sVpnParameters.?vpnClientRevokedCertificates
    vpnClientRootCertificates: virtualWanParameters.?p2sVpnParameters.?vpnClientRootCertificates
    vpnProtocols: [
      'OpenVPN'
    ]
  }
}

module p2sVpnGatewayModule 'br/public:avm/res/network/p2s-vpn-gateway:0.1.1' = [
  for (virtualHub, i) in virtualHubParameters!: if (virtualHub.?p2sVpnParameters.?deployP2SVpnGateway == true) {
    name: virtualHub.?p2sVpnParameters.?vpnGatewayName!
    params: {
      name: virtualHub.?p2sVpnParameters.?vpnGatewayName!
      location: virtualHubModule[i].outputs.location
      virtualHubResourceId: virtualHubModule[i].outputs.resourceId
      vpnServerConfigurationResourceId: vpnServerConfiguration.outputs.resourceId
      associatedRouteTableName: virtualHub.?p2sVpnParameters.?vpnGatewayAssociatedRouteTable
      vpnGatewayScaleUnit: virtualHub.?p2sVpnParameters.?vpnGatewayScaleUnit
      vpnClientAddressPoolAddressPrefixes: virtualHub.?p2sVpnParameters.?vpnClientAddressPoolAddressPrefixes
      p2SConnectionConfigurationsName: virtualHub.?p2sVpnParameters.?connectionConfigurationsName
      customDnsServers: virtualHub.?p2sVpnParameters.?customDnsServers
      enableInternetSecurity: virtualHub.?p2sVpnParameters.?enableInternetSecurity
      enableTelemetry: enableTelemetry
      inboundRouteMapResourceId: virtualHub.?p2sVpnParameters.?inboundRouteMapResourceId
      isRoutingPreferenceInternet: virtualHub.?p2sVpnParameters.?isRoutingPreferenceInternet
      lock: lock ?? {}
      outboundRouteMapResourceId: virtualHub.?p2sVpnParameters.?outboundRouteMapResourceId
      propagatedLabelNames: virtualHub.?p2sVpnParameters.?propagatedLabelNames
      propagatedRouteTableNames: virtualHub.?p2sVpnParameters.?propagatedRouteTableNames
      tags: virtualHub.?tags
      vnetRoutesStaticRoutes: virtualHub.?p2sVpnParameters.?vnetRoutesStaticRoutes
    }
  }
]

module s2sVpnGatewayModule 'br/public:avm/res/network/vpn-gateway:0.1.5' = [
  for (virtualHub, i) in virtualHubParameters!: if (virtualHub.?s2sVpnParameters.?deployS2SVpnGateway == true) {
    name: virtualHub.?s2sVpnParameters.?vpnGatewayName!
    params: {
      // Required parameters
      name: virtualHub.?s2sVpnParameters.?vpnGatewayName!
      location: virtualHubModule[i].outputs.location
      virtualHubResourceId: virtualHubModule[i].outputs.resourceId
      // Optional parameters
      bgpSettings: virtualHub.?s2sVpnParameters.?bgpSettings
      enableBgpRouteTranslationForNat: virtualHub.?s2sVpnParameters.?enableBgpRouteTranslationForNat
      isRoutingPreferenceInternet: virtualHub.?s2sVpnParameters.?isRoutingPreferenceInternet
      natRules: virtualHub.?s2sVpnParameters.?natRules
      vpnConnections: virtualHub.?s2sVpnParameters.?vpnConnections
      vpnGatewayScaleUnit: virtualHub.?s2sVpnParameters.?vpnGatewayScaleUnit
      enableTelemetry: enableTelemetry
      tags: virtualHub.?tags
      lock: lock ?? {}
    }
  }
]

module expressRouteGatewayModule 'br/public:avm/res/network/express-route-gateway:0.7.0' = [
  for (virtualHub, i) in virtualHubParameters!: if (virtualHub.?expressRouteParameters.?deployExpressRouteGateway == true) {
    name: virtualHub.?expressRouteParameters.?expressRouteGatewayName!
    params: {
      // Required parameters
      name: virtualHub.?expressRouteParameters.?expressRouteGatewayName!
      location: virtualHubModule[i].outputs.location
      virtualHubId: virtualHubModule[i].outputs.resourceId
      // Optional parameters
      allowNonVirtualWanTraffic: virtualHub.?allowBranchToBranchTraffic
      autoScaleConfigurationBoundsMin: virtualHub.?expressRouteParameters.?autoScaleConfigurationBoundsMin
      autoScaleConfigurationBoundsMax: virtualHub.?expressRouteParameters.?autoScaleConfigurationBoundsMax
      expressRouteConnections: virtualHub.?expressRouteParameters.?expressRouteConnections
      enableTelemetry: enableTelemetry
      tags: virtualHub.?tags
      lock: lock ?? {}
    }
  }
]

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2023-07-01' = if (enableTelemetry) {
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

@description('Object containing the Virtual WAN information.')
output virtualWan object = {
  name: virtualWan.outputs.name
  resourceId: virtualWan.outputs.resourceId
  resourceGroupName: virtualWan.outputs.resourceGroupName
}

@description('The array containing the Virtual Hub information.')
output virtualHubs object[] = [
  for (virtualHub, index) in virtualHubParameters: {
    name: virtualHubModule[index].outputs.name
    resourceId: virtualHubModule[index].outputs.resourceId
    resourceGroupName: virtualHubModule[index].outputs.resourceGroupName
  }
]

@description('Imports the VPN client IPsec policies type from the VPN server configuration module.')
import { vpnClientIpsecPoliciesType } from '../../../res/network/vpn-server-configuration/main.bicep'

@description('Imports the VNet routes static routes type from the P2S VPN gateway module.')
import { vnetRoutesStaticRoutesType } from '../../../res/network/p2s-vpn-gateway/main.bicep'

@description('Imports the Hub Virtual Network Connection type from the Virtual Hub module.')
import { hubVirtualNetworkConnectionType } from '../../../res/network/virtual-hub/main.bicep'

@description('Imports the Routing Intent type from the Virtual Hub module.')
import { routingIntentType } from '../../../res/network/virtual-hub/main.bicep'

@description('Imports the Hub Route Table type from the Virtual Hub module.')
import { hubRouteTableType } from '../../../res/network/virtual-hub/main.bicep'

@description('Imports the full diagnostic setting type from the AVM common types module.')
import { diagnosticSettingFullType } from '../../../utl/types/avm-common-types/main.bicep'

type virtualWanParameterType = {
  @description('Required. The name of the Virtual WAN.')
  virtualWanName: string

  @description('Optional. The Azure region where the Virtual WAN will be created. Defaults to the resource group location if not specified.')
  location: string?

  @description('Optional. Whether to allow branch-to-branch traffic within the Virtual WAN.')
  allowBranchToBranchTraffic: bool?

  @description('Optional. Whether to allow VNet-to-VNet traffic within the Virtual WAN.')
  allowVnetToVnetTraffic: bool?

  @description('Optional. Whether to disable VPN encryption for the Virtual WAN.')
  disableVpnEncryption: bool?

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
    vpnProtocols: ('IkeV2' | 'OpenVPN')?
  }?

  @description('Optional. Role assignments to be applied to the Virtual WAN.')
  roleAssignments: roleAssignmentType?

  @description('Optional. Tags to be applied to the Virtual WAN.')
  tags: object?

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
    @description('Optional. Custom DNS servers for the P2S VPN Gateway.')
    customDnsServers: array?

    @description('Required. Whether to deploy a P2S VPN Gateway.')
    deployP2SVpnGateway: bool

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

    @description('Required. Name of the VPN Gateway.')
    vpnGatewayName: string

    @description('Required. Address prefixes for the VPN client address pool.')
    vpnClientAddressPoolAddressPrefixes: array

    @description('Required. Name of the connection configurations.')
    connectionConfigurationsName: string

    @description('Optional. Scale unit for the VPN Gateway.')
    vpnGatewayScaleUnit: int?

    @description('Optional. Associated route table for the VPN Gateway.')
    vpnGatewayAssociatedRouteTable: ('noneRouteTable' | 'defaultRouteTable')?
  }?
  @description('Optional. Site-to-site VPN parameters for the Virtual Hub.')
  s2sVpnParameters: {
    @description('Required. Whether to deploy a S2S VPN Gateway.')
    deployS2SVpnGateway: bool

    @description('Optional. Name of the VPN Gateway.')
    vpnGatewayName: string?

    @description('Optional. Scale unit for the VPN Gateway.')
    vpnGatewayScaleUnit: int?

    @description('Optional. BGP settings for the VPN Gateway.')
    bgpSettings: {
      @description('Required. ASN for BGP.')
      asn: int

      @description('Required. BGP peering address.')
      bgpPeeringAddress: string

      @description('Required. BGP peering addresses.')
      bgpPeeringAddresses: [
        {
          @description('Required. Custom BGP IP addresses.')
          customBgpIpAddresses: [string]

          @description('Required. IP configuration ID.')
          ipconfigurationId: string
        }
      ]
      @description('Required. Peer weight for BGP.')
      peerWeight: int
    }?
    @description('Optional. Enable BGP route translation for NAT.')
    enableBgpRouteTranslationForNat: bool?

    @description('Optional. Whether routing preference is internet.')
    isRoutingPreferenceInternet: bool?

    @description('Optional. Lock settings for the VPN Gateway.')
    lock: lockType?

    @description('Optional. NAT rules for the VPN Gateway.')
    natRules: [
      {
        @description('Required. External mappings for NAT rule.')
        externalMappings: [
          {
            @description('Required. Address space for external mapping.')
            addressSpace: string
          }
        ]
        @description('Required. Internal mappings for NAT rule.')
        internalMappings: [
          {
            @description('Required. Address space for internal mapping.')
            addressSpace: string
          }
        ]
        @description('Required. Mode for NAT rule.')
        mode: ('EgressSnat' | 'IngressSnat')

        @description('Required. Name of the NAT rule.')
        name: string

        @description('Required. Type of NAT rule.')
        type: ('Static' | 'Dynamic')
      }
    ]?
    @description('Optional. VPN connections for the VPN Gateway.')
    vpnConnections: {
      @description('Required. Name of the VPN connection.')
      name: string

      @description('Required. Name of the VPN Gateway.')
      vpnGatewayName: string

      @description('Optional. Connection bandwidth.')
      connectionBandwidth: int?

      @description('Optional. Enable BGP for the connection.')
      enableBgp: bool?

      @description('Optional. Enable internet security for the connection.')
      enableInternetSecurity: bool?

      @description('Required. Resource ID of the remote VPN site.')
      remoteVpnSiteResourceId: string

      @description('Optional. Enable rate limiting.')
      enableRateLimiting: bool?

      @description('Optional. Routing configuration for the connection.')
      routingConfiguration: {}?

      @description('Required. Routing weight for the connection.')
      routingWeight: int

      @description('Required. Shared key for the connection.')
      sharedKey: string

      @description('Required. Use local Azure IP address.')
      useLocalAzureIpAddress: bool

      @description('Required. Use policy-based traffic selectors.')
      usePolicyBasedTrafficSelectors: bool

      @description('Required. VPN connection protocol type.')
      vpnConnectionProtocolType: ('IKEv1' | 'IKEv2')

      @description('Optional. IPsec policies for the connection.')
      ipsecPolicies: []?

      @description('Optional. Traffic selector policies for the connection.')
      trafficSelectorPolicies: []?

      @description('Optional. VPN link connections for the connection.')
      vpnLinkConnections: []?
    }[]?
  }?
  @description('Optional. ExpressRoute parameters for the Virtual Hub.')
  expressRouteParameters: {
    @description('Required. Whether to deploy an ExpressRoute Gateway.')
    deployExpressRouteGateway: bool

    @description('Optional. Name of the ExpressRoute Gateway.')
    expressRouteGatewayName: string?

    @description('Optional. Allow non-Virtual WAN traffic.')
    allowNonVirtualWanTraffic: bool?

    @description('Optional. Minimum bound for autoscale configuration.')
    autoScaleConfigurationBoundsMin: int?

    @description('Optional. Maximum bound for autoscale configuration.')
    autoScaleConfigurationBoundsMax: int?

    @description('Optional. ExpressRoute connections.')
    expressRouteConnections: {
      @description('Required. Name of the ExpressRoute connection.')
      name: string

      @description('Optional. Connection bandwidth.')
      connectionBandwidth: int?

      @description('Optional. Enable BGP for the connection.')
      enableBgp: bool?

      @description('Optional. Enable internet security for the connection.')
      enableInternetSecurity: bool?

      @description('Optional. Resource ID of the ExpressRoute circuit.')
      expressRouteCircuitId: string?

      @description('Optional. Routing intent for the connection.')
      routingIntent: routingIntentType?

      @description('Optional. Enable rate limiting.')
      enableRateLimiting: bool?

      @description('Required. Routing weight for the connection.')
      routingWeight: int

      @description('Required. Shared key for the connection.')
      sharedKey: string

      @description('Optional. Use policy-based traffic selectors.')
      usePolicyBasedTrafficSelectors: bool?

      @description('Optional. IPsec policies for the connection.')
      ipsecPolicies: []?

      @description('Optional. Traffic selector policies for the connection.')
      trafficSelectorPolicies: []?
    }[]?
  }?
  @description('Optional. Secure Hub parameters for the Virtual Hub.')
  secureHubParameters: {
    @description('Required. Whether to deploy a Secure Hub.')
    deploySecureHub: bool

    @description('Optional. Resource ID of the firewall policy.')
    firewallPolicyResourceId: string?

    @description('Optional. Name of the Azure Firewall.')
    azureFirewallName: string?

    @description('Optional. SKU for the Azure Firewall.')
    azureFirewallSku: ('Premium' | 'Standard' | 'Basic')?

    @description('Optional. Number of public IPs for the Azure Firewall.')
    azureFirewallPublicIPCount: int?

    @description('Optional. Public IP address object for the Azure Firewall.')
    publicIPAddressObject: {
      @description('Required. Name of the public IP address.')
      name: string

      @description('Required. Allocation method for the public IP address.')
      publicIPAllocationMethod: ('Static')

      @description('Required. Resource ID of the public IP prefix.')
      publicIPPrefixResourceId: string

      @description('Required. SKU name for the public IP address.')
      skuName: ('Standard')

      @description('Required. SKU tier for the public IP address.')
      skuTier: ('Regional')
    }?
    @description('Optional. Resource ID of the public IP address.')
    publicIPResourceID: string?

    @description('Optional. Additional public IP configuration resource IDs.')
    additionalPublicIpConfigurationResourceIds: []?

    // Force-tunneling for Azure Firewall is not currently supported, but is currently being worked and support is expected in the near future; leaving for future use.
    /*
    @description('Optional. Enable forced tunneling for the Azure Firewall.')
    enableForcedTunneling: bool?

    @description('Optional. Management public IP address object for the Azure Firewall.')
    managementIPAddressObject: {
      @description('Required. Name of the management public IP address.')
      name: string

      @description('Required. Allocation method for the management public IP address.')
      publicIPAllocationMethod: ('Static')

      @description('Required. Resource ID of the management public IP prefix.')
      publicIPPrefixResourceId: string

      @description('Required. SKU name for the management public IP address.')
      skuName: ('Standard')

      @description('Required. SKU tier for the management public IP address.')
      skuTier: ('Regional')
    }?
    @description('Optional. Resource ID of the management public IP address.')
    managementIPResourceID: string?
    */

    @description('Optional. Diagnostic settings for the Azure Firewall in the Secure Hub.')
    diagnosticSettings: diagnosticSettingFullType[]?
  }?
  @description('Optional. SKU for the Virtual Hub.')
  sku: ('Standard' | 'Basic')?

  @description('Optional. Tags to be applied to the Virtual Hub.')
  tags: object?

  @description('Optional. ASN for the Virtual Router.')
  virtualRouterAsn: int?

  @description('Optional. IP addresses for the Virtual Router.')
  virtualRouterIps: array?
}

type roleAssignmentType = {
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
}
