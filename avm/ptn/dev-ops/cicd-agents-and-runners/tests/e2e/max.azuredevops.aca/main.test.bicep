targetScope = 'subscription'

metadata name = 'Using large parameter set for Azure DevOps self-hosted agents using Azure Container Apps.'
metadata description = 'This instance deploys the module with most of its features enabled for Azure DevOps self-hosted agents using Azure Container Apps.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-devopsrunners-${serviceShort}-rg'

#disable-next-line no-hardcoded-location // Due to quotas and capacity challenges, this region must be used in the AVM testing subscription
var enforcedLocation = 'eastus2'

@description('Optional. The personal access token for the Azure DevOps organization.')
@secure()
param personalAccessToken string = newGuid()

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'mxdev'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// =================
// General resources
// =================

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../main.bicep' = {
  name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}'
  scope: resourceGroup
  params: {
    namingPrefix: namePrefix
    location: enforcedLocation
    computeTypes: [
      'azure-container-app'
    ]
    selfHostedConfig: {
      agentsPoolName: 'aca-pool'
      devOpsOrganization: 'azureDevOpsOrganization'
      personalAccessToken: personalAccessToken
      agentNamePrefix: namePrefix
      azureContainerAppTarget: {
        resources: {
          cpu: '1'
          memory: '2Gi'
        }
      }
      placeHolderAgentName: 'acaPlaceHolderAgent'
      targetPipelinesQueueLength: '1'
      selfHostedType: 'azuredevops'
    }
    networkingConfiguration: {
      virtualNetworkName: 'vnet-aca'
      addressSpace: '10.0.0.0/16'
      networkType: 'createNew'
      containerAppSubnetName: 'acaSubnet'
      containerAppSubnetAddressPrefix: '10.0.1.0/24'
    }
    privateNetworking: false
  }
}
