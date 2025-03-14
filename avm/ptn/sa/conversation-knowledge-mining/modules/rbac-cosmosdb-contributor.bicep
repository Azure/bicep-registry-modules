// NOTE: This assignment should be part of the CosmosDB module, but this is not available today in the AVM Cosmos DB module
// Future releases will include this assignment in the AVM module that deploys the Cosmos DB
@description('Required. The name of the Cosmos DB resource to assign the Contributor RBAC role.')
param cosmosDBAccountName string
@description('Required. The principal ID of the resource to grant the Contributor RBAC role.')
param principalId string

resource existingCosmosDB 'Microsoft.DocumentDB/databaseAccounts@2024-05-15' existing = {
  name: cosmosDBAccountName
}

resource resContributorRoleDefinition 'Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions@2024-05-15' existing = {
  parent: existingCosmosDB
  name: '00000000-0000-0000-0000-000000000002' //NOTE: Built-in role 'Contributor'
}

resource resRoleAssignmentContributorWebappCosmosDB 'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments@2024-12-01-preview' = {
  parent: existingCosmosDB
  name: guid(resContributorRoleDefinition.id, existingCosmosDB.id)
  properties: {
    principalId: principalId
    roleDefinitionId: resContributorRoleDefinition.id
    scope: existingCosmosDB.id
  }
}
