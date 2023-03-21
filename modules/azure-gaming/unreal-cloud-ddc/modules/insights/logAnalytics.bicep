@description('Specify the name of the workspace.')
param workspaceName string

@description('Specify the location for the workspace.')
param location string

@description('Create new or use existing workspace')
@allowed([ 'new', 'existing' ])
param newOrExistingWorkspace string = 'new'

@description('The resource group containing an existing logAnalyticsWorkspaceName')
param existingLogAnalyticsWorkspaceResourceGroupName string = ''

@description('Specify the pricing tier: PerGB2018 or legacy tiers (Free, Standalone, PerNode, Standard or Premium) which are not available to all customers.')
@allowed([
  'CapacityReservation'
  'Free'
  'LACluster'
  'PerGB2018'
  'PerNode'
  'Premium'
  'Standalone'
  'Standard'
])
param sku string = 'PerGB2018'

@description('Specify the number of days to retain data.')
param retentionInDays int = 30

@description('Specify true to use resource or workspace permissions, or false to require workspace permissions.')
param resourcePermissions bool = true

var newWorkspace = (newOrExistingWorkspace == 'new')

resource workspace 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' = if (newWorkspace) {
  name: workspaceName
  location: location
  properties: {
    sku: {
      name: sku
    }
    retentionInDays: retentionInDays
    features: {
      enableLogAccessUsingOnlyResourcePermissions: resourcePermissions
    }
  }
}

resource existingWorkspace 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' existing = if (!newWorkspace) {
  name: workspaceName
  scope: resourceGroup(existingLogAnalyticsWorkspaceResourceGroupName)
}

output workspaceId string = newWorkspace ? workspace.id : existingWorkspace.id

