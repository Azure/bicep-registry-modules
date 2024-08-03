targetScope = 'subscription'

metadata name = 'Using only defaults'
metadata description = 'This instance deploys the module with the minimum set of required parameters.'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-dev-ops-infrastructure.pools-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'mdpmin'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ========= //
// Variables //
// ========= //
var azureDevOpsOrganizationName = 'john-lokerse'

// ============ //
// Dependencies //
// ============ //
module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    devCenterName: 'dep-${namePrefix}-dc-${serviceShort}'
    devCenterProjectName: 'dep-${namePrefix}-dcp-${serviceShort}'
  }
}

// ================= //
// General resources //
// ================= //
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
      name: '${namePrefix}${serviceShort}001'
      location: resourceLocation
      agentProfile: {
        kind: 'Stateless'
      }
      concurrency: 1
      devCenterProjectResourceId: nestedDependencies.outputs.devCenterProjectResourceId
      images: [
        {
          aliases: [
            'windows-2022'
          ]
          buffer: '*'
        }
      ]
      fabricProfileSkuName: 'Standard_DS2_v2'
      organizationProfile: {
        kind: 'AzureDevOps'
        organizations: [
          {
            url: 'https://dev.azure.com/${azureDevOpsOrganizationName}'
            parallelism: 1
          }
        ]
        permissionProfile: {
          kind: 'Inherit'
        }
      }
    }
  }
]
