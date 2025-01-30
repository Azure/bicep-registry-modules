metadata name = 'Recovery Services Vaults'
metadata description = 'This module deploys a Recovery Services Vault.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the Azure Recovery Service Vault.')
param name string

@description('Optional. The storage configuration for the Azure Recovery Service Vault.')
param backupStorageConfig backupStorageConfigType?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. List of all backup policies.')
param backupPolicies backupPolicyType[]?

@description('Optional. The backup configuration.')
param backupConfig backupConfigType?

@description('Optional. List of all protection containers.')
param protectedItems protectedItemType[]?

@description('Optional. List of all replication fabrics.')
param replicationFabrics replicationFabricType[]?

@description('Optional. List of all replication policies.')
param replicationPolicies replicationPolicyType[]?

@description('Optional. Replication alert settings.')
param replicationAlertSettings replicationAlertSettingsType?

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

@description('Optional. Tags of the Recovery Service Vault resource.')
param tags object?

import { privateEndpointSingleServiceType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointSingleServiceType[]?

@description('Optional. Monitoring Settings of the vault.')
param monitoringSettings monitoringSettingsType?

@description('Optional. Security Settings of the vault.')
param securitySettings securitySettingType?

@description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Disabled'

@description('Optional. The redundancy settings of the vault.')
param redundancySettings redundancySettingsType?

@description('Optional. The restore settings of the vault.')
param restoreSettings restoreSettingsType?

import { customerManagedKeyWithAutoRotateType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. The customer managed key definition.')
param customerManagedKey customerManagedKeyWithAutoRotateType?

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned')
        : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : 'None')
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

var builtInRoleNames = {
  'Backup Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '5e467623-bb1f-42f4-a55d-6e525e11384b'
  )
  'Backup Operator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '00c29273-979b-4161-815c-10b084fb9324'
  )
  'Backup Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'a795c7a0-d4a2-40c1-ae25-d81f01202912'
  )
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
  'Site Recovery Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '6670b86e-a3f7-4917-ac9b-5d6ab1be4567'
  )
  'Site Recovery Operator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '494ae006-db33-4328-bf46-533a6560a3ca'
  )
  'Site Recovery Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'dbaa88c4-0c30-4179-9fb3-46319faa6149'
  )
  'User Access Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  )
}

var formattedRoleAssignments = [
  for (roleAssignment, index) in (roleAssignments ?? []): union(roleAssignment, {
    roleDefinitionId: builtInRoleNames[?roleAssignment.roleDefinitionIdOrName] ?? (contains(
        roleAssignment.roleDefinitionIdOrName,
        '/providers/Microsoft.Authorization/roleDefinitions/'
      )
      ? roleAssignment.roleDefinitionIdOrName
      : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName))
  })
]

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.recoveryservices-vault.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource cMKKeyVault 'Microsoft.KeyVault/vaults@2023-02-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId)) {
  name: last(split((customerManagedKey.?keyVaultResourceId ?? 'dummyVault'), '/'))
  scope: resourceGroup(
    split((customerManagedKey.?keyVaultResourceId ?? '//'), '/')[2],
    split((customerManagedKey.?keyVaultResourceId ?? '////'), '/')[4]
  )

  resource cMKKey 'keys@2023-02-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId) && !empty(customerManagedKey.?keyName)) {
    name: customerManagedKey.?keyName ?? 'dummyKey'
  }
}

resource cMKUserAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = if (!empty(customerManagedKey.?userAssignedIdentityResourceId)) {
  name: last(split(customerManagedKey.?userAssignedIdentityResourceId ?? 'dummyMsi', '/'))
  scope: resourceGroup(
    split((customerManagedKey.?userAssignedIdentityResourceId ?? '//'), '/')[2],
    split((customerManagedKey.?userAssignedIdentityResourceId ?? '////'), '/')[4]
  )
}

