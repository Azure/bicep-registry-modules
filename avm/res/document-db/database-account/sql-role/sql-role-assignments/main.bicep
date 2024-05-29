metadata name = 'DocumentDB Database Account SQL Role Assignments.'
metadata description = 'This module deploys a SQL Role Definision in a CosmosDB Account.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent Database Account. Required if the template is used in a standalone deployment.')
param databaseAccountName string

@description('Required. Name of the SQL database.')
param name string

@description('Required. Name of the SQL database.')
param principalId string = ''

@description('Required. Name of the SQL database.')
param roleDefinitionId string

resource databaseAccount 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' existing = {
  name: databaseAccountName
}

resource sqlRoleAssignment 'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments@2023-04-15' = {
  parent: databaseAccount
  name: name
  properties: {
    principalId: principalId
    roleDefinitionId: roleDefinitionId
    scope: databaseAccount.id
  }
}

@description('The name of the resource group the SQL Role Assignment was created in.')
output resourceGroupName string = resourceGroup().name
