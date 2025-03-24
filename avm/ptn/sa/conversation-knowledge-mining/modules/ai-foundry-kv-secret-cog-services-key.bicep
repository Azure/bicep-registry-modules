// NOTE: The value of this secret is duplicated, so it cannot be assigned twice via AVM Module ('AZURE-OPENAI-KEY').
// TODO: Update code to use always the same secret for the same value
@description('Required. The name of the Key Vault resource to store the Cognitive Services key.')
param keyVaultResourceName string
@description('Required. The name of the Cognitive Services resource.')
param cognitiveServicesAccountsResourceName string

resource existingCognitiveServicesAccountResource 'Microsoft.CognitiveServices/accounts@2024-10-01' existing = {
  name: cognitiveServicesAccountsResourceName
}

resource existingKeyVaultResource 'Microsoft.KeyVault/vaults@2024-04-01-preview' existing = {
  name: keyVaultResourceName
}

resource cogServiceKeyEntry 'Microsoft.keyvault/vaults/secrets@2021-11-01-preview' = {
  parent: existingKeyVaultResource
  name: 'COG-SERVICES-KEY'
  properties: {
    value: existingCognitiveServicesAccountResource.listKeys().key1
  }
}
