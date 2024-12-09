import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.3.0'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Built-in role names.')
param builtInRoleNames object = {}

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.3.0'
@description('Optional. The lock settings of the service.')
param lock lockType?

@description('Required. Name of the Data Collection Rule to assign the role(s) to.')
param dataCollectionRuleName string

resource dataCollectionRule 'Microsoft.Insights/dataCollectionRules@2023-03-11' existing = {
  name: dataCollectionRuleName
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

resource dataCollectionRule_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(resourceGroup().id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    scope: dataCollectionRule
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
  }
]

resource dataCollectionRule_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${dataCollectionRuleName}'
  scope: dataCollectionRule
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
}
