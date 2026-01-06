@description('Required. The name of the managed identity to create for the server.')
param serverIdentityName string

@description('Required. The name of the managed identity to create for the database.')
param databaseIdentityName string

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Key Vault to create.')
param keyVaultName string

var addressPrefix = '10.0.0.0/16'

resource serverIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: serverIdentityName
  location: location
}

resource databaseIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: databaseIdentityName
  location: location
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-07-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: map(range(0, 2), i => {
      name: 'subnet-${i}'
      properties: {
        addressPrefix: cidrSubnet(addressPrefix, 24, i)
      }
    })
  }
}

resource privateDNSZone 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: 'privatelink${environment().suffixes.sqlServerHostname}'
  location: 'global'

  resource virtualNetworkLinks 'virtualNetworkLinks@2024-06-01' = {
    name: '${virtualNetwork.name}-vnetlink'
    location: 'global'
    properties: {
      virtualNetwork: {
        id: virtualNetwork.id
      }
      registrationEnabled: false
    }
  }
}

resource keyVault 'Microsoft.KeyVault/vaults@2024-11-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenant().tenantId
    enablePurgeProtection: true // Required for encryption to work
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    enabledForDeployment: true
    enableRbacAuthorization: true
    accessPolicies: []
  }

  resource serverKey 'keys@2024-11-01' = {
    name: 'serverKeyEncryptionKey'
    properties: {
      kty: 'RSA'
    }
  }

  resource databaseKey 'keys@2024-11-01' = {
    name: 'databaseKeyEncryptionKey'
    properties: {
      kty: 'RSA'
    }
  }
}

resource serverKeyPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('msi-${keyVault::serverKey.id}-${location}-${serverIdentity.id}-Key-Vault-Crypto-Service-Encryption-User-RoleAssignment')
  scope: keyVault::serverKey
  properties: {
    principalId: serverIdentity.properties.principalId
    // Key Vault Crypto Service Encryption User
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'e147488a-f6f5-4113-8e2d-b22465e65bf6'
    )
    principalType: 'ServicePrincipal'
  }
}

resource databaseKeyPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('msi-${keyVault::databaseKey.id}-${location}-${databaseIdentity.id}-Key-Vault-Crypto-Service-Encryption-User-RoleAssignment')
  scope: keyVault::databaseKey
  properties: {
    principalId: databaseIdentity.properties.principalId
    // Key Vault Crypto Service Encryption User
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'e147488a-f6f5-4113-8e2d-b22465e65bf6'
    )
    principalType: 'ServicePrincipal'
  }
}

@description('The principal ID of the created server managed identity.')
output serverIdentityPrincipalId string = serverIdentity.properties.principalId

@description('The resource ID of the created server managed identity.')
output serverIdentityResourceId string = serverIdentity.id

@description('The resource ID of the created database managed identity.')
output databaseIdentityResourceId string = databaseIdentity.id

@description('The resource ID of the created virtual network subnet for a Private Endpoint.')
output privateEndpointSubnetResourceId string = virtualNetwork.properties.subnets[0].id

@description('The resource ID of the created virtual network subnet for a Service Endpoint.')
output serviceEndpointSubnetResourceId string = virtualNetwork.properties.subnets[1].id

@description('The resource ID of the created Private DNS Zone.')
output privateDNSZoneResourceId string = privateDNSZone.id

@description('The URL of the created server Encryption Key.')
output serverKeyVaultEncryptionKeyUrl string = keyVault::serverKey.properties.keyUriWithVersion

@description('The name of the created server Encryption Key.')
output serverKeyVaultKeyName string = keyVault::serverKey.name

@description('The URL of the created database Encryption Key.')
output databaseKeyVaultEncryptionKeyUrl string = keyVault::databaseKey.properties.keyUriWithVersion

@description('The name of the created database Encryption Key.')
output databaseKeyVaultKeyName string = keyVault::databaseKey.name

@description('The name of the created Key Vault.')
output keyVaultName string = keyVault.name

@description('The resource ID of the created Key Vault.')
output keyVaultResourceId string = keyVault.id
