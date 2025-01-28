metadata name = 'DocumentDB Database Account SQL Role Definitions.'
metadata description = 'This module deploys a SQL Role Definision in a CosmosDB Account.'

@description('Conditional. The name of the parent Database Account. Required if the template is used in a standalone deployment.')
param databaseAccountName string

@description('Optional. An array of data actions that are allowed.')
param dataActions array = []

@description('Optional. A user-friendly name for the Role Definition. Must be unique for the database account.')
param roleName string = 'Reader Writer'

@description('Optional. Indicates whether the Role Definition was built-in or user created.')
@allowed([
  'CustomRole'
  'BuiltInRole'
])
param roleType string = 'CustomRole'

resource databaseAccount 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' existing = {
  name: databaseAccountName
}

resource sqlRoleDefinition 'Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions@2023-04-15' = {
  parent: databaseAccount
  name: guid(databaseAccount.id, databaseAccountName, 'sql-role')
  properties: {
    assignableScopes: [
      databaseAccount.id
    ]
    permissions: [
      {
        dataActions: dataActions
      }
    ]
    roleName: roleName
    type: roleType
  }
}

@description('The name of the SQL database.')
output name string = sqlRoleDefinition.name

@description('The resource ID of the SQL database.')
output resourceId string = sqlRoleDefinition.id

@description('The name of the resource group the SQL database was created in.')
output resourceGroupName string = resourceGroup().name
