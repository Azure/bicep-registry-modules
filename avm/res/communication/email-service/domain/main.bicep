metadata name = 'Email Services Domains'
metadata description = 'This module deploys an Email Service Domain'

@description('Conditional. The name of the parent email service. Required if the template is used in a standalone deployment.')
param emailServiceName string

@minLength(1)
@maxLength(253)
@description('Required. Name of the domain to create.')
param name string

@description('Optional. Location for all Resources.')
param location string = 'global'

@description('Optional. Endpoint tags.')
param tags object?

@allowed([
  'AzureManaged'
  'CustomerManaged'
  'CustomerManagedInExchangeOnline'
])
@description('Optional. Describes how the Domain resource is being managed.')
param domainManagement string = 'AzureManaged'

@allowed([
  'Enabled'
  'Disabled'
])
@description('Optional. Describes whether user engagement tracking is enabled or disabled.')
param userEngagementTracking string = 'Disabled'

@description('Optional. The domains to deploy into this namespace.')
param senderUsernames array?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

var builtInRoleNames = {
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

// ============== //
// Resources      //
// ============== //

resource emailService 'Microsoft.Communication/emailServices@2023-04-01' existing = {
  name: emailServiceName
}

resource domain 'Microsoft.Communication/emailServices/domains@2023-04-01' = {
  name: name
  location: location
  tags: tags
  parent: emailService
  properties: {
    domainManagement: domainManagement
    userEngagementTracking: userEngagementTracking
  }
}

module domain_senderUsernames 'sender-username/main.bicep' = [
  for (senderUsername, index) in senderUsernames ?? []: {
    name: '${uniqueString(deployment().name, location)}-domain-senderusername-${index}'
    params: {
      emailServiceName: emailService.name
      domainName: domain.name
      name: senderUsername.name
      username: senderUsername.username
      displayName: senderUsername.?displayName
    }
  }
]

resource domain_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: domain
}

resource domain_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(domain.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: domain
  }
]

// ============ //
// Outputs      //
// ============ //

@description('The name of the domain.')
output name string = domain.name

@description('The resource ID of the domain.')
output resourceId string = domain.id

@description('The name of the resource group the domain was created in.')
output resourceGroupName string = resourceGroup().name
