targetScope = 'subscription'

metadata name = 'Deploying with a sql role definition and assignment'
metadata description = 'This instance deploys the module with sql role definition and assignment'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-documentdb.databaseaccounts-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dddarole'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// The default pipeline is selecting random regions which don't have capacity for Azure Cosmos DB or support all Azure Cosmos DB features when creating new accounts.
// This workaround also specifies the region for the dependency resources.
#disable-next-line no-hardcoded-location
var enforcedLocation = 'spaincentral'

// ============== //
// General resources
// ============== //
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedDependencies'
  params: {
    appName: 'dep-${namePrefix}-app-${serviceShort}'
    appServicePlanName: 'dep-${namePrefix}-asp-${serviceShort}'
    location: enforcedLocation
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-test-role-${serviceShort}'
  params: {
    name: '${namePrefix}-role-ref'
    dataPlaneRoleDefinitions: [
      {
        roleName: 'cosmos-sql-role-test'
        dataActions: [
          'Microsoft.DocumentDB/databaseAccounts/readMetadata'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/*'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/*'
        ]
        assignableScopes: [
          '${resourceGroup.id}/providers/Microsoft.DocumentDB/databaseAccounts/${namePrefix}-role-ref'
        ]
        assignments: [
          {
            principalId: nestedDependencies.outputs.identityPrincipalId
          }
        ]
      }
    ]
    dataPlaneRoleAssignments: [
      {
        principalId: nestedDependencies.outputs.identityPrincipalId
        roleDefinitionId: '${resourceGroup.id}/providers/Microsoft.DocumentDB/databaseAccounts/${namePrefix}-role-ref/sqlRoleDefinitions/00000000-0000-0000-0000-000000000001' // 'Cosmos DB Built-in Data Reader'
      }
    ]
    zoneRedundant: false
  }
}
