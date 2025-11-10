targetScope = 'subscription'

metadata name = 'Using Global Reach connections'
metadata description = 'This instance deploys two ExpressRoute circuits with a Global Reach connection between them.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.expressroutecircuits-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nercgr'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    location: resourceLocation
    expressRoutePort1: 'nerp001'
    expressRoutePort2: 'nerp002'
    expressRouteCircuit1: '${namePrefix}${serviceShort}001'
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-circuit2-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}002'
      location: resourceLocation
      bandwidthInGbps: 10
      peeringLocation: 'Amsterdam'
      serviceProviderName: 'Equinix'
      skuTier: 'Premium' // Required for Global Reach
      skuFamily: 'MeteredData'
      globalReachEnabled: true
      expressRoutePortResourceId: nestedDependencies.outputs.port2ResourceId
      peerings: [
        {
          name: 'AzurePrivatePeering'
          properties: {
            peeringType: 'AzurePrivatePeering'
            peerASN: 65001
            primaryPeerAddressPrefix: '10.0.0.0/30'
            secondaryPeerAddressPrefix: '10.0.0.4/30'
            vlanId: 100
            state: 'Enabled'
          }
        }
      ]
      connections: [
        {
          name: 'connection-to-circuit1'
          peeringName: 'AzurePrivatePeering'
          peerExpressRouteCircuitPeeringId: nestedDependencies.outputs.circuit1ResourceId
          addressPrefix: '192.168.8.0/29'
        }
      ]
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
  }
]
