@description('Specifies the name of the key vault.')
param keyVaultName string

@description('Specifies the name of the secret.')
param secretName string

@secure()
param secretValue string = ''

resource vault 'Microsoft.KeyVault/vaults@2022-11-01' existing = {
  name: keyVaultName
}

/***********************************************************************************************************************
                                            Add provided secret to the key vault.
***********************************************************************************************************************/

var hasSecret = secretValue != ''

resource secret 'Microsoft.KeyVault/vaults/secrets@2022-11-01' = if (hasSecret)  {
  parent: vault
  name: secretName
  properties: {
    value: secretValue
  }
}

@description('Secret Name')
output name string = secretName

@description('Key Vault Id')
output id string = hasSecret ? secret.id : ''

@description('Secret URI')
output secretUri string = hasSecret ? secret.properties.secretUri : ''

@description('Secret URI with version')
output secretUriWithVersion string = hasSecret ? secret.properties.secretUriWithVersion : ''

/***********************************************************************************************************************
                                            Add Azure Storage Account key to the key vault.
***********************************************************************************************************************/
param storageAccountName string = ''

resource existingStorageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' existing = if (storageAccountName != '') {
  name: storageAccountName
}

var storageSecretValue = secretValue == '' ? existingStorageAccount.listKeys().keys[0].value : secretValue

resource storageSecret 'Microsoft.KeyVault/vaults/secrets@2022-11-01' = if (storageAccountName != '') {
  parent: vault
  name: secretName
  properties: {
    value: storageSecretValue
  }
}

@description('Storage Secret URI')
output storageSecretUri string = storageAccountName != '' ? storageSecret.properties.secretUri : ''

@description('Storage Secret URI with version')
output storageSecretUriWithVersion string = storageAccountName != '' ? storageSecret.properties.secretUriWithVersion : ''

/***********************************************************************************************************************
                                            Add Cosmos DB key to the key vault.
***********************************************************************************************************************/
param cosmosDBName string = ''

resource existingCosmosDB 'Microsoft.Storage/storageAccounts@2022-09-01' existing = if (cosmosDBName != '') {
  name: cosmosDBName
}

resource cosmosSecret 'Microsoft.KeyVault/vaults/secrets@2022-11-01' = if (cosmosDBName != '') {
  parent: vault
  name: secretName
  properties: {
    value: existingCosmosDB.listKeys().keys[0].value
  }
}

@description('Cosmos Secret URI')
output cosmosSecretUri string = cosmosDBName != '' ? cosmosSecret.properties.secretUri : ''

@description('Cosmos Secret URI with version')
output cosmosSecretUriWithVersion string = cosmosDBName != '' ? cosmosSecret.properties.secretUriWithVersion : ''

/***********************************************************************************************************************
                                            Add CassandrDB key to the key vault.
***********************************************************************************************************************/
@description('Name of the CassandrDB')
param cassandraDBName string = ''

@description('Custom Location String for CassandrDB')
param locationString string = ''

resource cassandraDB 'Microsoft.DocumentDB/databaseAccounts@2022-05-15' existing = if (cassandraDBName == '') {
  name: cassandraDBName
}

var cassandraSecretValue = secretValue == '' ? 'Contact Points=${cassandraDB.name}.cassandra.cosmos.azure.com,${locationString};Username=${cassandraDB.name};Password=${cassandraDB.listKeys().primaryMasterKey};Port=10350' : secretValue

resource cassandraSecret 'Microsoft.KeyVault/vaults/secrets@2022-11-01' = if (cassandraDBName != '') {
  parent: vault
  name: secretName
  properties: {
    value: cassandraSecretValue
  }
}

@description('CassandrSecret URI')
output cassandraSecretUri string = cassandraDBName != '' ? cassandraSecret.properties.secretUri : ''

@description('CassandrSecret URI with version')
output cassandraSecretUriWithVersion string = cassandraDBName != '' ? cassandraSecret.properties.secretUriWithVersion : ''

/***********************************************************************************************************************
                                            Add Azure Event Hub key to the key vault.
***********************************************************************************************************************/

@description('Name of the Event Hub Namespace')
param eventHubNamespaceName string = ''
@description('Name of the Event Hub')
param eventHubName string = ''
@description('Name of the secret for the Event Hub')
param eventHubAuthorizationRulesName string = ''

resource eventHubNamespace 'Microsoft.EventHub/namespaces@2022-01-01-preview' existing = if (eventHubNamespaceName != '') {
  name: eventHubNamespaceName

  resource eventHubs 'eventhubs' existing = {
    name: eventHubName

    resource eventHubAuthorizationRules 'authorizationRules' existing = {
      name: eventHubAuthorizationRulesName
    }
  }
}

