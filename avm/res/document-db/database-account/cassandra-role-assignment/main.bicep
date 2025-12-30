metadata name = 'DocumentDB Database Account Cassandra Role Assignments.'
metadata description = 'This module deploys a Cassandra Role Assignment in a CosmosDB Account.'

@description('Conditional. The name of the parent Database Account. Required if the template is used in a standalone deployment.')
param databaseAccountName string

@description('Optional. Name unique identifier of the Cassandra Role Assignment.')
param name string?

@description('Required. The unique identifier for the associated AAD principal in the AAD graph to which access is being granted through this Role Assignment. Tenant ID for the principal is inferred using the tenant associated with the subscription.')
param principalId string

@description('Required. The unique identifier of the associated Cassandra Role Definition.')
param roleDefinitionId string

@description('Optional. The data plane resource path for which access is being granted through this Cassandra Role Assignment. Defaults to the current account.')
param scope string?

// ============== //
// Resources      //
// ============== //

resource databaseAccount 'Microsoft.DocumentDB/databaseAccounts@2024-11-15' existing = {
  name: databaseAccountName
}

resource cassandraRoleAssignment 'Microsoft.DocumentDB/databaseAccounts/cassandraRoleAssignments@2025-05-01-preview' = {
  parent: databaseAccount
  name: name ?? guid(roleDefinitionId, principalId, databaseAccount.id)
  properties: {
    principalId: principalId
    roleDefinitionId: roleDefinitionId
    scope: scope ?? databaseAccount.id
  }
}

// ============ //
// Outputs      //
// ============ //

@description('The name of the Cassandra Role Assignment.')
output name string = cassandraRoleAssignment.name

@description('The resource ID of the Cassandra Role Assignment.')
output resourceId string = cassandraRoleAssignment.id

@description('The name of the resource group the Cassandra Role Assignment was created in.')
output resourceGroupName string = resourceGroup().name
