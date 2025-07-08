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

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: 'temp-${name}'
  location: location
  tags: tags
}

resource CRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('msi-${managedIdentity.name}-C-RoleAssignment')
  scope: resourceGroup()
  properties: {
    principalId: managedIdentity.properties.principalId
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'b24988ac-6180-42a0-ab88-20f7382dd24c'
    ) // Contributor
    principalType: 'ServicePrincipal'
  }
}

resource KVSORole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('msi-${managedIdentity.name}-KVA-RoleAssignment')
  scope: keyVault
  properties: {
    principalId: managedIdentity.properties.principalId
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'b86a8fe4-44ce-4948-aee5-eccb2c155cd7'
    ) // Key Vault Secrets Officer
    principalType: 'ServicePrincipal'
  }
}

var readJsonRaw = loadTextContent('./nested/read.json')
var readJson = replace(
  replace(replace(readJsonRaw, '{{keyVaultName}}', keyVaultName), '{{publicKeySecretName}}', sshPublicKeySecretName),
  '{{privateKeySecretName}}',
  sshPrivateKeyPemSecretName
)

var writeJsonRaw = loadTextContent('./nested/write.json')
var writeJson = replace(
  replace(replace(writeJsonRaw, '{{keyVaultName}}', keyVaultName), '{{publicKeySecretName}}', sshPublicKeySecretName),
  '{{privateKeySecretName}}',
  sshPrivateKeyPemSecretName
)

resource newSshKey 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: 'newSshKey-${name}'
  location: location
  tags: tags
  dependsOn: [
    CRole
    KVSORole
  ]
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
    arguments: '"${base64(loadTextContent('./nested/reflect.bicep'))}" "${base64(loadTextContent('./nested/read.bicep'))}" "${base64(readJson)}" "${base64(loadTextContent('./nested/write.bicep'))}" "${base64(writeJson)}" "${subscription().subscriptionId}" "${resourceGroup().name}" "${name}"'
    timeout: 'PT30M'
    retentionInterval: 'PT60M'
    cleanupPreference: 'OnExpiration'
  }
}

output sshPublicKeyPemValue string = newSshKey.properties.outputs.output
