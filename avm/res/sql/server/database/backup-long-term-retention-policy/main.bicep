metadata name = 'SQL Server Database Long Term Backup Retention Policies'
metadata description = 'This module deploys an Azure SQL Server Database Long-Term Backup Retention Policy.'

@description('Required. The name of the parent SQL Server.')
param serverName string

@description('Required. The name of the parent database.')
param databaseName string

@description('Optional. Monthly retention in ISO 8601 duration format.')
param monthlyRetention string?

@description('Optional. Weekly retention in ISO 8601 duration format.')
param weeklyRetention string?

@description('Optional. Week of year backup to keep for yearly retention.')
param weekOfYear int = 1

@description('Optional. Yearly retention in ISO 8601 duration format.')
param yearlyRetention string?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

resource server 'Microsoft.Sql/servers@2025-01-01' existing = {
  name: serverName

  resource database 'databases@2025-01-01' existing = {
    name: databaseName
  }
}

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.sql-server-dbbckplongtermretpolicy.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

resource backupLongTermRetentionPolicy 'Microsoft.Sql/servers/databases/backupLongTermRetentionPolicies@2025-01-01' = {
  name: 'default'
  parent: server::database
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
