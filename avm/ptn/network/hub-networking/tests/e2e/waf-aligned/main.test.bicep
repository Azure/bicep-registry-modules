targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.hub-networking-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nhnwaf'

@description('Optional. A token to inject into the name of each resource.')
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
          addressPrefixes: array(addressPrefix)
          azureFirewallSettings: {
            azureSkuTier: 'Standard'
            enableTelemetry: true
            location: resourceLocation
            publicIPAddressObject: {
              name: 'hub1PublicIp'
            }
            threatIntelMode: 'Alert'
            zones: [
              1
              2
              3
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
          enableAzureFirewall: true
          enableBastion: true
          enablePeering: false
          enableTelemetry: true
          flowTimeoutInMinutes: 30
          dnsServers: ['10.0.1.6', '10.0.1.7']
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
          location: resourceLocation
          lock: {
            kind: 'CanNotDelete'
            name: 'hub1Lock'
          }
          routes: [
            {
              name: 'defaultRoute'
              properties: {
                addressPrefix: '0.0.0.0/0'
                nextHopType: 'Internet'
              }
            }
          ]
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
      }
    }
  }
]
