metadata name = 'App Service Environments'
metadata description = 'This module deploys an App Service Environment.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the App Service Environment.')
@minLength(1)
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. Resource tags.')
param tags object?

@allowed([
  'ASEv2'
  'ASEv3'
])
@description('Optional. Kind of resource.')
param kind string = 'ASEv3'

@description('Optional. Custom settings for changing the behavior of the App Service Environment.')
param clusterSettings array = [
  {
    name: 'DisableTls1.0'
    value: '1'
  }
]

@description('Optional. Enable the default custom domain suffix to use for all sites deployed on the ASE. If provided, then customDnsSuffixCertificateUrl and customDnsSuffixKeyVaultReferenceIdentity are required. Cannot be used when kind is set to ASEv2.')
param customDnsSuffix string = ''

@description('Conditional. The URL referencing the Azure Key Vault certificate secret that should be used as the default SSL/TLS certificate for sites with the custom domain suffix. Required if customDnsSuffix is not empty. Cannot be used when kind is set to ASEv2.')
param customDnsSuffixCertificateUrl string = ''

@description('Conditional. The user-assigned identity to use for resolving the key vault certificate reference. If not specified, the system-assigned ASE identity will be used if available. Required if customDnsSuffix is not empty. Cannot be used when kind is set to ASEv2.')
param customDnsSuffixKeyVaultReferenceIdentity string = ''

@description('Optional. The Dedicated Host Count. If `zoneRedundant` is false, and you want physical hardware isolation enabled, set to 2. Otherwise 0. Cannot be used when kind is set to ASEv2.')
param dedicatedHostCount int = 0

@description('Optional. DNS suffix of the App Service Environment.')
param dnsSuffix string = ''

@description('Optional. Scale factor for frontends.')
param frontEndScaleFactor int = 15

@description('Optional. Specifies which endpoints to serve internally in the Virtual Network for the App Service Environment. - None, Web, Publishing, Web,Publishing. "None" Exposes the ASE-hosted apps on an internet-accessible IP address.')
@allowed([
  'None'
  'Web'
  'Publishing'
  'Web, Publishing'
])
param internalLoadBalancingMode string = 'None'

@description('Optional. Number of IP SSL addresses reserved for the App Service Environment. Cannot be used when kind is set to ASEv3.')
param ipsslAddressCount int = 0

@description('Optional. Frontend VM size. Cannot be used when kind is set to ASEv3.')
@allowed([
  ''
  'Medium'
  'Large'
  'ExtraLarge'
  'Standard_D2'
  'Standard_D3'
  'Standard_D4'
  'Standard_D1_V2'
  'Standard_D2_V2'
  'Standard_D3_V2'
  'Standard_D4_V2'
])
param multiSize string = ''

@description('Optional. Property to enable and disable new private endpoint connection creation on ASE. Ignored when kind is set to ASEv2.')
param allowNewPrivateEndpointConnections bool = false

@description('Optional. Property to enable and disable FTP on ASEV3. Ignored when kind is set to ASEv2.')
param ftpEnabled bool = false

@description('Optional. Customer provided Inbound IP Address. Only able to be set on Ase create. Ignored when kind is set to ASEv2.')
param inboundIpAddressOverride string = ''

@description('Optional. Property to enable and disable Remote Debug on ASEv3. Ignored when kind is set to ASEv2.')
param remoteDebugEnabled bool = false

@description('Optional. Specify preference for when and how the planned maintenance is applied.')
@allowed([
  'Early'
  'Late'
  'Manual'
  'None'
])
param upgradePreference string = 'None'

@description('Required. ResourceId for the subnet.')
param subnetResourceId string

@description('Optional. User added IP ranges to whitelist on ASE DB. Cannot be used with \'kind\' `ASEv3`.')
param userWhitelistedIpRanges array = []

@description('Optional. Switch to make the App Service Environment zone redundant. If enabled, the minimum App Service plan instance count will be three, otherwise 1. If enabled, the `dedicatedHostCount` must be set to `-1`.')
param zoneRedundant bool = false

