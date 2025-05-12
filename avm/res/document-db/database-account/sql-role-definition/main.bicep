metadata name = 'DocumentDB Database Account SQL Role Definitions.'
metadata description = 'This module deploys a SQL Role Definision in a CosmosDB Account.'

@description('Conditional. The name of the parent Database Account. Required if the template is used in a standalone deployment.')
param databaseAccountName string

@description('Optional. The unique identifier of the Role Definition.')
param name string?

@description('Required. A user-friendly name for the Role Definition. Must be unique for the database account.')
param roleName string

@description('Optional. An array of data actions that are allowed.')
param dataActions string[] = [
  'Microsoft.DocumentDB/databaseAccounts/readMetadata'
  'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/*'
  'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/*'
]

@description('Optional. Indicates whether the Role Definition was built-in or user created.')
@allowed([
  'CustomRole'
  'BuiltInRole'
])
param roleType string = 'CustomRole'

resource databaseAccount 'Microsoft.DocumentDB/databaseAccounts@2024-11-15' existing = {
  name: databaseAccountName
}

resource sqlRoleDefinition 'Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions@2024-11-15' = {
  parent: databaseAccount
  name: name ?? guid(databaseAccount.id, databaseAccountName, 'sql-role')
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

@description('The name of the SQL Role Definition.')
output name string = sqlRoleDefinition.name

@description('The resource ID of the SQL Role Definition.')
output resourceId string = sqlRoleDefinition.id

@description('The name of the resource group the SQL Role Definition was created in.')
output resourceGroupName string = resourceGroup().name
