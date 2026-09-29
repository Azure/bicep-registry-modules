@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Log Analytics workspace to create.')
param logAnalyticsWorkspaceName string

@description('Required. The name of the User-Assigned Managed Identity to create (used to exercise the BYO-UAMI code path).')
param managedIdentityName string

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2025-02-01' = {
  name: logAnalyticsWorkspaceName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: managedIdentityName
  location: location
}

@description('The resource ID of the Log Analytics workspace.')
output logAnalyticsWorkspaceResourceId string = logAnalyticsWorkspace.id

@description('The resource ID of the User-Assigned Managed Identity (used to exercise the BYO-UAMI parameter).')
output managedIdentityResourceId string = managedIdentity.id
