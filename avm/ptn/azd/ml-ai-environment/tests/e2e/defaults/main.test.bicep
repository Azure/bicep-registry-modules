targetScope = 'subscription'

metadata name = 'Using only defaults'
metadata description = 'This instance deploys the module with the minimum set of required parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-azd-ml-ai-environment-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'maemin'

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

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      location: resourceLocation
      keyVaultName: '${namePrefix}${serviceShort}kv01'
      storageAccountName: '${namePrefix}${serviceShort}sa001'
      hubName: '${namePrefix}${serviceShort}hub001'
      projectName: '${namePrefix}${serviceShort}pro001'
      userAssignedtName: '${namePrefix}${serviceShort}ua001'
      cognitiveServicesName: '${namePrefix}${serviceShort}cs001'
      openAiConnectionName: '${namePrefix}${serviceShort}ai001-connection'
      searchConnectionName: '${namePrefix}${serviceShort}search001-connection'
    }
  }
]
