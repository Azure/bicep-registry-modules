metadata name = 'Hub Networking'
metadata description = 'This module is designed to simplify the creation of multi-region hub networks in Azure. It will create a number of virtual networks and subnets, and optionally peer them together in a mesh topology with routing.'

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

//
// Add your parameters here
//

@description('Optional. A map of the hub virtual networks to create.')
param hubVirtualNetworks hubVirtualNetworkType

//
// Add your variables here
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
module hubVirtualNetwork 'br/public:avm/res/network/virtual-network:0.5.0' = [
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
      enableTelemetry: hub.value.?enableTelemetry ?? true
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

resource hubVirtualNetworkPeer_local 'Microsoft.Network/virtualNetworks@2024-01-01' existing = [
  for (hub, index) in items(hubVirtualNetworks ?? {}): if (hub.value.enablePeering) {
    name: hub.key
  }
]

resource hubVirtualNetworkPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-01-01' = [
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
      name: hub.key
      location: hub.value.?location ?? location
      disableBgpRoutePropagation: true
      enableTelemetry: hub.value.?enableTelemetry ?? true
      roleAssignments: hub.value.?roleAssignments ?? []
      routes: hub.value.?routes ?? []
      tags: hub.value.?tags ?? {}
    }
    dependsOn: hubVirtualNetwork
  }
]

