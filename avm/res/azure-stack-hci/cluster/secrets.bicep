@description('Required. The name of the key vault.')
param keyVaultName string

@description('Required. The name of the strorage account.')
param storageAccountName string

@description('Required. The name of the cluster.')
param clusterName string

@description('Required. The cloud ID.')
param cloudId string

@description('Required. The name of the deployment user.')
param deploymentUser string

@secure()
@description('Required. The password of the deployment user.')
param deploymentUserPassword string

@description('Required. The name of the local admin user.')
param localAdminUser string

@secure()
@description('Required. The password of the local admin user.')
param localAdminPassword string

@description('Required. The service principal ID for ARB.')
param servicePrincipalId string

@secure()
@description('Required. The service principal secret for ARB.')
param servicePrincipalSecret string

@description('Optional. Content type of the azure stack lcm user credential.')
param azureStackLCMUserCredentialContentType string = 'Secret'

@description('Optional. Content type of the local admin credential.')
param localAdminCredentialContentType string = 'Secret'

@description('Optional. Content type of the witness storage key.')
param witnessStoragekeyContentType string = 'Secret'

@description('Optional. Content type of the default ARB application.')
param defaultARBApplicationContentType string = 'Secret'

@description('Optional. Tags of azure stack LCM user credential.')
param azureStackLCMUserCredentialTags object?

@description('Optional. Tags of the local admin credential.')
param localAdminCredentialTags object?

@description('Optional. Tags of the witness storage key.')
param witnessStoragekeyTags object?

@description('Optional. Tags of the default ARB application.')
param defaultARBApplicationTags object?

resource witnessStorageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' existing = {
  name: storageAccountName
}

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyVaultName
}

resource azureStackLCMUserCredential 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVault
  name: '${clusterName}-AzureStackLCMUserCredential-${cloudId}'

  properties: {
    contentType: azureStackLCMUserCredentialContentType
    value: base64('${deploymentUser}:${deploymentUserPassword}')
    attributes: {
      enabled: true
    }
  }
  tags: azureStackLCMUserCredentialTags
}

resource localAdminCredential 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVault
  name: '${clusterName}-LocalAdminCredential-${cloudId}'

  properties: {
    contentType: localAdminCredentialContentType
    value: base64('${localAdminUser}:${localAdminPassword}')
    attributes: {
      enabled: true
    }
  }
  tags: localAdminCredentialTags
}

resource witnessStorageKey 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVault
  name: '${clusterName}-WitnessStorageKey-${cloudId}'
  properties: {
    contentType: witnessStoragekeyContentType
    value: base64(witnessStorageAccount.listKeys().keys[0].value)
    attributes: {
      enabled: true
    }
  }
  tags: witnessStoragekeyTags
}

resource defaultARBApplication 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVault
  name: '${clusterName}-DefaultARBApplication-${cloudId}'
  properties: {
    contentType: defaultARBApplicationContentType
    value: base64('${servicePrincipalId}:${servicePrincipalSecret}')
    attributes: {
      enabled: true
    }
  }
  tags: defaultARBApplicationTags
}
