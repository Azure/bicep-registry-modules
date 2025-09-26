targetScope = 'subscription'

metadata name = 'Multiple hub deployment'
metadata description = 'This instance deploys a Virtual WAN with multiple Virtual Hubs.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.virtual-wan-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nvwanmultihub'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. The location for the first virtual hub. Defaults to the main resource location.')
param virtualHub1Location string = resourceLocation

@description('Optional. The location for the second virtual hub. Defaults to westus2.')
param virtualHub2Location string = 'westus2'


// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: resourceLocation
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
      virtualWanParameters: {
        virtualWanName: 'dep-${namePrefix}-vw-${serviceShort}'
        location: resourceLocation
      }
      virtualHubParameters: [
        {
          hubAddressPrefix: '10.0.0.0/24'
          hubLocation: virtualHub1Location
          hubName: 'dep-${namePrefix}-hub-${virtualHub1Location}-${serviceShort}'
          p2sVpnParameters: {
            deployP2SVpnGateway: false
            connectionConfigurationsName: 'default'
            vpnGatewayName: 'unused'
            vpnClientAddressPoolAddressPrefixes: []
          }
          s2sVpnParameters: {
            deployS2SVpnGateway: false
            vpnGatewayName: 'unused'
          }
          expressRouteParameters: {
            deployExpressRouteGateway: false
            expressRouteGatewayName: 'unused'
          }
          secureHubParameters: {
            deploySecureHub: false
            azureFirewallName: 'unused'
            azureFirewallSku: 'Standard'
            azureFirewallPublicIPCount: 1
          }
        }
        {
          hubAddressPrefix: '10.0.1.0/24'
          hubLocation: virtualHub2Location
          hubName: 'dep-${namePrefix}-hub-${virtualHub2Location}-${serviceShort}'
          p2sVpnParameters: {
            deployP2SVpnGateway: false
            connectionConfigurationsName: 'default'
            vpnGatewayName: 'unused'
            vpnClientAddressPoolAddressPrefixes: []
          }
          s2sVpnParameters: {
            deployS2SVpnGateway: false
            vpnGatewayName: 'unused'
          }
          expressRouteParameters: {
            deployExpressRouteGateway: false
            expressRouteGatewayName: 'unused'
          }
          secureHubParameters: {
            deploySecureHub: false
            azureFirewallName: 'unused'
            azureFirewallSku: 'Standard'
            azureFirewallPublicIPCount: 1
          }
        }
      ]
    }
  }
]
