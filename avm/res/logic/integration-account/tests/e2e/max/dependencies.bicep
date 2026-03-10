@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Key Vault to create.')
param keyVaultName string

@secure()
@description('Optional. The object ID of the Logic Apps Service Enterprise Application.')
param logicAppsServiceEnterpriseApplicationObjectId string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: managedIdentityName
  location: location
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
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    enabledForDeployment: true
    enableRbacAuthorization: true
    accessPolicies: []
  }
}

resource keyVaultKey 'Microsoft.KeyVault/vaults/keys@2024-11-01' = {
  name: 'testkey01'
  parent: keyVault
  properties: {
    kty: 'RSA'
    keySize: 2048
    keyOps: [
      'encrypt'
      'decrypt'
      'sign'
      'verify'
      'wrapKey'
      'unwrapKey'
    ]
  }
}

resource keyPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('msi-logicapps-KeyVault-Certificate-Officer-RoleAssignment')
  scope: keyVault
  properties: {
    principalId: logicAppsServiceEnterpriseApplicationObjectId // Logic Apps Service Principal
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'a4417e6f-fecd-4de8-b567-7b0420556985'
    ) // Key Vault Certificate Officer
    principalType: 'ServicePrincipal'
  }
}

resource keyPermissions2 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('msi-logicapps-KeyVault-Administrator-RoleAssignment')
  scope: keyVault
  properties: {
    principalId: logicAppsServiceEnterpriseApplicationObjectId // Logic Apps Service Principal
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '00482a5a-887f-4fb3-b363-3b7fe8e74483'
    ) // Key Vault Administrator
    principalType: 'ServicePrincipal'
  }
}

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The resource ID of the created Key Vault.')
output keyVaultResourceId string = keyVault.id

@description('The name of the created Key Vault key.')
output keyVaultKeyName string = keyVaultKey.name
