targetScope = 'resourceGroup'

metadata name = 'Storage Key Secret Export'

@description('Required. The storage resource ID resolved from the completed storage deployment.')
param storageAccountResourceId string

@description('Required. The destination Key Vault resource ID.')
param keyVaultResourceId string

@description('Required. Enable deployment telemetry.')
param enableTelemetry bool

// Evaluate listKeys inside this child deployment, after the storage output is available.
module secret 'br/public:avm/res/key-vault/vault/secret:0.1.1' = {
  name: take('${deployment().name}-secret', 64)
  scope: resourceGroup(split(keyVaultResourceId, '/')[2], split(keyVaultResourceId, '/')[4])
  params: {
    keyVaultName: last(split(keyVaultResourceId, '/'))
    name: 'ciStorageAccessKey1'
    value: listKeys(storageAccountResourceId, '2023-05-01').keys[0].value
    enableTelemetry: enableTelemetry
  }
}
