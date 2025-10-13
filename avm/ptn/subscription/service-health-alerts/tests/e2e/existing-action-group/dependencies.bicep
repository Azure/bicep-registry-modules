@description('Required. The name of the action group to create.')
param actionGroupName string

module actionGroup 'br/public:avm/res/insights/action-group:0.7.0' = {
  params: {
    name: actionGroupName
    groupShortName: take(actionGroupName, 12)
    enabled: true
  }
}

@description('The resource Id of the created action group.')
output actionGroupResourceId string = actionGroup.outputs.resourceId
