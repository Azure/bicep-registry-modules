@description('Required. The name of the Key Vault to create.')
param keyVaultName string

@description('Required. The name of the Kusto Cluster to create.')
param kustoClusterName string

@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

resource kustoCluster 'Microsoft.Kusto/clusters@2023-08-15' = {
  name: kustoClusterName
  location: location
  sku: {
    name: 'Standard_E2ads_v5'
    tier: 'Standard'
  }
  identity: {
    type: 'SystemAssigned'
  }
}

resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenant().tenantId
    enablePurgeProtection: true // Required for encryption to work
    softDeleteRetentionInDays: 7
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    enabledForDeployment: true
    enableRbacAuthorization: true
    accessPolicies: []
  }

  resource key 'keys@2023-02-01' = {
    name: 'keyEncryptionKey'
    properties: {
      kty: 'RSA'
    }
  }
}

resource keyPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('msi-${keyVault::key.id}-${location}-${kustoCluster.id}-Key-Reader-RoleAssignment')
  scope: keyVault::key
  properties: {
    principalId: kustoCluster.identity.principalId
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '12338af0-0e69-4776-bea7-57ae8d297424'
    ) // Key Vault Crypto User
    principalType: 'ServicePrincipal'
  }
}

@description('The name of the created Kusto Cluster.')
output kustoClusterName string = kustoCluster.name

@description('The resource ID of the created Key Vault.')
output keyVaultResourceId string = keyVault.id

@description('The name of the created encryption key.')
output keyName string = keyVault::key.name
