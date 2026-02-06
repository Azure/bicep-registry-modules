@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Data Collection Rule to create.')
param dataCollectionRuleName string

@description('Required. The name of the Log Analytics Workspace to create.')
param lawName string

// pre-deploy log analytics workspace for DCR to reference
resource law 'Microsoft.OperationalInsights/workspaces@2025-07-01' = {
  name: lawName
  location: location
}

resource dcr 'Microsoft.Insights/dataCollectionRules@2024-03-11' = {
  name: dataCollectionRuleName
  location: location
  kind: 'WorkspaceTransforms'
  properties: {
    dataSources: {}
    destinations: {
      logAnalytics: [
        {
          name: 'laDestination'
          workspaceResourceId: law.id
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          'Microsoft-Table-LAQueryLogs'
        ]
        destinations: [
          'laDestination'
        ]
        transformKql: 'source | where QueryText !contains \'LAQueryLogs\''
      }
      {
        streams: [
          'Microsoft-Table-Event'
        ]
        destinations: [
          'laDestination'
        ]
        transformKql: 'source | project-away ParameterXml'
      }
    ]
  }
}

@description('The resource ID of the created Data Collection Rule.')
output dataCollectionRuleResourceId string = dcr.id
