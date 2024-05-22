metadata name = 'Storage Account Local Users'
metadata description = 'This module deploys a Storage Account Local User, which is used for SFTP authentication.'
metadata owner = 'Azure/module-maintainers'

@maxLength(24)
@description('Conditional. The name of the parent Storage Account. Required if the template is used in a standalone deployment.')
param storageAccountName string

@description('Required. The name of the local user used for SFTP Authentication.')
param name string

@description('Optional. Indicates whether shared key exists. Set it to false to remove existing shared key.')
param hasSharedKey bool = false

@description('Required. Indicates whether SSH key exists. Set it to false to remove existing SSH key.')
param hasSshKey bool

@description('Required. Indicates whether SSH password exists. Set it to false to remove existing SSH password.')
param hasSshPassword bool

@description('Optional. The local user home directory.')
param homeDirectory string = ''

@description('Required. The permission scopes of the local user.')
param permissionScopes array

@description('Optional. The local user SSH authorized keys for SFTP.')
param sshAuthorizedKeys sshAuthorizedKeysType

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-04-01' existing = {
  name: storageAccountName
}

resource localUsers 'Microsoft.Storage/storageAccounts/localUsers@2023-04-01' = {
  name: name
  parent: storageAccount
  properties: {
    hasSharedKey: hasSharedKey
    hasSshKey: hasSshKey
    hasSshPassword: hasSshPassword
    homeDirectory: homeDirectory
    permissionScopes: permissionScopes
    sshAuthorizedKeys: sshAuthorizedKeys.?secureList
  }
}

@description('The name of the deployed local user.')
output name string = localUsers.name

@description('The resource group of the deployed local user.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the deployed local user.')
output resourceId string = localUsers.id

// =============== //
//   Definitions   //
// =============== //

@secure()
type sshAuthorizedKeysType = {
  @description('Optional. The list of SSH authorized keys.')
  secureList: {
    @description('Optional. Description used to store the function/usage of the key.')
    description: string?

    @description('Required. SSH public key base64 encoded. The format should be: \'{keyType} {keyData}\', e.g. ssh-rsa AAAABBBB.')
    key: string
  }[]
}?
