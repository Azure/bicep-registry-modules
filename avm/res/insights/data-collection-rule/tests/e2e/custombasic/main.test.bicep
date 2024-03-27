targetScope = 'subscription'

metadata name = 'Collecting custom text logs'
metadata description = 'This instance deploys the module to setup collection of custom logs.'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-insights.dataCollectionRules-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'idcrcusbas'

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
      description: 'Collecting custom text logs without ingestion-time transformation.'
      dataFlows: [
        {
          streams: [
            'Custom-CustomTableBasic_CL'
          ]
          destinations: [
            nestedDependencies.outputs.logAnalyticsWorkspaceName
          ]
          transformKql: 'source'
          outputStream: 'Custom-CustomTableBasic_CL'
        }
      ]
      dataSources: {
        logFiles: [
          {
            name: 'CustomTableBasic_CL'
            samplingFrequencyInSeconds: 60
            streams: [
              'Custom-CustomTableBasic_CL'
            ]
            filePatterns: [
              'C:\\TestLogsBasic\\TestLog*.log'
            ]
            format: 'text'
            settings: {
              text: {
                recordStartTimestampFormat: 'ISO 8601'
              }
            }
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
      streamDeclarations: {
        'Custom-CustomTableBasic_CL': {
          columns: [
            {
              name: 'TimeGenerated'
              type: 'datetime'
            }
            {
              name: 'RawData'
              type: 'string'
            }
          ]
        }
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
