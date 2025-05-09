metadata name = 'Data Protection Backup Vaults'
metadata description = 'This module deploys a Data Protection Backup Vault.'

@description('Required. Name of the Backup Vault.')
param name string

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

@description('Optional. Whether or not the service applies a secondary layer of encryption. For security reasons, it is recommended to set it to Enabled.')
@allowed([
  'Enabled'
  'Disabled'
])
param infrastructureEncryption string = 'Enabled'

import { customerManagedKeyWithAutoRotateType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The customer managed key (CMK) definition. ENABLING CMK WITH USER ASSIGNED MANAGED IDENTITY IS A PREVIEW SERVICE/FEATURE, MICROSOFT MAY NOT PROVIDE SUPPORT FOR THIS, PLEASE CHECK THE [PRODUCT DOCS](https://learn.microsoft.com/en-us/azure/backup/encryption-at-rest-with-cmk-for-backup-vault) FOR CLARIFICATION.')
param customerManagedKey customerManagedKeyWithAutoRotateType?

@description('Optional. The soft delete related settings.')
param softDeleteSettings softDeleteSettingType?

@description('Optional. The immmutability setting state of the backup vault resource.')
@allowed([
  'Disabled'
  'Locked'
  'Unlocked'
])
param immutabilitySettingState string?

@description('Optional. Tags of the backup vault resource.')
param tags object?

@description('Optional. The datastore type to use. ArchiveStore does not support ZoneRedundancy.')
@allowed([
  'ArchiveStore'
  'VaultStore'
  'OperationalStore'
])
param dataStoreType string = 'VaultStore'

@description('Optional. The vault redundancy level to use.')
@allowed([
  'LocallyRedundant'
  'GeoRedundant'
  'ZoneRedundant'
])
param type string = 'GeoRedundant'

@allowed([
  'Disabled'
  'Enabled'
])
@description('Optional. Settings for Azure Monitor based alerts for job failures.')
param azureMonitorAlertSettingsAlertsForAllJobFailures string = 'Enabled'

@description('Optional. List of all backup policies.')
param backupPolicies array?

@description('Optional. List of all backup instances.')
param backupInstances backupInstanceType[]?

@description('Optional. Feature settings for the backup vault.')
param featureSettings object?

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
  : {
      type: 'None'
    }

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
  name: '46d3xbcp.res.dataprotection-backupvault.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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
  name: last(split((customerManagedKey.?keyVaultResourceId!), '/'))
  scope: resourceGroup(
    split(customerManagedKey.?keyVaultResourceId!, '/')[2],
    split(customerManagedKey.?keyVaultResourceId!, '/')[4]
  )

  resource cMKKey 'keys@2023-02-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId) && !empty(customerManagedKey.?keyName)) {
    name: customerManagedKey.?keyName!
  }
}

resource cMKUserAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = if (!empty(customerManagedKey.?userAssignedIdentityResourceId)) {
  name: last(split(customerManagedKey.?userAssignedIdentityResourceId!, '/'))
  scope: resourceGroup(
    split(customerManagedKey.?userAssignedIdentityResourceId!, '/')[2],
    split(customerManagedKey.?userAssignedIdentityResourceId!, '/')[4]
  )
}

resource backupVault 'Microsoft.DataProtection/backupVaults@2024-04-01' = {
  name: name
  location: location
  tags: tags
  identity: identity
  properties: {
    monitoringSettings: {
      azureMonitorAlertSettings: {
        alertsForAllJobFailures: azureMonitorAlertSettingsAlertsForAllJobFailures
      }
    }
    storageSettings: [
      {
        type: type
        datastoreType: dataStoreType
      }
    ]
    featureSettings: featureSettings
    securitySettings: {
      encryptionSettings: !empty(customerManagedKey)
        ? {
            infrastructureEncryption: infrastructureEncryption
            kekIdentity: !empty(customerManagedKey.?userAssignedIdentityResourceId)
              ? {
                  identityId: cMKUserAssignedIdentity.id
                  identityType: 'UserAssigned'
                }
              : {
                  identityType: 'SystemAssigned'
                }
            keyVaultProperties: {
              keyUri: !empty(customerManagedKey.?keyVersion)
                ? '${cMKKeyVault::cMKKey.properties.keyUri}/${customerManagedKey!.?keyVersion}'
                : (customerManagedKey.?autoRotationEnabled ?? true)
                    ? cMKKeyVault::cMKKey.properties.keyUri
                    : cMKKeyVault::cMKKey.properties.keyUriWithVersion
            }
            state: 'Enabled'
          }
        : null
      immutabilitySettings: !empty(immutabilitySettingState)
        ? {
            state: immutabilitySettingState
          }
        : null
      softDeleteSettings: softDeleteSettings
    }
  }
}

module backupVault_backupPolicies 'backup-policy/main.bicep' = [
  for (backupPolicy, index) in (backupPolicies ?? []): {
    name: '${uniqueString(deployment().name, location)}-BV-BackupPolicy-${index}'
    params: {
      backupVaultName: backupVault.name
      name: backupPolicy.name
      properties: backupPolicy.properties
    }
  }
]

@batchSize(1)
module backupVault_backupInstances 'backup-instance/main.bicep' = [
  for (backupInstance, index) in (backupInstances ?? []): {
    name: '${uniqueString(deployment().name, location)}-BV-BackupInstance-${index}'
    params: {
      backupVaultName: backupVault.name
      name: backupInstance.name
      friendlyName: backupInstance.?friendlyName
      dataSourceInfo: backupInstance.dataSourceInfo
      policyInfo: backupInstance.policyInfo
    }
    dependsOn: [
      backupVault_backupPolicies
    ]
  }
]

resource backupVault_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: backupVault
}

resource backupVault_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(backupVault.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: backupVault
  }
]

@description('The resource ID of the backup vault.')
output resourceId string = backupVault.id

@description('The name of the resource group the recovery services vault was created in.')
output resourceGroupName string = resourceGroup().name

@description('The Name of the backup vault.')
output name string = backupVault.name

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string? = backupVault.?identity.?principalId

@description('The location the resource was deployed into.')
output location string = backupVault.location

// =============== //
//   Definitions   //
// =============== //

@export()
@description('The type for soft delete settings.')
type softDeleteSettingType = {
  @description('Required. The soft delete retention period in days.')
  retentionDurationInDays: int

  @description('Required. The soft delete state.')
  state: ('AlwaysON' | 'On' | 'Off')
}

import { dataSourceInfoType, policyInfoType } from 'backup-instance/main.bicep'
@export()
@description('The type for a backup instance.')
type backupInstanceType = {
  @description('Required. The name of the backup instance.')
  name: string

  @description('Optional. The friendly name of the backup instance.')
  friendlyName: string?

  @description('Required. The data source info for the backup instance.')
  dataSourceInfo: dataSourceInfoType

  @description('Required. The policy info for the backup instance.')
  policyInfo: policyInfoType
}
