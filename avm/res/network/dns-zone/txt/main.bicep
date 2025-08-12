metadata name = 'Public DNS Zone TXT record'
metadata description = 'This module deploys a Public DNS Zone TXT record.'

@description('Conditional. The name of the parent DNS zone. Required if the template is used in a standalone deployment.')
param dnsZoneName string

@description('Required. The name of the TXT record.')
param name string

@description('Optional. The metadata attached to the record set.')
param metadata object?

@description('Optional. The TTL (time-to-live) of the records in the record set.')
param ttl int = 3600

@description('Optional. The list of TXT records in the record set.')
param txtRecords array?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

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
resource dnsZone 'Microsoft.Network/dnsZones@2018-05-01' existing = {
  name: dnsZoneName
}

resource TXT 'Microsoft.Network/dnsZones/TXT@2018-05-01' = {
  name: name
  parent: dnsZone
  properties: {
    metadata: metadata
    TTL: ttl
    TXTRecords: txtRecords
  }
}

resource TXT_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(TXT.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: TXT
  }
]

@description('The name of the deployed TXT record.')
output name string = TXT.name

@description('The resource ID of the deployed TXT record.')
output resourceId string = TXT.id

@description('The resource group of the deployed TXT record.')
output resourceGroupName string = resourceGroup().name
