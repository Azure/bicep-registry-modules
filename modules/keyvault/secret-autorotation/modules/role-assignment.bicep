@description('Resource type')
param type string

@description('Name of the CosmosDB to who key should be rotated.')
param resourceName string

@description('Name of the function app that rotates the key.')
param functionAppName string

@description('Principal ID of the function app that rotates the key.')
param functionAppPrincipalId string

var dbManagerRoleId = '5bd9cd88-fe45-4216-938b-f97437e15450'

var redisContributorRoleId = 'e0f68234-74aa-48ed-b826-c38b57376e17'

resource databaseAccount 'Microsoft.DocumentDB/databaseAccounts@2022-08-15' existing = if (type == 'cosmosdb') {
  name: resourceName
}

resource redisAccount 'Microsoft.Cache/redis@2022-06-01' existing = if (type == 'redis') {
  name: resourceName
}

@description('Grant CosmosDB role to function app.')
resource grantCosmosDBAccess 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (type == 'cosmosdb') {
  name: guid('cosmosdb${resourceName}${functionAppName}')
  scope: databaseAccount
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', dbManagerRoleId)
    principalId: functionAppPrincipalId
    principalType: 'ServicePrincipal'
  }
}

resource grantRedisAccess 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (type == 'redis') {
  name: guid('redis${resourceName}${functionAppName}')
  scope: redisAccount
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', redisContributorRoleId)
    principalId: functionAppPrincipalId
    principalType: 'ServicePrincipal'
  }
}
