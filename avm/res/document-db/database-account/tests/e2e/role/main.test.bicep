targetScope = 'subscription'

metadata name = 'Deploying with a sql role definision and assignment'
metadata description = 'This instance deploys the module with sql role definision and assignment'

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

// Pipeline is selecting random regions which dont support all cosmos features and have constraints when creating new cosmos
#disable-next-line no-hardcoded-location
var enforcedLocation = 'eastus2'

// ============== //
// General resources
// ============== //
resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
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
    location: enforcedLocation
    name: '${namePrefix}-role-ref'
    sqlRoleAssignmentsPrincipalIds: [
      nestedDependencies.outputs.identityPrincipalId
    ]
    sqlRoleDefinitions: [
      { name: 'cosmos-sql-role-test' }
    ]
  }
}
