param cosmosDBAccountName string
param sqlRoleDefinitions array
param sqlRoleAssignments array

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2022-11-15' existing = {
  name: cosmosDBAccountName
}

@batchSize(1)
resource cosmosDBAccount_sqlRoleDefinitions 'Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions@2022-11-15' = [for sqlRoleDefinition in sqlRoleDefinitions: {
  name: guid(cosmosDBAccount.id, sqlRoleDefinition.roleName)
  parent: cosmosDBAccount
  properties: {
    roleName: sqlRoleDefinition.roleName
    type: 'CustomRole'
    assignableScopes: [for (scope, i) in sqlRoleDefinition.assignableScopes: '${cosmosDBAccount.id}${sqlRoleDefinition.assignableScopes[i]}']
    permissions: sqlRoleDefinition.permissions
  }
}]

@batchSize(1)
resource cosmosDBAccount_sqlRoleAssignments 'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments@2022-11-15' = [for sqlRoleAssignment in sqlRoleAssignments: {
  name: guid(cosmosDBAccount.id, sqlRoleAssignment.roleDefinitionId, sqlRoleAssignment.principalId)
  parent: cosmosDBAccount
  dependsOn: [
    cosmosDBAccount_sqlRoleDefinitions
  ]
  properties: {
    roleDefinitionId: resourceId('Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions', cosmosDBAccount.name, sqlRoleAssignment.roleDefinitionId)
    principalId: sqlRoleAssignment.principalId
    scope: '${cosmosDBAccount.id}${sqlRoleAssignment.scope}'
  }
}]

@description('The role definition ids of the created role definitions.')
output sqlRoleDefinitionIds array = [for (roleDefinition, i) in sqlRoleDefinitions: {
  name: roleDefinition.roleName
  id: cosmosDBAccount_sqlRoleDefinitions[i].id
}]
