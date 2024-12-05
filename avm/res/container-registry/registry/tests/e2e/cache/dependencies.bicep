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

  resource userName 'secrets@2023-07-01' = {
    name: 'UserName'
    properties: {
      value: userNameSecret
    }
  }

  resource password 'secrets@2023-07-01' = {
    name: 'Password'
    properties: {
      value: passwordSecret
    }
  }
}

resource acr 'Microsoft.ContainerRegistry/registries@2023-11-01-preview' = {
  name: acrName
  location: location
  sku: {
    name: 'Standard'
  }

  resource credentialSet 'credentialSets@2023-11-01-preview' = {
    name: 'default'
    identity: {
      type: 'SystemAssigned'
    }
    properties: {
      authCredentials: [
        {
          name: 'Credential1'
          usernameSecretIdentifier: keyVault::userName.properties.secretUri
          passwordSecretIdentifier: keyVault::password.properties.secretUri
        }
      ]
      loginServer: 'docker.io'
    }
  }
}

resource keyPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('msi-${acr::credentialSet.name}-KeyVaultSecretUser-RoleAssignment')
  scope: keyVault
  properties: {
    principalId: acr::credentialSet.identity.principalId
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '4633458b-17de-408a-b874-0445c86b69e6'
    ) // Key Vault Secrets User
    principalType: 'ServicePrincipal'
  }
}

@description('The username key vault secret URI.')
output userNameSecretURI string = keyVault::userName.properties.secretUri

@description('The password key vault secret URI.')
output pwdSecretURI string = keyVault::password.properties.secretUri

@description('The name of the Azure Container Registry.')
output acrName string = acr.name

@description('The resource ID of the Azure Container Registry Credential Set.')
output acrCredentialSetResourceId string = acr::credentialSet.id
