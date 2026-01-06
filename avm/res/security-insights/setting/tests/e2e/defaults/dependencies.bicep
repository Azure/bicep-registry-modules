@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the managed identity to create.')
param managedIdentityName string

@description('Required. The name of the Workspace to create.')
param name string

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: name
  location: location
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

// Assign Security Administrator role to the managed identity at workspace level
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(logAnalyticsWorkspace.id, managedIdentity.id, 'fb1c8493-542b-48eb-b624-b4c8fea62acd')
  scope: logAnalyticsWorkspace
  properties: {
    principalId: managedIdentity.properties.principalId
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'fb1c8493-542b-48eb-b624-b4c8fea62acd'
    ) // Security Administrator
    principalType: 'ServicePrincipal'
  }
}

// Create Microsoft Sentinel on the Log Analytics Workspace
resource sentinel 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = {
  name: 'SecurityInsights(${name})'
  location: location
  properties: {
    workspaceResourceId: logAnalyticsWorkspace.id
  }
  plan: {
    name: 'SecurityInsights(${name})'
    product: 'OMSGallery/SecurityInsights'
    promotionCode: ''
    publisher: 'Microsoft'
  }
}

// Onboard Sentinel after it has been created
resource onboardingStates 'Microsoft.SecurityInsights/onboardingStates@2022-12-01-preview' = {
  scope: logAnalyticsWorkspace
  name: 'default'
}

@description('The resource ID of the created Log Analytics workspace.')
output workspaceResourceId string = logAnalyticsWorkspace.id

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The principal ID of the created managed identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId
