metadata name = 'Azure Cosmos DB account tables'
metadata description = 'This module deploys a table within an Azure Cosmos DB Account.'

@description('Required. Name of the table.')
param name string

@description('Optional. Tags for the table.')
param tags resourceInput<'Microsoft.DocumentDB/databaseAccounts/tables@2025-04-15'>.tags?

@description('Conditional. The name of the parent Azure Cosmos DB account. Required if the template is used in a standalone deployment.')
param databaseAccountName string

@description('Optional. Represents maximum throughput, the resource can scale up to. Cannot be set together with `throughput`. If `throughput` is set to something else than -1, this autoscale setting is ignored.')
param maxThroughput int = 4000

@description('Optional. Request Units per second (for example 10000). Cannot be set together with `maxThroughput`.')
param throughput int?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

resource databaseAccount 'Microsoft.DocumentDB/databaseAccounts@2025-04-15' existing = {
  name: databaseAccountName
}

resource table 'Microsoft.DocumentDB/databaseAccounts/tables@2025-04-15' = {
  name: name
  tags: tags
  parent: databaseAccount
  properties: {
    options: contains(databaseAccount.properties.capabilities, { name: 'EnableServerless' })
      ? {}
      : {
          autoscaleSettings: throughput == null
            ? {
                maxThroughput: maxThroughput
              }
            : null
          throughput: throughput
        }
    resource: {
      id: name
    }
  }
}

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '	46d3xbcp.res.documentdb-databaseaccounttable.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

@description('The name of the table.')
output name string = table.name

@description('The resource ID of the table.')
output resourceId string = table.id

@description('The name of the resource group the table was created in.')
output resourceGroupName string = resourceGroup().name
