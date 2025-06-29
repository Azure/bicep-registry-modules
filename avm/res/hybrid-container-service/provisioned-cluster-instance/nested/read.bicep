@description('Required. The name of the key vault.')
param keyVaultName string

@description('Required. The name of the secret for the public key in the key vault.')
param publicKeySecretName string

@description('Required. The name of the secret for the private key in the key vault.')
param privateKeySecretName string

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: keyVaultName
}

module reflect './reflect.bicep' = {
  name: 'reflect'
  params: {
    input: keyVault.getSecret(publicKeySecretName)
  }
}

output publicKeySecretName string = publicKeySecretName
output privateKeySecretName string = privateKeySecretName
output publicKeySecretValue string = reflect.outputs.output
