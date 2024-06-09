@description('Required. The name of the Action Group to create.')
param actionGroupName string

@description('Required. The name of the Actvity Log Alert to create.')
param actvityLogAlertName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

resource actionGroup 'Microsoft.Insights/actionGroups@2022-06-01' = {
  name: actionGroupName
  location: 'global'
  properties: {
    groupShortName: substring(replace(actionGroupName, '-', ''), 0, 11)
    enabled: true
  }
}

resource activityLogAlert 'Microsoft.Insights/activityLogAlerts@2020-10-01' = {
  name: actvityLogAlertName
  location: 'global'
  properties: {
    scopes: [
      subscription().id
    ]
    condition: {
      allOf: [
        {
          field: 'category'
          equals: 'Administrative'
        }
        {
          field: 'operationName'
          equals: 'Microsoft.Logic/integrationAccounts/listKeyVaultKeys/action'
        }
      ]
    }
    actions: {
      actionGroups: [
        {
          actionGroupId: actionGroup.id
        }
      ]
    }
  }
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

@description('The resource ID of the created Action Group.')
output actionGroupResourceId string = actionGroup.id

@description('The resource name of the created actvityLogAlert.')
output activityLogAlertResourceName string = activityLogAlert.name

@description('The resource name of the created actvityLogAlert.')
output activityLogAlertResourceId string = activityLogAlert.id

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId
