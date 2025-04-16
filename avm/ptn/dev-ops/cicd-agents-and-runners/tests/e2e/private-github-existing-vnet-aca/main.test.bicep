targetScope = 'subscription'

metadata name = 'Using only defaults for GitHub self-hosted runners using Private networking in an existing vnet.'
metadata description = 'This instance deploys the module with the minimum set of required parameters GitHub self-hosted runners using Private networking in Azure Container Apps in an existing vnet.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-githubrunners-${serviceShort}-rg'

#disable-next-line no-hardcoded-location // Due to quotas and capacity challenges, this region must be used in the AVM testing subscription
var enforcedLocation = 'eastus2'

@description('Optional. The personal access token for the Azure DevOps organization.')
@secure()
param personalAccessToken string = newGuid()

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'pnexg'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// =================
// General resources
// =================

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

// =================
// Dependencies
// =================
module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedDependencies'
  params: {
    location: enforcedLocation
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    publicIPName: 'dep-${namePrefix}-pip-${serviceShort}'
    natGatewayName: 'dep-${namePrefix}-natGw-${serviceShort}'
  }
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
      'azure-container-instance'
    ]
    selfHostedConfig: {
      githubOrganization: 'githHubOrganization'
      githubRepository: 'dummyRepo'
      personalAccessToken: personalAccessToken
      selfHostedType: 'github'
    }
    networkingConfiguration: {
      networkType: 'useExisting'
      virtualNetworkResourceId: nestedDependencies.outputs.virtualNetworkResourceId
      containerRegistryPrivateDnsZoneResourceId: nestedDependencies.outputs.acrPrivateDNSZoneId
      containerRegistryPrivateEndpointSubnetName: 'acr-subnet'
      natGatewayPublicIpAddressResourceId: nestedDependencies.outputs.publicIPResourceId
      natGatewayResourceId: nestedDependencies.outputs.natGatewayResourceId
      computeNetworking: {
        containerAppDeploymentScriptSubnetName: 'aca-ds-subnet'
        containerAppSubnetName: 'aca-subnet'
        deploymentScriptPrivateDnsZoneResourceId: nestedDependencies.outputs.deploymentScriptPrivateDnsZoneResourceId
        containerInstanceSubnetName: 'aci-subnet'
        computeNetworkType: 'azureContainerApp'
      }
    }
    privateNetworking: true
  }
}
