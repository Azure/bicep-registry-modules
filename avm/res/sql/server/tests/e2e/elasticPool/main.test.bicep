targetScope = 'subscription'

metadata name = 'Using elastic pool'
metadata description = 'This instance deploys the module with an elastic pool.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-sql.servers-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ssep'

@description('Optional. The password to leverage for the login.')
@secure()
param password string = newGuid()

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceLocation
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
      administratorLogin: 'adminUserName'
      administratorLoginPassword: password
      elasticPools: [
        // bare minimum elastic pool: only a name is specified
        {
          name: '${namePrefix}-${serviceShort}-ep-001'
        }
        // more complex elastic pool with non-default SKU and per database settings
        {
          name: '${namePrefix}-${serviceShort}-ep-002'
          sku: {
            name: 'GP_Gen5'
            tier: 'GeneralPurpose'
            capacity: 4
          }
          perDatabaseSettings: {
            minCapacity: '0.5'
            maxCapacity: '4'
          }
        }
      ]
    }
  }
]
