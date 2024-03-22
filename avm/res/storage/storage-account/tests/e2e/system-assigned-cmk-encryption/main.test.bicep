targetScope = 'subscription'

metadata name = 'Using Customer-Managed-Keys with System-Assigned identity'
metadata description = 'This instance deploys the module using Customer-Managed-Keys using a System-Assigned Identity. This required the service to be deployed twice, once as a pre-requisite to create the System-Assigned Identity, and once to use it for accessing the Customer-Managed-Key secret.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-storage.storageaccounts-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ssasacr'

@description('Generated. Used as a basis for unique resource names.')
param baseTime string = utcNow('u')

@description('Optional. A token to inject into the name of each resource.')
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

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    location: resourceLocation
    storageAccountName: '${namePrefix}${serviceShort}001'
    // Adding base time to make the name unique as purge protection must be enabled (but may not be longer than 24 characters total)
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}-${substring(uniqueString(baseTime), 0, 3)}'
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [for iteration in [ 'init', 'idem' ]: {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
  params: {
    location: resourceLocation
    name: nestedDependencies.outputs.storageAccountName
    privateEndpoints: [
      {
        service: 'blob'
        subnetResourceId: nestedDependencies.outputs.subnetResourceId
        privateDnsZoneResourceIds: [
          nestedDependencies.outputs.privateDNSZoneResourceId
        ]
      }
    ]
    blobServices: {
      containers: [
        {
          name: '${namePrefix}container'
          publicAccess: 'None'
        }
      ]
    }
    managedIdentities: {
      systemAssigned: true
    }
    customerManagedKey: {
      keyName: nestedDependencies.outputs.keyName
      keyVaultResourceId: nestedDependencies.outputs.keyVaultResourceId
    }
  }
  dependsOn: [
    nestedDependencies
  ]
}]
