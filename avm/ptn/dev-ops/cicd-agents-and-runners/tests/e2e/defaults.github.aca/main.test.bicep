metadata name = 'Using only defaults for GitHub self-hosted runners using Azure Container Apps.'
metadata description = 'This instance deploys the module with the minimum set of required parameters for GitHub self-hosted runners in Azure Container Apps.'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = resourceGroup().location

@description('Optional. Whether to use private or public networking for the Azure Container Registry.')
param privateNetworking bool = false

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
      githubOrganization: 'gitHubOrganization'
      githubRepository: 'gitHubRepository'
      personalAccessToken: 'dummyPAT'
      selfHostedType: 'github'
    }
    networkingConfiguration: {
      addressSpace: '10.0.0.0/16'
      networkType: 'createNew'
      virtualNetworkName: 'vnet-aca'
    }
    enableTelemetry: enableTelemetry
    privateNetworking: privateNetworking
  }
}
