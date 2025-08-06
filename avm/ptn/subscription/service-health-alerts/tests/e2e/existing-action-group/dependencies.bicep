targetScope = 'subscription'

@description('Required. The name of the Resource Group.')
param resourceGroupName string

@description('Required. The location where all resources will be deployed.')
param location string = deployment().location

@description('Required. The name of the action group to create.')
param actionGroupName string

resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: location
}

module actionGroup 'br/public:avm/res/insights/action-group:0.7.0' = {
  scope: rg
  params: {
    name: actionGroupName
    groupShortName: take(actionGroupName, 12)
    enabled: true
  }
}

output resourceGroupName string = rg.name
output actionGroupName string = actionGroup.outputs.name
output actionGroupResourceId string = actionGroup.outputs.resourceId
