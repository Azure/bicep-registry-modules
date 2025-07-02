targetScope = 'subscription'

metadata name = 'Using custom BGP peering addresses'
metadata description = 'This instance deploys the module with custom BGP peering addresses to test both bgpPeeringAddress and bgpPeeringAddresses properties.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.vpngateways-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'vpngbgp'

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
    virtualHubName: 'dep-${namePrefix}-vh-${serviceShort}'
    virtualWANName: 'dep-${namePrefix}-vw-${serviceShort}'
    vpnSiteName: 'dep-${namePrefix}-vs-${serviceShort}'
  }
}

// ============== //
// Test Execution //
// ============== //

// Test 1: Using bgpPeeringAddress (for custom IPs outside APIPA range)
@batchSize(1)
module testDeploymentCustomBgp '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-custom-bgp-${serviceShort}-${iteration}'
    params: {
      location: resourceLocation
      name: '${namePrefix}${serviceShort}custom001'
      virtualHubResourceId: nestedDependencies.outputs.virtualHubResourceId
      bgpSettings: {
        asn: 65515
        peerWeight: 5
        // Using bgpPeeringAddress for custom IP outside APIPA range
        bgpPeeringAddress: '10.1.1.1'
      }
      vpnConnections: [
        {
          enableBgp: true
          name: 'Connection-Custom-BGP-${last(split(nestedDependencies.outputs.vpnSiteResourceId, '/'))}'
          remoteVpnSiteResourceId: nestedDependencies.outputs.vpnSiteResourceId
          enableInternetSecurity: true
          vpnConnectionProtocolType: 'IKEv2'
        }
      ]
      tags: {
        'hidden-title': 'Custom BGP IP Test'
        Environment: 'Test'
        Role: 'BGPValidation'
        TestType: 'CustomBgpPeeringAddress'
      }
    }
  }
]

// Test 2: Using bgpPeeringAddresses (for APIPA ranges)
@batchSize(1) 
module testDeploymentApipaBgp '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-apipa-bgp-${serviceShort}-${iteration}'
    params: {
      location: resourceLocation
      name: '${namePrefix}${serviceShort}apipa001'
      virtualHubResourceId: nestedDependencies.outputs.virtualHubResourceId
      bgpSettings: {
        asn: 65516
        peerWeight: 10
        // Using bgpPeeringAddresses for APIPA range
        bgpPeeringAddresses: [
          {
            customBgpIpAddresses: [
              '169.254.21.1'
              '169.254.22.1'
            ]
          }
        ]
      }
      vpnConnections: [
        {
          enableBgp: true
          name: 'Connection-APIPA-BGP-${last(split(nestedDependencies.outputs.vpnSiteResourceId, '/'))}'
          remoteVpnSiteResourceId: nestedDependencies.outputs.vpnSiteResourceId
          enableInternetSecurity: true
          vpnConnectionProtocolType: 'IKEv2'
        }
      ]
      tags: {
        'hidden-title': 'APIPA BGP Test'
        Environment: 'Test'
        Role: 'BGPValidation'
        TestType: 'ApipaBgpPeeringAddresses'
      }
    }
  }
]
