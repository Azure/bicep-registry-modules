metadata name = 'Hub Networking'
metadata description = 'This module is designed to simplify the creation of multi-region hub networks in Azure. It will create a number of virtual networks and subnets, and optionally peer them together in a mesh topology with routing.'

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. A map of the hub virtual networks to create.')
param hubVirtualNetworks hubVirtualNetworkType?

var hubVirtualNetworkPeerings = [for (hub, index) in items(hubVirtualNetworks ?? {}): hub.value.?peeringSettings ?? []]

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2023-07-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.network-hubnetworking.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

// Create hub virtual networks
module hubVirtualNetwork 'br/public:avm/res/network/virtual-network:0.7.0' = [
  for (hub, index) in items(hubVirtualNetworks ?? {}): {
    name: '${uniqueString(deployment().name, location)}-${hub.key}-nvn'
    params: {
      // Required parameters
      name: hub.key
      addressPrefixes: hub.value.addressPrefixes
      // Non-required parameters
      ddosProtectionPlanResourceId: hub.value.?ddosProtectionPlanResourceId ?? ''
      diagnosticSettings: hub.value.?diagnosticSettings ?? []
      dnsServers: hub.value.?dnsServers ?? []
      enableTelemetry: enableTelemetry
      flowTimeoutInMinutes: hub.value.?flowTimeoutInMinutes ?? 0
      location: hub.value.?location ?? ''
      lock: hub.value.?lock ?? {}
      roleAssignments: hub.value.?roleAssignments ?? []
      subnets: hub.value.?subnets ?? []
      tags: hub.value.?tags ?? {}
      vnetEncryption: hub.value.?vnetEncryption ?? false
      vnetEncryptionEnforcement: hub.value.?vnetEncryptionEnforcement ?? ''
    }
  }
]

// Create hub virtual network peerings
module hubVirtualNetworkPeer_remote 'modules/vnets.bicep' = [
  for (peer, index) in flatten(hubVirtualNetworkPeerings): {
    name: '${uniqueString(deployment().name, location)}-${peer.remoteVirtualNetworkName}-nvnp'
    params: {
      name: peer.remoteVirtualNetworkName
    }
    dependsOn: hubVirtualNetwork
  }
]

// Create hub virtual network peerings
// resource hubVirtualNetworkPeer_remote 'Microsoft.Network/virtualNetworks@2023-11-01' existing = [
//   for (peer, index) in flatten(hubVirtualNetworkPeerings): {
//     name: peer.remoteVirtualNetworkName
//   }
// ]

resource hubVirtualNetworkPeer_local 'Microsoft.Network/virtualNetworks@2024-05-01' existing = [
  for (hub, index) in items(hubVirtualNetworks ?? {}): if (hub.value.enablePeering) {
    name: hub.key
  }
]

resource hubVirtualNetworkPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-05-01' = [
  for (peer, index) in (flatten(hubVirtualNetworkPeerings) ?? []): {
    name: '${hubVirtualNetworkPeer_local[index].name}/${hubVirtualNetworkPeer_local[index].name}-to-${peer.remoteVirtualNetworkName}-peering'
    properties: {
      allowForwardedTraffic: peer.allowForwardedTraffic ?? false
      allowGatewayTransit: peer.allowGatewayTransit ?? false
      allowVirtualNetworkAccess: peer.allowVirtualNetworkAccess ?? true
      useRemoteGateways: peer.useRemoteGateways ?? false
      remoteVirtualNetwork: {
        id: hubVirtualNetworkPeer_remote[index].outputs.resourceId
      }
    }
    dependsOn: hubVirtualNetwork
  }
]

// Create hub virtual network route tables
module hubRouteTable 'br/public:avm/res/network/route-table:0.4.0' = [
  for (hub, index) in items(hubVirtualNetworks ?? {}): {
    name: '${uniqueString(deployment().name, location)}-${hub.key}-nrt'
    params: {
      name: hub.value.?routeTableName ?? hub.key
      location: hub.value.?location ?? location
      disableBgpRoutePropagation: true
      enableTelemetry: enableTelemetry
      roleAssignments: hub.value.?roleAssignments ?? []
      routes: hub.value.?routes ?? []
      tags: hub.value.?tags ?? {}
      lock: hub.value.?lock ?? {}
    }
    dependsOn: hubVirtualNetwork
  }
]

