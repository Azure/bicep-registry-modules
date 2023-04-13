@description('Resource type')
param type string

@description('Name of the CosmosDB to who key should be rotated.')
param resourceName string

@description('CosmosDB resource group name')
param resourceRg string

@description('Name of the keyvault')
param keyvaultName string

@description('Name of the keyvault secret to be created')
param secretName string

@description('Validity period in days, default is 90.')
param validityDays int = 90

@description('Expiration date in ISO-8601 format, default to <validityDays> from now.')
param expirationDate string = dateTimeAdd(utcNow(), 'P${validityDays}D')

resource databaseAccount 'Microsoft.DocumentDB/databaseAccounts@2022-08-15' existing = if (type == 'cosmosdb') {
  name: resourceName
  scope: resourceGroup(resourceRg)
}

resource redisAccount 'Microsoft.Cache/redis@2022-06-01' existing = if (type == 'redis') {
  name: resourceName
  scope: resourceGroup(resourceRg)
}

resource vaultSecret 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  name: '${keyvaultName}/${secretName}'
  tags: {
    ValidityPeriodDays: '${validityDays}'
    CredentialId: 'Primary'
    ProviderAddress: type == 'cosmosdb' ? databaseAccount.id : (type == 'redis' ? redisAccount.id : '')
  }
  properties: {
    attributes: {
      enabled: true
      exp: dateTimeToEpoch(expirationDate)
    }
    value: type == 'cosmosdb' ? databaseAccount.listKeys().primaryMasterKey : (type == 'redis' ? redisAccount.listKeys().primaryKey : '')
  }
}
