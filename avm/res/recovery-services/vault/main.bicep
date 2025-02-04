metadata name = 'Recovery Services Vaults'
metadata description = 'This module deploys a Recovery Services Vault.'

@description('Required. Name of the Azure Recovery Service Vault.')
param name string

@description('Optional. The storage configuration for the Azure Recovery Service Vault.')
param backupStorageConfig object = {}

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. List of all backup policies.')
param backupPolicies array = []

@description('Optional. The backup configuration.')
param backupConfig object = {}

@description('Optional. List of all protection containers.')
param protectionContainers array = []

@description('Optional. List of all replication fabrics.')
param replicationFabrics array = []

@description('Optional. List of all replication policies.')
param replicationPolicies array = []

@description('Optional. Replication alert settings.')
param replicationAlertSettings object = {}

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

@description('Optional. Tags of the Recovery Service Vault resource.')
param tags object?

import { privateEndpointSingleServiceType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointSingleServiceType[]?

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

module rsv_replicationFabrics 'replication-fabric/main.bicep' = [
  for (replicationFabric, index) in replicationFabrics: {
    name: '${uniqueString(deployment().name, location)}-RSV-Fabric-${index}'
    params: {
      recoveryVaultName: rsv.name
      name: contains(replicationFabric, 'name') ? replicationFabric.name : replicationFabric.location
      location: replicationFabric.location
      replicationContainers: contains(replicationFabric, 'replicationContainers')
        ? replicationFabric.replicationContainers
        : []
    }
    dependsOn: [
      rsv_replicationPolicies
    ]
  }
]

module rsv_replicationPolicies 'replication-policy/main.bicep' = [
  for (replicationPolicy, index) in replicationPolicies: {
    name: '${uniqueString(deployment().name, location)}-RSV-Policy-${index}'
    params: {
      name: replicationPolicy.name
      recoveryVaultName: rsv.name
      appConsistentFrequencyInMinutes: contains(replicationPolicy, 'appConsistentFrequencyInMinutes')
        ? replicationPolicy.appConsistentFrequencyInMinutes
        : 60
      crashConsistentFrequencyInMinutes: contains(replicationPolicy, 'crashConsistentFrequencyInMinutes')
        ? replicationPolicy.crashConsistentFrequencyInMinutes
        : 5
      multiVmSyncStatus: contains(replicationPolicy, 'multiVmSyncStatus')
        ? replicationPolicy.multiVmSyncStatus
        : 'Enable'
      recoveryPointHistory: contains(replicationPolicy, 'recoveryPointHistory')
        ? replicationPolicy.recoveryPointHistory
        : 1440
    }
  }
]

module rsv_backupStorageConfiguration 'backup-storage-config/main.bicep' = if (!empty(backupStorageConfig)) {
  name: '${uniqueString(deployment().name, location)}-RSV-BackupStorageConfig'
  params: {
    recoveryVaultName: rsv.name
    storageModelType: backupStorageConfig.storageModelType
    crossRegionRestoreFlag: backupStorageConfig.crossRegionRestoreFlag
  }
}

module rsv_backupFabric_protectionContainers 'backup-fabric/protection-container/main.bicep' = [
  for (protectionContainer, index) in protectionContainers: {
    name: '${uniqueString(deployment().name, location)}-RSV-ProtectionContainers-${index}'
    params: {
      recoveryVaultName: rsv.name
      name: protectionContainer.name
      sourceResourceId: protectionContainer.?sourceResourceId
      friendlyName: protectionContainer.?friendlyName
      backupManagementType: protectionContainer.?backupManagementType
      containerType: protectionContainer.?containerType
      protectedItems: contains(protectionContainer, 'protectedItems') ? protectionContainer.protectedItems : []
      location: location
    }
  }
]

module rsv_backupPolicies 'backup-policy/main.bicep' = [
  for (backupPolicy, index) in backupPolicies: {
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
    name: contains(backupConfig, 'name') ? backupConfig.name : 'vaultconfig'
    enhancedSecurityState: contains(backupConfig, 'enhancedSecurityState')
      ? backupConfig.enhancedSecurityState
      : 'Enabled'
    resourceGuardOperationRequests: contains(backupConfig, 'resourceGuardOperationRequests')
      ? backupConfig.resourceGuardOperationRequests
      : []
    softDeleteFeatureState: contains(backupConfig, 'softDeleteFeatureState')
      ? backupConfig.softDeleteFeatureState
      : 'Enabled'
    storageModelType: contains(backupConfig, 'storageModelType') ? backupConfig.storageModelType : 'GeoRedundant'
    storageType: contains(backupConfig, 'storageType') ? backupConfig.storageType : 'GeoRedundant'
    storageTypeState: contains(backupConfig, 'storageTypeState') ? backupConfig.storageTypeState : 'Locked'
    isSoftDeleteFeatureStateEditable: contains(backupConfig, 'isSoftDeleteFeatureStateEditable')
      ? backupConfig.isSoftDeleteFeatureStateEditable
      : true
  }
}

module rsv_replicationAlertSettings 'replication-alert-setting/main.bicep' = if (!empty(replicationAlertSettings)) {
  name: '${uniqueString(deployment().name, location)}-RSV-replicationAlertSettings'
  params: {
    name: 'defaultAlertSetting'
    recoveryVaultName: rsv.name
    customEmailAddresses: contains(replicationAlertSettings, 'customEmailAddresses')
      ? replicationAlertSettings.customEmailAddresses
      : []
    locale: contains(replicationAlertSettings, 'locale') ? replicationAlertSettings.locale : ''
    sendToOwners: contains(replicationAlertSettings, 'sendToOwners') ? replicationAlertSettings.sendToOwners : 'Send'
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

module rsv_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.10.1' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-rsv-PrivateEndpoint-${index}'
    scope: !empty(privateEndpoint.?resourceGroupResourceId)
      ? resourceGroup(
          split((privateEndpoint.?resourceGroupResourceId ?? '//'), '/')[2],
          split((privateEndpoint.?resourceGroupResourceId ?? '////'), '/')[4]
        )
      : resourceGroup(
          split((privateEndpoint.?subnetResourceId ?? '//'), '/')[2],
          split((privateEndpoint.?subnetResourceId ?? '////'), '/')[4]
        )
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
output privateEndpoints privateEndpointOutputType[] = [
  for (pe, i) in (!empty(privateEndpoints) ? array(privateEndpoints) : []): {
    name: rsv_privateEndpoints[i].outputs.name
    resourceId: rsv_privateEndpoints[i].outputs.resourceId
    groupId: rsv_privateEndpoints[i].outputs.?groupId!
    customDnsConfigs: rsv_privateEndpoints[i].outputs.customDnsConfigs
    networkInterfaceResourceIds: rsv_privateEndpoints[i].outputs.networkInterfaceResourceIds
  }
]

// =============== //
//   Definitions   //
// =============== //

@export()
type privateEndpointOutputType = {
  @description('The name of the private endpoint.')
  name: string

  @description('The resource ID of the private endpoint.')
  resourceId: string

  @description('The group Id for the private endpoint Group.')
  groupId: string?

  @description('The custom DNS configurations of the private endpoint.')
  customDnsConfigs: {
    @description('FQDN that resolves to private endpoint IP address.')
    fqdn: string?

    @description('A list of private IP addresses of the private endpoint.')
    ipAddresses: string[]
  }[]

  @description('The IDs of the network interfaces associated with the private endpoint.')
  networkInterfaceResourceIds: string[]
}
