import { uniqueResourceName } from '../../../../../../../utilities/e2e-template-assets/functions/unique-resource-name.bicep'

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

#disable-next-line no-hardcoded-location // Accounting for capacity constraints
var enforcedLocation = 'germanywestcentral'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedDependencies'
  params: {
    location: enforcedLocation
    storageAccountName: uniqueResourceName('dep${namePrefix}sa${serviceShort}01', resourceGroup.id, 24)
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
      name: uniqueResourceName('${namePrefix}${serviceShort}001', resourceGroup.id, 50)
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
