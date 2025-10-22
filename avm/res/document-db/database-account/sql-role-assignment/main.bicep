metadata name = 'DocumentDB Database Account SQL Role Assignments.'
metadata description = 'This module deploys a SQL Role Assignment in a CosmosDB Account.'

@description('Conditional. The name of the parent Database Account. Required if the template is used in a standalone deployment.')
param databaseAccountName string

@description('Optional. Name unique identifier of the SQL Role Assignment.')
param name string?

@description('Required. The unique identifier for the associated AAD principal in the AAD graph to which access is being granted through this Role Assignment. Tenant ID for the principal is inferred using the tenant associated with the subscription.')
param principalId string

@description('Required. The unique identifier of the associated SQL Role Definition.')
param roleDefinitionIdOrName string

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. The data plane resource id for which access is being granted through this Role Assignment. Defaults to the root of the database account, but can also be scoped to e.g., the container and database level.')
param scope string?

var builtInDataPlaneRoleNames = {
  'Cosmos DB Built-in Data Reader': '${databaseAccount.id}/sqlRoleDefinitions/00000000-0000-0000-0000-000000000001'
  'Cosmos DB Built-in Data Contributor': '${databaseAccount.id}/sqlRoleDefinitions/00000000-0000-0000-0000-000000000002'
}

var formattedRoleDefinition = builtInDataPlaneRoleNames[?roleDefinitionIdOrName] ?? (contains(
    roleDefinitionIdOrName,
    '/sqlRoleDefinitions/'
  )
  ? roleDefinitionIdOrName
  : '${databaseAccount.id}/sqlRoleDefinitions/${roleDefinitionIdOrName}')

// The internal naming differs from the resource ID
var formattedScope = replace(replace(scope ?? databaseAccount.id, '/sqlDatabases/', '/dbs/'), '/containers/', '/colls/')

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.doctdb-dbacct-sqlroleassignment.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

resource databaseAccount 'Microsoft.DocumentDB/databaseAccounts@2024-11-15' existing = {
  name: databaseAccountName
}

resource sqlRoleAssignment 'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments@2024-11-15' = {
  parent: databaseAccount
  name: name ?? guid(formattedRoleDefinition, principalId, formattedScope)
  properties: {
    principalId: principalId
    roleDefinitionId: formattedRoleDefinition
    scope: formattedScope
  }
}

// ============ //
// Outputs      //
// ============ //

@description('The name of the SQL Role Assignment.')
output name string = sqlRoleAssignment.name

@description('The resource ID of the SQL Role Assignment.')
output resourceId string = sqlRoleAssignment.id

@description('The name of the resource group the SQL Role Definition was created in.')
output resourceGroupName string = resourceGroup().name
