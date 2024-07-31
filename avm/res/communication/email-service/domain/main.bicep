metadata name = 'Email Services Domains'
metadata description = 'This module deploys an Email Service Domain'
metadata owner = 'Azure/module-maintainers'

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

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
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

// ================ //
// Definitions      //
// ================ //

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
