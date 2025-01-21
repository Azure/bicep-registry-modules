metadata name = 'Storage Account Blob Containers'
metadata description = 'This module deploys a Storage Account Blob Container.'

@maxLength(24)
@description('Conditional. The name of the parent Storage Account. Required if the template is used in a standalone deployment.')
param storageAccountName string

@description('Optional. The name of the parent Blob Service. Required if the template is used in a standalone deployment.')
param blobServiceName string = 'default'

@description('Required. The name of the storage container to deploy.')
param name string

@description('Optional. Default the container to use specified encryption scope for all writes.')
param defaultEncryptionScope string = ''

@description('Optional. Block override of encryption scope from the container default.')
param denyEncryptionScopeOverride bool = false

@description('Optional. Enable NFSv3 all squash on blob container.')
param enableNfsV3AllSquash bool = false

@description('Optional. Enable NFSv3 root squash on blob container.')
param enableNfsV3RootSquash bool = false

@description('Optional. This is an immutable property, when set to true it enables object level immutability at the container level. The property is immutable and can only be set to true at the container creation time. Existing containers must undergo a migration process.')
param immutableStorageWithVersioningEnabled bool = false

@description('Optional. Name of the immutable policy.')
param immutabilityPolicyName string = 'default'

@description('Optional. Configure immutability policy.')
param immutabilityPolicyProperties object?

@description('Optional. A name-value pair to associate with the container as metadata.')
param metadata object = {}

@allowed([
  'Container'
  'Blob'
  'None'
])
@description('Optional. Specifies whether data in the container may be accessed publicly and the level of access.')
param publicAccess string = 'None'

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Reader and Data Access': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'c12c1c16-33a1-487b-954d-41c89c60f349'
  )
  'Role Based Access Control Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
  'Storage Account Backup Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'e5e2a7ff-d759-4cd2-bb51-3152d37e2eb1'
  )
  'Storage Account Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '17d1049b-9a84-46fb-8f53-869881c3d3ab'
  )
  'Storage Account Key Operator Service Role': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '81a9662b-bebf-436f-a333-f67b29880f12'
  )
  'Storage Blob Data Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'ba92f5b4-2d11-453d-a403-e96b0029c9fe'
  )
  'Storage Blob Data Owner': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'b7e6dc6d-f1e8-4753-8033-0f276bb0955b'
  )
  'Storage Blob Data Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '2a2b9908-6ea1-4ae2-8e65-a410df84e7d1'
  )
  'Storage Blob Delegator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'db58b8e5-c6ad-4a2a-8342-4190687cbf4a'
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

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' existing = {
  name: storageAccountName

  resource blobServices 'blobServices@2022-09-01' existing = {
    name: blobServiceName
  }
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  name: name
  parent: storageAccount::blobServices
  properties: {
    defaultEncryptionScope: !empty(defaultEncryptionScope) ? defaultEncryptionScope : null
    denyEncryptionScopeOverride: denyEncryptionScopeOverride == true ? denyEncryptionScopeOverride : null
    enableNfsV3AllSquash: enableNfsV3AllSquash == true ? enableNfsV3AllSquash : null
    enableNfsV3RootSquash: enableNfsV3RootSquash == true ? enableNfsV3RootSquash : null
    immutableStorageWithVersioning: immutableStorageWithVersioningEnabled == true
      ? {
          enabled: immutableStorageWithVersioningEnabled
        }
      : null
    metadata: metadata
    publicAccess: publicAccess
  }
}

module immutabilityPolicy 'immutability-policy/main.bicep' = if (!empty((immutabilityPolicyProperties ?? {}))) {
  name: immutabilityPolicyName
  params: {
    storageAccountName: storageAccount.name
    containerName: container.name
    immutabilityPeriodSinceCreationInDays: immutabilityPolicyProperties.?immutabilityPeriodSinceCreationInDays
    allowProtectedAppendWrites: immutabilityPolicyProperties.?allowProtectedAppendWrites
    allowProtectedAppendWritesAll: immutabilityPolicyProperties.?allowProtectedAppendWritesAll
  }
}

resource container_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(container.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: container
  }
]

@description('The name of the deployed container.')
output name string = container.name

@description('The resource ID of the deployed container.')
output resourceId string = container.id

@description('The resource group of the deployed container.')
output resourceGroupName string = resourceGroup().name
