metadata name = 'Recovery Services Vaults'
metadata description = 'This module deploys a Recovery Services Vault.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the Azure Recovery Service Vault.')
param name string

@description('Optional. The storage configuration for the Azure Recovery Service Vault.')
param backupStorageConfig object = {}

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. List of all backup policies.')
param backupPolicies array = []

@description('Optional. The backup configuration.')
param backupConfig object = {}

@description('Optional. List of all protection containers.')
@minLength(0)
param protectionContainers array = []

@description('Optional. List of all replication fabrics.')
@minLength(0)
param replicationFabrics array = []

@description('Optional. List of all replication policies.')
@minLength(0)
param replicationPolicies array = []

@description('Optional. Replication alert settings.')
param replicationAlertSettings object = {}

@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingType

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentitiesType

@description('Optional. Tags of the Recovery Service Vault resource.')
param tags object?

@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointType

@description('Optional. Monitoring Settings of the vault.')
param monitoringSettings object = {}

@description('Optional. Security Settings of the vault.')
param securitySettings object = {}

@description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Disabled'

var formattedUserAssignedIdentities = reduce(map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }), {}, (cur, next) => union(cur, next)) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities) ? {
  type: (managedIdentities.?systemAssigned ?? false) ? (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned') : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : null)
  userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
} : null

var enableReferencedModulesTelemetry = false

var builtInRoleNames = {
  'Backup Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '5e467623-bb1f-42f4-a55d-6e525e11384b')
  'Backup Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '00c29273-979b-4161-815c-10b084fb9324')
  'Backup Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a795c7a0-d4a2-40c1-ae25-d81f01202912')
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f58310d9-a9f6-439a-9e8d-f62e7b41a168')
  'Site Recovery Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '6670b86e-a3f7-4917-ac9b-5d6ab1be4567')
  'Site Recovery Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '494ae006-db33-4328-bf46-533a6560a3ca')
  'Site Recovery Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'dbaa88c4-0c30-4179-9fb3-46319faa6149')
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

resource rsv 'Microsoft.RecoveryServices/vaults@2023-01-01' = {
  name: name
  location: location
  tags: tags
  identity: identity
  sku: {
    name: 'RS0'
    tier: 'Standard'
  }
  properties: {
    monitoringSettings: !empty(monitoringSettings) ? monitoringSettings : null
    securitySettings: !empty(securitySettings) ? securitySettings : null
    publicNetworkAccess: publicNetworkAccess
  }
}

module rsv_replicationFabrics 'replication-fabric/main.bicep' = [for (replicationFabric, index) in replicationFabrics: {
  name: '${uniqueString(deployment().name, location)}-RSV-Fabric-${index}'
  params: {
    recoveryVaultName: rsv.name
    name: contains(replicationFabric, 'name') ? replicationFabric.name : replicationFabric.location
    location: replicationFabric.location
    replicationContainers: contains(replicationFabric, 'replicationContainers') ? replicationFabric.replicationContainers : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
  dependsOn: [
    rsv_replicationPolicies
  ]
}]

module rsv_replicationPolicies 'replication-policy/main.bicep' = [for (replicationPolicy, index) in replicationPolicies: {
  name: '${uniqueString(deployment().name, location)}-RSV-Policy-${index}'
  params: {
    name: replicationPolicy.name
    recoveryVaultName: rsv.name
    appConsistentFrequencyInMinutes: contains(replicationPolicy, 'appConsistentFrequencyInMinutes') ? replicationPolicy.appConsistentFrequencyInMinutes : 60
    crashConsistentFrequencyInMinutes: contains(replicationPolicy, 'crashConsistentFrequencyInMinutes') ? replicationPolicy.crashConsistentFrequencyInMinutes : 5
    multiVmSyncStatus: contains(replicationPolicy, 'multiVmSyncStatus') ? replicationPolicy.multiVmSyncStatus : 'Enable'
    recoveryPointHistory: contains(replicationPolicy, 'recoveryPointHistory') ? replicationPolicy.recoveryPointHistory : 1440
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module rsv_backupStorageConfiguration 'backup-storage-config/main.bicep' = if (!empty(backupStorageConfig)) {
  name: '${uniqueString(deployment().name, location)}-RSV-BackupStorageConfig'
  params: {
    recoveryVaultName: rsv.name
    storageModelType: backupStorageConfig.storageModelType
    crossRegionRestoreFlag: backupStorageConfig.crossRegionRestoreFlag
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

module rsv_backupFabric_protectionContainers 'backup-fabric/protection-container/main.bicep' = [for (protectionContainer, index) in protectionContainers: {
  name: '${uniqueString(deployment().name, location)}-RSV-ProtectionContainers-${index}'
  params: {
    recoveryVaultName: rsv.name
    name: protectionContainer.name
    sourceResourceId: protectionContainer.sourceResourceId
    friendlyName: protectionContainer.friendlyName
    backupManagementType: protectionContainer.backupManagementType
    containerType: protectionContainer.containerType
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    protectedItems: contains(protectionContainer, 'protectedItems') ? protectionContainer.protectedItems : []
    location: location
  }
}]

module rsv_backupPolicies 'backup-policy/main.bicep' = [for (backupPolicy, index) in backupPolicies: {
  name: '${uniqueString(deployment().name, location)}-RSV-BackupPolicy-${index}'
  params: {
    recoveryVaultName: rsv.name
    name: backupPolicy.name
    properties: backupPolicy.properties
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module rsv_backupConfig 'backup-config/main.bicep' = if (!empty(backupConfig)) {
  name: '${uniqueString(deployment().name, location)}-RSV-BackupConfig'
  params: {
    recoveryVaultName: rsv.name
    name: contains(backupConfig, 'name') ? backupConfig.name : 'vaultconfig'
    enhancedSecurityState: contains(backupConfig, 'enhancedSecurityState') ? backupConfig.enhancedSecurityState : 'Enabled'
    resourceGuardOperationRequests: contains(backupConfig, 'resourceGuardOperationRequests') ? backupConfig.resourceGuardOperationRequests : []
    softDeleteFeatureState: contains(backupConfig, 'softDeleteFeatureState') ? backupConfig.softDeleteFeatureState : 'Enabled'
    storageModelType: contains(backupConfig, 'storageModelType') ? backupConfig.storageModelType : 'GeoRedundant'
    storageType: contains(backupConfig, 'storageType') ? backupConfig.storageType : 'GeoRedundant'
    storageTypeState: contains(backupConfig, 'storageTypeState') ? backupConfig.storageTypeState : 'Locked'
    isSoftDeleteFeatureStateEditable: contains(backupConfig, 'isSoftDeleteFeatureStateEditable') ? backupConfig.isSoftDeleteFeatureStateEditable : true
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

module rsv_replicationAlertSettings 'replication-alert-setting/main.bicep' = if (!empty(replicationAlertSettings)) {
  name: '${uniqueString(deployment().name, location)}-RSV-replicationAlertSettings'
  params: {
    name: 'defaultAlertSetting'
    recoveryVaultName: rsv.name
    customEmailAddresses: contains(replicationAlertSettings, 'customEmailAddresses') ? replicationAlertSettings.customEmailAddresses : []
    locale: contains(replicationAlertSettings, 'locale') ? replicationAlertSettings.locale : ''
    sendToOwners: contains(replicationAlertSettings, 'sendToOwners') ? replicationAlertSettings.sendToOwners : 'Send'
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

resource rsv_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot delete or modify the resource or child resources.'
  }
  scope: rsv
}

resource rsv_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [for (diagnosticSetting, index) in (diagnosticSettings ?? []): {
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
  scope: rsv
}]

module rsv_privateEndpoints '../../network/private-endpoint/main.bicep' = [for (privateEndpoint, index) in (privateEndpoints ?? []): {
  name: '${uniqueString(deployment().name, location)}-rsv-PrivateEndpoint-${index}'
  params: {
    groupIds: [
      privateEndpoint.?service ?? 'AzureSiteRecovery'
    ]
    name: privateEndpoint.?name ?? 'pep-${last(split(rsv.id, '/'))}-${privateEndpoint.?service ?? 'AzureSiteRecovery'}-${index}'
    serviceResourceId: rsv.id
    subnetResourceId: privateEndpoint.subnetResourceId
    enableDefaultTelemetry: privateEndpoint.?enableDefaultTelemetry ?? enableReferencedModulesTelemetry
    location: privateEndpoint.?location ?? reference(split(privateEndpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location
    lock: privateEndpoint.?lock ?? lock
    privateDnsZoneGroupName: privateEndpoint.?privateDnsZoneGroupName
    privateDnsZoneResourceIds: privateEndpoint.?privateDnsZoneResourceIds
    roleAssignments: privateEndpoint.?roleAssignments
    tags: privateEndpoint.?tags ?? tags
    manualPrivateLinkServiceConnections: privateEndpoint.?manualPrivateLinkServiceConnections
    customDnsConfigs: privateEndpoint.?customDnsConfigs
    ipConfigurations: privateEndpoint.?ipConfigurations
    applicationSecurityGroupResourceIds: privateEndpoint.?applicationSecurityGroupResourceIds
    customNetworkInterfaceName: privateEndpoint.?customNetworkInterfaceName
  }
}]

resource rsv_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (roleAssignment, index) in (roleAssignments ?? []): {
  name: guid(rsv.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : contains(roleAssignment.roleDefinitionIdOrName, '/providers/Microsoft.Authorization/roleDefinitions/') ? roleAssignment.roleDefinitionIdOrName : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName)
    principalId: roleAssignment.principalId
    description: roleAssignment.?description
    principalType: roleAssignment.?principalType
    condition: roleAssignment.?condition
    conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
    delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
  }
  scope: rsv
}]

@description('The resource ID of the recovery services vault.')
output resourceId string = rsv.id

@description('The name of the resource group the recovery services vault was created in.')
output resourceGroupName string = resourceGroup().name

@description('The Name of the recovery services vault.')
output name string = rsv.name

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string = (managedIdentities.?systemAssigned ?? false) && contains(rsv.identity, 'principalId') ? rsv.identity.principalId : ''

@description('The location the resource was deployed into.')
output location string = rsv.location

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

type privateEndpointType = {
  @description('Optional. The name of the private endpoint.')
  name: string?

  @description('Optional. The location to deploy the private endpoint to.')
  location: string?

  @description('Optional. The service (sub-) type to deploy the private endpoint for. For example "vault" or "blob".')
  service: string?

  @description('Required. Resource ID of the subnet where the endpoint needs to be created.')
  subnetResourceId: string

  @description('Optional. The name of the private DNS zone group to create if privateDnsZoneResourceIds were provided.')
  privateDnsZoneGroupName: string?

  @description('Optional. The private DNS zone groups to associate the private endpoint with. A DNS zone group can support up to 5 DNS zones.')
  privateDnsZoneResourceIds: string[]?

  @description('Optional. Custom DNS configurations.')
  customDnsConfigs: {
    @description('Required. Fqdn that resolves to private endpoint ip address.')
    fqdn: string?

    @description('Required. A list of private ip addresses of the private endpoint.')
    ipAddresses: string[]
  }[]?

  @description('Optional. A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints.')
  ipConfigurations: {
    @description('Required. The name of the resource that is unique within a resource group.')
    name: string

    @description('Required. Properties of private endpoint IP configurations.')
    properties: {
      @description('Required. The ID of a group obtained from the remote resource that this private endpoint should connect to.')
      groupId: string

      @description('Required. The member name of a group obtained from the remote resource that this private endpoint should connect to.')
      memberName: string

      @description('Required. A private ip address obtained from the private endpoint\'s subnet.')
      privateIPAddress: string
    }
  }[]?

  @description('Optional. Application security groups in which the private endpoint IP configuration is included.')
  applicationSecurityGroupResourceIds: string[]?

  @description('Optional. The custom name of the network interface attached to the private endpoint.')
  customNetworkInterfaceName: string?

  @description('Optional. Specify the type of lock.')
  lock: lockType

  @description('Optional. Array of role assignments to create.')
  roleAssignments: roleAssignmentType

  @description('Optional. Tags to be applied on all resources/resource groups in this deployment.')
  tags: object?

  @description('Optional. Manual PrivateLink Service Connections.')
  manualPrivateLinkServiceConnections: array?

  @description('Optional. Enable/Disable usage telemetry for module.')
  enableTelemetry: bool?
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
