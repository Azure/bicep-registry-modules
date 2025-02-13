metadata name = 'DocumentDB Database Account SQL Role.'
metadata description = 'This module deploys SQL Role Definision and Assignment in a CosmosDB Account.'

@description('Conditional. The name of the parent Database Account. Required if the template is used in a standalone deployment.')
param databaseAccountName string

@description('Required. Name of the SQL Role.')
param name string

@description('Optional. An array of data actions that are allowed.')
param dataActions array = [
  'Microsoft.DocumentDB/databaseAccounts/readMetadata'
  'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/*'
  'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/*'
]

@description('Optional. Ids needs to be granted.')
param principalIds array = []

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

module sqlRoleDefinition 'sql-role-definitions/main.bicep' = {
  name: 'sql-role-definition-${uniqueString(name)}'
  params: {
    databaseAccountName: databaseAccount.name
    dataActions: dataActions
    roleName: roleName
    roleType: roleType
  }
  dependsOn: [
    databaseAccount
  ]
}

@batchSize(1)
module sqlRoleAssignment 'sql-role-assignments/main.bicep' = [
  for principalId in principalIds: if (!empty(principalId)) {
    name: 'sql-role-assign-${uniqueString(principalId)}'
    params: {
      name: guid(sqlRoleDefinition.outputs.resourceId, principalId, databaseAccount.id)
      databaseAccountName: databaseAccountName
      roleDefinitionId: sqlRoleDefinition.outputs.resourceId
      principalId: principalId
    }
    dependsOn: [
      databaseAccount
      sqlRoleDefinition
    ]
  }
]

@description('The name of the resource group the SQL Role Definition and Assignment were created in.')
output resourceGroupName string = resourceGroup().name
