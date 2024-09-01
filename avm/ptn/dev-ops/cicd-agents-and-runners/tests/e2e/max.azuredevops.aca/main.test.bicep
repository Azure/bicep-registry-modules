targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-devopsrunners-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Required. The name of the Azure DevOps agents pool.')
param agentsPoolName string = 'aca'

@description('Required. The name of the Azure DevOps organization.')
param devOpsOrganization string = 'azureDevOpsOrganization'

@description('Required. The personal access token for the Azure DevOps organization.')
@secure()
param personalAccessToken string = newGuid()

@description('Optional. Whether to use private or public networking for the Azure Container Registry.')
param privateNetworking bool = false

@description('Required. The name of the virtual network to create.')
param virtualNetworkName string = 'vnet-aca'

@description('Required. The address space for the virtual network.')
param virtualNetworkAddressSpace string = '10.0.0.0/16'

@description('Optional. The name of the Azure DevOps placeholder agent.')
param placeHolderAgentName string = 'acaPlaceHolderAgent'

@description('Optional. The target pipelines queue length.')
param targetPipelinesQueueLength string = '1'

@description('Optional. The name of the subnet for the Azure Container App.')
param containerAppSubnetName string = 'acaSubnet'

param containerAppSubnetAddressPrefix string = '10.0.1.0/24'

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'mxdev'

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
  name: '${uniqueString(deployment().name, resourceLocation)}-dep-${serviceShort}'
  scope: resourceGroup
  params: {
    namingPrefix: namePrefix
    location: resourceLocation
    computeTypes: [
      'azure-container-app'
    ]
    selfHostedConfig: {
      agentsPoolName: agentsPoolName
      devOpsOrganization: devOpsOrganization
      personalAccessToken: personalAccessToken
      agentNamePrefix: namePrefix
      azureContainerAppTarget: {
        resources: {
          cpu: '1'
          memory: '2Gi'
        }
      }
      placeHolderAgentName: placeHolderAgentName
      targetPipelinesQueueLength: targetPipelinesQueueLength
      selfHostedType: 'azuredevops'
    }
    networkingConfiguration: {
      addressSpace: virtualNetworkAddressSpace
      networkType: 'createNew'
      virtualNetworkName: virtualNetworkName
      containerAppSubnetName: containerAppSubnetName
      containerAppSubnetAddressPrefix: containerAppSubnetAddressPrefix
    }
    enableTelemetry: enableTelemetry
    privateNetworking: privateNetworking
  }
}