// Create hub virtual network route table route
resource hubRoute 'Microsoft.Network/routeTables/routes@2024-01-01' = [
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
module hubBastion 'br/public:avm/res/network/bastion-host:0.4.0' = [
  for (hub, index) in items(hubVirtualNetworks ?? {}): if (hub.value.enableBastion) {
    name: '${uniqueString(deployment().name, location)}-${hub.key}-nbh'
    params: {
      // Required parameters
      name: hub.key
      virtualNetworkResourceId: hubVirtualNetwork[index].outputs.resourceId
      // Non-required parameters
      diagnosticSettings: hub.value.?diagnosticSettings ?? []
      disableCopyPaste: hub.value.?bastionHost.?disableCopyPaste ?? true
      enableFileCopy: hub.value.?bastionHost.?enableFileCopy ?? false
      enableIpConnect: hub.value.?bastionHost.?enableIpConnect ?? false
      enableShareableLink: hub.value.?bastionHost.?enableShareableLink ?? false
      location: hub.value.?location ?? location
      enableTelemetry: hub.value.?enableTelemetry ?? true
      roleAssignments: hub.value.?roleAssignments ?? []
      scaleUnits: hub.value.?bastionHost.?scaleUnits ?? 4
      skuName: hub.value.?bastionHost.?skuName ?? 'Standard'
      tags: hub.value.?tags ?? {}
    }
    dependsOn: hubVirtualNetwork
  }
]

// Create Azure Firewall if enabled
// AzureFirewallSubnet is required to deploy Azure Firewall service. This subnet must exist in the subnets array if you enable Azure Firewall.
module hubAzureFirewall 'br/public:avm/res/network/azure-firewall:0.5.1' = [
  for (hub, index) in items(hubVirtualNetworks ?? {}): if (hub.value.enableAzureFirewall) {
    name: '${uniqueString(deployment().name, location)}-${hub.key}-naf'
    params: {
      // Required parameters
      name: hub.key
      // Conditional parameters
      hubIPAddresses: hub.value.?azureFirewallSettings.?hubIpAddresses ?? {}
      virtualHubId: hub.value.?azureFirewallSettings.?virtualHub ?? ''
      virtualNetworkResourceId: hubVirtualNetwork[index].outputs.resourceId ?? ''
      // Non-required parameters
      additionalPublicIpConfigurations: hub.value.?azureFirewallSettings.?additionalPublicIpConfigurations ?? []
      applicationRuleCollections: hub.value.?azureFirewallSettings.?applicationRuleCollections ?? []
      azureSkuTier: hub.value.?azureFirewallSettings.?azureSkuTier ?? {}
      diagnosticSettings: hub.value.?diagnosticSettings ?? []
      enableTelemetry: hub.value.?enableTelemetry ?? true
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

//
// Add your resources here
//

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

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

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

type diagnosticSettingType = {
  @description('Optional. The name of diagnostic setting.')
  name: string?

  @description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.')
  logCategoriesAndGroups: {
    @description('Optional. Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.')
    category: string?

    @description('Optional. Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.')
    categoryGroup: string?

    @description('Optional. Enable or disable the category explicitly. Default is `true`.')
    enabled: bool?
  }[]?

  @description('Optional. The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.')
  metricCategories: {
    @description('Required. Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.')
    category: string

    @description('Optional. Enable or disable the category explicitly. Default is `true`.')
    enabled: bool?
  }[]?

  @description('Optional. A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.')
  logAnalyticsDestinationType: ('Dedicated' | 'AzureDiagnostics')?

  @description('Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.value.')
  workspaceResourceId: string?

  @description('Optional. Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.value.')
  storageAccountResourceId: string?

  @description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
  eventHubAuthorizationRuleResourceId: string?

  @description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.value.')
  eventHubName: string?

  @description('Optional. The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.')
  marketplacePartnerResourceId: string?
}[]?

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

      @description('Optional. The number of scale units for the Bastion host. Defaults to 4.')
      scaleUnits: int?

      @description('Optional. The SKU name of the Bastion host. Defaults to Standard.')
      skuName: string?
    }?

    @description('Optional. Enable/Disable usage telemetry for module.')
    enableTelemetry: bool?

    @description('Optional. Enable/Disable Azure Bastion for the virtual network.')
    enableBastion: bool?

    @description('Optional. Enable/Disable Azure Firewall for the virtual network.')
    enableAzureFirewall: bool?

    @description('Optional. The location of the virtual network. Defaults to the location of the resource group.')
    location: string?

    @description('Optional. The lock settings of the virtual network.')
    lock: lockType?

    @description('Optional. The diagnostic settings of the virtual network.')
    diagnosticSettings: diagnosticSettingType?

    @description('Optional. The DDoS protection plan resource ID.')
    ddosProtectionPlanResourceId: string?

    @description('Optional. The DNS servers of the virtual network.')
    dnsServers: array?

    @description('Optional. The flow timeout in minutes.')
    flowTimeoutInMinutes: int?

    @description('Optional. Enable/Disable peering for the virtual network.')
    enablePeering: bool?

    @description('Optional. The peerings of the virtual network.')
    peeringSettings: peeringSettingsType?

    @description('Optional. The role assignments to create.')
    roleAssignments: roleAssignmentType?

    @description('Optional. Routes to add to the virtual network route table.')
    routes: array?

    @description('Optional. The subnets of the virtual network.')
    subnets: array?

    @description('Optional. The tags of the virtual network.')
    tags: object?

    @description('Optional. Enable/Disable VNet encryption.')
    vnetEncryption: bool?

    @description('Optional. The VNet encryption enforcement settings of the virtual network.')
    vnetEncryptionEnforcement: string?
  }
}?

type peeringSettingsType = {
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
}[]?

type azureFirewallType = {
  @description('Optional. Hub IP addresses.')
  hubIpAddresses: object?

  @description('Optional. Virtual Hub ID.')
  virtualHub: string?

  @description('Optional. Additional public IP configurations.')
  additionalPublicIpConfigurations: array?

  @description('Optional. Application rule collections.')
  applicationRuleCollections: array?

  @description('Optional. Azure Firewall SKU.')
  azureSkuTier: string?

  @description('Optional. Diagnostic settings.')
  diagnosticSettings: diagnosticSettingType?

  @description('Optional. Enable/Disable usage telemetry for module.')
  enableTelemetry: bool?

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
  roleAssignments: roleAssignmentType?

  @description('Optional. Tags of the resource.')
  tags: object?

  @description('Optional. Threat Intel mode.')
  threatIntelMode: string?

  @description('Optional. Zones.')
  zones: int[]?
}?
