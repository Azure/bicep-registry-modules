targetScope = 'subscription'

metadata name = 'Collecting IIS logs'
metadata description = 'This instance deploys the module to setup the collection of IIS logs.'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-insights.dataCollectionRules-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'idcrcusiis'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// =========== //
// Deployments //
// =========== //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    dataCollectionEndpointName: 'dep-${namePrefix}-dce-${serviceShort}'
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
      dataCollectionEndpointId: nestedDependencies.outputs.dataCollectionEndpointResourceId
      description: 'Collecting IIS logs.'
      dataFlows: [
        {
          streams: [
            'Microsoft-W3CIISLog'
          ]
          destinations: [
            nestedDependencies.outputs.logAnalyticsWorkspaceName
          ]
          transformKql: 'source'
          outputStream: 'Microsoft-W3CIISLog'
        }
      ]
      dataSources: {
        iisLogs: [
          {
            name: 'iisLogsDataSource'
            streams: [
              'Microsoft-W3CIISLog'
            ]
            logDirectories: [
              'C:\\inetpub\\logs\\LogFiles\\W3SVC1'
            ]
          }
        ]
      }
      destinations: {
        logAnalytics: [
          {
            workspaceResourceId: nestedDependencies.outputs.logAnalyticsWorkspaceResourceId
            name: nestedDependencies.outputs.logAnalyticsWorkspaceName
          }
        ]
      }
      kind: 'Windows'
      tags: {
        'hidden-title': 'This is visible in the resource name'
        resourceType: 'Data Collection Rules'
        kind: 'Windows'
      }
    }
  }
]
