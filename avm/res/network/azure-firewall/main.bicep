metadata name = 'Azure Firewalls'
metadata description = 'This module deploys an Azure Firewall.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the Azure Firewall.')
param name string

@description('Optional. Tier of an Azure Firewall.')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param azureSkuTier string = 'Standard'

@description('Conditional. Shared services Virtual Network resource ID. The virtual network ID containing AzureFirewallSubnet. If a Public IP is not provided, then the Public IP that is created as part of this module will be applied with the subnet provided in this variable. Required if `virtualHubId` is empty.')
param vNetId string = ''

@description('Optional. The Public IP resource ID to associate to the AzureFirewallSubnet. If empty, then the Public IP that is created as part of this module will be applied to the AzureFirewallSubnet.')
param publicIPResourceID string = ''

@description('Optional. This is to add any additional Public IP configurations on top of the Public IP with subnet IP configuration.')
param additionalPublicIpConfigurations array = []

@description('Optional. Specifies the properties of the Public IP to create and be used by the Firewall, if no existing public IP was provided.')
param publicIPAddressObject object = {
  name: '${name}-pip'
}

@description('Optional. The Management Public IP resource ID to associate to the AzureFirewallManagementSubnet. If empty, then the Management Public IP that is created as part of this module will be applied to the AzureFirewallManagementSubnet.')
param managementIPResourceID string = ''

@description('Optional. Specifies the properties of the Management Public IP to create and be used by Azure Firewall. If it\'s not provided and managementIPResourceID is empty, a \'-mip\' suffix will be appended to the Firewall\'s name.')
param managementIPAddressObject object = {}

@description('Optional. Collection of application rule collections used by Azure Firewall.')
param applicationRuleCollections array = []

@description('Optional. Collection of network rule collections used by Azure Firewall.')
param networkRuleCollections array = []

@description('Optional. Collection of NAT rule collections used by Azure Firewall.')
param natRuleCollections array = []

@description('Optional. Resource ID of the Firewall Policy that should be attached.')
param firewallPolicyId string = ''

@description('Conditional. IP addresses associated with AzureFirewall. Required if `virtualHubId` is supplied.')
param hubIPAddresses object = {}

@description('Conditional. The virtualHub resource ID to which the firewall belongs. Required if `vNetId` is empty.')
param virtualHubId string = ''

@allowed([
  'Alert'
  'Deny'
  'Off'
])
@description('Optional. The operation mode for Threat Intel.')
param threatIntelMode string = 'Deny'

@description('Optional. Zone numbers e.g. 1,2,3.')
param zones array = [
  '1'
  '2'
  '3'
]

@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingType

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. Tags of the Azure Firewall resource.')
param tags object?

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

var azureSkuName = empty(vNetId) ? 'AZFW_Hub' : 'AZFW_VNet'
var requiresManagementIp = azureSkuTier == 'Basic' ? true : false
var isCreateDefaultManagementIP = empty(managementIPResourceID) && requiresManagementIp

// ----------------------------------------------------------------------------
// Prep ipConfigurations object AzureFirewallSubnet for different uses cases:
// 1. Use existing Public IP
// 2. Use new Public IP created in this module
// 3. Do not use a Public IP if publicIPAddressObject is empty

var additionalPublicIpConfigurationsVar = [for ipConfiguration in additionalPublicIpConfigurations: {
  name: ipConfiguration.name
  properties: {
    publicIPAddress: contains(ipConfiguration, 'publicIPAddressResourceId') ? {
      id: ipConfiguration.publicIPAddressResourceId
    } : null
  }
}]
var ipConfigurations = concat([
    {
      name: !empty(publicIPResourceID) ? last(split(publicIPResourceID, '/')) : publicIPAddress.outputs.name
      properties: union({
          subnet: {
            id: '${vNetId}/subnets/AzureFirewallSubnet' // The subnet name must be AzureFirewallSubnet
          }
        }, (!empty(publicIPResourceID) || !empty(publicIPAddressObject)) ? {
          //Use existing Public IP, new Public IP created in this module, or none if neither
          publicIPAddress: {
            id: !empty(publicIPResourceID) ? publicIPResourceID : publicIPAddress.outputs.resourceId
          }
        } : {})
    }
  ], additionalPublicIpConfigurationsVar)

// ----------------------------------------------------------------------------
// Prep managementIPConfiguration object for different uses cases:
// 1. Use existing Management Public IP
// 2. Use new Management Public IP created in this module

