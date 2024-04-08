targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
// e.g., for a module 'network/private-endpoint' you could use 'dep-dev-network.privateendpoints-${serviceShort}-rg'
param resourceGroupName string = 'dep-${namePrefix}-network.hub-networking-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
// e.g., for a module 'network/private-endpoint' you could use 'npe' as a prefix and then 'waf' as a suffix for the waf-aligned test
param serviceShort string = 'nhnmax'

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

// Diagnostics
// ===========
module diagnosticDependencies '../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}diasa${serviceShort}01'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}'
    location: resourceLocation
  }
}

// ============== //
// Test Execution //
// ============== //

var addressPrefix = '10.0.0.0/16'
var addressPrefix2 = '10.1.0.0/16'

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      // You parameters go here
      location: resourceLocation
      hubVirtualNetworks: {
        hub1: {
          name: 'hub1'
          addressPrefixes: array(addressPrefix)
          azureFirewallSettings: {
            hubIpAddresses: {}
            virtualHub: ''
            additionalPublicIpConfigurations: []
            applicationRuleCollections: []
            azureSkuTier: 'Standard'
            diagnosticSettings: []
            enableTelemetry: true
            firewallPolicyId: ''
            location: 'westus'
            lock: {}
            managementIPAddressObject: {}
            managementIPResourceID: ''
            natRuleCollections: []
            networkRuleCollections: []
            publicIPAddressObject: {
              name: 'hub1PublicIp'
            }
            publicIPResourceID: ''
            roleAssignments: []
            tags: {}
            threatIntelMode: 'Alert'
            zones: []
          }
          bastionHost: {
            disableCopyPaste: true
            enableFileCopy: false
            enableIpConnect: false
            enableShareableLink: false
            scaleUnits: 2
            skuName: 'Standard'
          }
          ddosProtectionPlanResourceId: ''
          dnsServers: ['10.0.1.4', '10.0.1.5']
          diagnosticSettings: [
            {
              eventHubAuthorizationRuleResourceId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
              eventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
              metricCategories: [
                {
                  category: 'AllMetrics'
                }
              ]
              name: 'customSetting'
              storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
              workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
            }
          ]
          enableAzureFirewall: true
          enableBastion: true
          enablePeering: false
          enableTelemetry: true
          flowTimeoutInMinutes: 30
          location: 'westus'
          lock: {
            kind: 'CanNotDelete'
            name: 'hub1Lock'
          }
          peeringSettings: [
            {
              allowForwardedTraffic: true
              allowGatewayTransit: false
              allowVirtualNetworkAccess: true
              useRemoteGateways: false
              remoteVirtualNetworkName: 'hub2'
            }
          ]
          roleAssignments: []
          routes: []
          subnets: [
            {
              name: 'GatewaySubnet'
              addressPrefix: cidrSubnet(addressPrefix, 26, 0)
            }
            {
              name: 'AzureFirewallSubnet'
              addressPrefix: cidrSubnet(addressPrefix, 26, 1)
            }
            {
              name: 'AzureBastionSubnet'
              addressPrefix: cidrSubnet(addressPrefix, 26, 2)
            }
          ]
          tags: {
            'hidden-title': 'This is visible in the resource name'
            Environment: 'Non-Prod'
            Role: 'DeploymentValidation'
          }
          vnetEncryption: false
          vnetEncryptionEnforcement: 'AllowUnencrypted'
        }
        hub2: {
          name: 'hub2'
          addressPrefixes: array(addressPrefix2)
          azureFirewallSettings: {
            hubIpAddresses: {}
            virtualHub: ''
            additionalPublicIpConfigurations: []
            applicationRuleCollections: []
            azureSkuTier: 'Standard'
            diagnosticSettings: []
            enableTelemetry: true
            firewallPolicyId: ''
            location: 'westus2'
            lock: {}
            managementIPAddressObject: {}
            managementIPResourceID: ''
            natRuleCollections: []
            networkRuleCollections: []
            publicIPAddressObject: {
              name: 'hub2PublicIp'
            }
            publicIPResourceID: ''
            roleAssignments: []
            tags: {}
            threatIntelMode: 'Alert'
            zones: [
              '1'
              '2'
              '3'
            ]
          }
          bastionHost: {
            disableCopyPaste: true
            enableFileCopy: false
            enableIpConnect: false
            enableShareableLink: false
            scaleUnits: 2
            skuName: 'Standard'
          }
          ddosProtectionPlanResourceId: ''
          dnsServers: []
          diagnosticSettings: []
          enableAzureFirewall: true
          enableBastion: true
          enablePeering: false
          enableTelemetry: false
          flowTimeoutInMinutes: 10
          location: 'westus2'
          lock: {
            kind: 'CanNotDelete'
            name: 'hub2Lock'
          }
          peeringSettings: [
            {
              allowForwardedTraffic: true
              allowGatewayTransit: false
              allowVirtualNetworkAccess: true
              useRemoteGateways: false
              remoteVirtualNetworkName: 'hub1'
            }
          ]
          roleAssignments: []
          routes: []
          subnets: [
            {
              name: 'GatewaySubnet'
              addressPrefix: cidrSubnet(addressPrefix2, 26, 0)
            }
            {
              name: 'AzureFirewallSubnet'
              addressPrefix: cidrSubnet(addressPrefix2, 26, 1)
            }
            {
              name: 'AzureBastionSubnet'
              addressPrefix: cidrSubnet(addressPrefix2, 26, 2)
            }
          ]
          tags: {
            'hidden-title': 'This is visible in the resource name'
            Environment: 'Non-Prod'
            Role: 'DeploymentValidation'
          }
          vnetEncryption: false
          vnetEncryptionEnforcement: 'AllowUnencrypted'
        }
      }
    }
  }
]