// Create hub virtual network route table route
resource hubRoute 'Microsoft.Network/routeTables/routes@2024-05-01' = [
  for (peer, index) in (flatten(hubVirtualNetworkPeerings) ?? []): {
    name: '${hubVirtualNetworkPeer_local[index].name}/${hubVirtualNetworkPeer_local[index].name}-to-${peer.remoteVirtualNetworkName}-route'
    properties: {
      addressPrefix: hubVirtualNetworkPeer_remote[index].outputs.addressPrefix
      nextHopType: 'VirtualAppliance'
      nextHopIpAddress: hubAzureFirewall[index].outputs.privateIp
    }
    dependsOn: hubVirtualNetworkPeering
  }
]

// Create Bastion host if enabled
// AzureBastionSubnet is required to deploy Bastion service. This subnet must exist in the parsubnets array if you enable Bastion Service.
// There is a minimum subnet requirement of /27 prefix.
module hubBastion 'br/public:avm/res/network/bastion-host:0.6.1' = [
  for (hub, index) in items(hubVirtualNetworks ?? {}): if (hub.value.enableBastion) {
    name: '${uniqueString(deployment().name, location)}-${hub.key}-nbh'
    params: {
      // Required parameters
      name: hub.value.?bastionHost.?bastionHostName ?? hub.key
      virtualNetworkResourceId: hubVirtualNetwork[index].outputs.resourceId
      // Non-required parameters
      diagnosticSettings: hub.value.?diagnosticSettings ?? []
      disableCopyPaste: hub.value.?bastionHost.?disableCopyPaste ?? true
      enableFileCopy: hub.value.?bastionHost.?enableFileCopy ?? false
      enableIpConnect: hub.value.?bastionHost.?enableIpConnect ?? false
      enableShareableLink: hub.value.?bastionHost.?enableShareableLink ?? false
      location: hub.value.?location ?? location
      enableTelemetry: enableTelemetry
      roleAssignments: hub.value.?roleAssignments ?? []
      scaleUnits: hub.value.?bastionHost.?scaleUnits ?? 4
      skuName: hub.value.?bastionHost.?skuName ?? 'Standard'
      tags: hub.value.?tags ?? {}
      lock: hub.value.?lock ?? {}
      enableKerberos: hub.value.?bastionHost.?enableKerberos ?? false
    }
    dependsOn: hubVirtualNetwork
  }
]

// Create Azure Firewall if enabled
// AzureFirewallSubnet is required to deploy Azure Firewall service. This subnet must exist in the subnets array if you enable Azure Firewall.
module hubAzureFirewall 'br/public:avm/res/network/azure-firewall:0.6.1' = [
  for (hub, index) in items(hubVirtualNetworks ?? {}): if (hub.value.enableAzureFirewall) {
    name: '${uniqueString(deployment().name, location)}-${hub.key}-naf'
    params: {
      // Required parameters
      name: hub.value.?azureFirewallSettings.?azureFirewallName ?? hub.key
      // Conditional parameters
      hubIPAddresses: hub.value.?azureFirewallSettings.?hubIpAddresses ?? {}
      virtualHubId: hub.value.?azureFirewallSettings.?virtualHub ?? ''
      virtualNetworkResourceId: hubVirtualNetwork[index].outputs.resourceId ?? ''
      // Non-required parameters
      additionalPublicIpConfigurations: hub.value.?azureFirewallSettings.?additionalPublicIpConfigurations ?? []
      applicationRuleCollections: hub.value.?azureFirewallSettings.?applicationRuleCollections ?? []
      azureSkuTier: hub.value.?azureFirewallSettings.?azureSkuTier ?? {}
      diagnosticSettings: hub.value.?diagnosticSettings ?? []
      enableTelemetry: enableTelemetry
      firewallPolicyId: hub.value.?azureFirewallSettings.?firewallPolicyId ?? ''
      location: hub.value.?location ?? location
      lock: hub.value.?lock ?? {}
      managementIPAddressObject: hub.value.?azureFirewallSettings.?managementIPAddressObject ?? {}
      managementIPResourceID: hub.value.?azureFirewallSettings.?managementIPResourceID ?? ''
      natRuleCollections: hub.value.?azureFirewallSettings.?natRuleCollections ?? []
      networkRuleCollections: hub.value.?azureFirewallSettings.?networkRuleCollections ?? []
      publicIPAddressObject: hub.value.?azureFirewallSettings.?publicIPAddressObject ?? {}
      publicIPResourceID: hub.value.?azureFirewallSettings.?publicIPResourceID ?? ''
      roleAssignments: hub.value.?roleAssignments ?? []
      tags: hub.value.?tags ?? {}
      threatIntelMode: hub.value.?azureFirewallSettings.?threatIntelMode ?? ''
      zones: hub.value.?azureFirewallSettings.?zones ?? []
    }
    dependsOn: hubVirtualNetwork
  }
]

