metadata name = 'Key Vault Keys'
metadata description = 'This module deploys a Key Vault Key.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent key vault. Required if the template is used in a standalone deployment.')
param keyVaultName string

@description('Required. The name of the key.')
param name string

@description('Optional. Resource tags.')
param tags object?

@description('Optional. Determines whether the object is enabled.')
param attributesEnabled bool = true

@description('Optional. Expiry date in seconds since 1970-01-01T00:00:00Z. For security reasons, it is recommended to set an expiration date whenever possible.')
param attributesExp int?

@description('Optional. Not before date in seconds since 1970-01-01T00:00:00Z.')
param attributesNbf int?

@description('Optional. The elliptic curve name.')
@allowed([
  'P-256'
  'P-256K'
  'P-384'
  'P-521'
])
param curveName string = 'P-256'

@description('Optional. Array of JsonWebKeyOperation.')
@allowed([
  'decrypt'
  'encrypt'
  'import'
  'sign'
  'unwrapKey'
  'verify'
  'wrapKey'
])
param keyOps array?

@description('Optional. The key size in bits. For example: 2048, 3072, or 4096 for RSA.')
param keySize int?

@description('Optional. The type of the key.')
@allowed([
  'EC'
  'EC-HSM'
  'RSA'
  'RSA-HSM'
])
param kty string = 'EC'

@description('Optional. Key release policy.')
param releasePolicy object?

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. Key rotation policy properties object.')
param rotationPolicy object?

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Key Vault Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '00482a5a-887f-4fb3-b363-3b7fe8e74483'
  )
  'Key Vault Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f25e0fa2-a7c8-4377-a976-54943a77a395'
  )
  'Key Vault Crypto Officer': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '14b46e9e-c2b7-41b4-b07b-48a6ebf60603'
  )
  'Key Vault Crypto Service Encryption User': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'e147488a-f6f5-4113-8e2d-b22465e65bf6'
  )
  'Key Vault Crypto User': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '12338af0-0e69-4776-bea7-57ae8d297424'
  )
  'Key Vault Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '21090545-7ca7-4776-b22c-e363652d74d2'
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

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyVaultName
}

resource key 'Microsoft.KeyVault/vaults/keys@2022-07-01' = {
  name: name
  parent: keyVault
  tags: tags
  properties: {
    attributes: {
      enabled: attributesEnabled
      exp: attributesExp
      nbf: attributesNbf
    }
    curveName: curveName
    keyOps: keyOps
    keySize: keySize
    kty: kty
    rotationPolicy: rotationPolicy ?? {}
    release_policy: releasePolicy ?? {}
  }
}

resource key_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(key.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: key
  }
]

@description('The name of the key.')
output name string = key.name

@description('The resource ID of the key.')
output resourceId string = key.id

@description('The name of the resource group the key was created in.')
output resourceGroupName string = resourceGroup().name

// ================ //
// Definitions      //
// ================ //

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
