targetScope = 'subscription'

metadata name = 'Using Routing Intent'
metadata description = 'This instance deploys the module the Virtual WAN hub with Routing Intent enabled; requires an existing Virtual Hub, as well the firewall Resource ID.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.virtualHub-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nvhrtint'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    virtualWANName: 'dep-${namePrefix}-vw-${serviceShort}'
    virtualHubName: '${namePrefix}-${serviceShort}'
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    azureFirewallName: 'dep-${namePrefix}-azfw-${serviceShort}'
    location: resourceLocation
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    dependsOn: [nestedDependencies]
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      location: resourceLocation
      name: '${namePrefix}-${serviceShort}'
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
      addressPrefix: '10.10.0.0/23'
      virtualWanId: nestedDependencies.outputs.virtualWANResourceId
      hubRouteTables: []
      hubVirtualNetworkConnections: [
        {
          name: 'connection1'
          remoteVirtualNetworkId: nestedDependencies.outputs.virtualNetworkResourceId
          routingConfiguration: {}
        }
      ]
      hubRoutingPreference: 'ASPath'
      azureFirewallResourceId: nestedDependencies.outputs.azureFirewallResourceId
      internetToFirewall: false
      privateToFirewall: true
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
  }
]
