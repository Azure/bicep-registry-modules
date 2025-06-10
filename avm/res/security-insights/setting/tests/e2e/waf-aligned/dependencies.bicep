@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Workspace to create.')
param name string

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: name
  location: location
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
