param cosmosDBAccountName string
param role object

var allScopes = [for roleAssignment in role.?assignments ?? []: roleAssignment.?scope ?? '']
var assignableScopes = filter(allScopes, scope => !empty(scope))

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' existing = {
  name: cosmosDBAccountName
}

resource sqlRoleDefinitions 'Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions@2023-04-15' = {
  parent: cosmosDBAccount

  name: guid(cosmosDBAccountName, role.name)
  properties: {
    roleName: role.name
    type: 'CustomRole'
    assignableScopes: empty(assignableScopes) ? [ cosmosDBAccount.id ] : assignableScopes
    permissions: role.?permissions
  }
}

resource sqlRoleAssignments 'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments@2023-04-15' = [for assignment in role.?assignments ?? []: {
  parent: cosmosDBAccount

  name: guid(cosmosDBAccount.id, sqlRoleDefinitions.id, assignment.principalId)
  properties: {
    roleDefinitionId: sqlRoleDefinitions.id
    principalId: assignment.principalId
    scope: '${cosmosDBAccount.id}${assignment.?scope ?? ''}'
  }
}]

@description('The role definition ids of the created role definitions.')
output roleDefinitionId string = sqlRoleDefinitions.id