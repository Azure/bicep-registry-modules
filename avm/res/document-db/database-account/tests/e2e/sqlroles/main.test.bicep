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
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      sqlRoleDefinitions: [
        {
          name: guid('optional-role-identifier') // MUST be a guid
          roleName: 'cosmos-sql-role-test'
          dataActions: [
            'Microsoft.DocumentDB/databaseAccounts/readMetadata'
            'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/*'
            'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/*'
          ]
          assignableScopes: [
            '${resourceGroup.id}/providers/Microsoft.DocumentDB/databaseAccounts/${namePrefix}${serviceShort}001'
          ]
          assignments: [
            {
              principalId: nestedDependencies.outputs.identityPrincipalId
            }
          ]
        }
        {
          roleName: 'cosmos-sql-role-test-2'
          dataActions: [
            'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/*'
          ]
          assignableScopes: [
            '${resourceGroup.id}/providers/Microsoft.DocumentDB/databaseAccounts/${namePrefix}${serviceShort}001'
          ]
        }
        {
          roleName: 'cosmos-sql-role-test-3'
          dataActions: [
            'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/*'
          ]
        }
      ]
      zoneRedundant: false
      sqlDatabases: [
        {
          name: 'simple-db'
          containers: [
            {
              name: 'container-001'
              indexingPolicy: {
                automatic: true
              }
              paths: [
                '/myPartitionKey'
              ]
              // defaultTtl: - // = Off if not provided at all?
              // defaultTtl: -1 // = On (no default)
              // defaultTtl: 10 // = On with 10 seconds
            }
          ]
        }
      ]
      sqlRoleAssignments: [
        {
          principalId: nestedDependencies.outputs.identityPrincipalId
          roleDefinitionId: '${resourceGroup.id}/providers/Microsoft.DocumentDB/databaseAccounts/${namePrefix}${serviceShort}001/sqlRoleDefinitions/00000000-0000-0000-0000-000000000001' // 'Cosmos DB Built-in Data Reader'
        }
        {
          principalId: nestedDependencies.outputs.identityPrincipalId
          roleDefinitionId: '00000000-0000-0000-0000-000000000001' // 'Cosmos DB Built-in Data Reader'
          scope: '${resourceGroup.id}/providers/Microsoft.DocumentDB/databaseAccounts/${namePrefix}${serviceShort}001/dbs/simple-db'
        }
        {
          principalId: nestedDependencies.outputs.identityPrincipalId
          roleDefinitionId: 'Cosmos DB Built-in Data Reader'
          scope: '${resourceGroup.id}/providers/Microsoft.DocumentDB/databaseAccounts/${namePrefix}${serviceShort}001/dbs/simple-db/colls/container-001'
        }
      ]
    }
  }
]
