targetScope = 'subscription'

metadata name = 'Using only defaults'
metadata description = 'This instance deploys the module with the minimum set of required parameters.'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-dev-ops-infrastructure.pool-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'mdpmin'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Required. Name of the Azure DevOps organization. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'CI-AzureDevOpsOrganizationName\'.')
@secure()
param azureDevOpsOrganizationName string = ''

// The Managed DevOps Pools resource is not available in all regions
#disable-next-line no-hardcoded-location
var enforcedLocation = 'uksouth'

// ============ //
// Dependencies //
// ============ //
module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedDependencies'
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
  location: enforcedLocation
}

// ============== //
// Test Execution //
// ============== //
@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      location: enforcedLocation
      agentProfile: {
        kind: 'Stateless'
      }
      concurrency: 1
      devCenterProjectResourceId: nestedDependencies.outputs.devCenterProjectResourceId
      images: [
        {
          wellKnownImageName: 'windows-2022/latest'
        }
      ]
      fabricProfileSkuName: 'Standard_DS2_v2'
      organizationProfile: {
        kind: 'AzureDevOps'
        organizations: [
          {
            url: 'https://dev.azure.com/${azureDevOpsOrganizationName}'
          }
        ]
      }
    }
  }
]
