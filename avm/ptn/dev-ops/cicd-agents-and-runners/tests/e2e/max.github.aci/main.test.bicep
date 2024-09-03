targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-githubRunner-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Required. The name of the GitHub organization.')
param githubOrganization string = 'githHubOrganization'

@description('Required. The name of the GitHub repository.')
param githubRepository string = 'dummyRepo'

@description('Required. The personal access token for the GitHub organization.')
@secure()
param personalAccessToken string = newGuid()

@description('Optional. The scope of the self-hosted runner.')
param runnerScope string = 'repo'

@description('Optional. The target workflows queue length.')
param targetWorkflowQueueLength string = '1'

@description('Optional. Whether to use private or public networking for the Azure Container Registry.')
param privateNetworking bool = false

@description('Required. The name of the virtual network to create.')
param virtualNetworkName string = 'vnet-aci'

@description('Required. The address space for the virtual network.')
param virtualNetworkAddressSpace string = '10.0.0.0/16'

@description('Optional. The name of the subnet for the Azure Container App.')
param containerInstanceSubnetName string = 'aciSubnet'

param containerInstanceSubnetAddressPrefix string = '10.0.1.0/24'

@description('Optional. The SKU of the Azure Container Instance.')
param skuName string = 'Standard'

@description('Optional. The memory in GB of the Azure Container Instance containers.')
param memory int = 2

@description('Optional. The number of CPUs of the Azure Container Instance containers.')
param cpu int = 1

@description('Optional. The number of instances of the Azure Container Instance.')
param numberOfInstances int = 3

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
      githubOrganization: githubOrganization
      githubRepository: githubRepository
      personalAccessToken: personalAccessToken
      ephemeral: true
      runnerNamePrefix: namePrefix
      runnerScope: runnerScope
      targetWorkflowQueueLength: targetWorkflowQueueLength
      azureContainerInstanceTarget: {
        sku: skuName
        cpu: cpu
        memoryInGB: memory
        numberOfInstances: numberOfInstances
      }
      selfHostedType: 'github'
    }
    networkingConfiguration: {
      addressSpace: virtualNetworkAddressSpace
      networkType: 'createNew'
      virtualNetworkName: virtualNetworkName
      containerInstanceSubnetName: containerInstanceSubnetName
      containerInstanceSubnetAddressPrefix: containerInstanceSubnetAddressPrefix
    }
    privateNetworking: privateNetworking
  }
}
