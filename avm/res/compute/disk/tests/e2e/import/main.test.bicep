targetScope = 'subscription'

metadata name = 'Using an imported image'
metadata description = 'This instance deploys the module with a custom image that is imported from a VHD in a storage account.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-compute.disks-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'cdimp'

@description('Generated. Do not provide a value! This date value is used to generate a unique image template name.')
param baseTime string = utcNow('yyyy-MM-dd-HH-mm-ss')

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
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    location: resourceLocation
    storageAccountName: 'dep${namePrefix}sa${serviceShort}01'
    imageTemplateName: 'dep-${namePrefix}-imgt-${serviceShort}-${baseTime}'
    triggerImageDeploymentScriptName: 'dep-${namePrefix}-ds-${serviceShort}-triggerImageTemplate'
    copyVhdDeploymentScriptName: 'dep-${namePrefix}-ds-${serviceShort}-copyVhdToStorage'
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
    name: '${namePrefix}-${serviceShort}001'
    location: resourceLocation
    sku: 'Standard_LRS'
    createOption: 'Import'
    sourceUri: nestedDependencies.outputs.vhdUri
    storageAccountId: nestedDependencies.outputs.storageAccountResourceId
  }
}]
