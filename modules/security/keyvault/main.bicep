@description('Deployment Location')
param location string

@description('Prefix of Azure Key Vault Resource Name')
param prefix string = 'kv'

@description('Name of the Key Vault')
@minLength(3)
@maxLength(24)
param name string = take('${prefix}-${uniqueString(resourceGroup().id)}', 24)

@description('The tenant ID where the Key Vault is deployed')
param tenantId string = subscription().tenantId

@description('Deploy Key Vault into existing Virtual Network. Enabling this setting also requires subnetID')
param enableVNet bool = false

@description('Subnet ID for the Key Vault')
param subnetID string = ''

@description('List of RBAC policies to assign to the Key Vault')
param rbacPolicies array = []

@description('RBAC Role Assignments to apply to each RBAC policy')
param roleAssignments array = [
  '4633458b-17de-408a-b874-0445c86b69e6' // rbacSecretsReaderRole
  'a4417e6f-fecd-4de8-b567-7b0420556985' // rbacCertificateOfficerRole
]

@allowed([ 'new', 'existing' ])
@description('Whether to create a new Key Vault or use an existing one.')
param newOrExisting string = 'new'

@description('Name of Secret to add to Key Vault. Required when provided a secretValue.')
param secretName string = ''

@secure()
@description('Value of Secret to add to Key Vault. The secretName parameter must also be provided when adding a secret.')
param secretValue string = ''

@description('Specifies whether soft delete should be enabled for the Key Vault.')
param enableSoftDelete bool = true

@description('The number of days to retain deleted data in the Key Vault.')
param softDeleteRetentionInDays int = 7

@allowed(['standard', 'premium'])
@description('The SKU name of the Key Vault.')
param skuName string = 'standard'

@allowed(['A', 'B'])
@description('The SKU family of the Key Vault.')
param skuFamily string = 'A'

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

module keyVault 'modules/vaults.bicep' = {
  name: guid(name, 'deploy')
  params: {
    location: location
    name: name
    newOrExisting: newOrExisting
    enableSoftDelete: enableSoftDelete
    softDeleteRetentionInDays: softDeleteRetentionInDays
    skuFamily: skuFamily
    skuName: skuName
    tenantId: tenantId
    subnetID: subnetID
    enableVNet: enableVNet
  }
}

module rbacRoleAssignments 'modules/roleAssignment.bicep' = [for rbacRole in roleAssignments: {
  name: guid(name, rbacRole)
  params: {
    keyVaultName: keyVault.outputs.name
    rbacPolicies: rbacPolicies
    rbacRole: rbacRole
  }
}]

var createSecret = secretValue != ''

module secret 'modules/secrets.bicep' = if (createSecret) {
  name: guid(name, 'secrets')
  params: {
    keyVaultName: keyVault.outputs.name
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
output id string = keyVault.outputs.id

@description('Key Vault Name')
@minLength(3)
@maxLength(24)
output name string = name

@description('Key Vault Seceret Id')
output secretId string = createSecret ? secret.outputs.id : ''

@description('Key Vault Secert Name')
output secretName string = secretName

@description('Secret URI')
output secretUri string = createSecret ? secret.outputs.secretUri : ''

@description('Secret URI with version')
output secretUriWithVersion string = createSecret ? secret.outputs.secretUriWithVersion : ''
