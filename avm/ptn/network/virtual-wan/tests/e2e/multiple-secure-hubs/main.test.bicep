targetScope = 'subscription'

metadata name = 'Multiple secure hub deployment'
metadata description = 'This instance deploys a Virtual WAN with multiple Secure Hubs utilizing Azure Firewall.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.virtual-wan-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nvwansechub'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: resourceGroupName
  location: resourceLocation
}

// ============== //
// Test Execution //
// ============== //

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    azureFirewallPolicyName: 'dep-${namePrefix}-fwp-${serviceShort}'
  }
}

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
          hubLocation: resourceLocation
          hubName: 'dep-${namePrefix}-hub-${resourceLocation}-${serviceShort}'
          secureHubParameters: {
            deploySecureHub: true
            firewallPolicyResourceId: nestedDependencies.outputs.azureFirewallPolicyId
            azureFirewallName: 'dep-${namePrefix}-fw-${serviceShort}'
            azureFirewallSku: 'Standard'
            azureFirewallPublicIPCount: 1
          }
        }
      ]
    }
  }
]
