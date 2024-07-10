@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('The name of the Log Analytics Workspace.')
param lawName string

resource law 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: '${lawName}-law'
  location: location
}

@description('The name of the created Azure Container Registry.')
output logAnalyticsResourceId string = law.id
