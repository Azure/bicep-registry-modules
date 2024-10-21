metadata name = 'Data Protection Backup Vaults'
metadata description = 'This module deploys a Data Protection Backup Vault.'

@description('Required. Name of the Backup Vault.')
param name string

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentitiesType

@description('Optional. Tags of the Recovery Service Vault resource.')
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
param backupPolicies array = []

@description('Optional. Security settings for the backup vault.')
param securitySettings object = {}

@description('Optional. Feature settings for the backup vault.')
param featureSettings object = {}

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false) ? 'SystemAssigned' : null
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

resource backupVault 'Microsoft.DataProtection/backupVaults@2023-05-01' = {
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
    securitySettings: securitySettings
  }
}

module backupVault_backupPolicies 'backup-policy/main.bicep' = [
  for (backupPolicy, index) in backupPolicies: {
    name: '${uniqueString(deployment().name, location)}-BV-BackupPolicy-${index}'
    params: {
      backupVaultName: backupVault.name
      name: backupPolicy.name
      properties: backupPolicy.properties
    }
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
output systemAssignedMIPrincipalId string = backupVault.?identity.?principalId ?? ''

@description('The location the resource was deployed into.')
output location string = backupVault.location

// =============== //
//   Definitions   //
// =============== //

type managedIdentitiesType = {
  @description('Optional. Enables system assigned managed identity on the resource.')
  systemAssigned: bool?
}?

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