@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentitiesType

@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingType

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

var formattedUserAssignedIdentities = reduce(map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }), {}, (cur, next) => union(cur, next)) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities) ? {
  type: (managedIdentities.?systemAssigned ?? false) ? (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned') : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : null)
  userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
} : any(null)

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

resource appServiceEnvironment 'Microsoft.Web/hostingEnvironments@2022-03-01' = {
  name: name
  kind: kind
  location: location
  tags: tags
  identity: identity
  properties: {
    clusterSettings: clusterSettings
    dedicatedHostCount: dedicatedHostCount != 0 ? dedicatedHostCount : null
    dnsSuffix: !empty(dnsSuffix) ? dnsSuffix : null
    frontEndScaleFactor: frontEndScaleFactor
    internalLoadBalancingMode: internalLoadBalancingMode
    ipsslAddressCount: ipsslAddressCount != 0 ? ipsslAddressCount : null
    multiSize: !empty(multiSize) ? any(multiSize) : null
    upgradePreference: upgradePreference
    userWhitelistedIpRanges: !empty(userWhitelistedIpRanges) ? userWhitelistedIpRanges : null
    virtualNetwork: {
      id: subnetResourceId
      subnet: last(split(subnetResourceId, '/'))
    }
    zoneRedundant: zoneRedundant
  }
}

module appServiceEnvironment_configurations_networking 'configuration--networking/main.bicep' = if (kind == 'ASEv3') {
  name: '${uniqueString(deployment().name, location)}-AppServiceEnv-Configurations-Networking'
  params: {
    hostingEnvironmentName: appServiceEnvironment.name
    allowNewPrivateEndpointConnections: allowNewPrivateEndpointConnections
    ftpEnabled: ftpEnabled
    inboundIpAddressOverride: inboundIpAddressOverride
    remoteDebugEnabled: remoteDebugEnabled
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

module appServiceEnvironment_configurations_customDnsSuffix 'configuration--customdnssuffix/main.bicep' = if (kind == 'ASEv3' && !empty(customDnsSuffix)) {
  name: '${uniqueString(deployment().name, location)}-AppServiceEnv-Configurations-CustomDnsSuffix'
  params: {
    hostingEnvironmentName: appServiceEnvironment.name
    certificateUrl: customDnsSuffixCertificateUrl
    keyVaultReferenceIdentity: customDnsSuffixKeyVaultReferenceIdentity
    dnsSuffix: customDnsSuffix
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

resource appServiceEnvironment_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot delete or modify the resource or child resources.'
  }
  scope: appServiceEnvironment
}

resource appServiceEnvironment_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [for (diagnosticSetting, index) in (diagnosticSettings ?? []): {
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
  scope: appServiceEnvironment
}]

resource appServiceEnvironment_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (roleAssignment, index) in (roleAssignments ?? []): {
  name: guid(appServiceEnvironment.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : contains(roleAssignment.roleDefinitionIdOrName, '/providers/Microsoft.Authorization/roleDefinitions/') ? roleAssignment.roleDefinitionIdOrName : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName)
    principalId: roleAssignment.principalId
    description: roleAssignment.?description
    principalType: roleAssignment.?principalType
    condition: roleAssignment.?condition
    conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
    delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
  }
  scope: appServiceEnvironment
}]

@description('The resource ID of the App Service Environment.')
output resourceId string = appServiceEnvironment.id

@description('The resource group the App Service Environment was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the App Service Environment.')
output name string = appServiceEnvironment.name

@description('The location the resource was deployed into.')
output location string = appServiceEnvironment.location

// =============== //
//   Definitions   //
// =============== //

type managedIdentitiesType = {
  @description('Optional. Enables system assigned managed identity on the resource.')
  systemAssigned: bool?

  @description('Optional. The resource ID(s) to assign to the resource.')
  userAssignedResourceIds: string[]?
}?

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
