targetScope = 'subscription'

metadata name = 'Using only defaults for Azure DevOps self-hosted agents using Azure Container Instances.'
metadata description = 'This instance deploys the module with the minimum set of required parameters for Azure DevOps self-hosted agents in Azure Container Instances.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'test-${namePrefix}-devopsrunners-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location
@description('Required. The name of the Azure DevOps agents pool.')
param agentsPoolName string = 'aci-pool'

@description('Required. The name of the Azure DevOps organization.')
param devOpsOrganization string = 'azureDevOpsOrganization'

@description('Required. The personal access token for the Azure DevOps organization.')
@secure()
param personalAccessToken string = newGuid()

@description('Optional. Whether to use private or public networking for the Azure Container Registry.')
param privateNetworking bool = false

@description('Required. The name of the virtual network to create.')
param virtualNetworkName string = 'vnet-aci'

@description('Required. The address space for the virtual network.')
param virtualNetworkAddressSpace string = '10.0.0.0/16'

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'devaci'

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
      agentsPoolName: agentsPoolName
      devOpsOrganization: devOpsOrganization
      personalAccessToken: personalAccessToken
      selfHostedType: 'azuredevops'
    }
    networkingConfiguration: {
      addressSpace: virtualNetworkAddressSpace
      networkType: 'createNew'
      virtualNetworkName: virtualNetworkName
    }
    enableTelemetry: enableTelemetry
    privateNetworking: privateNetworking
  }
}
