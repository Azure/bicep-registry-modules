targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
// e.g., for a module 'network/private-endpoint' you could use 'dep-dev-network.privateendpoints-${serviceShort}-rg'
param resourceGroupName string = 'dep-${namePrefix}-<provider>-<resourceType>-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
// e.g., for a module 'network/private-endpoint' you could use 'npe' as a prefix and then 'waf' as a suffix for the waf-aligned test
param serviceShort string = 'cimin'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-nestedDependencies'
  params: {
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    location: location
    storageAccountName: 'dep${namePrefix}sa${serviceShort}01'
    imageTemplateNamePrefix: 'dep-${namePrefix}-imgt-${serviceShort}'
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
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}-${iteration}'
  params: {
    name: '${namePrefix}${serviceShort}001'
    location: location
    osAccountType: 'Standard_LRS'
    osDiskBlobUri: nestedDependencies.outputs.vhdUri
    osDiskCaching: 'ReadWrite'
    osType: 'Windows'
  }
}]
