@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Log Analytics Workspace to create.')
param logAnalyticsWorkspaceName string

@description('Required. The name of the Action Group to create.')
param actionGroupName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.11.1' = {
  params: {
    name: logAnalyticsWorkspaceName
    roleAssignments: [
      {
        principalId: managedIdentity.properties.principalId
        roleDefinitionIdOrName: 'Reader'
        principalType: 'ServicePrincipal'
      }
    ]
  }
}

resource actionGroup 'Microsoft.Insights/actionGroups@2023-01-01' = {
  name: actionGroupName
  location: location
  properties: {
    enabled: true
    groupShortName: 'superShort'
    emailReceivers: [
      {
        emailAddress: 'avm@saysHi.com'
        name: 'notification-email'
        useCommonAlertSchema: true
      }
    ]
  }
}

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Log Analytics Workspace.')
output logAnalyticsWorkspaceResourceId string = logAnalyticsWorkspace.outputs.resourceId

@description('The resource ID of the created Action Group.')
output actionGroupResourceId string = actionGroup.id

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id