var eventHubSecretValue = secretValue == '' ? eventHubNamespace::eventHubs::eventHubAuthorizationRules.listKeys().primaryConnectionString : secretValue

resource eventHubSecret 'Microsoft.KeyVault/vaults/secrets@2022-11-01' = if (eventHubNamespaceName != '') {
  parent: vault
  name: secretName
  properties: {
    value: eventHubSecretValue
  }
}

@description('Event Hub Secret URI')
output eventHubSecretUri string = eventHubNamespaceName != '' ? eventHubSecret.properties.secretUri : ''

@description('Event Hub Secret URI with version')
output eventHubSecretUriWithVersion string = eventHubNamespaceName != '' ? eventHubSecret.properties.secretUriWithVersion : ''


/***********************************************************************************************************************
                                            Add Azure Redis Cache key to the key vault.
***********************************************************************************************************************/

@description('Name of the Redis Cache')
param redisCacheName string = ''

resource redisCache 'Microsoft.Cache/redis@2022-06-01' existing = if (redisCacheName != '') {
  name: redisCacheName
}

var redisSecretValue = secretValue == '' ? redisCache.listKeys().primaryKey : secretValue

resource redisSecret 'Microsoft.KeyVault/vaults/secrets@2022-11-01' = if (redisCacheName != '') {
  parent: vault
  name: secretName
  properties: {
    value: redisSecretValue
  }
}

@description('Redis Secret URI')
output redisSecretUri string = redisCacheName != '' ? redisSecret.properties.secretUri : ''

@description('Redis Secret URI with version')
output redisSecretUriWithVersion string = redisCacheName != '' ? redisSecret.properties.secretUriWithVersion : ''

/***********************************************************************************************************************
                                            Add Azure PSQL key to the key vault.
***********************************************************************************************************************/

@description('Name of the Azure PSQL Server')
param azurePsqlServerName string = ''

resource azurePsqlServer 'Microsoft.DBforPostgreSQL/flexibleServers@2022-12-01' existing = if (azurePsqlServerName != '') {
  name: azurePsqlServerName
}

var azurePsqlSecretValue = secretValue == '' ? azurePsqlServer.listKeys().primaryMasterKey : secretValue

resource azurePsqlSecret 'Microsoft.KeyVault/vaults/secrets@2022-11-01' = if (azurePsqlServerName != '') {
  parent: vault
  name: secretName
  properties: {
    value: azurePsqlSecretValue
  }
}

@description('Azure PSQL Secret URI')
output azurePsqlSecretUri string = azurePsqlServerName != '' ? azurePsqlSecret.properties.secretUri : ''

@description('Azure PSQL Secret URI with version')
output azurePsqlSecretUriWithVersion string = azurePsqlServerName != '' ? azurePsqlSecret.properties.secretUriWithVersion : ''

/***********************************************************************************************************************
                                            Add Azure MySQL key to the key vault.
***********************************************************************************************************************/

@description('Name of the Azure MySQL Server')
param azureMySQLServerName string = ''

resource azureMySQLServer 'Microsoft.DBforMySQL/flexibleServers@2021-05-01' existing = if (azureMySQLServerName != '') {
  name: azureMySQLServerName
}

var azureMySQLSecretValue = secretValue == '' ? azureMySQLServer.listKeys().primaryMasterKey : secretValue

resource azureMySQLSecret 'Microsoft.KeyVault/vaults/secrets@2022-11-01' = if (azureMySQLServerName != '') {
  parent: vault
  name: secretName
  properties: {
    value: azureMySQLSecretValue
  }
}

@description('Azure MySQL Secret URI')
output azureMySQLSecretUri string = azureMySQLServerName != '' ? azureMySQLSecret.properties.secretUri : ''

@description('Azure MySQL Secret URI with version')
output azureMySQLSecretUriWithVersion string = azureMySQLServerName != '' ? azureMySQLSecret.properties.secretUriWithVersion : ''

/***********************************************************************************************************************
                                            Add Azure SQL key to the key vault.
***********************************************************************************************************************/

@description('Name of the Azure SQL Server')
param azureSqlServerName string = ''

resource azureSqlServer 'Microsoft.Sql/servers@2021-11-01' existing = if (azureSqlServerName != '') {
  name: azureSqlServerName
}

var azureSqlSecretValue = secretValue == '' ? azureSqlServer.listKeys().primaryMasterKey : secretValue

resource azureSqlSecret 'Microsoft.KeyVault/vaults/secrets@2022-11-01' = if (azureSqlServerName != '') {
  parent: vault
  name: secretName
  properties: {
    value: azureSqlSecretValue
  }
}

@description('Azure SQL Secret URI')
output azureSqlSecretUri string = azureSqlServerName != '' ? azureSqlSecret.properties.secretUri : ''

