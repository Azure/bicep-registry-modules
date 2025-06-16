targetScope = 'subscription'

metadata name = 'NAT Rules Issue Test Case'
metadata description = 'This test case reproduces and verifies the fix for the NAT rules reference issue.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.vpngateway-nattest-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment.')
param serviceShort string = 'vpngnat'

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

// Test the NAT rules issue scenario
@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      location: resourceLocation
      name: '${namePrefix}${serviceShort}001'
      virtualHubResourceId: nestedDependencies.outputs.virtualHubResourceId
      
      // BGP Settings
      bgpSettings: {
        asn: 65515
        peerWeight: 0
      }      // NAT Rules - Define these first
      natRules: [
        {
          name: 'testnatrule'
          mode: 'EgressSnat'
          type: 'Static'  // Static NAT requires equal-sized address spaces
          externalMappings: [
            {
              addressSpace: '10.52.18.0/28'  // Changed to /28 to match internal mapping
            }
          ]
          internalMappings: [
            {
              addressSpace: '10.33.5.64/28'  // Both are /28 (16 IPs each)
            }
          ]
        }
        {
          name: 'ingress-nat-rule'
          mode: 'IngressSnat'
          type: 'Static'
          externalMappings: [
            {
              addressSpace: '192.168.100.0/24'  // /24 (256 IPs)
            }
          ]
          internalMappings: [
            {
              addressSpace: '10.10.10.0/24'    // /24 (256 IPs) - equal size
            }
          ]
        }
      ]
        // VPN Connections that reference the NAT rules
      // With the fix, these will deploy after NAT rules are created
      vpnConnections: [
        {
          name: 'test-connection-with-nat'
          enableBgp: false
          enableInternetSecurity: true
          enableRateLimiting: false
          remoteVpnSiteResourceId: nestedDependencies.outputs.vpnSiteResourceId
          useLocalAzureIpAddress: false
          usePolicyBasedTrafficSelectors: false
          vpnConnectionProtocolType: 'IKEv2'
          // Removed deprecated routingWeight property from connection level
          
          // VPN Link Connections with NAT rule references
          vpnLinkConnections: [
            {
              name: 'link-connection-with-egress-nat'
              properties: {
                connectionBandwidth: 100
                enableBgp: false
                enableRateLimiting: false
                routingWeight: 10
                usePolicyBasedTrafficSelectors: false
                vpnConnectionProtocolType: 'IKEv2'
                vpnLinkConnectionMode: 'Default'
                vpnSiteLink: {
                  id: nestedDependencies.outputs.vpnSiteLinkResourceId
                }                // This egress NAT rule reference will now work due to the dependency fix
                egressNatRules: [
                  {
                    id: '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup.name}/providers/Microsoft.Network/vpnGateways/${namePrefix}${serviceShort}001/natRules/testnatrule'
                  }
                ]
                // Also test ingress NAT rule reference  
                ingressNatRules: [
                  {
                    id: '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup.name}/providers/Microsoft.Network/vpnGateways/${namePrefix}${serviceShort}001/natRules/ingress-nat-rule'
                  }
                ]
              }
            }
          ]
        }
      ]
      
      // Additional settings
      vpnGatewayScaleUnit: 2
      enableTelemetry: true
        // Tags for identification
      tags: {
        'test-case': 'nat-rules-issue-fix'
        issue: 'vpng-4509'
        Environment: 'Test'
        Purpose: 'NAT Rules Dependency Fix Validation'
      }
    }
  }
]

// ======= //
// Outputs //
// ======= //

@description('The name of the VPN gateway.')
output vpnGatewayName string = testDeployment[0].outputs.name

@description('The resource ID of the VPN gateway.')
output vpnGatewayResourceId string = testDeployment[0].outputs.resourceId

@description('The NAT rule resource IDs.')
output natRuleResourceIds array = testDeployment[0].outputs.natRuleResourceIds

@description('The VPN connection resource IDs.')
output vpnConnectionResourceIds array = testDeployment[0].outputs.vpnConnectionResourceIds

@description('The resource group name.')
output resourceGroupName string = resourceGroup.name
