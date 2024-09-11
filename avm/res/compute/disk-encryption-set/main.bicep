metadata name = 'Disk Encryption Sets'
metadata description = 'This module deploys a Disk Encryption Set. The module will attempt to set permissions on the provided Key Vault for any used user-assigned identity.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the disk encryption set that is being created.')
param name string

@description('Optional. Resource location.')
param location string = resourceGroup().location

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Required. Resource ID of the KeyVault containing the key or secret.')
param keyVaultResourceId string

@description('Required. Key URL (with version) pointing to a key or secret in KeyVault.')
param keyName string

@description('Optional. The version of the customer managed key to reference for encryption. If not provided, the latest key version is used.')
param keyVersion string = ''

@description('Optional. The type of key used to encrypt the data of the disk. For security reasons, it is recommended to set encryptionType to EncryptionAtRestWithPlatformAndCustomerKeys.')
@allowed([
  'EncryptionAtRestWithCustomerKey'
  'EncryptionAtRestWithPlatformAndCustomerKeys'
])
param encryptionType string = 'EncryptionAtRestWithPlatformAndCustomerKeys'

@description('Optional. Multi-tenant application client ID to access key vault in a different tenant. Setting the value to "None" will clear the property.')
param federatedClientId string = 'None'

@description('Optional. Set this flag to true to enable auto-updating of this disk encryption set to the latest key version.')
param rotationToLatestKeyVersionEnabled bool = false

@description('Optional. The managed identity definition for this resource. At least one identity type is required.')
param managedIdentities managedIdentitiesType = {
  systemAssigned: true
}

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. Tags of the disk encryption resource.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned')
        : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : null)
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Data Operator for Managed Disks': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '959f8984-c045-4866-89c7-12bf9737be2e'
  )
  'Disk Backup Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '3e5e47e6-65f7-47ef-90b5-e5dd4d455f24'
  )
  'Disk Pool Operator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '60fc6e62-5479-42d4-8bf4-67625fcc2840'
  )
  'Disk Restore Operator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'b50d9833-a0cb-478e-945f-707fcc997c13'
  )
  'Disk Snapshot Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '7efff54f-a5b4-42b5-a1c5-5411624893ce'
  )
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
  name: '46d3xbcp.res.compute-diskencryptionset.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource keyVault 'Microsoft.KeyVault/vaults@2021-10-01' existing = {
  name: last(split(keyVaultResourceId, '/'))!
  scope: resourceGroup(split(keyVaultResourceId, '/')[2], split(keyVaultResourceId, '/')[4])

  resource key 'keys@2021-10-01' existing = {
    name: keyName
  }
}

// Note: This is only enabled for user-assigned identities as the service's system-assigned identity isn't available during its initial deployment
module keyVaultPermissions 'modules/nested_keyVaultPermissions.bicep' = [
  for (userAssignedIdentityResourceId, index) in (managedIdentities.?userAssignedResourceIds ?? []): {
    name: '${uniqueString(deployment().name, location)}-DiskEncrSet-KVPermissions-${index}'
    params: {
      keyName: keyName
      keyVaultResourceId: keyVaultResourceId
      userAssignedIdentityResourceId: userAssignedIdentityResourceId
      rbacAuthorizationEnabled: keyVault.properties.enableRbacAuthorization
      location: location
    }
    scope: resourceGroup(split(keyVaultResourceId, '/')[2], split(keyVaultResourceId, '/')[4])
  }
]

resource diskEncryptionSet 'Microsoft.Compute/diskEncryptionSets@2023-10-02' = {
  name: name
  location: location
  tags: tags
  identity: identity
  properties: {
    activeKey: {
      sourceVault: {
        id: keyVaultResourceId
      }
      keyUrl: !empty(keyVersion)
        ? '${keyVault::key.properties.keyUri}/${keyVersion}'
        : keyVault::key.properties.keyUriWithVersion
    }
    encryptionType: encryptionType
    federatedClientId: federatedClientId
    rotationToLatestKeyVersionEnabled: rotationToLatestKeyVersionEnabled
  }
  dependsOn: [
    keyVaultPermissions
  ]
}

resource diskEncryptionSet_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(
      diskEncryptionSet.id,
      roleAssignment.principalId,
      roleAssignment.roleDefinitionId
    )
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: diskEncryptionSet
  }
]

resource diskEncryptionSet_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: diskEncryptionSet
}

@description('The resource ID of the disk encryption set.')
output resourceId string = diskEncryptionSet.id

@description('The name of the disk encryption set.')
output name string = diskEncryptionSet.name

@description('The resource group the disk encryption set was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string = diskEncryptionSet.?identity.?principalId ?? ''

@description('The idenities of the disk encryption set.')
output identities object = diskEncryptionSet.identity

@description('The name of the key vault with the disk encryption key.')
output keyVaultName string = last(split(keyVaultResourceId, '/'))!

@description('The location the resource was deployed into.')
output location string = diskEncryptionSet.location

// =============== //
//   Definitions   //
// =============== //

type managedIdentitiesType = {
  @description('Optional. Enables system assigned managed identity on the resource.')
  systemAssigned: bool?

  @description('Optional. The resource ID(s) to assign to the resource.')
  userAssignedResourceIds: string[]?
}

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