@description('Azure SQL Secret URI with version')
output azureSqlSecretUriWithVersion string = azureSqlServerName != '' ? azureSqlSecret.properties.secretUriWithVersion : ''

/***********************************************************************************************************************
                                            Add Azure Maps key to the key vault.
***********************************************************************************************************************/

@description('Name of the Azure Maps Account')
param azureMapsAccountName string = ''

resource azureMapsAccount 'Microsoft.Maps/accounts@2021-02-01' existing = if (azureMapsAccountName != '') {
  name: azureMapsAccountName
}

var azureMapsSecretValue = secretValue == '' ? azureMapsAccount.listKeys().primaryKey : secretValue

resource azureMapsSecret 'Microsoft.KeyVault/vaults/secrets@2022-11-01' = if (azureMapsAccountName != '') {
  parent: vault
  name: secretName
  properties: {
    value: azureMapsSecretValue
  }
}

@description('Azure Maps Secret URI')
output azureMapsSecretUri string = azureMapsAccountName != '' ? azureMapsSecret.properties.secretUri : ''

@description('Azure Maps Secret URI with version')
output azureMapsSecretUriWithVersion string = azureMapsAccountName != '' ? azureMapsSecret.properties.secretUriWithVersion : ''

/***********************************************************************************************************************
                                            Add Azure Operational Insights key to the key vault.
***********************************************************************************************************************/

@description('Name of the Azure OperationalInsights Workspace')
param azureOperationalInsightsWorkspaceName string = ''

resource azureOperationalInsightsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = if (azureOperationalInsightsWorkspaceName != '') {
  name: azureOperationalInsightsWorkspaceName
}

var azureOperationalInsightsSecretValue = secretValue == '' ? azureOperationalInsightsWorkspace.listKeys().primarySharedKey : secretValue

resource azureOperationalInsightsSecret 'Microsoft.KeyVault/vaults/secrets@2022-11-01' = if (azureOperationalInsightsWorkspaceName != '') {
  parent: vault
  name: secretName
  properties: {
    value: azureOperationalInsightsSecretValue
  }
}

@description('Azure OperationalInsights Secret URI')
output azureOperationalInsightsSecretUri string = azureOperationalInsightsWorkspaceName != '' ? azureOperationalInsightsSecret.properties.secretUri : ''

@description('Azure OperationalInsights Secret URI with version')
output azureOperationalInsightsSecretUriWithVersion string = azureOperationalInsightsWorkspaceName != '' ? azureOperationalInsightsSecret.properties.secretUriWithVersion : ''

/***********************************************************************************************************************
                                            Add Azure Batch key to the key vault.
***********************************************************************************************************************/

@description('Name of the Azure Batch Account')
param azureBatchAccountName string = ''

resource azureBatchAccount 'Microsoft.Batch/batchAccounts@2021-06-01' existing = if (azureBatchAccountName != '') {
  name: azureBatchAccountName
}

var azureBatchSecretValue = secretValue == '' ? azureBatchAccount.listKeys().primary : secretValue

resource azureBatchSecret 'Microsoft.KeyVault/vaults/secrets@2022-11-01' = if (azureBatchAccountName != '') {
  parent: vault
  name: secretName
  properties: {
    value: azureBatchSecretValue
  }
}

@description('Azure Batch Secret URI')
output azureBatchSecretUri string = azureBatchAccountName != '' ? azureBatchSecret.properties.secretUri : ''

@description('Azure Batch Secret URI with version')
output azureBatchSecretUriWithVersion string = azureBatchAccountName != '' ? azureBatchSecret.properties.secretUriWithVersion : ''

/***********************************************************************************************************************
                                            Add Azure ContainerRegistry key to the key vault.
***********************************************************************************************************************/

@description('Name of the Azure ContainerRegistry Account')
param azureContainerRegistryAccountName string = ''

resource azureContainerRegistryAccount 'Microsoft.ContainerRegistry/registries@2022-12-01' existing = if (azureContainerRegistryAccountName != '') {
  name: azureContainerRegistryAccountName
}

var azureContainerRegistrySecretValue = secretValue == '' ? azureContainerRegistryAccount.listKeys().key1 : secretValue

resource azureContainerRegistry 'Microsoft.KeyVault/vaults/secrets@2022-11-01' = if (azureContainerRegistryAccountName != '') {
  parent: vault
  name: secretName
  properties: {
    value: azureContainerRegistrySecretValue
  }
}

@description('Azure ContainerRegistry Secret URI')
output azureContainerRegistrySecretUri string = azureContainerRegistryAccountName != '' ? azureContainerRegistry.properties.secretUri : ''

@description('Azure ContainerRegistry Secret URI with version')
output azureContainerRegistrySecretUriWithVersion string = azureContainerRegistryAccountName != '' ? azureContainerRegistry.properties.secretUriWithVersion : ''
