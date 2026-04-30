targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with a large parameter set.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.virtual-wan-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nvwanmax'

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

// ============== //
// Test Execution //
// ============== //

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    azureFirewallPolicyName: 'dep-${namePrefix}-fwp-${serviceShort}'
    virtualNetwork1Name: 'dep-${namePrefix}-vnet1-${serviceShort}'
    virtualNetwork1Location: resourceLocation
    virtualNetwork2Name: 'dep-${namePrefix}-vnet2-${serviceShort}'
    virtualNetwork2Location: resourceLocation
    expressRouteCircuitName: 'dep-${namePrefix}-erc-${serviceShort}'
    expressRoutePortName: 'dep-${namePrefix}-erp-${serviceShort}'
    storageAccountName: 'dep${namePrefix}sa${serviceShort}'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}'
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
        allowBranchToBranchTraffic: true
        type: 'Standard'
        p2sVpnParameters: {
          createP2sVpnServerConfiguration: true
          p2sVpnServerConfigurationName: 'dep-${namePrefix}-p2s-${serviceShort}'
          vpnAuthenticationTypes: ['AAD']
          aadTenant: '${environment().authentication.loginEndpoint}${tenant().tenantId}'
          aadAudience: '41b23e61-6c1e-4545-b367-cd054e0ed4b4'
          aadIssuer: 'https://sts.windows.net/${tenant().tenantId}/'
          vpnProtocols: [
            'OpenVPN'
          ]
        }
        tags: {
          Environment: 'Test'
          CostCenter: 'IT'
        }
      }
      virtualHubParameters: [
        {
          hubAddressPrefix: '10.0.0.0/24'
          hubLocation: resourceLocation
          hubName: 'dep-${namePrefix}-hub-${resourceLocation}-${serviceShort}'
          allowBranchToBranchTraffic: true
          hubRoutingPreference: 'ASPath'
          virtualRouterAutoScaleConfiguration: {
            minCount: 2
          }
          hubVirtualNetworkConnections: [
            {
              name: 'dep-${namePrefix}-vnetconn1-${serviceShort}'
              remoteVirtualNetworkResourceId: nestedDependencies.outputs.virtualNetwork1Id
              enableInternetSecurity: true
            }
            {
              name: 'dep-${namePrefix}-vnetconn2-${serviceShort}'
              remoteVirtualNetworkResourceId: nestedDependencies.outputs.virtualNetwork2Id
              enableInternetSecurity: true
            }
          ]
          p2sVpnParameters: {
            deployP2SVpnGateway: true
            vpnGatewayName: 'dep-${namePrefix}-p2s-gw-${serviceShort}'
            connectionConfigurationsName: 'default'
            vpnClientAddressPoolAddressPrefixes: ['192.168.1.0/24']
            vpnGatewayScaleUnit: 1
            vpnGatewayAssociatedRouteTable: 'defaultRouteTable'
            customDnsServers: [
              '8.8.8.8'
              '8.8.4.4'
            ]
            enableInternetSecurity: true
            isRoutingPreferenceInternet: true
          }
          s2sVpnParameters: {
            deployS2SVpnGateway: true
            vpnGatewayName: 'dep-${namePrefix}-s2s-gw-${serviceShort}'
            vpnGatewayScaleUnit: 1
            bgpSettings: {
              asn: 65515
            }
            vpnConnections: []
            isRoutingPreferenceInternet: false
          }
          expressRouteParameters: {
            deployExpressRouteGateway: true
            expressRouteGatewayName: 'dep-${namePrefix}-er-gw-${serviceShort}'
            allowNonVirtualWanTraffic: true
            autoScaleConfigurationBoundsMin: 1
            autoScaleConfigurationBoundsMax: 2
            expressRouteConnections: [
              {
                name: 'dep-${namePrefix}-er-conn-${serviceShort}'
                properties: {
                  expressRouteCircuitPeering: {
                    id: '${nestedDependencies.outputs.expressRouteCircuitId}/peerings/AzurePrivatePeering'
                  }
                  routingWeight: 10
                  enableInternetSecurity: false
                }
              }
            ]
          }
          secureHubParameters: {
            deploySecureHub: true
            azureFirewallName: 'dep-${namePrefix}-azfw-${serviceShort}'
            azureFirewallSku: 'Standard'
            azureFirewallPublicIPCount: 1
            availabilityZones: []
            routingIntent: {
              internetToFirewall: true
              privateToFirewall: true
            }
            firewallPolicyResourceId: nestedDependencies.outputs.azureFirewallPolicyId
            diagnosticSettings: [
              {
                name: 'diagnosticSettings'
                storageAccountResourceId: nestedDependencies.outputs.logAnalyticsStorageAccountId
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
            HubType: 'Transit'
          }
        }
      ]
      tags: {
        Environment: 'Test'
        'hidden-title': 'This is visible in the resource name'
        Purpose: 'Maximum functionality test'
      }
    }
  }
]

module testVpnSite 'br/public:avm/res/network/vpn-site:0.4.0' = {
  scope: resourceGroup
  params: {
    name: 'dep-${namePrefix}-vpnSite-${serviceShort}'
    virtualWanResourceId: testDeployment[0].outputs.resourceId
    vpnSiteLinks: [
      {
        name: '${namePrefix}-vSite-${serviceShort}'
        properties: {
          bgpProperties: {
            asn: 65010
            bgpPeeringAddress: '1.1.1.1'
          }
          ipAddress: '1.2.3.4'
          linkProperties: {
            linkProviderName: 'contoso'
            linkSpeedInMbps: 5
          }
        }
      }
      {
        name: 'Link1'
        properties: {
          bgpProperties: {
            asn: 65020
            bgpPeeringAddress: '192.168.1.0'
          }
          ipAddress: '2.2.2.2'
          linkProperties: {
            linkProviderName: 'contoso'
            linkSpeedInMbps: 5
          }
        }
      }
    ]
  }
}
