metadata name = 'Hub Networking'
metadata description = 'This module is designed to simplify the creation of multi-region hub networks in Azure. It will create a number of virtual networks and subnets, and optionally peer them together in a mesh topology with routing.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the resource to create.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

//
// Add your parameters here
//

@description('Optional. A map of the hub virtual networks to create.')
param hubVirtualNetworks hubVirtualNetworkObject

// ============== //
// Resources      //
// ============== //

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

module hubVirtualNetwork 'br/public:avm/res/network/virtual-network:0.1.1' = [for (hub, index) in items(hubVirtualNetworks ?? {}): {
  name: '${uniqueString(deployment().name, location)}-${hub.value.name}-nvn'
  params: {
    // Required parameters
    name: hub.value.name
    addressPrefixes: hub.value.addressPrefixes
    // Non-required parameters
    ddosProtectionPlanResourceId: hub.value.ddosProtectionPlanResourceId ?? ''
    diagnosticSettings: hub.value.diagnosticSettings ?? []
    dnsServers: hub.value.dnsServers ?? []
    enableTelemetry: hub.value.enableTelemetry ?? true
    flowTimeoutInMinutes: hub.value.flowTimeoutInMinutes ?? 0
    location: hub.value.location ?? ''
    lock: hub.value.lock ?? {}
    roleAssignments: hub.value.roleAssignments ?? []
    subnets: hub.value.subnets ?? []
    tags: hub.value.tags ?? {}
    vnetEncryption: hub.value.vnetEncryption ?? false
    vnetEncryptionEnforcement: hub.value.vnetEncryptionEnforcement ?? ''
  }
}]

module hubRouteTable 'br/public:avm/res/network/route-table:0.2.2' = [for (hub, index) in items(hubVirtualNetworks ?? {}): {
  name: '${uniqueString(deployment().name, location)}-${hub.value.name}-nrt'
  params: {
    name: hub.value.name
    location: hub.value.location ?? location
    disableBgpRoutePropagation: true
    enableTelemetry: hub.value.enableTelemetry ?? true
    roleAssignments: hub.value.roleAssignments ?? []
    routes: []
    tags: hub.value.tags ?? {}
  }
}]

// AzureBastionSubnet is required to deploy Bastion service. This subnet must exist in the parsubnets array if you enable Bastion Service.
// There is a minimum subnet requirement of /27 prefix.
module hubBastion 'br/public:avm/res/network/bastion-host:0.1.1' = [for (hub, index) in items(hubVirtualNetworks ?? {}): if (hub.value.enableBastion) {
  name: '${uniqueString(deployment().name, location)}-${hub.value.name}-nbh'
  params: {
    // Required parameters
    name: hub.value.name
    vNetId: hubVirtualNetwork[index].outputs.resourceId
    // Non-required parameters
    diagnosticSettings: hub.value.diagnosticSettings ?? []
    location: hub.value.location ?? location
    enableTelemetry: hub.value.enableTelemetry ?? true
    roleAssignments: hub.value.roleAssignments ?? []
    tags: hub.value.tags ?? {}
  }
}]

// Fireall module will go here

//
// Add your resources here
//

// ============ //
// Outputs      //
// ============ //

@description('The resource group the virtual network was deployed into.')
output resourceGroupName string[] = [for (hub, index) in items(hubVirtualNetworks ?? {}): hubVirtualNetwork[index].outputs.resourceGroupName]

@description('The location the virtual network was deployed into.')
output location string[] = [for (hub, index) in items(hubVirtualNetworks ?? {}): hubVirtualNetwork[index].outputs.location]

@description('The name of the hub virtual network.')
output hubVirtualNetworkName string[] = [for (hub, index) in items(hubVirtualNetworks ?? {}): hubVirtualNetwork[index].outputs.name]

@description('The resource ID of the hub virtual network.')
output hubVirtualNetworkResourceId string[] = [for (hub, index) in items(hubVirtualNetworks ?? {}): hubVirtualNetwork[index].outputs.resourceId]

