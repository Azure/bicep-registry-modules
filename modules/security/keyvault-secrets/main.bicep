@description('Prefix of Azure Key Vault Resource Name')
param prefix string = 'kv'

@description('Name of the Key Vault')
@minLength(3)
@maxLength(24)
param name string = take('${prefix}-${uniqueString(resourceGroup().id)}', 24)

@description('Name of Secret to add to Key Vault. Required when provided a secretValue.')
param secretName string

@secure()
@description('Value of Secret to add to Key Vault. The secretName parameter must also be provided when adding a secret.')
param secretValue string = ''

@description('The name of the storage account to add secrets from.')
param storageAccountName string = ''

@description('The name of the Cosmos DB to add secrets from.')
param cosmosDBName string = ''

@description('Custom Location String for Cassandra DB')
param locationString string = ''

@description('The name of the Cassandra Keyspace to add secrets from.')
param cassandraDBName string = ''

@description('Name of the Event Hub Namespace')
param eventHubNamespaceName string = ''

@description('Name of the Event Hub')
param eventHubName string = ''

@description('Name of the secret for the Event Hub')
param eventHubAuthorizationRulesName string = ''

@description('Name of the Redis Cache')
param redisCacheName string = ''

@description('Name of the Azure PSQL Server')
param azurePsqlServerName string = ''

@description('Name of the Azure MySQL Server')
param azureMySQLServerName string = ''

@description('Name of the Azure SQL Server')
param azureSqlServerName string = ''

@description('Name of the Azure Maps Account')
param azureMapsAccountName string = ''

@description('Name of the Azure OperationalInsights Workspace')
param azureOperationalInsightsWorkspaceName string = ''

@description('Name of the Azure Batch Account')
param azureBatchAccountName string = ''

@description('Name of the Azure ContainerRegistry Account')
param azureContainerRegistryAccountName string = ''

module secret 'modules/secrets.bicep' = {
  name: guid(name, 'secrets')
  params: {
    keyVaultName: name
    secretName: secretName
    secretValue: secretValue
    storageAccountName: storageAccountName
    cosmosDBName: cosmosDBName
    azureBatchAccountName: azureBatchAccountName
    azureContainerRegistryAccountName: azureContainerRegistryAccountName
    azureMapsAccountName: azureMapsAccountName
    azureMySQLServerName: azureMySQLServerName
    azureOperationalInsightsWorkspaceName: azureOperationalInsightsWorkspaceName
    azurePsqlServerName: azurePsqlServerName
    azureSqlServerName: azureSqlServerName
    cassandraDBName: cassandraDBName
    eventHubAuthorizationRulesName: eventHubAuthorizationRulesName
    eventHubName: eventHubName
    eventHubNamespaceName: eventHubNamespaceName
    redisCacheName: redisCacheName
    locationString: locationString
  }
}

@description('Key Vault Id')
output id string = secret.outputs.id

@description('Key Vault Name')
@minLength(3)
@maxLength(24)
output name string = name

@description('Key Vault Seceret Id')
output secretId string = secret.outputs.id

@description('Key Vault Secert Name')
output secretName string = secretName

@description('Secret URI')
output secretUri string = secret.outputs.secretUri

@description('Secret URI with version')
output secretUriWithVersion string = secret.outputs.secretUriWithVersion
