targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.vpngateways-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'vpngmax'

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
    location: resourceLocation
    virtualHubName: 'dep-${namePrefix}-vh-${serviceShort}'
    virtualWANName: 'dep-${namePrefix}-vw-${serviceShort}'
    vpnSiteName: 'dep-${namePrefix}-vs-${serviceShort}'
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
      location: resourceLocation
      name: '${namePrefix}${serviceShort}001'
      virtualHubResourceId: nestedDependencies.outputs.virtualHubResourceId
      bgpSettings: {
        asn: 65515
        peerWeight: 0
      }
      vpnConnections: [
        {
          connectionBandwidth: 100
          enableBgp: false
          name: 'Connection-${last(split(nestedDependencies.outputs.vpnSiteResourceId, '/'))}'
          remoteVpnSiteResourceId: nestedDependencies.outputs.vpnSiteResourceId
          enableInternetSecurity: true
          vpnConnectionProtocolType: 'IKEv2'
          enableRateLimiting: false
          useLocalAzureIpAddress: false
          usePolicyBasedTrafficSelectors: false
          routingWeight: 0
        }
      ]
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
      natRules: [
        {
          externalMappings: [
            {
              addressSpace: '192.168.21.0/24'
            }
          ]
          internalMappings: [
            {
              addressSpace: '10.4.0.0/24'
            }
          ]
          mode: 'EgressSnat'
          name: 'natRule1'
          type: 'Static'
        }
      ]
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
    dependsOn: [
      nestedDependencies
    ]
  }
]