var managementIPConfiguration = {
  name: !empty(managementIPResourceID) ? last(split(managementIPResourceID, '/')) : managementIPAddress.outputs.name
  properties: union({
      subnet: {
        id: '${vNetId}/subnets/AzureFirewallManagementSubnet' // The subnet name must be AzureFirewallManagementSubnet for a 'Basic' SKU tier firewall
      }
    }, (!empty(publicIPResourceID) || !empty(managementIPAddressObject)) ? {
      // Use existing Management Public IP, new Management Public IP created in this module, or none if neither
      publicIPAddress: {
        id: !empty(managementIPResourceID) ? managementIPResourceID : managementIPAddress.outputs.resourceId
      }
    } : {})
}

// ----------------------------------------------------------------------------

var enableReferencedModulesTelemetry = false

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f58310d9-a9f6-439a-9e8d-f62e7b41a168')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
}

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

module publicIPAddress '../../network/public-ip-address/main.bicep' = if (empty(publicIPResourceID) && azureSkuName == 'AZFW_VNet') {
  name: '${uniqueString(deployment().name, location)}-Firewall-PIP'
  params: {
    name: publicIPAddressObject.name
    publicIPPrefixResourceId: contains(publicIPAddressObject, 'publicIPPrefixResourceId') ? (!(empty(publicIPAddressObject.publicIPPrefixResourceId)) ? publicIPAddressObject.publicIPPrefixResourceId : '') : ''
    publicIPAllocationMethod: contains(publicIPAddressObject, 'publicIPAllocationMethod') ? (!(empty(publicIPAddressObject.publicIPAllocationMethod)) ? publicIPAddressObject.publicIPAllocationMethod : 'Static') : 'Static'
    skuName: contains(publicIPAddressObject, 'skuName') ? (!(empty(publicIPAddressObject.skuName)) ? publicIPAddressObject.skuName : 'Standard') : 'Standard'
    skuTier: contains(publicIPAddressObject, 'skuTier') ? (!(empty(publicIPAddressObject.skuTier)) ? publicIPAddressObject.skuTier : 'Regional') : 'Regional'
    roleAssignments: contains(publicIPAddressObject, 'roleAssignments') ? (!empty(publicIPAddressObject.roleAssignments) ? publicIPAddressObject.roleAssignments : []) : []
    diagnosticSettings: publicIPAddressObject.?diagnosticSettings
    location: location
    lock: lock
    tags: publicIPAddressObject.?tags ?? tags
    zones: zones
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

// create a Management Public IP address if one is not provided and the flag is true
module managementIPAddress '../../network/public-ip-address/main.bicep' = if (isCreateDefaultManagementIP && azureSkuName == 'AZFW_VNet') {
  name: '${uniqueString(deployment().name, location)}-Firewall-MIP'
  params: {
    name: contains(managementIPAddressObject, 'name') ? (!(empty(managementIPAddressObject.name)) ? managementIPAddressObject.name : '${name}-mip') : '${name}-mip'
    publicIPPrefixResourceId: contains(managementIPAddressObject, 'managementIPPrefixResourceId') ? (!(empty(managementIPAddressObject.publicIPPrefixResourceId)) ? managementIPAddressObject.publicIPPrefixResourceId : '') : ''
    publicIPAllocationMethod: contains(managementIPAddressObject, 'managementIPAllocationMethod') ? (!(empty(managementIPAddressObject.publicIPAllocationMethod)) ? managementIPAddressObject.publicIPAllocationMethod : 'Static') : 'Static'
    skuName: contains(managementIPAddressObject, 'skuName') ? (!(empty(managementIPAddressObject.skuName)) ? managementIPAddressObject.skuName : 'Standard') : 'Standard'
    skuTier: contains(managementIPAddressObject, 'skuTier') ? (!(empty(managementIPAddressObject.skuTier)) ? managementIPAddressObject.skuTier : 'Regional') : 'Regional'
    roleAssignments: contains(managementIPAddressObject, 'roleAssignments') ? (!empty(managementIPAddressObject.roleAssignments) ? managementIPAddressObject.roleAssignments : []) : []
    diagnosticSettings: managementIPAddressObject.?diagnosticSettings
    location: location
    tags: managementIPAddressObject.?tags ?? tags
    zones: zones
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

resource azureFirewall 'Microsoft.Network/azureFirewalls@2023-04-01' = {
  name: name
  location: location
  zones: length(zones) == 0 ? null : zones
  tags: tags
  properties: azureSkuName == 'AZFW_VNet' ? {
    threatIntelMode: threatIntelMode
    firewallPolicy: !empty(firewallPolicyId) ? {
      id: firewallPolicyId
    } : null
    ipConfigurations: ipConfigurations
    managementIpConfiguration: requiresManagementIp ? managementIPConfiguration : null
    sku: {
      name: azureSkuName
      tier: azureSkuTier
    }
    applicationRuleCollections: applicationRuleCollections
    natRuleCollections: natRuleCollections
    networkRuleCollections: networkRuleCollections
  } : {
    firewallPolicy: !empty(firewallPolicyId) ? {
      id: firewallPolicyId
    } : null
    sku: {
      name: azureSkuName
      tier: azureSkuTier
    }
    hubIPAddresses: !empty(hubIPAddresses) ? hubIPAddresses : null
    virtualHub: !empty(virtualHubId) ? {
      id: virtualHubId
    } : null
  }
}

resource azureFirewall_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot delete or modify the resource or child resources.'
  }
  scope: azureFirewall
}

resource azureFirewall_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [for (diagnosticSetting, index) in (diagnosticSettings ?? []): {
  name: diagnosticSetting.?name ?? '${name}-diagnosticSettings'
  properties: {
    storageAccountId: diagnosticSetting.?storageAccountResourceId
    workspaceId: diagnosticSetting.?workspaceResourceId
    eventHubAuthorizationRuleId: diagnosticSetting.?eventHubAuthorizationRuleResourceId
    eventHubName: diagnosticSetting.?eventHubName
    metrics: diagnosticSetting.?metricCategories ?? [
      {
        category: 'AllMetrics'
        timeGrain: null
        enabled: true
      }
    ]
    logs: diagnosticSetting.?logCategoriesAndGroups ?? [
      {
        categoryGroup: 'AllLogs'
        enabled: true
      }
    ]
    marketplacePartnerId: diagnosticSetting.?marketplacePartnerResourceId
    logAnalyticsDestinationType: diagnosticSetting.?logAnalyticsDestinationType
  }
  scope: azureFirewall
}]

resource azureFirewall_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (roleAssignment, index) in (roleAssignments ?? []): {
  name: guid(azureFirewall.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : contains(roleAssignment.roleDefinitionIdOrName, '/providers/Microsoft.Authorization/roleDefinitions/') ? roleAssignment.roleDefinitionIdOrName : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName)
    principalId: roleAssignment.principalId
    description: roleAssignment.?description
    principalType: roleAssignment.?principalType
    condition: roleAssignment.?condition
    conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
    delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
  }
  scope: azureFirewall
}]

