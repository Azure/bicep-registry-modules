targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'NetworkWatcherRG' // Note, this is the default NetworkWatcher resource group. Do not change.

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nnwwaf'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// Note, we set the location of the NetworkWatcherRG to avoid conflicts with the already existing NetworkWatcherRG
#disable-next-line no-hardcoded-location
var enforcedLocation = 'uksouth'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

resource resourceGroupDependencies 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'dep-${namePrefix}-network.networkwatcher-${serviceShort}-rg'
  location: enforcedLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroupDependencies
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedDependencies'
  params: {
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    firstNetworkSecurityGroupName: 'dep-${namePrefix}-nsg-1-${serviceShort}'
    secondNetworkSecurityGroupName: 'dep-${namePrefix}-nsg-2-${serviceShort}'
    virtualMachineName: 'dep-${namePrefix}-vm-${serviceShort}'
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    location: enforcedLocation
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroupDependencies
  name: '${uniqueString(deployment().name, enforcedLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}diasa${serviceShort}01'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}'
    location: enforcedLocation
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: 'NetworkWatcher_${enforcedLocation}'
      location: enforcedLocation
      connectionMonitors: [
        {
          name: '${namePrefix}-${serviceShort}-cm-001'
          endpoints: [
            {
              name: '${namePrefix}-subnet-001(${resourceGroup.name})'
              resourceId: nestedDependencies.outputs.virtualMachineResourceId
              type: 'AzureVM'
            }
            {
              address: 'www.bing.com'
              name: 'Bing'
              type: 'ExternalAddress'
            }
          ]
          testConfigurations: [
            {
              httpConfiguration: {
                method: 'Get'
                port: 80
                preferHTTPS: false
                requestHeaders: []
                validStatusCodeRanges: [
                  '200'
                ]
              }
              name: 'HTTP Bing Test'
              protocol: 'Http'
              successThreshold: {
                checksFailedPercent: 5
                roundTripTimeMs: 100
              }
              testFrequencySec: 30
            }
          ]
          testGroups: [
            {
              destinations: [
                'Bing'
              ]
              disable: false
              name: 'test-http-Bing'
              sources: [
                '${namePrefix}-subnet-001(${resourceGroup.name})'
              ]
              testConfigurations: [
                'HTTP Bing Test'
              ]
            }
          ]
          workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
        }
      ]
      flowLogs: [
        {
          enabled: false
          storageId: diagnosticDependencies.outputs.storageAccountResourceId
          targetResourceId: nestedDependencies.outputs.firstNetworkSecurityGroupResourceId
        }
        {
          formatVersion: 1
          name: '${namePrefix}-${serviceShort}-fl-001'
          retentionInDays: 8
          storageId: diagnosticDependencies.outputs.storageAccountResourceId
          targetResourceId: nestedDependencies.outputs.secondNetworkSecurityGroupResourceId
          trafficAnalyticsInterval: 10
          workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
        }
      ]
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
  }
]
