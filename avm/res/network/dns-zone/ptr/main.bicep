metadata name = 'Public DNS Zone PTR record'
metadata description = 'This module deploys a Public DNS Zone PTR record.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent DNS zone. Required if the template is used in a standalone deployment.')
param dnsZoneName string

@description('Required. The name of the PTR record.')
param name string

@description('Optional. The metadata attached to the record set.')
param metadata object?

@description('Optional. The list of PTR records in the record set.')
param ptrRecords array?

@description('Optional. The TTL (time-to-live) of the records in the record set.')
param ttl int = 3600

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'DNS Resolver Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '0f2ebee7-ffd4-4fc0-b3b7-664099fdad5d'
  )
  'DNS Zone Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'befefa01-2a29-4197-83a8-272ff33ce314'
  )
  'Domain Services Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'eeaeda52-9324-47f6-8069-5d5bade478b2'
  )
  'Domain Services Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '361898ef-9ed1-48c2-849c-a832951106bb'
  )
  'Network Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '4d97b98b-1d4f-4787-a291-c67834d212e7'
  )
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  'Private DNS Zone Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'b12aa53e-6015-4669-85d0-8515ebb3ae7f'
  )
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
  'User Access Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  )
}

resource dnsZone 'Microsoft.Network/dnsZones@2018-05-01' existing = {
  name: dnsZoneName
}

resource PTR 'Microsoft.Network/dnsZones/PTR@2018-05-01' = {
  name: name
  parent: dnsZone
  properties: {
    metadata: metadata
    PTRRecords: ptrRecords
    TTL: ttl
  }
}

resource PTR_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (roleAssignments ?? []): {
    name: guid(PTR.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
    properties: {
      roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName)
        ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName]
        : contains(roleAssignment.roleDefinitionIdOrName, '/providers/Microsoft.Authorization/roleDefinitions/')
            ? roleAssignment.roleDefinitionIdOrName
            : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName)
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: PTR
  }
]

@description('The name of the deployed PTR record.')
output name string = PTR.name

@description('The resource ID of the deployed PTR record.')
output resourceId string = PTR.id

@description('The resource group of the deployed PTR record.')
output resourceGroupName string = resourceGroup().name
// =============== //
//   Definitions   //
// =============== //

type roleAssignmentType = {
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
