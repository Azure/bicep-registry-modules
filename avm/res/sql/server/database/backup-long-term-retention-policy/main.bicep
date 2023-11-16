metadata name = 'SQL Server Database Long Term Backup Retention Policies'
metadata description = 'This module deploys an Azure SQL Server Database Long-Term Backup Retention Policy.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the parent SQL Server.')
param serverName string

@description('Required. The name of the parent database.')
param databaseName string

@description('Optional. Monthly retention in ISO 8601 duration format.')
param weeklyRetention string = ''

@description('Optional. Weekly retention in ISO 8601 duration format.')
param monthlyRetention string = ''

@description('Optional. Week of year backup to keep for yearly retention.')
param weekOfYear int = 1

@description('Optional. Yearly retention in ISO 8601 duration format.')
param yearlyRetention string = ''

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource server 'Microsoft.Sql/servers@2022-05-01-preview' existing = {
  name: serverName
}

resource database 'Microsoft.Sql/servers/databases@2022-05-01-preview' existing = {
  name: databaseName
  parent: server
}

resource backupLongTermRetentionPolicy 'Microsoft.Sql/servers/databases/backupLongTermRetentionPolicies@2022-05-01-preview' = {
  name: 'default'
  parent: database
  properties: {
    monthlyRetention: monthlyRetention
    weeklyRetention: weeklyRetention
    weekOfYear: weekOfYear
    yearlyRetention: yearlyRetention
  }
}

@description('The resource group the long-term policy was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the long-term policy.')
output name string = backupLongTermRetentionPolicy.name

@description('The resource ID of the long-term policy.')
output resourceId string = backupLongTermRetentionPolicy.id
