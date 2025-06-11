@description('Required. The name of the provisioned cluster instance.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Required. The name of the key vault.')
param keyVaultName string

@description('Optional. The name of the secret in the key vault that contains the SSH private key PEM.')
param sshPrivateKeyPemSecretName string = 'AksArcAgentSshPrivateKeyPem'

@description('Optional. The name of the secret in the key vault that contains the SSH public key.')
param sshPublicKeySecretName string = 'AksArcAgentSshPublicKey'

@description('Optional. Tags of the resource.')
param tags object?

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: keyVaultName
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: 'temp-${name}'
  location: location
  tags: tags
}

var parametersJsonRaw = loadTextContent('./nested/parameters.json')
var parametersJson = replace(
  replace(
    replace(parametersJsonRaw, '{{keyVaultName}}', keyVaultName),
    '{{publicKeySecretName}}',
    sshPublicKeySecretName
  ),
  '{{privateKeySecretName}}',
  sshPrivateKeyPemSecretName
)

resource newSshKey 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: 'newSshKey-${name}'
  location: location
  tags: tags
  kind: 'AzureCLI'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {
    azCliVersion: '2.71.0'
    scriptContent: loadTextContent('./New-SshKey.sh')
    arguments: '"${base64(loadTextContent('./nested/reflect.bicep'))}" "${base64(loadTextContent('./nested/read.bicep'))}" "${base64(loadTextContent('./nested/write.bicep'))}" "${base64(parametersJson)}" "${resourceGroup().name}" "${subscription().subscriptionId}"'
    timeout: 'PT60M'
    retentionInterval: 'PT1H'
    cleanupPreference: 'OnExpiration'
  }
}

output sshPublicKeyPemValue string = newSshKey.properties.outputs.output
