targetScope = 'subscription'

metadata name = 'Using managed Vnet'
metadata description = 'This instance deploys the module using a managed Vnet.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-synapse.workspaces-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'swmanv'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    location: resourceLocation
    storageAccountName: 'dep${namePrefix}sa${serviceShort}01'
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      location: resourceLocation
      defaultDataLakeStorageAccountResourceId: nestedDependencies.outputs.storageAccountResourceId
      defaultDataLakeStorageFilesystem: nestedDependencies.outputs.storageContainerName
      sqlAdministratorLogin: 'synwsadmin'
      managedVirtualNetwork: true
      preventDataExfiltration: true
      allowedAadTenantIdsForLinking: [
        tenant().tenantId
      ]
    }
  }
]
