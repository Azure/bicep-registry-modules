@description('Required. The name of the KeyVault to create.')
param keyVaultName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Dev Center Network Connection to create.')
param devCenterNetworkConnectionName string

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

var addressPrefix = '10.0.0.0/16'

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: managedIdentityName
  location: location
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: cidrSubnet(addressPrefix, 24, 0)
        }
      }
    ]
  }
}

resource devCenterNetworkConnection 'Microsoft.DevCenter/networkConnections@2025-02-01' = {
  name: devCenterNetworkConnectionName
  location: location
  properties: {
    domainJoinType: 'AzureADJoin'
    subnetId: virtualNetwork.properties.subnets[0].id
  }
}

//resource keyVault 'Microsoft.KeyVault/vaults@2024-11-01' = {
//  name: keyVaultName
//  location: location
//  properties: {
//    sku: {
//      family: 'A'
//      name: 'standard'
//    }
//    tenantId: tenant().tenantId
//    enablePurgeProtection: true // Required for encryption to work
//    softDeleteRetentionInDays: 7
//    enabledForTemplateDeployment: true
//    enabledForDiskEncryption: true
//    enabledForDeployment: true
//    enableRbacAuthorization: true
//    accessPolicies: []
//  }
//
//  resource key 'keys@2024-11-01' = {
//    name: 'keyEncryptionKey'
//    properties: {
//      kty: 'RSA'
//    }
//  }
//}
//
//resource keyPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
//  name: guid('msi-${keyVault::key.id}-${location}-${managedIdentity.id}-Key-Reader-RoleAssignment')
//  scope: keyVault::key
//  properties: {
//    principalId: managedIdentity.properties.principalId
//    // Key Vault Crypto User
//    roleDefinitionId: subscriptionResourceId(
//      'Microsoft.Authorization/roleDefinitions',
//      '12338af0-0e69-4776-bea7-57ae8d297424'
//    )
//    principalType: 'ServicePrincipal'
//  }
//}

// @description('The name of the created Key Vault encryption key.')
// output keyVaultKeyName string = keyVault::key.name
//
// @description('The resource ID of the created Key Vault.')
// output keyVaultResourceId string = keyVault.id

resource keyVault 'Microsoft.KeyVault/vaults@2024-11-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenant().tenantId
    softDeleteRetentionInDays: 7
    enableRbacAuthorization: true
  }

  resource secret 'secrets' = {
    name: 'testSecret'
    properties: {
      value: ''
    }
  }
}

resource secretsPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('msi-${keyVault.id}-${location}-${keyVault::secret.id}-KeyVault-Secrets-User-RoleAssignment')
  scope: keyVault
  properties: {
    principalId: managedIdentity.properties.principalId
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '4633458b-17de-408a-b874-0445c86b69e6'
    ) // Key Vault Secrets User
    principalType: 'ServicePrincipal'
  }
}

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The name of the created Dev Center Network Connection.')
output networkConnectionResourceId string = devCenterNetworkConnection.id

@description('The secret URI of the created Key Vault secret.')
output keyVaultSecretUri string = keyVault::secret.properties.secretUriWithVersion
