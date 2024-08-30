metadata name = 'Operational Insights Workspaces'
metadata description = 'Creates a Log Analytics workspace.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The resource operational insights workspaces name.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
@metadata({
  example: '''
  {
      "key1": "value1"
      "key2": "value2"
  }
  '''
})
param tags object?

// ============== //
// Resources      //
// ============== //

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' = {
  name: name
  location: location
  tags: tags
  properties: any({
    retentionInDays: 30
    features: {
      searchVersion: 1
    }
    sku: {
      name: 'PerGB2018'
    }
  })
}

// ============ //
// Outputs      //
// ============ //

@description('The resource group the operational insights workspace was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the loganalytics workspace.')
output id string = logAnalytics.id

@description('The name of the loganalytics workspace.')
output name string = logAnalytics.name