resource rsv 'Microsoft.RecoveryServices/vaults@2024-04-01' = {
  name: name
  location: location
  tags: tags
  identity: identity
  sku: {
    name: 'RS0'
    tier: 'Standard'
  }
  properties: {
    monitoringSettings: !empty(monitoringSettings)
      ? {
          azureMonitorAlertSettings: !empty(monitoringSettings.?azureMonitorAlertSettings)
            ? {
                alertsForAllFailoverIssues: monitoringSettings!.azureMonitorAlertSettings.?alertsForAllFailoverIssues ?? 'Enabled'
                alertsForAllJobFailures: monitoringSettings!.azureMonitorAlertSettings.?alertsForAllJobFailures ?? 'Enabled'
                alertsForAllReplicationIssues: monitoringSettings!.azureMonitorAlertSettings.?alertsForAllReplicationIssues ?? 'Enabled'
              }
            : null
          classicAlertSettings: !empty(monitoringSettings.?classicAlertSettings)
            ? {
                alertsForCriticalOperations: monitoringSettings!.classicAlertSettings.?alertsForCriticalOperations ?? 'Enabled'
                emailNotificationsForSiteRecovery: monitoringSettings!.classicAlertSettings.?emailNotificationsForSiteRecovery ?? 'Enabled'
              }
            : null
        }
      : null
    securitySettings: securitySettings
    publicNetworkAccess: publicNetworkAccess
    redundancySettings: redundancySettings
    restoreSettings: restoreSettings
    encryption: !empty(customerManagedKey)
      ? {
          infrastructureEncryption: 'Enabled'
          kekIdentity: !empty(customerManagedKey.?userAssignedIdentityResourceId)
            ? {
                userAssignedIdentity: cMKUserAssignedIdentity.id
              }
            : {
                useSystemAssignedIdentity: empty(customerManagedKey.?userAssignedIdentityResourceId)
              }
          keyVaultProperties: {
            keyUri: !empty(customerManagedKey.?keyVersion)
              ? '${cMKKeyVault::cMKKey.properties.keyUri}/${customerManagedKey!.keyVersion}'
              : (customerManagedKey.?autoRotationEnabled ?? true)
                  ? cMKKeyVault::cMKKey.properties.keyUri
                  : cMKKeyVault::cMKKey.properties.keyUriWithVersion
          }
        }
      : null
  }
}

module rsv_replicationFabrics 'replication-fabric/main.bicep' = [
  for (replicationFabric, index) in (replicationFabrics ?? []): {
    name: '${uniqueString(deployment().name, location)}-RSV-Fabric-${index}'
    params: {
      recoveryVaultName: rsv.name
      name: replicationFabric.?name
      location: replicationFabric.location
      replicationContainers: replicationFabric.?replicationContainers
    }
    dependsOn: [
      rsv_replicationPolicies
    ]
  }
]

module rsv_replicationPolicies 'replication-policy/main.bicep' = [
  for (replicationPolicy, index) in (replicationPolicies ?? []): {
    name: '${uniqueString(deployment().name, location)}-RSV-Policy-${index}'
    params: {
      name: replicationPolicy.name
      recoveryVaultName: rsv.name
      appConsistentFrequencyInMinutes: replicationPolicy.?appConsistentFrequencyInMinutes
      crashConsistentFrequencyInMinutes: replicationPolicy.?crashConsistentFrequencyInMinutes
      multiVmSyncStatus: replicationPolicy.?multiVmSyncStatus
      recoveryPointHistory: replicationPolicy.?recoveryPointHistory
    }
  }
]

module rsv_backupStorageConfiguration 'backup-storage-config/main.bicep' = if (!empty(backupStorageConfig)) {
  name: '${uniqueString(deployment().name, location)}-RSV-BackupStorageConfig'
  params: {
    recoveryVaultName: rsv.name
    storageModelType: backupStorageConfig!.storageModelType
    crossRegionRestoreFlag: backupStorageConfig!.crossRegionRestoreFlag
  }
}

module rsv_backupFabric_protectionContainer_protectedItems 'backup-fabric/protection-container/protected-item/main.bicep' = [
  for (protectedItem, index) in (protectedItems ?? []): {
    name: '${uniqueString(deployment().name, location)}-ProtectedItem-${index}'
    params: {
      recoveryVaultName: rsv.name
      name: protectedItem.name
      location: location
      policyName: protectedItem.policyName
      protectedItemType: protectedItem.protectedItemType
      protectionContainerName: protectedItem.protectionContainerName
      sourceResourceId: protectedItem.sourceResourceId
    }
    dependsOn: [
      rsv_backupPolicies
    ]
  }
]

module rsv_backupPolicies 'backup-policy/main.bicep' = [
  for (backupPolicy, index) in (backupPolicies ?? []): {
    name: '${uniqueString(deployment().name, location)}-RSV-BackupPolicy-${index}'
    params: {
      recoveryVaultName: rsv.name
      name: backupPolicy.name
      properties: backupPolicy.properties
    }
  }
]

module rsv_backupConfig 'backup-config/main.bicep' = if (!empty(backupConfig)) {
  name: '${uniqueString(deployment().name, location)}-RSV-BackupConfig'
  params: {
    recoveryVaultName: rsv.name
    name: backupConfig.?name
    enhancedSecurityState: backupConfig.?enhancedSecurityState
    resourceGuardOperationRequests: backupConfig.?resourceGuardOperationRequests
    softDeleteFeatureState: backupConfig.?softDeleteFeatureState
    storageModelType: backupConfig.?storageModelType
    storageType: backupConfig.?storageType
    storageTypeState: backupConfig.?storageTypeState
    isSoftDeleteFeatureStateEditable: backupConfig.?isSoftDeleteFeatureStateEditable
  }
}

module rsv_replicationAlertSettings 'replication-alert-setting/main.bicep' = if (!empty(replicationAlertSettings)) {
  name: '${uniqueString(deployment().name, location)}-RSV-replicationAlertSettings'
  params: {
    name: 'defaultAlertSetting'
    recoveryVaultName: rsv.name
    customEmailAddresses: replicationAlertSettings.?customEmailAddresses
    locale: replicationAlertSettings.?locale
    sendToOwners: replicationAlertSettings.?sendToOwners
  }
}

resource rsv_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: rsv
}

resource rsv_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for (diagnosticSetting, index) in (diagnosticSettings ?? []): {
    name: diagnosticSetting.?name ?? '${name}-diagnosticSettings'
    properties: {
      storageAccountId: diagnosticSetting.?storageAccountResourceId
      workspaceId: diagnosticSetting.?workspaceResourceId
      eventHubAuthorizationRuleId: diagnosticSetting.?eventHubAuthorizationRuleResourceId
      eventHubName: diagnosticSetting.?eventHubName
      metrics: [
        for group in (diagnosticSetting.?metricCategories ?? [{ category: 'AllMetrics' }]): {
          category: group.category
          enabled: group.?enabled ?? true
          timeGrain: null
        }
      ]
      logs: [
        for group in (diagnosticSetting.?logCategoriesAndGroups ?? [{ categoryGroup: 'allLogs' }]): {
          categoryGroup: group.?categoryGroup
          category: group.?category
          enabled: group.?enabled ?? true
        }
      ]
      marketplacePartnerId: diagnosticSetting.?marketplacePartnerResourceId
      logAnalyticsDestinationType: diagnosticSetting.?logAnalyticsDestinationType
    }
    scope: rsv
  }
]

module rsv_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.9.0' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-rsv-PrivateEndpoint-${index}'
    scope: resourceGroup(privateEndpoint.?resourceGroupName ?? '')
    params: {
      name: privateEndpoint.?name ?? 'pep-${last(split(rsv.id, '/'))}-${privateEndpoint.?service ?? 'AzureSiteRecovery'}-${index}'
      privateLinkServiceConnections: privateEndpoint.?isManualConnection != true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(rsv.id, '/'))}-${privateEndpoint.?service ?? 'AzureSiteRecovery'}-${index}'
              properties: {
                privateLinkServiceId: rsv.id
                groupIds: [
                  privateEndpoint.?service ?? 'AzureSiteRecovery'
                ]
              }
            }
          ]
        : null
      manualPrivateLinkServiceConnections: privateEndpoint.?isManualConnection == true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(rsv.id, '/'))}-${privateEndpoint.?service ?? 'AzureSiteRecovery'}-${index}'
              properties: {
                privateLinkServiceId: rsv.id
                groupIds: [
                  privateEndpoint.?service ?? 'AzureSiteRecovery'
                ]
                requestMessage: privateEndpoint.?manualConnectionRequestMessage ?? 'Manual approval required.'
              }
            }
          ]
        : null
      subnetResourceId: privateEndpoint.subnetResourceId
      enableTelemetry: privateEndpoint.?enableTelemetry ?? enableTelemetry
      location: privateEndpoint.?location ?? reference(
        split(privateEndpoint.subnetResourceId, '/subnets/')[0],
        '2020-06-01',
        'Full'
      ).location
      lock: privateEndpoint.?lock ?? lock
      privateDnsZoneGroup: privateEndpoint.?privateDnsZoneGroup
      roleAssignments: privateEndpoint.?roleAssignments
      tags: privateEndpoint.?tags ?? tags
      customDnsConfigs: privateEndpoint.?customDnsConfigs
      ipConfigurations: privateEndpoint.?ipConfigurations
      applicationSecurityGroupResourceIds: privateEndpoint.?applicationSecurityGroupResourceIds
      customNetworkInterfaceName: privateEndpoint.?customNetworkInterfaceName
    }
  }
]

