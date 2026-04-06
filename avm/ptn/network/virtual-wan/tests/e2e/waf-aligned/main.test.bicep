targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the Well-Architected Framework principles.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.virtual-wan-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nvwanwaf'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
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
    azureFirewallPolicyName: 'dep-${namePrefix}-fwp-${serviceShort}'
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    storageAccountName: 'dep${namePrefix}sa${serviceShort}'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}'
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
      virtualWanParameters: {
        virtualWanName: 'dep-${namePrefix}-vw-${serviceShort}'
        allowBranchToBranchTraffic: false
        type: 'Standard'
        lock: {
          kind: 'CanNotDelete'
        }
        tags: {
          ResourceType: 'VirtualWAN'
        }
      }
      virtualHubParameters: [
        {
          hubAddressPrefix: '10.0.0.0/23'
          hubLocation: resourceLocation
          hubName: 'dep-${namePrefix}-hub-${resourceLocation}-${serviceShort}'
          allowBranchToBranchTraffic: false
          hubRoutingPreference: 'ExpressRoute'
          hubVirtualNetworkConnections: [
            {
              name: 'dep-${namePrefix}-vnetconn-${serviceShort}'
              remoteVirtualNetworkResourceId: nestedDependencies.outputs.virtualNetworkId
              enableInternetSecurity: true
            }
          ]
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
            azureFirewallName: 'dep-${namePrefix}-fw-${serviceShort}'
            azureFirewallSku: 'Standard'
            azureFirewallPublicIPCount: 1
            availabilityZones: []
            routingIntent: {
              internetToFirewall: true
              privateToFirewall: true
            }
            threatIntelMode: 'Deny'
            diagnosticSettings: [
              {
                name: 'waf-diag'
                storageAccountResourceId: nestedDependencies.outputs.storageAccountId
                workspaceResourceId: nestedDependencies.outputs.logAnalyticsWorkspaceId
                metricCategories: [
                  {
                    category: 'AllMetrics'
                  }
                ]
              }
            ]
          }
          tags: {
            ResourceType: 'VirtualHub'
          }
        }
      ]
      tags: {
        Environment: 'Production'
        'hidden-title': 'WAF-Aligned Virtual WAN Deployment'
        Purpose: 'Well-Architected Framework demonstration'
        SecurityLevel: 'High'
        Monitoring: 'Required'
      }
    }
  }
]
