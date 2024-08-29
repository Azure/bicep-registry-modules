metadata name = 'Using only defaults for GitHub self-hosted runners using Azure Container Apps.'
metadata description = 'This instance deploys the module with the minimum set of required parameters for GitHub self-hosted runners in Azure Container Apps.'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = resourceGroup().location

@description('Required. The name of the GitHub organization.')
param githubOrganization string = 'azureDevOpsOrganization'

@description('Required. The name of the GitHub repository.')
param githubRepository string = 'dummyRepo'

@description('Required. The personal access token for the GitHub organization.')
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
param namePrefix string = '#_namePrefix_#'
module testDeployment '../../../main.bicep' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}'
  params: {
    namingPrefix: namePrefix
    location: resourceLocation
    computeTypes: [
      'azure-container-app'
    ]
    selfHostedConfig: {
      githubOrganization: githubOrganization
      githubRepository: githubRepository
      personalAccessToken: personalAccessToken
      selfHostedType: 'github'
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
