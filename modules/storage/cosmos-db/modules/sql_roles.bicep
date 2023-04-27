param cosmosDBAccountName string
param roleDefinitions array
param roleAssignments array

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2022-11-15' existing = {
  name: cosmosDBAccountName
}

@batchSize(1)
resource sqlRoleDefinitions 'Microsoft.DocumentDB/databaseAccounts/sqlroleDefinitions@2022-11-15' = [for roleDefinition in roleDefinitions: {
  name: guid(cosmosDBAccount.id, roleDefinition.roleName)
  parent: cosmosDBAccount
  properties: {
    roleName: roleDefinition.roleName
    type: 'CustomRole'
    assignableScopes: [for (scope, i) in roleDefinition.assignableScopes: '${cosmosDBAccount.id}${roleDefinition.assignableScopes[i]}']
    permissions: roleDefinition.permissions
  }
}]

@batchSize(1)
resource sqlRoleAssignments 'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments@2022-11-15' = [for roleAssignment in roleAssignments: {
  name: guid(cosmosDBAccount.id, roleAssignment.roleDefinitionId, roleAssignment.principalId)
  parent: cosmosDBAccount
  dependsOn: [
    sqlRoleDefinitions
  ]
  properties: {
    roleDefinitionId: resourceId('Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions', cosmosDBAccount.name, roleAssignment.roleDefinitionId)
    principalId: roleAssignment.principalId
    scope: '${cosmosDBAccount.id}${roleAssignment.scope}'
  }
}]

@description('The role definition ids of the created role definitions.')
output roleDefinitionIds array = [for (roleDefinition, i) in roleDefinitions: {
  name: roleDefinition.roleName
  id: sqlRoleDefinitions[i].id
}]
