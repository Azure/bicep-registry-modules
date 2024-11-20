@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Key Vault referenced by the ACR Credential Set.')
param keyVaultName string

@description('Optional. UserName secret used by the ACR Credential Set deployment. The value is a GUID.')
@secure()
param userNameSecret string = newGuid()

@description('Optional. Password secret used by the ACR Credential Set deployment. The value is a GUID.')
@secure()
param passwordSecret string = newGuid()

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    publicNetworkAccess: 'Enabled'
    enableRbacAuthorization: true
  }
}

resource keyVaultSecretUserName 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVault
  name: 'UserName'
  properties: {
    value: userNameSecret
  }
}

resource keyVaulSecretPwd 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVault
  name: 'Password'
  properties: {
    value: passwordSecret
  }
}

resource keyPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('msi-${location}-${managedIdentity.id}-KeyVaultSecretsUser-RoleAssignment')
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

@description('The managed identity resource ID.')
output managedIdentityResourceId string = managedIdentity.id

@description('The username key vault secret URI.')
output userNameSecretURI string = keyVaultSecretUserName.properties.secretUri

@description('The password key vault secret URI.')
output pwdSecretURI string = keyVaulSecretPwd.properties.secretUri
