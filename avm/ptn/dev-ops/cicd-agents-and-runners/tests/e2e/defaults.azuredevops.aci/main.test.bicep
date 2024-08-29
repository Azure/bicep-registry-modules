metadata name = 'Using only defaults for Azure DevOps self-hosted agents using Azure Container Instances.'
metadata description = 'This instance deploys the module with the minimum set of required parameters for Azure DevOps self-hosted agents in Azure Container Instances.'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = resourceGroup().location

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

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'devsr'

@description('Optional. A token to inject into the name of each resource.')
//param namePrefix string = '#_namePrefix_#'
param namePrefix string = 'sb'

module testDeployment '../../../main.bicep' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}'
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
