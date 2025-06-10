@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the data collection endpoint to create.')
param dataCollectionEndpointName string

@description('Required. The name of the log analytics workspace to create.')
param logAnalyticsWorkspaceName string

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: logAnalyticsWorkspaceName
  location: location

  resource ApacheAccess 'tables@2022-10-01' = {
    name: 'ApacheAccess_CL'
    properties: {
      schema: {
        name: 'ApacheAccess_CL'
        description: 'Apache access logs table to demonstrate the use of the Data Collection Rule example at https://learn.microsoft.com/en-us/azure/azure-monitor/logs/tutorial-logs-ingestion-portal'
        columns: [
          {
            name: 'Application'
            type: 'String'
          }
          {
            name: 'TimeGenerated'
            type: 'DateTime'
          }
          {
            name: 'ClientIP'
            type: 'String'
          }
          {
            name: 'RequestType'
            type: 'String'
          }
          {
            name: 'Resource'
            type: 'String'
          }
          {
            name: 'ResponseCode'
            type: 'Int'
          }
        ]
      }
    }
  }
}

resource dataCollectionEndpoint 'Microsoft.Insights/dataCollectionEndpoints@2023-03-11' = {
  location: location
  name: dataCollectionEndpointName
  properties: {
    networkAcls: {
      publicNetworkAccess: 'Enabled'
    }
  }
}

@description('The resource ID of the created Log Analytics Workspace.')
output logAnalyticsWorkspaceResourceId string = logAnalyticsWorkspace.id

@description('The name of the deployed log analytics workspace.')
output logAnalyticsWorkspaceName string = logAnalyticsWorkspace.name

@description('The resource ID of the created Data Collection Endpoint.')
output dataCollectionEndpointResourceId string = dataCollectionEndpoint.id