@description('The resource ID of the Azure Firewall.')
output resourceId string = azureFirewall.id

@description('The name of the Azure Firewall.')
output name string = azureFirewall.name

@description('The resource group the Azure firewall was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The private IP of the Azure firewall.')
output privateIp string = contains(azureFirewall.properties, 'ipConfigurations') ? azureFirewall.properties.ipConfigurations[0].properties.privateIPAddress : ''

@description('The Public IP configuration object for the Azure Firewall Subnet.')
output ipConfAzureFirewallSubnet object = contains(azureFirewall.properties, 'ipConfigurations') ? azureFirewall.properties.ipConfigurations[0] : {}

@description('List of Application Rule Collections.')
output applicationRuleCollections array = applicationRuleCollections

@description('List of Network Rule Collections.')
output networkRuleCollections array = networkRuleCollections

@description('Collection of NAT rule collections used by Azure Firewall.')
output natRuleCollections array = natRuleCollections

@description('The location the resource was deployed into.')
output location string = azureFirewall.location

// =============== //
//   Definitions   //
// =============== //

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

  @description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container"')
  condition: string?

  @description('Optional. Version of the condition.')
  conditionVersion: '2.0'?

  @description('Optional. The Resource Id of the delegated managed identity resource.')
  delegatedManagedIdentityResourceId: string?
}[]?

type diagnosticSettingType = {
  @description('Optional. The name of diagnostic setting.')
  name: string?

  @description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to \'\' to disable log collection.')
  logCategoriesAndGroups: {
    @description('Optional. Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.')
    category: string?

    @description('Optional. Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to \'AllLogs\' to collect all logs.')
    categoryGroup: string?
  }[]?

  @description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to \'\' to disable log collection.')
  metricCategories: {
    @description('Required. Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to \'AllMetrics\' to collect all metrics.')
    category: string
  }[]?

  @description('Optional. A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.')
  logAnalyticsDestinationType: ('Dedicated' | 'AzureDiagnostics')?

  @description('Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  workspaceResourceId: string?

  @description('Optional. Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  storageAccountResourceId: string?

  @description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
  eventHubAuthorizationRuleResourceId: string?

  @description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  eventHubName: string?

  @description('Optional. The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.')
  marketplacePartnerResourceId: string?
}[]?
