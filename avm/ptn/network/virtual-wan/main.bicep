metadata name = 'avm/ptn/network/virtual-wan'
metadata description = 'Azure Virtual WAN'

@description('Option. Azure region where the Virtual WAN will be created.')
param location string = resourceGroup().location

@description('Required. The parameters for the Virtual WAN.')
param virtualWanParameters virtualWanParameterType

@description('Required. The parameters for the Virtual Hubs and associated networking components.')
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
  for (virtualHub, i) in virtualHubParameters!: {
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

module newAzureFirewallPolicyModule 'br/public:avm/res/network/firewall-policy:0.3.1' = [
  for (virtualHub, i) in virtualHubParameters!: if (!empty(virtualHub.?secureHubParameters.?newFirewallPolicyName!)) {
    name: virtualHub.?secureHubParameters.?newFirewallPolicyName! // May need index name here
    params: {
      name: virtualHub.?secureHubParameters.?newFirewallPolicyName!
      location: location
      ruleCollectionGroups: []
      lock: lock ?? {}
      enableTelemetry: enableTelemetry
      //tags:
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
      firewallPolicyId: ((!empty(virtualHub.?secureHubParameters.?newFirewallPolicyName!)) ? newAzureFirewallPolicyModule[i].outputs.resourceId : virtualHub.?secureHubParameters.?existingFirewallPolicyResourceId)
      location: virtualHubModule[i].outputs.location
      hubIPAddresses: {
        publicIPs: {
          count: virtualHub.?secureHubParameters.?azureFirewallPublicIPCount
        }
      }
      /*publicIPAddressObject: virtualHub.?secureHubParameters.
      publicIPResourceID:
      additionalPublicIpConfigurations:
      diagnosticSettings:
      enableForcedTunneling:
      lock:*/
      enableTelemetry: enableTelemetry
      /*managementIPAddressObject:
      managementIPResourceID:
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
      natRules: []
      vpnConnections: virtualHub.?s2sVpnParameters.?vpnConnections
      vpnGatewayScaleUnit: virtualHub.?s2sVpnParameters.?vpnGatewayScaleUnit
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

import {vpnClientIpsecPoliciesType} from '../../../res/network/vpn-server-configuration/main.bicep'
import {vnetRoutesStaticRoutesType} from '../../../res/network/p2s-vpn-gateway/main.bicep'
import {hubVirtualNetworkConnectionType } from '../../../res/network/virtual-hub/main.bicep'
import {routingIntentType} from '../../../res/network/virtual-hub/main.bicep'
import {hubRouteTableType } from '../../../res/network/virtual-hub/main.bicep'

type virtualWanParameterType = {
  virtualWanName: string
  location: string?
  allowBranchToBranchTraffic: bool?
  allowVnetToVnetTraffic: bool?
  disableVpnEncryption: bool?
  lock: lockType?
  p2sVpnParameters: {
    createP2sVpnServerConfiguration: bool
    p2sVpnServerConfigurationName: string?
    aadAudience: string?
    aadIssuer: string?
    aadTenant: string?
    p2sConfigurationPolicyGroups: array?
    radiusClientRootCertificates: array?
    radiusServerAddress: string?
    radiusServerRootCertificates: array?
    radiusServerSecret: string?
    radiusServers: array?
    vpnAuthenticationTypes: ['AAD' | 'Certificate' | 'Radius']?
    vpnClientIpsecPolicies: vpnClientIpsecPoliciesType[]?
    vpnClientRevokedCertificates: array?
    vpnClientRootCertificates: array?
    vpnProtocols: ('IkeV2' | 'OpenVPN')?
  }?
  roleAssignments: roleAssignmentType?
  tags: object?
  type: ('Standard' | 'Basic')?
}

type virtualHubParameterType = {
  hubName: string
  hubLocation: string
  hubAddressPrefix: string
  allowBranchToBranchTraffic: bool?
  hubRoutingPreference: ('ASPath' | 'ExpressRoute' | 'VpnGateway')?
  hubRouteTables: hubRouteTableType[]?
  hubVirtualNetworkConnections: hubVirtualNetworkConnectionType[]?
  p2sVpnParameters: {
    customDnsServers: array?
    deployP2SVpnGateway: bool
    enableInternetSecurity: bool?
    inboundRouteMapResourceId: string?
    isRoutingPreferenceInternet: bool?
    outboundRouteMapResourceId: string?
    propagatedLabelNames: array?
    propagatedRouteTableNames: array?
    vnetRoutesStaticRoutes: vnetRoutesStaticRoutesType?
    vpnGatewayName: string
    vpnClientAddressPoolAddressPrefixes: array
    connectionConfigurationsName: string
    vpnGatewayScaleUnit: int?
    vpnGatewayAssociatedRouteTable: ('noneRouteTable' | 'defaultRouteTable')?
  }?
  s2sVpnParameters: {
    deployS2SVpnGateway: bool
    vpnGatewayName: string?
    vpnGatewayScaleUnit: int?
    bgpSettings: {
      asn: int
      bgpPeeringAddress: string
      bgpPeeringAddresses: [
        {
          customBgpIpAddresses: [
            string
          ]
          ipconfigurationId: string
        }
      ]?
      peerWeight: int
    }?
    enableBgpRouteTranslationForNat: bool?
    isRoutingPreferenceInternet: bool?
    vpnConnections: {
      //name: string
      //vpnGatewayName: 
      //connectionBandwidth: int
      //enableBgp: bool
      //enableInternetSecurity: bool
      //remoteVpnSiteResourceId: connection.?remoteVpnSiteResourceId
      enableRateLimiting: bool?
      //routingConfiguration: connection.?routingConfiguration
      //routingWeight: int
      //sharedKey: string
      //useLocalAzureIpAddress: bool
      //usePolicyBasedTrafficSelectors: bool
      //vpnConnectionProtocolType: ('IKEv1' | 'IKEv2')
      //ipsecPolicies: []
      //trafficSelectorPolicies: []
      //vpnLinkConnections: connection.?vpnLinkConnections
    }[]
  }?
  secureHubParameters: {
    deploySecureHub: bool
    @description('Conditional. Existing Firewall Policy Resource ID, enter if using an existing Firewall Policy.')
    existingFirewallPolicyResourceId: string?
    @description('Conditional. Firewall Policy name; enter if creating a new Firewall Policy.')
    newFirewallPolicyName: string?
    azureFirewallName: string?
    azureFirewallSku: ('Premium' | 'Standard' | 'Basic')?
    azureFirewallPublicIPCount: int?
  }?
  sku: ('Standard' | 'Basic')?
  tags: object?
  virtualRouterAsn: int?
  virtualRouterIps: array?
}[]

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
}[]?
