@description('Required. The name of the Action Group to create.')
param actionGroupName string

resource actionGroup 'Microsoft.Insights/actionGroups@2022-06-01' = {
  name: actionGroupName
  location: 'global'

  properties: {
    enabled: true
    groupShortName: substring(actionGroupName, 0, 11)
  }
}

@description('The resource ID of the created Action Group.')
output actionGroupResourceId string = actionGroup.id
