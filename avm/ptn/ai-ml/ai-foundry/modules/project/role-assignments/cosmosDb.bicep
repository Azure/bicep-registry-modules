@description('Required. The name of the Cosmos DB account.')
param cosmosDbName string

@description('Required. The principal ID of the project identity.')
param projectIdentityPrincipalId string

@description('Required. The project workspace ID.')
param projectWorkspaceId string

@description('Required. Whether to create a capability host for the project.')
param createCapabilityHost bool

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

resource cosmosDb 'Microsoft.DocumentDB/databaseAccounts@2025-04-15' existing = {
  name: cosmosDbName
}

module cosmosDbOperatorAssignment 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = {
  name: take('proj-cosmos-db-operator-role-assign-${cosmosDbName}', 64)
  params: {
    resourceId: cosmosDb.id
    principalId: projectIdentityPrincipalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: '230815da-be43-4aae-9cb4-875f7bd000aa' // Cosmos DB Operator
    enableTelemetry: enableTelemetry
  }
}

var cosmosContainerNameSuffixes = createCapabilityHost
  ? [
      'thread-message-store'
      'system-thread-message-store'
      'agent-entity-store'
    ]
  : []

var cosmosDefaultSqlRoleDefinitionId = createCapabilityHost
  ? resourceId(
      'Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions',
      cosmosDbName,
      '00000000-0000-0000-0000-000000000002'
    )
  : ''

resource cosmosDataRoleAssigment 'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments@2025-04-15' = [
  for (containerSuffix, i) in cosmosContainerNameSuffixes: {
    parent: cosmosDb
    dependsOn: [
      cosmosDbOperatorAssignment
    ]
    name: guid(cosmosDefaultSqlRoleDefinitionId, cosmosDbName, containerSuffix)
    properties: {
      principalId: projectIdentityPrincipalId
      roleDefinitionId: cosmosDefaultSqlRoleDefinitionId
      scope: '${cosmosDb.id}/dbs/enterprise_memory/colls/${projectWorkspaceId}-${containerSuffix}'
    }
  }
]
