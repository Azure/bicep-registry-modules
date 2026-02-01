@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the first Express Route Port to create.')
param expressRoutePort1 string

@description('Required. The name of the second Express Route Port to create.')
param expressRoutePort2 string

@description('Required. The name of the first Express Route Circuit to create.')
param expressRouteCircuit1 string

// // Deploy first Express Route Port (for testDeploymentCircuit2)
module testDeploymentPort1 'br/public:avm/res/network/express-route-port:0.3.1' = {
  name: '${uniqueString(deployment().name, location)}-test-port1'
  params: {
    name: expressRoutePort1
    location: location
    bandwidthInGbps: 10
    peeringLocation: 'Equinix-Amsterdam-AM5'
    encapsulation: 'Dot1Q'
    billingType: 'MeteredData'
    tags: {
      'hidden-title': 'Express Route Port for Circuit 1'
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
  }
}

// Deploy second Express Route Port (for later use)
module testDeploymentPort2 'br/public:avm/res/network/express-route-port:0.3.1' = {
  name: '${uniqueString(deployment().name, location)}-test-port2'
  params: {
    name: expressRoutePort2
    location: location
    bandwidthInGbps: 10
    peeringLocation: 'Equinix-London-LD5'
    encapsulation: 'Dot1Q'
    billingType: 'MeteredData'
    tags: {
      'hidden-title': 'Express Route Port for Circuit 2Future Use'
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
  }
}

// Deploy second circuit
module testDeploymentCircuit1 'br/public:avm/res/network/express-route-circuit:0.7.0' = {
  name: '${uniqueString(deployment().name, location)}-test-circuit1'
  params: {
    name: expressRouteCircuit1
    location: location
    bandwidthInGbps: 10
    peeringLocation: 'London'
    serviceProviderName: 'Equinix'
    skuTier: 'Premium'
    skuFamily: 'MeteredData'
    globalReachEnabled: true
    expressRoutePortResourceId: testDeploymentPort1.outputs.resourceId
    authorizationNames: [
      'globalReachAuth1'
    ]
    peerings: [
      {
        name: 'AzurePrivatePeering'
        properties: {
          peeringType: 'AzurePrivatePeering'
          peerASN: 65002
          primaryPeerAddressPrefix: '10.1.0.0/30'
          secondaryPeerAddressPrefix: '10.1.0.4/30'
          vlanId: 100
          state: 'Enabled'
        }
      }
    ]
    tags: {
      'hidden-title': 'This is visible in the resource name'
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
  }
}

@description('The resource ID of the created Express Route Circuit 1.')
output circuit1ResourceId string = testDeploymentCircuit1.outputs.resourceId

@description('The resource ID of the created Express Route Port 2.')
output port2ResourceId string = testDeploymentPort2.outputs.resourceId
