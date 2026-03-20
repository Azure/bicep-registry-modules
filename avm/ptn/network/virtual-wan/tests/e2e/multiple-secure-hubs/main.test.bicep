targetScope = 'subscription'

metadata name = 'Multiple secure hub deployment'
metadata description = 'This instance deploys a Virtual WAN with multiple Secure Hubs utilizing Azure Firewall.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.virtual-wan-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nvwanmultisechub'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. The location for the first virtual hub. Enforced region to work around capacity constraints.')
#disable-next-line no-hardcoded-location
var enforcedLocation1 = 'uksouth'

@description('Optional. The location for the second virtual hub. Enforced region to work around capacity constraints.')
#disable-next-line no-hardcoded-location
var enforcedLocation2 = 'eastus'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: enforcedLocation1
}

// ============== //
// Test Execution //
// ============== //

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation1)}-nestedDependencies'
  params: {
    azureFirewallPolicyName: 'dep-${namePrefix}-fwp-${serviceShort}'
  }
}

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, enforcedLocation1)}-test-${serviceShort}-${iteration}'
    params: {
      virtualWanParameters: {
        virtualWanName: 'dep-${namePrefix}-vw-${serviceShort}'
        location: enforcedLocation1
      }
      virtualHubParameters: [
        {
          hubAddressPrefix: '10.0.0.0/24'
          hubLocation: enforcedLocation1
          hubName: 'dep-${namePrefix}-hub-${enforcedLocation1}-${serviceShort}'
          p2sVpnParameters: {
            deployP2SVpnGateway: false
          }
          s2sVpnParameters: {
            deployS2SVpnGateway: false
          }
          expressRouteParameters: {
            deployExpressRouteGateway: false
          }
          secureHubParameters: {
            deploySecureHub: true
            firewallPolicyResourceId: nestedDependencies.outputs.azureFirewallPolicyId
            azureFirewallName: 'dep-${namePrefix}-fw-${enforcedLocation1}-${serviceShort}'
            azureFirewallSku: 'Standard'
            azureFirewallPublicIPCount: 1
            routingIntent: {
              internetToFirewall: true
              privateToFirewall: true
            }
          }
        }
        {
          hubAddressPrefix: '10.0.1.0/24'
          hubLocation: enforcedLocation2
          hubName: 'dep-${namePrefix}-hub-${enforcedLocation2}-${serviceShort}'
          p2sVpnParameters: {
            deployP2SVpnGateway: false
          }
          s2sVpnParameters: {
            deployS2SVpnGateway: false
          }
          expressRouteParameters: {
            deployExpressRouteGateway: false
          }
          secureHubParameters: {
            deploySecureHub: true
            firewallPolicyResourceId: nestedDependencies.outputs.azureFirewallPolicyId
            azureFirewallName: 'dep-${namePrefix}-fw-${enforcedLocation2}-${serviceShort}'
            azureFirewallSku: 'Standard'
            azureFirewallPublicIPCount: 1
            routingIntent: {
              internetToFirewall: true
              privateToFirewall: true
            }
          }
        }
      ]
    }
  }
]
