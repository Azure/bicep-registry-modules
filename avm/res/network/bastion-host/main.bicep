metadata name = 'Bastion Hosts'
metadata description = 'This module deploys a Bastion Host.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the Azure Bastion resource.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Required. Shared services Virtual Network resource identifier.')
param vNetId string

@description('Optional. The Public IP resource ID to associate to the azureBastionSubnet. If empty, then the Public IP that is created as part of this module will be applied to the azureBastionSubnet.')
param bastionSubnetPublicIpResourceId string = ''

@description('Optional. Specifies the properties of the Public IP to create and be used by Azure Bastion, if no existing public IP was provided.')
param publicIPAddressObject object = {
  name: '${name}-pip'
}

@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingType

@description('Optional. The lock settings of the service.')
param lock lockType

@allowed([
  'Basic'
  'Standard'
])
@description('Optional. The SKU of this Bastion Host.')
param skuName string = 'Basic'

@description('Optional. Choose to disable or enable Copy Paste.')
param disableCopyPaste bool = false

@description('Optional. Choose to disable or enable File Copy.')
param enableFileCopy bool = true

@description('Optional. Choose to disable or enable IP Connect.')
param enableIpConnect bool = false

@description('Optional. Choose to disable or enable Kerberos authentication.')
param enableKerberos bool = false

@description('Optional. Choose to disable or enable Shareable Link.')
param enableShareableLink bool = false

@description('Optional. The scale units for the Bastion Host resource.')
param scaleUnits int = 2

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

// ----------------------------------------------------------------------------
// Prep ipConfigurations object AzureBastionSubnet for different uses cases:
// 1. Use existing Public IP
// 2. Use new Public IP created in this module
var ipConfigurations = [
  {
    name: 'IpConfAzureBastionSubnet'
    properties: union({
        subnet: {
          id: '${vNetId}/subnets/AzureBastionSubnet' // The subnet name must be AzureBastionSubnet
        }
      }, {
        //Use existing Public IP, new Public IP created in this module
        publicIPAddress: {
          id: !empty(bastionSubnetPublicIpResourceId) ? bastionSubnetPublicIpResourceId : publicIPAddress.outputs.resourceId
        }
      })
  }
]

var enableReferencedModulesTelemetry = false

// ----------------------------------------------------------------------------

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f58310d9-a9f6-439a-9e8d-f62e7b41a168')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
}

resource defaultTelemetry 'Microsoft.Resources/deployments@2022-09-01' = if (enableDefaultTelemetry) {
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

module publicIPAddress '../public-ip-address/main.bicep' = if (empty(bastionSubnetPublicIpResourceId)) {
  name: '${uniqueString(deployment().name, location)}-Bastion-PIP'
  params: {
    name: publicIPAddressObject.name
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    location: location
    lock: lock
    diagnosticSettings: publicIPAddressObject.?diagnosticSettings
    publicIPAddressVersion: contains(publicIPAddressObject, 'publicIPAddressVersion') ? publicIPAddressObject.publicIPAddressVersion : 'IPv4'
    publicIPAllocationMethod: contains(publicIPAddressObject, 'publicIPAllocationMethod') ? publicIPAddressObject.publicIPAllocationMethod : 'Static'
    publicIPPrefixResourceId: contains(publicIPAddressObject, 'publicIPPrefixResourceId') ? publicIPAddressObject.publicIPPrefixResourceId : ''
    roleAssignments: contains(publicIPAddressObject, 'roleAssignments') ? publicIPAddressObject.roleAssignments : []
    skuName: contains(publicIPAddressObject, 'skuName') ? publicIPAddressObject.skuName : 'Standard'
    skuTier: contains(publicIPAddressObject, 'skuTier') ? publicIPAddressObject.skuTier : 'Regional'
    tags: publicIPAddressObject.?tags ?? tags
    zones: contains(publicIPAddressObject, 'zones') ? publicIPAddressObject.zones : []
  }
}

var bastionpropertiesVar = union({
    scaleUnits: skuName == 'Basic' ? 2 : scaleUnits
    ipConfigurations: ipConfigurations
    enableKerberos: enableKerberos
  }, (skuName == 'Standard' ? {
    enableTunneling: skuName == 'Standard'
    disableCopyPaste: disableCopyPaste
    enableFileCopy: enableFileCopy
    enableIpConnect: enableIpConnect
    enableShareableLink: enableShareableLink
  } : {})
)

resource azureBastion 'Microsoft.Network/bastionHosts@2022-11-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: skuName
  }
  properties: bastionpropertiesVar
}

resource azureBastion_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot delete or modify the resource or child resources.'
  }
  scope: azureBastion
}

resource azureBastion_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [for (diagnosticSetting, index) in (diagnosticSettings ?? []): {
  name: diagnosticSetting.?name ?? '${name}-diagnosticSettings'
  properties: {
    storageAccountId: diagnosticSetting.?storageAccountResourceId
    workspaceId: diagnosticSetting.?workspaceResourceId
    eventHubAuthorizationRuleId: diagnosticSetting.?eventHubAuthorizationRuleResourceId
    eventHubName: diagnosticSetting.?eventHubName
    logs: diagnosticSetting.?logCategoriesAndGroups ?? [
      {
        categoryGroup: 'AllLogs'
        enabled: true
      }
    ]
    marketplacePartnerId: diagnosticSetting.?marketplacePartnerResourceId
    logAnalyticsDestinationType: diagnosticSetting.?logAnalyticsDestinationType
  }
  scope: azureBastion
}]

resource azureBastion_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (roleAssignment, index) in (roleAssignments ?? []): {
  name: guid(azureBastion.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : contains(roleAssignment.roleDefinitionIdOrName, '/providers/Microsoft.Authorization/roleDefinitions/') ? roleAssignment.roleDefinitionIdOrName : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName)
    principalId: roleAssignment.principalId
    description: roleAssignment.?description
    principalType: roleAssignment.?principalType
    condition: roleAssignment.?condition
    conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
    delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
  }
  scope: azureBastion
}]

@description('The resource group the Azure Bastion was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name the Azure Bastion.')
output name string = azureBastion.name

@description('The resource ID the Azure Bastion.')
output resourceId string = azureBastion.id

@description('The location the resource was deployed into.')
output location string = azureBastion.location

@description('The Public IPconfiguration object for the AzureBastionSubnet.')
output ipConfAzureBastionSubnet object = azureBastion.properties.ipConfigurations[0]

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