module hubAzureFirewallSubnet 'modules/getSubnet.bicep' = [
  for (hub, index) in items(hubVirtualNetworks ?? {}): if (hub.value.enableAzureFirewall) {
    name: '${uniqueString(deployment().name, location)}-${hub.key}-nafs'
    params: {
      subnetName: 'AzureFirewallSubnet'
      virtualNetworkName: hub.key
    }
    dependsOn: [hubVirtualNetwork]
  }
]

@batchSize(1)
module hubAzureFirewallSubnetAssociation 'modules/subnets.bicep' = [
  for (hub, index) in items(hubVirtualNetworks ?? {}): if (hub.value.enableAzureFirewall) {
    name: '${uniqueString(deployment().name, location)}-${hub.key}-nafsa'
    params: {
      name: 'AzureFirewallSubnet'
      virtualNetworkName: hub.key
      addressPrefix: hubAzureFirewallSubnet[index].outputs.addressPrefix
      routeTableResourceId: hubRouteTable[index].outputs.resourceId
    }
    dependsOn: [hubAzureFirewallSubnet, hubAzureFirewall, hubVirtualNetwork]
  }
]

// ============ //
// Outputs      //
// ============ //

@description('Array of hub virtual network resources.')
output hubVirtualNetworks object[] = [
  for (hub, index) in items(hubVirtualNetworks ?? {}): {
    resourceGroupName: hubVirtualNetwork[index].outputs.resourceGroupName
    location: hubVirtualNetwork[index].outputs.location
    name: hubVirtualNetwork[index].outputs.name
    resourceId: hubVirtualNetwork[index].outputs.resourceId
  }
]

@description('Array of hub bastion resources.')
output hubBastions object[] = [
  for (hub, index) in items(hubVirtualNetworks ?? {}): (hub.value.enableBastion)
    ? {
        resourceGroupName: hubBastion[index].outputs.resourceGroupName
        location: hubBastion[index].outputs.location
        name: hubBastion[index].outputs.name
        resourceId: hubBastion[index].outputs.resourceId
      }
    : {}
]

@description('Array of hub Azure Firewall resources.')
output hubAzureFirewalls object[] = [
  for (hub, index) in items(hubVirtualNetworks ?? {}): (hub.value.enableAzureFirewall)
    ? {
        resourceGroupName: hubAzureFirewall[index].outputs.resourceGroupName
        location: hubAzureFirewall[index].outputs.location
        name: hubAzureFirewall[index].outputs.name
        resourceId: hubAzureFirewall[index].outputs.resourceId
        privateIp: hubAzureFirewall[index].outputs.privateIp
      }
    : {}
]

@description('The subnets of the hub virtual network.')
output hubVirtualNetworkSubnets array = [
  for (hub, index) in items(hubVirtualNetworks ?? {}): hubVirtualNetwork[index].outputs.subnetNames
]

@description('The resource group the resources were deployed into.')
output resourceGroupName string = resourceGroup().name

// ================ //
// Definitions      //
// ================ //
//
// Add your User-defined-types here, if any
//

