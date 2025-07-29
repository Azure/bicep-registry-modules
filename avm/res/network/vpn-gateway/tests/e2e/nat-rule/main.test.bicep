targetScope = 'subscription'

metadata name = 'Using NAT Rules'
metadata description = 'This instance deploys the module using NAT rule.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.vpngateways-${serviceShort}-rg'

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
      }     
      natRules: [
        {
          name: 'testnatrule'
          mode: 'EgressSnat'
          type: 'Static'  
          externalMappings: [
            {
              addressSpace: '10.52.18.0/28'  
            }
          ]
          internalMappings: [
            {
              addressSpace: '10.33.5.64/28' 
            }
          ]
        }
        {
          name: 'ingress-nat-rule'
          mode: 'IngressSnat'
          type: 'Static'
          externalMappings: [
            {
              addressSpace: '192.168.100.0/24' 
            }
          ]
          internalMappings: [
            {
              addressSpace: '10.10.10.0/24' 
            }
          ]
        }
      ]
        // VPN Connections that reference the NAT rules
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
                }              
                egressNatRules: [
                  {
                    id: '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup.name}/providers/Microsoft.Network/vpnGateways/${namePrefix}${serviceShort}001/natRules/testnatrule'
                  }
                ]
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
      
      vpnGatewayScaleUnit: 2
      enableTelemetry: true
    }
  }
]

