@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Workspace to create.')
param logAnalyticsWorkspaceName string

@description('Required. The name of the managed identity to create.')
param managedIdentityName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: logAnalyticsWorkspaceName
  location: location
}

resource sentinel 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = {
  name: 'SecurityInsights(${logAnalyticsWorkspaceName})'
  location: location
  properties: {
    workspaceResourceId: logAnalyticsWorkspace.id
  }
  plan: {
    name: 'SecurityInsights(${logAnalyticsWorkspaceName})'
    product: 'OMSGallery/SecurityInsights'
    promotionCode: ''
    publisher: 'Microsoft'
  }
}

// Enable Microsoft Sentinel and onboard the workspace
resource workspace_securityInsights 'Microsoft.SecurityInsights/onboardingStates@2023-11-01' = {
  name: 'default'
  scope: logAnalyticsWorkspace
  properties: {}
  dependsOn: [
    sentinel
  ]
}

resource workspace_SecurityInsights_roleAssignment_securityReader 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(logAnalyticsWorkspace.id, managedIdentity.id, 'SecurityReaderRole')
  properties: {
    principalId: managedIdentity.properties.principalId
    roleDefinitionId: '/providers/Microsoft.Authorization/roleDefinitions/39bc4728-0917-49c7-9d2c-d95423bc2eb4' // Security Reader
    principalType: 'ServicePrincipal'
  }
}

resource workspace_SecurityInsights_roleAssignment_securityAdmin 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(logAnalyticsWorkspace.id, managedIdentity.id, 'SecurityAdminRole')
  scope: logAnalyticsWorkspace
  properties: {
    principalId: managedIdentity.properties.principalId
    roleDefinitionId: '/providers/Microsoft.Authorization/roleDefinitions/fb1c8493-542b-48eb-b624-b4c8fea62acd' // Security Administrator
    principalType: 'ServicePrincipal'
  }
}

@description('The resource ID of the created Log Analytics workspace.')
output workspaceResourceId string = logAnalyticsWorkspace.id

@description('The name of the created Log Analytics workspace.')
output workspaceName string = logAnalyticsWorkspace.name

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The principal ID of the created managed identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId
