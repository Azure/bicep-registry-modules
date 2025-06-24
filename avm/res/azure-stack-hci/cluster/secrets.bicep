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

@description('Conditional. The service principal ID for ARB.')
param servicePrincipalId string?

@secure()
@description('Conditional. The service principal secret for ARB.')
param servicePrincipalSecret string?

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

@description('Optional. Storage account subscription ID, which is used as the witness for the HCI Windows Failover Cluster.')
param witnessStorageAccountSubscriptionId string

@description('Optional. Storage account resource group, which is used as the witness for the HCI Windows Failover Cluster..')
param witnessStorageAccountResourceGroup string

@description('Required. The service principal object ID of the Azure Stack HCI Resource Provider in this tenant. Can be fetched via `Get-AzADServicePrincipal -ApplicationId 1412d89f-b8a8-4111-b4fd-e82905cbd85d` after the \'Microsoft.AzureStackHCI\' provider was registered in the subscription.')
@secure()
param hciResourceProviderObjectId string

@description('Required. Resource ids of the cluster node Arc Machine resources. These are the id of the Arc Machine resources created when the new HCI nodes were Arc initialized.')
param arcNodeResourceIds array

resource witnessStorageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' existing = {
  name: storageAccountName
  scope: resourceGroup(witnessStorageAccountSubscriptionId, witnessStorageAccountResourceGroup)
}

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyVaultName
}

var keyVaultSecretUserRoleID = subscriptionResourceId(
  'Microsoft.Authorization/roleDefinitions',
  '4633458b-17de-408a-b874-0445c86b69e6'
)

resource KeyVaultSecretsUserPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for hciNode in arcNodeResourceIds: {
    name: guid(
      subscription().subscriptionId,
      hciResourceProviderObjectId,
      'keyVaultSecretUser',
      hciNode,
      resourceGroup().id
    )
    scope: keyVault
    properties: {
      roleDefinitionId: keyVaultSecretUserRoleID
      principalId: reference(hciNode, '2023-10-03-preview', 'Full').identity.principalId
      principalType: 'ServicePrincipal'
      description: 'Created by Azure Stack HCI deployment template'
    }
  }
]

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

resource defaultARBApplication 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = if (!empty(servicePrincipalId) && !empty(servicePrincipalSecret)) {
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
