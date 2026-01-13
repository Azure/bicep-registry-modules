targetScope = 'subscription'

metadata name = 'Single secure hub deployment'
metadata description = 'This instance deploys a Virtual WAN with a single Secure Hub itilizing Azure Firewall.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.virtual-wan-${serviceShort}-rg'

@description('Optional. The location for the virtual hub. Enforced region to work around capacity constraints.')
#disable-next-line no-hardcoded-location
var enforcedLocation = 'uksouth'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nvwansechub'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

// ============== //
// Test Execution //
// ============== //

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedDependencies'
  params: {
    azureFirewallPolicyName: 'dep-${namePrefix}-fwp-${serviceShort}'
  }
}

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-${iteration}'
    params: {
      virtualWanParameters: {
        virtualWanName: 'dep-${namePrefix}-vw-${serviceShort}'
        location: enforcedLocation
      }
      virtualHubParameters: [
        {
          hubAddressPrefix: '10.0.0.0/24'
          hubLocation: enforcedLocation
          hubName: 'dep-${namePrefix}-hub-${enforcedLocation}-${serviceShort}'
          p2sVpnParameters: {
            deployP2SVpnGateway: false
            connectionConfigurationsName: 'default'
            vpnGatewayName: 'unused'
            vpnClientAddressPoolAddressPrefixes: []
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
            azureFirewallName: 'dep-${namePrefix}-fw-${enforcedLocation}-${serviceShort}'
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
