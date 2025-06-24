@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The resource operational insights workspaces name.')
param name string

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

module logAnalytics 'br/public:avm/res/operational-insights/workspace:0.5.0' = {
  name: '${uniqueString(deployment().name, location)}-loganalytics'
  params: {
    name: name
    location: location
    tags: tags
    dataRetention: 30
    skuName: 'PerGB2018'
  }
}

@description('The resource ID of the loganalytics workspace.')
output logAnalyticsWorkspaceResourceId string = logAnalytics.outputs.resourceId
