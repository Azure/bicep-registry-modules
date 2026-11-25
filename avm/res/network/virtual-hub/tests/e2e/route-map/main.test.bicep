targetScope = 'subscription'

metadata name = 'Using Route Maps'
metadata description = 'This instance deploys the module with Route-maps enabled. Route-maps require the virtual hub to have a gateway-based connection (S2S VPN, P2S VPN, or ExpressRoute); a VPN gateway is deployed as a dependency to satisfy this prerequisite.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.virtualHub-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nvhrmap'

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
    virtualWANName: 'dep-${namePrefix}-vw-${serviceShort}'
    virtualHubName: '${namePrefix}-${serviceShort}'
    vpnGatewayName: 'dep-${namePrefix}-vpngw-${serviceShort}'
    location: resourceLocation
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}-${serviceShort}'
      addressPrefix: '10.10.0.0/23'
      virtualWanResourceId: nestedDependencies.outputs.virtualWANResourceId
      routeMaps: [
        {
          name: 'routeMap1'
          associatedInboundConnections: []
          associatedOutboundConnections: []
          rules: [
            {
              name: 'rule1'
              matchCriteria: [
                {
                  matchCondition: 'Contains'
                  routePrefix: [
                    '10.100.0.0/16'
                  ]
                  community: []
                  asPath: []
                }
              ]
              actions: [
                {
                  type: 'Drop'
                  parameters: []
                }
              ]
              nextStepIfMatched: 'Terminate'
            }
          ]
        }
      ]
    }
  }
]
