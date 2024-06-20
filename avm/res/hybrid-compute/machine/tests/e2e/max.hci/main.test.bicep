targetScope = 'subscription'

metadata name = 'Creates an Arc Machine with maximum configurations'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-hybridCompute.machine-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'arcmachcimx'

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
    privateLinkScopeName: 'dep-${namePrefix}-pls-${serviceShort}'
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
      location: resourceLocation
      name: '${namePrefix}${serviceShort}'
      kind: 'HCI'
      patchAssessmentMode: 'AutomaticByPlatform'
      patchMode: 'AutomaticByPlatform'
      privateLinkScopeResourceId: nestedDependencies.outputs.privateLinkScopeResourceId
      guestConfiguration: {
        name: 'AzureWindowsBaseline'
        version: '1.*'
        assignmentType: 'ApplyAndMonitor'
        configurationParameter: [
          {
            name: 'Minimum Password Length;ExpectedValue'
            value: '16'
          }
          {
            name: 'Minimum Password Length;RemediateValue'
            value: '16'
          }
          {
            name: 'Maximum Password Age;ExpectedValue'
            value: '75'
          }
          {
            name: 'Maximum Password Age;RemediateValue'
            value: '75'
          }
        ]
      }
      osType: 'Windows'
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
  }
]