import { lockType, roleAssignmentType, diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'

@export()
@description('The type of a hub virtual network.')
type hubVirtualNetworkType = {
  @description('Required. The hub virtual networks to create.')
  *: {
    @description('Required. The address prefixes for the virtual network.')
    addressPrefixes: array

    @description('Optional. The Azure Firewall config.')
    azureFirewallSettings: azureFirewallType?

    @description('Optional. The Azure Bastion config.')
    bastionHost: {
      @description('Optional. Enable/Disable copy/paste functionality.')
      disableCopyPaste: bool?

      @description('Optional. Enable/Disable file copy functionality.')
      enableFileCopy: bool?

      @description('Optional. Enable/Disable IP connect functionality.')
      enableIpConnect: bool?

      @description('Optional. Enable/Disable shareable link functionality.')
      enableShareableLink: bool?

      @description('Optional. Enable/Disable Kerberos authentication.')
      enableKerberos: bool?

      @description('Optional. The number of scale units for the Bastion host. Defaults to 4.')
      scaleUnits: int?

      @description('Optional. The SKU name of the Bastion host. Defaults to Standard.')
      skuName: 'Basic' | 'Developer' | 'Premium' | 'Standard'?

      @description('Optional. The name of the bastion host.')
      bastionHostName: string?
    }?

    @description('Optional. Enable/Disable Azure Bastion for the virtual network.')
    enableBastion: bool?

    @description('Optional. Enable/Disable Azure Firewall for the virtual network.')
    enableAzureFirewall: bool?

    @description('Optional. The location of the virtual network. Defaults to the location of the resource group.')
    location: string?

    @description('Optional. The lock settings of the virtual network.')
    lock: lockType?

    @description('Optional. The diagnostic settings of the virtual network.')
    diagnosticSettings: diagnosticSettingFullType[]?

    @description('Optional. The DDoS protection plan resource ID.')
    ddosProtectionPlanResourceId: string?

    @description('Optional. The DNS servers of the virtual network.')
    dnsServers: array?

    @description('Optional. The flow timeout in minutes.')
    flowTimeoutInMinutes: int?

    @description('Optional. Enable/Disable peering for the virtual network.')
    enablePeering: bool?

    @description('Optional. The peerings of the virtual network.')
    peeringSettings: peeringSettingType[]?

    @description('Optional. The role assignments to create.')
    roleAssignments: roleAssignmentType[]?

    @description('Optional. Routes to add to the virtual network route table.')
    routes: array?

    @description('Optional. The name of the route table.')
    routeTableName: string?

    @description('Optional. The subnets of the virtual network.')
    subnets: array?

    @description('Optional. The tags of the virtual network.')
    tags: object?

    @description('Optional. Enable/Disable VNet encryption.')
    vnetEncryption: bool?

    @description('Optional. The VNet encryption enforcement settings of the virtual network.')
    vnetEncryptionEnforcement: string?
  }
}

@description('The type of a peering setting.')
type peeringSettingType = {
  @description('Optional. Allow forwarded traffic.')
  allowForwardedTraffic: bool?

  @description('Optional. Allow gateway transit.')
  allowGatewayTransit: bool?

  @description('Optional. Allow virtual network access.')
  allowVirtualNetworkAccess: bool?

  @description('Optional. Use remote gateways.')
  useRemoteGateways: bool?

  @description('Optional. Remote virtual network name.')
  remoteVirtualNetworkName: string?
}

@description('The type of an Azure Firewall configuration.')
type azureFirewallType = {
  @description('Optional. The name of the Azure Firewall.')
  azureFirewallName: string?

  @description('Optional. Hub IP addresses.')
  hubIpAddresses: object?

  @description('Optional. Virtual Hub ID.')
  virtualHub: string?

  @description('Optional. Additional public IP configurations.')
  additionalPublicIpConfigurations: array?

  @description('Optional. Application rule collections.')
  applicationRuleCollections: array?

  @description('Optional. Azure Firewall SKU.')
  azureSkuTier: 'Basic' | 'Standard' | 'Premium'?

  @description('Optional. Diagnostic settings.')
  diagnosticSettings: diagnosticSettingFullType?

  @description('Optional. Firewall policy ID.')
  firewallPolicyId: string?

  @description('Optional. The location of the virtual network. Defaults to the location of the resource group.')
  location: string?

  @description('Optional. Lock settings.')
  lock: lockType?

  @description('Optional. Management IP address configuration.')
  managementIPAddressObject: object?

  @description('Optional. Management IP resource ID.')
  managementIPResourceID: string?

  @description('Optional. NAT rule collections.')
  natRuleCollections: array?

  @description('Optional. Network rule collections.')
  networkRuleCollections: array?

  @description('Optional. Public IP address object.')
  publicIPAddressObject: object?

  @description('Optional. Public IP resource ID.')
  publicIPResourceID: string?

  @description('Optional. Role assignments.')
  roleAssignments: roleAssignmentType[]?

  @description('Optional. Tags of the resource.')
  tags: object?

  @description('Optional. Threat Intel mode.')
  threatIntelMode: string?

  @description('Optional. Zones.')
  zones: int[]?
}
