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

// Assigned to the module parameter as-is, so the resource provider's schema is enforced at build time.
var gitConfiguration = {
  type: 'FactoryVSTSConfiguration'
  accountName: 'contoso'
  projectName: 'contoso-adf'
  repositoryName: 'contoso-adf-repo'
  collaborationBranch: 'main'
  rootFolder: '/'
  disablePublish: false
  tenantId: tenant().tenantId
}

// 'tenantId' is environment-specific and 'disablePublish' is not echoed back by the resource provider when false.
var unassertedProperties = ['disablePublish', 'tenantId']

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      location: resourceLocation
      gitConfiguration: gitConfiguration
    }
  }
]

@description('The resource ID of the deployed Data Factory. Consumed by the post-deployment test.')
output dataFactoryResourceId string = testDeployment[1].outputs.resourceId

@description('The Git repository configuration properties that must be persisted on the Data Factory. Consumed by the post-deployment test.')
output expectedGitConfiguration object[] = map(
  filter(items(gitConfiguration), property => !contains(unassertedProperties, property.key)),
  property => {
    name: property.key
    value: property.value
  }
)
