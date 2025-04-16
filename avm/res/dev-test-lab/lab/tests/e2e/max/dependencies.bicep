@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Disk Encryption Set to create.')
param diskEncryptionSetName string

@description('Required. The name of the Key Vault to create.')
param keyVaultName string

@description('Required. The name of the Storage Account to create.')
param storageAccountName string

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

var addressPrefix = '10.0.0.0/16'

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
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

  resource key 'keys@2022-07-01' = {
    name: 'encryptionKey'
    properties: {
      kty: 'RSA'
    }
  }
}

resource diskEncryptionSet 'Microsoft.Compute/diskEncryptionSets@2021-04-01' = {
  name: diskEncryptionSetName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    activeKey: {
      sourceVault: {
        id: keyVault.id
      }
      keyUrl: keyVault::key.properties.keyUriWithVersion
    }
    encryptionType: 'EncryptionAtRestWithCustomerKey'
  }
}

resource keyPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('msi-${keyVault.id}-${location}-${diskEncryptionSet.id}-KeyVault-Key-Read-RoleAssignment')
  scope: keyVault
  properties: {
    principalId: diskEncryptionSet.identity.principalId
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'e147488a-f6f5-4113-8e2d-b22465e65bf6'
    ) // Key Vault Crypto Service Encryption User
    principalType: 'ServicePrincipal'
  }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    allowBlobPublicAccess: false
    publicNetworkAccess: 'Disabled'
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-04-01' = {
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
        name: 'subnet01'
        properties: {
          addressPrefix: cidrSubnet(addressPrefix, 24, 0)
        }
      }
      {
        name: 'subnet02'
        properties: {
          addressPrefix: cidrSubnet(addressPrefix, 24, 1)
        }
      }
    ]
  }
}

@description('The name of the created Virtual Network.')
output virtualNetworkName string = virtualNetwork.name

@description('The resource ID of the created Virtual Network.')
output virtualNetworkResourceId string = virtualNetwork.id

@description('The name of the created Virtual Network Subnet 1.')
output subnet1Name string = virtualNetwork.properties.subnets[0].name

@description('The resource ID of the created Virtual Network Subnet 1.')
output subnet1ResourceId string = virtualNetwork.properties.subnets[0].id

@description('The name of the created Virtual Network Subnet 2.')
output subnet2Name string = virtualNetwork.properties.subnets[1].name

@description('The resource ID of the created Virtual Network Subnet 2.')
output subnet2ResourceId string = virtualNetwork.properties.subnets[1].id

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The resource ID of the created Disk Encryption Set.')
output diskEncryptionSetResourceId string = diskEncryptionSet.id

@description('The resource ID of the created Storage Account.')
output storageAccountResourceId string = storageAccount.id
