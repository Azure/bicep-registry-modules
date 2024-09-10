@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The AI Studio Hub Resource name.')
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

module hub 'br/public:avm/res/machine-learning-services/workspace:0.7.0' = {
  name: 'workspaceDeployment'
  params: {
    name: name
    tags: tags
    location: location
    sku: 'Basic'
    kind: 'Hub'
  }
}

@description('The resource ID of the ai studio hub resource.')
output name string = hub.outputs.name