resource rsv_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(rsv.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: rsv
  }
]

@description('The resource ID of the recovery services vault.')
output resourceId string = rsv.id

@description('The name of the resource group the recovery services vault was created in.')
output resourceGroupName string = resourceGroup().name

@description('The Name of the recovery services vault.')
output name string = rsv.name

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string? = rsv.?identity.?principalId

@description('The location the resource was deployed into.')
output location string = rsv.location

@description('The private endpoints of the recovery services vault.')
output privateEndpoints array = [
  for (item, index) in (!empty(privateEndpoints) ? array(privateEndpoints) : []): {
    name: rsv_privateEndpoints[index].outputs.name
    resourceId: rsv_privateEndpoints[index].outputs.resourceId
    groupId: rsv_privateEndpoints[index].outputs.groupId
    customDnsConfigs: rsv_privateEndpoints[index].outputs.customDnsConfig
    networkInterfaceResourceIds: rsv_privateEndpoints[index].outputs.networkInterfaceResourceIds
  }
]

// =============== //
//   Definitions   //
// =============== //

@export()
@description('The type for redundancy settings.')
type redundancySettingsType = {
  @description('Optional. Flag to show if Cross Region Restore is enabled on the Vault or not.')
  crossRegionRestore: string?

  @description('Optional. The storage redundancy setting of a vault.')
  standardTierStorageRedundancy: string?
}

@export()
@description('The type for restore settings.')
type restoreSettingsType = {
  @description('Required. The restore settings of the vault.')
  crossSubscriptionRestoreSettings: {
    @description('Required. The restore settings of the vault.')
    crossSubscriptionRestoreState: string
  }
}

import { containerType } from 'replication-fabric/main.bicep'
@export()
@description('The type for replication fabrics.')
type replicationFabricType = {
  @description('Optional. The name of the fabric.')
  name: string?

  @description('Optional. The recovery location the fabric represents.')
  location: string?

  @description('Optional. Replication containers to create.')
  replicationContainers: containerType[]?
}

@export()
@description('The type for replication policies.')
type replicationPolicyType = {
  @description('Required. The name of the replication policy.')
  name: string

  @description('Optional. The app consistent snapshot frequency (in minutes).')
  appConsistentFrequencyInMinutes: int?

  @description('Optional. The crash consistent snapshot frequency (in minutes).')
  crashConsistentFrequencyInMinutes: int?

  @description('Optional. A value indicating whether multi-VM sync has to be enabled.')
  multiVmSyncStatus: ('Enable' | 'Disable')?

  @description('Optional. The duration in minutes until which the recovery points need to be stored.')
  recoveryPointHistory: int?
}

@export()
@description('The type for a backup storage config.')
type backupStorageConfigType = {
  @description('Optional. The name of the backup storage config.')
  name: string?

  @description('Optional. Change Vault Storage Type (Works if vault has not registered any backup instance).')
  storageModelType: ('GeoRedundant' | 'LocallyRedundant' | 'ReadAccessGeoZoneRedundant' | 'ZoneRedundant')?

  @description('Optional. Opt in details of Cross Region Restore feature.')
  crossRegionRestoreFlag: bool?
}