@description('The name of the bastion host.')
output hubBastionName string[] = [for (hub, index) in items(hubVirtualNetworks ?? {}): hubBastion[index].outputs.name]

@description('The resource ID of the bastion host.')
output hubBastionResourceId string[] = [for (hub, index) in items(hubVirtualNetworks ?? {}): hubBastion[index].outputs.resourceId]
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

type hubVirtualNetworkObject = {
  *: hubVirtualNetworkType?
}?

type hubVirtualNetworkType = {
  @description('Required. The name of the virtual network.')
  name: string

  @description('Required. The address prefixes for the virtual network.')
  addressPrefixes: array

  @description('Optional. The location of the virtual network. Defaults to the location of the resource group.')
  location: string?

  @description('Optional. The tags of the virtual network.')
  tags: object?

  @description('Optional. The lock settings of the virtual network.')
  lock: lockType?

  @description('Optional. The diagnostic settings of the virtual network.')
  diagnosticSettings: diagnosticSettingType?

  @description('Optional. The role assignments to create.')
  roleAssignments: roleAssignmentType?

  @description('Optional. The DDoS protection plan resource ID.')
  ddosProtectionPlanResourceId: string?

  @description('Optional. The DNS servers of the virtual network.')
  dnsServers: array?

  @description('Optional. The flow timeout in minutes.')
  flowTimeoutInMinutes: int?

  @description('Optional. Enable/Disable peering for the virtual network.')
  enablePeering: bool?

  @description('Optional. The peerings of the virtual network.')
  peeringSettings: {
    allowForwardedTraffic: bool?
    allowGatewayTransit: bool?
    allowVirtualNetworkAccess: bool?
    useRemoteGateways: bool?
    remoteVirtualNetworkName: string?
  }[]?

  @description('Optional. The subnets of the virtual network.')
  subnets: array?

  @description('Optional. Enable/Disable VNet encryption.')
  vnetEncryption: bool?

  @description('Optional. The VNet encryption enforcement settings of the virtual network.')
  vnetEncryptionEnforcement: string?

  @description('Optional. Enable/Disable usage telemetry for module.')
  enableTelemetry: bool?

  @description('Optional. Enable/Disable Azure Bastion for the virtual network.')
  enableBastion: bool?

  @description('Optional. Enable/Disable Azure Firewall for the virtual network.')
  enableAzureFirewall: bool?

  @description('Optional. The Azure Firewall config.')
  azureFirewallSettings: azureFirewallType?
}

type azureFirewallType = {
  @description('Required. The name of the Azure Firewall.')
  name: string?

  @description('Optional. The location of the Azure Firewall. Defaults to the location of the resource group.')
  location: string?

  @description('Optional. The zones of the Azure Firewall.')
  zones: array?

  @description('Optional. The additional properties of the Azure Firewall.')
  additionalProperties: object?

  @description('Optional. The application rule collections of the Azure Firewall.')
  applicationRuleCollections: array?

  @description('Optional. The firewall policy of the Azure Firewall.')
  firewallPolicy: string?

  @description('Optional. The hub IP addresses of the Azure Firewall.')
  hubIpAddresses: object?

  @description('Optional. The IP configurations of the Azure Firewall.')
  ipConfigurations: array?

  @description('Optional. The management IP configuration of the Azure Firewall.')
  managementIpConfiguration: string?

  @description('Optional. The NAT rule collections of the Azure Firewall.')
  natRuleCollections: array?

  @description('Optional. The network rule collections of the Azure Firewall.')
  networkRuleCollections: array?

  @description('Optional. The SKU of the Azure Firewall.')
  sku: object?

  @description('Optional. The threat intel mode of the Azure Firewall.')
  threatIntelMode: string?

  @description('Optional. The virtual hub of the Azure Firewall.')
  virtualHub: string?
}?
