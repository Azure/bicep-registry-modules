targetScope = 'subscription'

metadata name = 'Using only defaults for GitHub self-hosted runners using Private networking.'
metadata description = 'This instance deploys the module with the minimum set of required parameters GitHub self-hosted runners using Private networking in Azure Container Instances.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-githubrunners-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. The personal access token for the Azure DevOps organization.')
@secure()
param personalAccessToken string = newGuid()

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'pngh'

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
      selfHostedType: 'github'
    }
    networkingConfiguration: {
      addressSpace: '10.0.0.0/16'
      networkType: 'createNew'
      virtualNetworkName: 'vnet-aci'
    }
    privateNetworking: true
  }
}