@export()
@description('The type for a backup configuration.')
type backupConfigType = {
  @description('Optional. Name of the Azure Recovery Service Vault Backup Policy.')
  name: string?

  @description('Optional. Enable this setting to protect hybrid backups against accidental deletes and add additional layer of authentication for critical operations.')
  enhancedSecurityState: ('Disabled' | 'Enabled')?

  @description('Optional. ResourceGuard Operation Requests.')
  resourceGuardOperationRequests: object[]?

  @description('Optional. Enable this setting to protect backup data for Azure VM, SQL Server in Azure VM and SAP HANA in Azure VM from accidental deletes.')
  softDeleteFeatureState: ('Disabled' | 'Enabled')?

  @description('Optional. Storage type.')
  storageModelType: ('GeoRedundant' | 'LocallyRedundant' | 'ReadAccessGeoZoneRedundant' | 'ZoneRedundant')?

  @description('Optional. Storage type.')
  storageType: ('GeoRedundant' | 'LocallyRedundant' | 'ReadAccessGeoZoneRedundant' | 'ZoneRedundant')?

  @description('Optional. Once a machine is registered against a resource, the storageTypeState is always Locked.')
  storageTypeState: ('Locked' | 'Unlocked')?

  @description('Optional. Is soft delete feature state editable.')
  isSoftDeleteFeatureStateEditable: bool?
}

@export()
@description('The type for replication alert settings')
type replicationAlertSettingsType = {
  @description('Optional. The name of the replication Alert Setting.')
  name: string?

  @description('Optional. The custom email address for sending emails.')
  customEmailAddresses: string[]?

  @description('Optional. The locale for the email notification.')
  locale: string?

  @description('Optional. The value indicating whether to send email to subscription administrator.')
  sendToOwners: ('DoNotSend' | 'Send')?
}

@export()
@description('The type for a protected item')
type protectedItemType = {
  @description('Required. Name of the resource.')
  name: string

  @description('Optional. Location for all resources.')
  location: string?

  @description('Required. Name of the Azure Recovery Service Vault Protection Container.')
  protectionContainerName: string

  @description('Required. The backup item type.')
  protectedItemType: (
    | 'AzureFileShareProtectedItem'
    | 'AzureVmWorkloadSAPAseDatabase'
    | 'AzureVmWorkloadSAPHanaDatabase'
    | 'AzureVmWorkloadSQLDatabase'
    | 'DPMProtectedItem'
    | 'GenericProtectedItem'
    | 'MabFileFolderProtectedItem'
    | 'Microsoft.ClassicCompute/virtualMachines'
    | 'Microsoft.Compute/virtualMachines'
    | 'Microsoft.Sql/servers/databases')

  @description('Required. The backup policy with which this item is backed up.')
  policyName: string

  @description('Required. Resource ID of the resource to back up.')
  sourceResourceId: string
}

@export()
@description('The type of a backup policy.')
type backupPolicyType = {
  @description('Required. Name of the Azure Recovery Service Vault Backup Policy.')
  name: string

  @description('Required. Configuration of the Azure Recovery Service Vault Backup Policy.')
  properties: object
}

@export()
type monitoringSettingsType = {
  @description('Optional. The alert settings.')
  azureMonitorAlertSettings: {
    @description('Optional. Enable / disable alerts for all failover issues.')
    alertsForAllFailoverIssues: ('Enabled' | 'Disabled')?

    @description('Optional. Enable / disable alerts for all job failures.')
    alertsForAllJobFailures: ('Enabled' | 'Disabled')?

    @description('Optional. Enable / disable alerts for all replication issues.')
    alertsForAllReplicationIssues: ('Enabled' | 'Disabled')?
  }?

  @description('Optional. The classic alert settings.')
  classicAlertSettings: {
    @description('Optional. Enable / disable alerts for critical operations.')
    alertsForCriticalOperations: ('Enabled' | 'Disabled')?

    @description('Optional. Enable / disable email notifications for site recovery.')
    emailNotificationsForSiteRecovery: ('Enabled' | 'Disabled')?
  }?
}

@export()
@description('The type for security settings.')
type securitySettingType = {
  @description('Optional. Immutability settings of a vault.')
  immutabilitySettings: {
    @description('Required. The immmutability setting of the vault.')
    state: ('Disabled' | 'Locked' | 'Unlocked')
  }?

  @description('Optional. Soft delete settings of a vault.')
  softDeleteSettings: {
    @description('Required. The enhanced security state.')
    enhancedSecurityState: ('AlwaysON' | 'Disabled' | 'Enabled' | 'Invalid')

    @description('Required. The soft delete retention period in days.')
    softDeleteRetentionPeriodInDays: int

    @description('Required. The soft delete state.')
    softDeleteState: ('AlwaysON' | 'Disabled' | 'Enabled' | 'Invalid')
  }?
}
