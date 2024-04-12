metadata name = 'Role Assignments (Management Group scope)'
metadata description = 'This module deploys a Role Assignment at a Management Group scope.'
metadata owner = 'Azure/module-maintainers'

targetScope = 'managementGroup'

@sys.description('Required. You can provide either the display name of the role definition (must be configured in the variable `builtInRoleNames`), or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleDefinitionIdOrName string

@sys.description('Required. The Principal or Object ID of the Security Principal (User, Group, Service Principal, Managed Identity).')
param principalId string

@sys.description('Optional. Group ID of the Management Group to assign the RBAC role to. If not provided, will use the current scope for deployment.')
param managementGroupId string = managementGroup().name

@sys.description('Optional. The description of the role assignment.')
param description string = ''

@sys.description('Optional. ID of the delegated managed identity resource.')
param delegatedManagedIdentityResourceId string = ''

@sys.description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to.')
param condition string = ''

@sys.description('Optional. Version of the condition. Currently accepted value is "2.0".')
@allowed([
  '2.0'
])
param conditionVersion string = '2.0'

@sys.description('Optional. The principal type of the assigned principal ID.')
@allowed([
  'ServicePrincipal'
  'Group'
  'User'
  'ForeignGroup'
  'Device'
  ''
])
param principalType string = ''

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: '/providers/Microsoft.Authorization/roleDefinitions/8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Resource Policy Contributor': '/providers/Microsoft.Authorization/roleDefinitions/36243c78-bf99-498c-9df9-86d9f8d28608'
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f58310d9-a9f6-439a-9e8d-f62e7b41a168')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
  'Management Group Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ac63b705-f282-497d-ac71-919bf39d939d')
}

var roleDefinitionIdVar = (contains(builtInRoleNames, roleDefinitionIdOrName) ? builtInRoleNames[roleDefinitionIdOrName] : roleDefinitionIdOrName)


resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(managementGroupId, roleDefinitionIdVar, principalId)
  properties: {
    roleDefinitionId: roleDefinitionIdVar
    principalId: principalId
    description: !empty(description) ? description : null
    principalType: !empty(principalType) ? any(principalType) : null
    delegatedManagedIdentityResourceId: !empty(delegatedManagedIdentityResourceId) ? delegatedManagedIdentityResourceId : null
    conditionVersion: !empty(conditionVersion) && !empty(condition) ? conditionVersion : null
    condition: !empty(condition) ? condition : null
  }
}

@sys.description('The GUID of the Role Assignment.')
output name string = roleAssignment.name

@sys.description('The resource ID of the Role Assignment.')
output resourceId string = roleAssignment.id

@sys.description('The scope this Role Assignment applies to.')
output scope string = az.resourceId('Microsoft.Management/managementGroups', managementGroupId)
