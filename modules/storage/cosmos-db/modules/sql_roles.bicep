param cosmosDBAccountName string
param role object

var roleName = role.key
var roleConfig = role.value
var allScopes = [for roleAssignment in roleConfig.assignments: roleAssignment.scope ?? '']
var assignableScopes = filter(allScopes, scope => empty(scope) == false)

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' existing = {
  name: cosmosDBAccountName
}

resource sqlRoleDefinitions 'Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions@2023-04-15' = {
  parent: cosmosDBAccount

  name: roleName
  properties: {
    roleName: roleName
    type: roleConfig.roleType
    assignableScopes: empty(assignableScopes) ? [ cosmosDBAccount.id ] : assignableScopes
    permissions: roleConfig.roleType == 'BuiltInRole' ? null : roleConfig.permissions
  }
}

resource sqlRoleAssignments 'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments@2023-04-15' = [for assignment in roleConfig.assignments: {
  parent: cosmosDBAccount

  name: uniqueString(cosmosDBAccount.id, sqlRoleDefinitions.id, assignment.principalId)
  properties: {
    roleDefinitionId: sqlRoleDefinitions.id
    principalId: assignment.principalId
    scope: assignment.scope ?? cosmosDBAccount
  }
}]

@description('The role definition ids of the created role definitions.')
output roleDefinitionId string = sqlRoleDefinitions.id