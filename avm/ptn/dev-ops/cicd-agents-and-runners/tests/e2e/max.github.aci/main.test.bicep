targetScope = 'subscription'

metadata name = 'Using large parameter set for GitHub self-hosted runners using Azure Container Instances.'
metadata description = 'This instance deploys the module with most of its features enabled for GitHub self-hosted runners using Azure Container Instances.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-githubRunner-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. The personal access token for the GitHub organization.')
@secure()
param personalAccessToken string = newGuid()

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'mxgh'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// =================
// General resources
// =================

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../main.bicep' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}'
  scope: resourceGroup
  params: {
    namingPrefix: namePrefix
    location: resourceLocation
    computeTypes: [
      'azure-container-instance'
    ]
    selfHostedConfig: {
      githubOrganization: 'githHubOrganization'
      githubRepository: 'dummyRepo'
      personalAccessToken: personalAccessToken
      ephemeral: true
      runnerNamePrefix: namePrefix
      runnerScope: 'repo'
      targetWorkflowQueueLength: '1'
      azureContainerInstanceTarget: {
        sku: 'Standard'
        cpu: 1
        memoryInGB: 2
        numberOfInstances: 3
      }
      selfHostedType: 'github'
    }
    networkingConfiguration: {
      addressSpace: '10.0.0.0/16'
      networkType: 'createNew'
      virtualNetworkName: 'vnet-aci'
      containerInstanceSubnetName: 'aci-subnet'
      containerInstanceSubnetAddressPrefix: '10.0.1.0/24'
    }
    privateNetworking: false
  }
}
