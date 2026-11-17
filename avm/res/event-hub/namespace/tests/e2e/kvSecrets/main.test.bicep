import { uniqueResourceName } from '../../../../../../../utilities/e2e-template-assets/functions/unique-resource-name.bicep'

targetScope = 'subscription'

metadata name = 'Deploying with a key vault reference to save secrets'
metadata description = 'This instance deploys the module saving all its secrets in a key vault.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-eventhub.namespaces-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ehnkv'

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
    keyVaultName: uniqueResourceName('dep-${namePrefix}-kv-${serviceShort}', resourceGroup.id, 24)
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}'
  params: {
    name: uniqueResourceName('${namePrefix}${serviceShort}001', resourceGroup.id, 50)
    secretsExportConfiguration: {
      keyVaultResourceId: nestedDependencies.outputs.keyVaultResourceId
      rootPrimaryKeyName: 'primaryKey-name'
      rootSecondaryKeyName: 'secondaryKey-name'
      rootPrimaryConnectionStringName: 'primaryConnectionString-name'
      rootSecondaryConnectionStringName: 'secondaryConnectionString-name'
    }
  }
}
