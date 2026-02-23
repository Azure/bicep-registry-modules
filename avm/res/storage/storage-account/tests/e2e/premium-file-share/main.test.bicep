targetScope = 'subscription'

metadata name = 'Using premium file shares'
metadata description = 'This instance deploys the module with File Services with PremiumV2 SKU and a file share.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-storage.storageaccounts-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ssapfs'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
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
      allowBlobPublicAccess: false
      networkAcls: {
        defaultAction: 'Deny'
        bypass: 'AzureServices'
      }
      kind: 'FileStorage'
      skuName: 'PremiumV2_LRS'
      fileServices: {
        shares: [
          {
            name: 'fileshare01'
            provisionedBandwidthMibps: 200
            provisionedIops: 5000
          }
          {
            name: 'fileshare02'
          }
        ]
      }
    }
  }
]
