targetScope = 'subscription'

metadata name = 'Using only defaults for Azure DevOps self-hosted agents using Private networking in an existing vnet.'
metadata description = 'This instance deploys the module with the minimum set of required parameters Azure DevOps self-hosted agents using Private networking in Azure Container Instances in an existing vnet.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-azuredevops-${serviceShort}-rg'

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
param privateNetworking bool = true

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'pnexa'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// =================
// General resources
// =================

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

// =================
// Dependencies
// =================
module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    namePrefix: namePrefix
    location: resourceLocation
  }
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
      selfHostedType: 'azuredevops'
      agentsPoolName: agentsPoolName
      devOpsOrganization: devOpsOrganization
      personalAccessToken: personalAccessToken
      agentNamePrefix: namePrefix
      azureContainerInstanceTarget: {
        numberOfInstances: 2
      }
    }
    networkingConfiguration: {
      networkType: 'useExisting'
      virtualNetworkResourceId: nestedDependencies.outputs.virtualNetworkResourceId
      containerRegistryPrivateEndpointSubnetName: 'acr-subnet'
      containerRegistryPrivateDnsZoneResourceId: nestedDependencies.outputs.acrPrivateDNSZoneResourceId
      natGatewayPublicIpAddressResourceId: nestedDependencies.outputs.publicIPResourceId
      natGatewayResourceId: nestedDependencies.outputs.natGatewayResourceId
      computeNetworking: {
        computeNetworkType: 'azureContainerInstance'
        containerInstanceSubnetName: 'aci-subnet'
      }
    }
    enableTelemetry: enableTelemetry
    privateNetworking: privateNetworking
  }
}
