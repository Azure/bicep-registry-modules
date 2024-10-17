targetScope = 'subscription'

metadata name = 'Use Case 3 - allowed IP address'
metadata description = 'Integration with existing core Infrastructure - allowed IP address.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-data-privateanalyticalworkspace-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dpawuc03pub'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
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
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}'
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
      name: '${namePrefix}${serviceShort}001'
      tags: {
        Owner: 'Contoso'
        CostCenter: '123-456-789'
      }
      enableDatabricks: true
      virtualNetworkResourceId: nestedDependencies.outputs.virtualNetworkResourceId
      logAnalyticsWorkspaceResourceId: nestedDependencies.outputs.logAnalyticsWorkspaceResourceId
      keyVaultResourceId: nestedDependencies.outputs.keyVaultResourceId
      advancedOptions: {
        networkAcls: { ipRules: ['104.43.16.94'] }
        virtualNetwork: {
          subnetNamePrivateLink: last(split(nestedDependencies.outputs.subnetResourceIds[0], '/'))
        }
        databricks: {
          subnetNameFrontend: last(split(nestedDependencies.outputs.subnetResourceIds[1], '/'))
          subnetNameBackend: last(split(nestedDependencies.outputs.subnetResourceIds[2], '/'))
        }
      }
    }
  }
]

output resourceId string = testDeployment[0].outputs.resourceId
output name string = testDeployment[0].outputs.name
output location string = testDeployment[0].outputs.location
output resourceGroupName string = testDeployment[0].outputs.resourceGroupName
output virtualNetworkResourceId string = testDeployment[0].outputs.virtualNetworkResourceId
output virtualNetworkName string = testDeployment[0].outputs.virtualNetworkName
output virtualNetworkLocation string = testDeployment[0].outputs.virtualNetworkLocation
output virtualNetworkResourceGroupName string = testDeployment[0].outputs.virtualNetworkResourceGroupName
output logAnalyticsWorkspaceResourceId string = testDeployment[0].outputs.logAnalyticsWorkspaceResourceId
output logAnalyticsWorkspaceName string = testDeployment[0].outputs.logAnalyticsWorkspaceName
output logAnalyticsWorkspaceLocation string = testDeployment[0].outputs.logAnalyticsWorkspaceLocation
output logAnalyticsWorkspaceResourceGroupName string = testDeployment[0].outputs.logAnalyticsWorkspaceResourceGroupName
output keyVaultResourceId string = testDeployment[0].outputs.keyVaultResourceId
output keyVaultName string = testDeployment[0].outputs.keyVaultName
output keyVaultLocation string = testDeployment[0].outputs.keyVaultLocation
output keyVaultResourceGroupName string = testDeployment[0].outputs.keyVaultResourceGroupName
output databricksResourceId string = testDeployment[0].outputs.databricksResourceId
output databricksName string = testDeployment[0].outputs.databricksName
output databricksLocation string = testDeployment[0].outputs.databricksLocation
output databricksResourceGroupName string = testDeployment[0].outputs.databricksResourceGroupName
