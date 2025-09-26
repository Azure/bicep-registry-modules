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
        allowBranchToBranchTraffic: false // Security: Minimize lateral movement
        type: 'Standard' // Performance: Use Standard for production workloads
        lock: {
          kind: 'CanNotDelete' // Reliability: Prevent accidental deletion
        }
        tags: {
          Environment: 'Production'
          CostCenter: 'NetworkOps'
          Owner: 'NetworkTeam'
          Purpose: 'WAF-Aligned-Deployment'
        }
      }
      virtualHubParameters: [
        {
          hubAddressPrefix: '10.0.0.0/23' // Operational Excellence: Larger address space for growth
          hubLocation: resourceLocation
          hubName: 'dep-${namePrefix}-hub-${resourceLocation}-${serviceShort}'
          allowBranchToBranchTraffic: false // Security: Consistent with WAN setting
          hubRoutingPreference: 'ExpressRoute' // Performance: Prefer ExpressRoute over VPN
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
          tags: {
            HubType: 'Production'
            Monitoring: 'Enabled'
          }
        }
      ]
      lock: {
        kind: 'CanNotDelete' // Reliability: Prevent accidental deletion
      }
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
