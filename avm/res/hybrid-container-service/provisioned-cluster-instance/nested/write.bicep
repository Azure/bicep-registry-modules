@description('Required. The name of the key vault.')
param keyVaultName string

@description('Required. The name of the secret for the public key in the key vault.')
param publicKeySecretName string

@description('Required. The value of the public key in Base 64.')
@secure()
param publicKeySecretValueBase64 string

@description('Required. The name of the secret for the private key in the key vault.')
param privateKeySecretName string

@description('Required. The value of the private key in Base 64.')
@secure()
param privateKeySecretValueBase64 string

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: keyVaultName
}

resource publicKeySecret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVault
  name: publicKeySecretName
  properties: {
    value: base64ToString(publicKeySecretValueBase64)
  }
}

resource privateKeySecret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVault
  name: privateKeySecretName
  properties: {
    value: base64ToString(privateKeySecretValueBase64)
  }
}

module reflect './reflect.bicep' = {
  name: 'reflect'
  params: {
    input: base64ToString(publicKeySecretValueBase64)
  }
}

output publicKeySecretName string = publicKeySecretName
output privateKeySecretName string = privateKeySecretName
output publicKeySecretValue string = reflect.outputs.output
