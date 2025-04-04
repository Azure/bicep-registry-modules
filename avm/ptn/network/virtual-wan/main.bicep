metadata name = 'avm/ptn/network/virtual-wan'
metadata description = 'Azure Virtual WAN'

@description('Option. Azure region where the Virtual WAN will be created.')
param location string = resourceGroup().location

param virtualWanParameters virtualWanParameterType

param virtualHubParameters virtualHubParameterType

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@description('Optional. The lock settings for the Private Link Private DNS Zones created.')
param lock lockType?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

module virtualWan 'br/public:avm/res/network/virtual-wan:0.3.1' = {
  name: '${uniqueString(deployment().name, location)}-${virtualWanParameters.virtualWanName}'
  params: {
    name: virtualWanParameters.virtualWanName
    location: virtualWanParameters.location
    allowBranchToBranchTraffic: virtualWanParameters.allowBranchToBranchTraffic
    allowVnetToVnetTraffic: virtualWanParameters.allowVnetToVnetTraffic
    disableVpnEncryption: virtualWanParameters.disableVpnEncryption
  }
}

module virtualHubModule 'br/public:avm/res/network/virtual-hub:0.3.0' = [
  for (virtualHub, i) in virtualHubParameters: {
    name: '${uniqueString(deployment().name, location)}-${virtualHub.hubName}'
    params: {
      name: virtualHub.hubName
      location: virtualHub.hubLocation
      virtualWanResourceId: virtualWan.outputs.resourceId
      addressPrefix: virtualHub.hubAddressPrefix
    }
  }
]

module newAzureFirewallPolicyModule 'br/public:avm/res/network/firewall-policy:0.3.1' = [
  for (virtualHub, i) in virtualHubParameters: if (!empty(virtualHub.?secureHubParameters.?newFirewallPolicyName!)) {
    name: virtualHub.?secureHubParameters.?newFirewallPolicyName! // May need index name here
    params: {
      name: virtualHub.?secureHubParameters.?newFirewallPolicyName!
      location: location
      ruleCollectionGroups: []
    }
  }
]

module firewallModule 'br/public:avm/res/network/azure-firewall:0.6.0' = [
  for (virtualHub, i) in virtualHubParameters: if (virtualHub.?secureHubParameters.?deploySecureHub!) {
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
      lock:
      enableTelemetry:
      managementIPAddressObject:
      managementIPResourceID:
      roleAssignments:
      tags: */
      lock: lock
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
    p2sConfigurationPolicyGroups: virtualWanParameters.?p2sVpnParameters.?p2sConfigurationPolicyGroups
    radiusClientRootCertificates: virtualWanParameters.?p2sVpnParameters.?radiusClientRootCertificates
    radiusServerAddress: virtualWanParameters.?p2sVpnParameters.?radiusServerAddress
    radiusServerRootCertificates: virtualWanParameters.?p2sVpnParameters.?radiusServerRootCertificates
    radiusServerSecret: virtualWanParameters.?p2sVpnParameters.?radiusServerSecret
    radiusServers: virtualWanParameters.?p2sVpnParameters.?radiusServers
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
  for (virtualHub, i) in virtualHubParameters: if (virtualHub.?p2sVpnParameters.?deployP2SVpnGateway == true) {
    name: virtualHub.?p2sVpnParameters.p2sVpnGatewayName!
    params: {
      name: virtualHub.?p2sVpnParameters.p2sVpnGatewayName!
      location: virtualHubModule[i].outputs.location
      virtualHubResourceId: virtualHubModule[i].outputs.resourceId
      vpnServerConfigurationResourceId: vpnServerConfiguration.outputs.resourceId
      associatedRouteTableName: virtualHub.?p2sVpnParameters.?p2sVpnGatewayAssociatedRouteTable
      vpnGatewayScaleUnit: virtualHub.?p2sVpnParameters.?p2sVpnGatewayScaleUnit
      vpnClientAddressPoolAddressPrefixes: virtualHub.?p2sVpnParameters.?p2sVpnClientAddressPoolAddressPrefixes
      p2SConnectionConfigurationsName: 'something'
    }
  }
]

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2023-07-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.network-privatelinkprivatednszones.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

type virtualWanParameterType = {
  virtualWanName: string
  location: string
  allowBranchToBranchTraffic: bool
  allowVnetToVnetTraffic: bool
  disableVpnEncryption: bool
  p2sVpnParameters: {
    createP2sVpnServerConfiguration: bool
    p2sVpnServerConfigurationName: string
    aadAudience: string?
    aadIssuer: string?
    aadTenant: string?
    p2sConfigurationPolicyGroups: array?
    radiusClientRootCertificates: array?
    radiusServerAddress: string?
    radiusServerRootCertificates: array?
    radiusServerSecret: string?
    radiusServers: array?
    vpnAuthenticationTypes: ['AAD' | 'Certificate' | 'Radius']
    vpnClientIpsecPolicies: vpnClientIpsecPoliciesType[]?
    vpnClientRevokedCertificates: array?
    vpnClientRootCertificates: array?
    vpnProtocols: ('IkeV2' | 'OpenVPN')
  }?
}

type virtualHubParameterType = {
  hubName: string
  hubLocation: string
  hubAddressPrefix: string
  secureHubParameters: {
    deploySecureHub: bool
    @description('Conditional. Existing Firewall Policy Resource ID, enter if using an existing Firewall Policy.')
    existingFirewallPolicyResourceId: string?
    @description('Conditional. Firewall Policy name; enter if creating a new Firewall Policy.')
    newFirewallPolicyName: string?
    azureFirewallName: string
    azureFirewallSku: ('Premium' | 'Standard' | 'Basic')
    azureFirewallPublicIPCount: int?
  }?
  p2sVpnParameters: {
    deployP2SVpnGateway: bool
    p2sVpnGatewayName: string
    p2sVpnClientAddressPoolAddressPrefixes: array
    p2SConnectionConfigurationsName: string
    p2sVpnGatewayScaleUnit: int?
    p2sVpnGatewayAssociatedRouteTable: ('noneRouteTable' | 'defaultRouteTable')?
  }?
}[]
