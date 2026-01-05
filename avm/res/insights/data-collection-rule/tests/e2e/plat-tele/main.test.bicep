targetScope = 'subscription'

metadata name = 'Collecting metrics from Azure resources using Platform Telemetry DCR'
metadata description = 'This instance collects metrics from Azure resources using Platform Telemetry and sends them to a Log Analytics workspace.'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-insights.dataCollectionRules-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'idcrpltele'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// =========== //
// Deployments //
// =========== //

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
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    location: resourceLocation
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
      name: '${namePrefix}${serviceShort}001'
      location: resourceLocation
      dataCollectionRuleProperties: {
        kind: 'PlatformTelemetry'
        description: 'Data Collection Rule to collect monitoring data from your Azure resources'
        dataSources: {
          platformTelemetry: [
            {
              streams: [
                'Microsoft.Compute/virtualMachines:Metrics-Percentage CPU'
                'Microsoft.KeyVault/vaults:Metrics-Group-All'
              ]
              name: 'myPlatformTelemetryDataSource'
            }
          ]
        }
        destinations: {
          logAnalytics: [
            {
              name: nestedDependencies.outputs.logAnalyticsWorkspaceName
              workspaceResourceId: nestedDependencies.outputs.logAnalyticsWorkspaceResourceId
            }
          ]
        }
        dataFlows: [
          {
            streams: [
              'Microsoft.Compute/virtualMachines:Metrics-Percentage CPU'
              'Microsoft.KeyVault/vaults:Metrics-Group-All'
            ]
            destinations: [
              nestedDependencies.outputs.logAnalyticsWorkspaceName
            ]
          }
        ]
      }
    }
  }
]
