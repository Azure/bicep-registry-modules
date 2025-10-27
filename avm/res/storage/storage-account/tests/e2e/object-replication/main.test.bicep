targetScope = 'subscription'

metadata name = 'Object Replication'
metadata description = 'This instance deploys the module with Object Replication features.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-storage.storageaccounts-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ssaobre'

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

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    location: resourceLocation == 'eastus2' ? 'westus' : 'eastus2'
    storageAccountName: '${namePrefix}${serviceShort}002'
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}diasa${serviceShort}01'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}'
    location: resourceLocation
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
      skuName: 'Standard_LRS'
      blobServices: {
        containers: [
          {
            name: 'container01'
          }
        ]
        isVersioningEnabled: true
        changeFeedEnabled: true
      }
      objectReplicationPolicies: [
        {
          destinationNameOrResourceId: nestedDependencies.outputs.storageAccountResourceId
          rules: [
            {
              sourceContainer: 'container01'
              destinationContainer: nestedDependencies.outputs.containerName
              filters: {
                prefixMatch: [
                  'documents/'
                  'images/'
                ]
                minCreationTime: '2025-01-01T00:00:00Z'
              }
            }
          ]
        }
      ]
    }
  }
]
