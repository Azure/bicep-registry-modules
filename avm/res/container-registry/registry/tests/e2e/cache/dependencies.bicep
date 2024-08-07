@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Azure Container Registry to pre-create before the actual test.')
param acrName string

@description('Required. The name of the Key Vault referenced by the ACR Credential Set.')
param keyVaultName string

@description('Optional. UserName secret used by the ACR Credential Set deployment. The value is a GUID.')
@secure()
param userNameSecret string = newGuid()

@description('Optional. Password secret used by the ACR Credential Set deployment. The value is a GUID.')
@secure()
param passwordSecret string = newGuid()

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

resource acr 'Microsoft.ContainerRegistry/registries@2023-11-01-preview' = {
  name: acrName
  location: location
  sku: {
    name: 'Standard'
  }
}

resource acrCredentialSet 'Microsoft.ContainerRegistry/registries/credentialSets@2023-11-01-preview' = {
  parent: acr
  name: 'default'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    authCredentials: [
      {
        name: 'Credential1'
        passwordSecretIdentifier: keyVaulSecretPwd.properties.secretUri
        usernameSecretIdentifier: keyVaultSecretUserName.properties.secretUri
      }
    ]
    loginServer: 'docker.io'
  }
}

resource keyPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('msi-${acrCredentialSet.name}-KeyVaultSecretUser-RoleAssignment')
  scope: keyVault
  properties: {
    principalId: acrCredentialSet.identity.principalId
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '4633458b-17de-408a-b874-0445c86b69e6'
    ) // Key Vault Secrets User
    principalType: 'ServicePrincipal'
  }
}

@description('The username key vault secret URI.')
output userNameSecretURI string = keyVaultSecretUserName.properties.secretUri

@description('The password key vault secret URI.')
output pwdSecretURI string = keyVaulSecretPwd.properties.secretUri

@description('The name of the Azure Container Registry.')
output acrName string = acr.name

@description('The resource ID of the Azure Container Registry Credential Set.')
output acrCredentialSetResourceId string = acrCredentialSet.id
