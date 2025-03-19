targetScope = 'subscription'

metadata name = 'Send data to Azure Monitor Logs with Logs ingestion API'
metadata description = 'This instance deploys the module to setup sending data to Azure Monitor Logs with Logs ingestion API.'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-insights.dataCollectionRules-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'idcrdir'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// =========== //
// Deployments //
// =========== //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
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
      dataCollectionRuleProperties: {
        kind: 'Direct'
        dataCollectionEndpointResourceId: nestedDependencies.outputs.dataCollectionEndpointResourceId
        description: 'Send data to Azure Monitor Logs with Logs ingestion API. Based on the example at https://learn.microsoft.com/en-us/azure/azure-monitor/logs/tutorial-logs-ingestion-portal'
        dataFlows: [
          {
            streams: [
              'Custom-ApacheAccess_CL'
            ]
            destinations: [
              nestedDependencies.outputs.logAnalyticsWorkspaceName
            ]
            transformKql: 'source\n| extend TimeGenerated = todatetime(Time)\n| parse RawData with \nClientIP:string\n\' \' *\n\' \' *\n\' [\' * \'] "\' RequestType:string\n\' \' Resource:string\n\' \' *\n\'" \' ResponseCode:int\n\' \' *\n| project-away Time, RawData\n| where ResponseCode != 200\n'
            outputStream: 'Custom-ApacheAccess_CL'
          }
        ]
        destinations: {
          logAnalytics: [
            {
              workspaceResourceId: nestedDependencies.outputs.logAnalyticsWorkspaceResourceId
              name: nestedDependencies.outputs.logAnalyticsWorkspaceName
            }
          ]
        }
        streamDeclarations: {
          'Custom-ApacheAccess_CL': {
            columns: [
              {
                name: 'RawData'
                type: 'string'
              }
              {
                name: 'Time'
                type: 'datetime'
              }
              {
                name: 'Application'
                type: 'string'
              }
            ]
          }
        }
      }
      tags: {
        'hidden-title': 'This is visible in the resource name'
        resourceType: 'Data Collection Rules'
        kind: 'Direct'
      }
    }
  }
]
