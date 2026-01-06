@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Log Analytics Workspace.')
param lawName string

resource law 'Microsoft.OperationalInsights/workspaces@2025-02-01' = {
  name: lawName
  location: location
}

@description('The name of the created Log Analytics Workspace.')
output logAnalyticsResourceId string = law.id
