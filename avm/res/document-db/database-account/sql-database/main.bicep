metadata name = 'DocumentDB Database Account SQL Databases'
metadata description = 'This module deploys a SQL Database in a CosmosDB Account.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent Database Account. Required if the template is used in a standalone deployment.')
param databaseAccountName string

@description('Required. Name of the SQL database .')
param name string

@description('Optional. Array of containers to deploy in the SQL database.')
param containers array = []

@description('Optional. Request units per second. Will be set to null if autoscaleSettingsMaxThroughput is used.')
param throughput int = 400

@description('Optional. Specifies the Autoscale settings and represents maximum throughput, the resource can scale up to.  The autoscale throughput should have valid throughput values between 1000 and 1000000 inclusive in increments of 1000. If value is set to -1, then the property will be set to null and autoscale will be disabled.')
param autoscaleSettingsMaxThroughput int = -1

@description('Optional. Tags of the SQL database resource.')
param tags object?

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

var enableReferencedModulesTelemetry = false

resource defaultTelemetry 'Microsoft.Resources/deployments@2022-09-01' = if (enableDefaultTelemetry) {
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

resource databaseAccount 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' existing = {
  name: databaseAccountName
}

resource sqlDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2023-04-15' = {
  name: name
  parent: databaseAccount
  tags: tags
  properties: {
    resource: {
      id: name
    }
    options: contains(databaseAccount.properties.capabilities, { name: 'EnableServerless' }) ? null : {
      throughput: autoscaleSettingsMaxThroughput == -1 ? throughput : null
      autoscaleSettings: autoscaleSettingsMaxThroughput != -1 ? {
        maxThroughput: autoscaleSettingsMaxThroughput
      } : null
    }
  }
}

module container 'container/main.bicep' = [for container in containers: {
  name: '${uniqueString(deployment().name, sqlDatabase.name)}-sqldb-${container.name}'
  params: {
    databaseAccountName: databaseAccountName
    sqlDatabaseName: name
    name: container.name
    analyticalStorageTtl: contains(container, 'analyticalStorageTtl') ? container.analyticalStorageTtl : 0
    autoscaleSettingsMaxThroughput: contains(container, 'autoscaleSettingsMaxThroughput') ? container.autoscaleSettingsMaxThroughput : -1
    conflictResolutionPolicy: contains(container, 'conflictResolutionPolicy') ? container.conflictResolutionPolicy : {}
    defaultTtl: contains(container, 'defaultTtl') ? container.defaultTtl : -1
    indexingPolicy: contains(container, 'indexingPolicy') ? container.indexingPolicy : {}
    kind: contains(container, 'kind') ? container.kind : 'Hash'
    paths: contains(container, 'paths') ? container.paths : []
    throughput: contains(container, 'throughput') ? container.throughput : 400
    uniqueKeyPolicyKeys: contains(container, 'uniqueKeyPolicyKeys') ? container.uniqueKeyPolicyKeys : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

@description('The name of the SQL database.')
output name string = sqlDatabase.name

@description('The resource ID of the SQL database.')
output resourceId string = sqlDatabase.id

@description('The name of the resource group the SQL database was created in.')
output resourceGroupName string = resourceGroup().name
