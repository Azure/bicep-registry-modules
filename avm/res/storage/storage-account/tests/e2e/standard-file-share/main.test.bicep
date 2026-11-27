targetScope = 'subscription'

metadata name = 'Using standard provisioned v2 file shares'
metadata description = 'This instance deploys FileStorage accounts with StandardV2_ZRS and StandardV2_LRS SKUs and file shares without an explicit access tier.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-storage.storageaccounts-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ssasv2'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

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
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-zrs-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}zrs'
      kind: 'FileStorage'
      skuName: 'StandardV2_ZRS'
      allowBlobPublicAccess: false
      networkAcls: {
        defaultAction: 'Deny'
        bypass: 'AzureServices'
      }
      azureFilesIdentityBasedAuthentication: {
        directoryServiceOptions: 'AADKERB'
      }
      fileServices: {
        shares: [
          {
            name: 'profiles'
          }
        ]
      }
    }
  }
]

@batchSize(1)
module testDeploymentLrs '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-lrs-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}lrs'
      kind: 'FileStorage'
      skuName: 'StandardV2_LRS'
      allowBlobPublicAccess: false
      networkAcls: {
        defaultAction: 'Deny'
        bypass: 'AzureServices'
      }
      fileServices: {
        shares: [
          {
            name: 'profiles'
          }
        ]
      }
    }
  }
]
