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

resource kv 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: keyVaultName!
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: 'temp-${name}'
  location: location
  tags: tags
}

resource generateSSHKey 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'generateSSHKey-${name}'
  location: location
  tags: tags
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {
    azPowerShellVersion: '8.0'
    retentionInterval: 'P1D'
    scriptContent: loadTextContent('./scripts/generateSshKey.ps1')
  }
}

resource sshPublicKeyPem 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: kv
  name: sshPublicKeySecretName
  properties: {
    value: generateSSHKey.properties.outputs.publicKey
  }
}

resource sshPrivateKeyPem 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: kv
  name: sshPrivateKeyPemSecretName
  properties: {
    value: generateSSHKey.properties.outputs.privateKey
  }
}

output sshPublicKeyPemValue string = generateSSHKey.properties.outputs.publicKey
