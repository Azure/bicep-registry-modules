metadata name = 'SSH Key Lifecycle'
metadata description = 'Runs the AKS1P SSH key generation process with the shared shell identity after Key Vault protection and access are configured.'

param location string
param keyVaultSubscriptionId string
param keyVaultName string
param scriptIdentityResourceId string
param sshPublicKeySecretName string
param sshPrivateKeySecretName string
param tags resourceInput<'Microsoft.Resources/resourceGroups@2025-04-01'>.tags
param forceUpdateTag string = utcNow()

resource generateAndStoreSshKey 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: 'ssh-${take(uniqueString(resourceGroup().id, keyVaultName), 8)}'
  location: location
  tags: tags
  kind: 'AzureCLI'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${scriptIdentityResourceId}': {}
    }
  }
  properties: {
    azCliVersion: '2.71.0'
    scriptContent: loadTextContent('generate-ssh-key.sh')
    arguments: '"${keyVaultSubscriptionId}" "${keyVaultName}" "${sshPublicKeySecretName}" "${sshPrivateKeySecretName}"'
    timeout: 'PT30M'
    retentionInterval: 'PT1H'
    cleanupPreference: 'OnSuccess'
    forceUpdateTag: forceUpdateTag
  }
}

output resourceId string = generateAndStoreSshKey.id
output sshPublicKey string = generateAndStoreSshKey.properties.outputs.sshPublicKey
