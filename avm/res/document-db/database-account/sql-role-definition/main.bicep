metadata name = 'DocumentDB Database Account SQL Role Definitions.'
metadata description = 'This module deploys a SQL Role Definision in a CosmosDB Account.'

@description('Conditional. The name of the parent Database Account. Required if the template is used in a standalone deployment.')
param databaseAccountName string

@description('Optional. The unique identifier of the Role Definition.')
param name string?

@description('Required. A user-friendly name for the Role Definition. Must be unique for the database account.')
param roleName string

@description('Optional. An array of data actions that are allowed.')
param dataActions string[] = []

@description('Optional. A set of fully qualified Scopes at or below which Role Assignments may be created using this Role Definition. This will allow application of this Role Definition on the entire database account or any underlying Database / Collection. Must have at least one element. Scopes higher than Database account are not enforceable as assignable Scopes. Note that resources referenced in assignable Scopes need not exist. Defaults to the current account.')
param assignableScopes string[]?

@description('Optional. An array of SQL Role Assignments to be created for the SQL Role Definition.')
param sqlRoleAssignments sqlRoleAssignmentType[]?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var enableReferencedModulesTelemetry = false

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.doctdb-dbacct-sqlroledefinition.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource sqlRoleDefinition 'Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions@2024-11-15' = {
  parent: databaseAccount
  name: name ?? guid(databaseAccount.id, databaseAccountName, 'sql-role')
  properties: {
    assignableScopes: assignableScopes ?? [
      databaseAccount.id
    ]
    permissions: [
      {
        dataActions: dataActions
      }
    ]
    roleName: roleName
    type: 'CustomRole'
  }
}

module databaseAccount_sqlRoleAssignments '../sql-role-assignment/main.bicep' = [
  for (sqlRoleAssignment, index) in (sqlRoleAssignments ?? []): {
    name: '${uniqueString(deployment().name)}-sqlra-${index}'
    params: {
      databaseAccountName: databaseAccount.name
      roleDefinitionId: sqlRoleDefinition.id
      principalId: sqlRoleAssignment.principalId
      name: sqlRoleAssignment.?name
      enableTelemetry: enableReferencedModulesTelemetry
    }
  }
]

@description('The name of the SQL Role Definition.')
output name string = sqlRoleDefinition.name

@description('The resource ID of the SQL Role Definition.')
output resourceId string = sqlRoleDefinition.id

@description('The name of the resource group the SQL Role Definition was created in.')
output resourceGroupName string = resourceGroup().name

@description('The role name of the SQL Role Definition.')
output roleName string = sqlRoleDefinition.properties.roleName

// =============== //
//   Definitions   //
// =============== //

@export()
@description('The type for the SQL Role Assignments.')
type sqlRoleAssignmentType = {
  @description('Optional. Name unique identifier of the SQL Role Assignment.')
  name: string?

  @description('Required. The unique identifier for the associated AAD principal in the AAD graph to which access is being granted through this Role Assignment. Tenant ID for the principal is inferred using the tenant associated with the subscription.')
  principalId: string
}
