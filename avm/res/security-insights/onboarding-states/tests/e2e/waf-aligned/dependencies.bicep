@description('Required. The name of the Log Analytics Workspace.')
param name string

@description('Required. The location to deploy resources to.')
param location string

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2025-02-01' = {
  name: name
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
    features: {
      searchVersion: 1
    }
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

@description('The resource ID of the created Log Analytics Workspace.')
output workspaceResourceId string = logAnalyticsWorkspace.id

@description('The name of the created Log Analytics Workspace.')
output workspaceName string = logAnalyticsWorkspace.name
