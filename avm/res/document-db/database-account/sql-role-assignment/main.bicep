metadata name = 'DocumentDB Database Account SQL Role Assignments.'
metadata description = 'This module deploys a SQL Role Assignment in a CosmosDB Account.'

@description('Conditional. The name of the parent Database Account. Required if the template is used in a standalone deployment.')
param databaseAccountName string

@description('Optional. Name unique identifier of the SQL Role Assignment.')
param name string?

@description('Required. The unique identifier for the associated AAD principal in the AAD graph to which access is being granted through this Role Assignment. Tenant ID for the principal is inferred using the tenant associated with the subscription.')
param principalId string

@description('Required. The unique identifier or name for the associated SQL Role Definition.')
param sqlRoleDefinitionIdOrName string

var formattedRoleDefinition = contains(sqlRoleDefinitionIdOrName, 'sqlRoleDefinitions')
  ? sqlRoleDefinitionIdOrName
  : sqlRoleDefinition.id

resource sqlRoleDefinition 'Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions@2024-11-15' existing = if (!contains(
  sqlRoleDefinitionIdOrName,
  'sqlRoleDefinitions'
)) {
  parent: databaseAccount
  name: sqlRoleDefinitionIdOrName
}

resource databaseAccount 'Microsoft.DocumentDB/databaseAccounts@2024-11-15' existing = {
  name: databaseAccountName
}

resource sqlRoleAssignment 'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments@2024-11-15' = {
  parent: databaseAccount
  name: name ?? guid(formattedRoleDefinition, principalId, databaseAccount.id)
  properties: {
    principalId: principalId
    roleDefinitionId: formattedRoleDefinition
    scope: databaseAccount.id
  }
}

@description('The name of the SQL Role Assignment.')
output name string = sqlRoleAssignment.name

@description('The resource ID of the SQL Role Assignment.')
output resourceId string = sqlRoleAssignment.id

@description('The name of the resource group the SQL Role Definition was created in.')
output resourceGroupName string = resourceGroup().name
