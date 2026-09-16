targetScope = 'subscription'

metadata name = 'Using a Git repository configuration'
metadata description = 'This instance deploys the module with a Git (Azure DevOps) repository configuration and validates that the configuration is actually persisted on the Data Factory - both after the initial and after a repeated deployment.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-datafactory.factories-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dffgit'

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
      location: resourceLocation
      gitConfigureLater: false
      gitRepoType: 'FactoryVSTSConfiguration'
      gitAccountName: 'contoso'
      gitProjectName: 'contoso-adf'
      gitRepositoryName: 'contoso-adf-repo'
      gitCollaborationBranch: 'main'
      gitRootFolder: '/'
      gitDisablePublish: false
      gitTenantId: tenant().tenantId
    }
  }
]

// Asserts that the Git configuration requested above is not silently dropped by the resource provider.
module testDeployment_validation 'validation.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-validation'
  params: {
    dataFactoryName: '${namePrefix}${serviceShort}001'
    expectedRepoType: 'FactoryVSTSConfiguration'
    expectedAccountName: 'contoso'
    expectedProjectName: 'contoso-adf'
    expectedRepositoryName: 'contoso-adf-repo'
    expectedCollaborationBranch: 'main'
    expectedRootFolder: '/'
  }
  dependsOn: [
    testDeployment
  ]
}
