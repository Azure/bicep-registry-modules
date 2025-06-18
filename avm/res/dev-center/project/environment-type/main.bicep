metadata name = 'Dev Center Project Environment Type'
metadata description = 'This module deploys a Dev Center Project Environment Type.'

// ================ //
// Parameters       //
// ================ //

@description('Required. The name of the environment type. The environment type must be first created in the Dev Center and then made available to a project using project level environment types. The name should be equivalent to the name of the environment type in the Dev Center.')
@minLength(3)
@maxLength(63)
param name string

@description('Conditional. The name of the parent dev center project. Required if the template is used in a standalone deployment.')
param projectName string

@description('Optional. The display name of the environment type.')
param displayName string?

@description('Required. The subscription Resource ID where the environment type will be mapped to. The environment\'s resources will be deployed into this subscription. Should be in the format "/subscriptions/{subscriptionId}".')
param deploymentTargetSubscriptionResourceId string

@description('Optional. Defines whether this Environment Type can be used in this Project. The default is "Enabled".')
@allowed([
  'Enabled'
  'Disabled'
])
param status string = 'Enabled'

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Required. An array specifying the role definitions (permissions) GUIDs that will be granted to the user that creates a given environment of this type. These can be both built-in or custom role definitions. At least one role must be specified.')
param creatorRoleAssignmentRoles string[]

@description('Optional. A collection of additional object IDs of users, groups, service principals or managed identities be granted permissions on each environment of this type. Each identity can have multiple role definitions (permissions) GUIDs assigned to it. These can be either built-in or custom role definitions.')
param userRoleAssignmentsRoles userRoleAssignmentsRolesType[]?

@description('Optional. Resource tags to apply to the environment type.')
param tags resourceInput<'Microsoft.DevCenter/projects/environmentTypes@2025-02-01'>.tags?

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The managed identity definition for this resource. If using user assigned identities, they must be first associated to the project that this environment type is created in and only one user identity can be used per project. At least one identity (system assigned or user assigned) must be enabled for deployment. The default is set to system assigned identity.')
param managedIdentities managedIdentityAllType = {
  systemAssigned: true
}

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

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
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'DevCenter Project Admin': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '331c37c6-af14-46d9-b9f4-e1909e1b95a0'
  )
  'DevCenter Dev Box User': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '45d50f46-0b78-4001-a660-4198cbe8cd05'
  )
  'DevTest Labs User': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '76283e04-6283-4c54-8f91-bcf1374a3c64'
  )
  'Deployment Environments User': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18e40d4e-8d2e-438d-97e1-9528336e149c'
  )
  'Deployment Environments Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'eb960402-bf75-4cc3-8d68-35b34f960f72'
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

// ============== //
// Resources      //
// ============== //

resource project 'Microsoft.DevCenter/projects@2025-02-01' existing = {
  name: projectName
}

resource environmentType 'Microsoft.DevCenter/projects/environmentTypes@2025-02-01' = {
  parent: project
  name: name
  location: location
  tags: tags
  identity: identity
  properties: {
    displayName: displayName
    deploymentTargetId: deploymentTargetSubscriptionResourceId
    status: status
    creatorRoleAssignment: {
      roles: reduce(map(creatorRoleAssignmentRoles, (role) => { '${role}': {} }), {}, (cur, next) => union(cur, next))
    }
    userRoleAssignments: !empty(userRoleAssignmentsRoles) // Transform the user-friendly array into the required Azure object format (roles as GUIDs, no mapping)
      ? reduce(
          userRoleAssignmentsRoles ?? [],
          {},
          (cur, next) =>
            union(cur, {
              '${next.objectId}': {
                roles: reduce(next.roleDefinitions, {}, (roleCur, roleNext) => union(roleCur, { '${roleNext}': {} }))
              }
            })
        )
      : null
  }
}

resource environmentType_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(environmentType.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: environmentType
  }
]
// ============ //
// Outputs      //
// ============ //

@description('The resource ID of the environment type.')
output resourceId string = environmentType.id

@description('The name of the environment type.')
output name string = environmentType.name

@description('The name of the resource group the environment type was created in.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = environmentType.location

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string? = environmentType.?identity.?principalId

// ================ //
// Definitions      //
// ================ //

@description('The type for additional role assignments.')
@export()
type userRoleAssignmentsRolesType = {
  @description('Required. The object ID of the user, group, service principal, or managed identity.')
  objectId: string
  @description('Required. An array of role definition GUIDs to assign to the object.')
  roleDefinitions: string[]
}
