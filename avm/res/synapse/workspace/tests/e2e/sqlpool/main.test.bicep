targetScope = 'subscription'

metadata name = 'Using SQL Pool'
metadata description = 'This instance deploys the module with the configuration of SQL Pool.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-synapse.workspaces-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'swsqlp'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

#disable-next-line no-hardcoded-location
var enforcedLocation = 'northeurope'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedDependencies'
  params: {
    location: enforcedLocation
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
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      defaultDataLakeStorageAccountResourceId: nestedDependencies.outputs.storageAccountResourceId
      defaultDataLakeStorageFilesystem: nestedDependencies.outputs.storageContainerName
      sqlAdministratorLogin: 'synwsadmin'
      sqlPools: [
        {
          name: 'dep${namePrefix}sqlp01'
        }
        {
          name: 'dep${namePrefix}sqlp02'
          collation: 'SQL_Latin1_General_CP1_CI_AS'
          maxSizeBytes: 1099511627776 // 1 TB
          sku: 'DW200c'
          storageAccountType: 'LRS'
          transparentDataEncryption: 'Enabled'
        }
      ]
    }
  }
]
