targetScope = 'subscription'

param location string

@description('Optional. The name of the Managed Identity to create.')
param managedIdentityName string = 'test-env-mi'

@description('Optional. The name of the Key Vault to create.')
param keyVaultName string = 'test-env-kv'

@description('Optional. The name of the SSH Key to create.')
param sshKeyName string = 'test-env-ssh-key'

@description('Optional. The name of the certificate name.')
param certificateName string = 'test-env-cert'

@description('Optional. The name of the certificate subject name.')
param certificateSubjectName string = 'acahello.demoapp.com'

var rgName = '${take(uniqueString(deployment().name, deployment().location),4)}-testenv-rg'

module testenvrg 'br/public:avm/res/resources/resource-group:0.2.3' = {
  name: '${take(uniqueString(deployment().name, deployment().location),4)}-testenv-rg-deployment'
  params: {
    name: rgName
    location: location
    enableTelemetry: false
  }
}

module testenv 'testenv.bicep' = {
  name: '${take(uniqueString(deployment().name, deployment().location),4)}-testenv-deployment'
  scope: resourceGroup(rgName)
  params: {
    location: location
    managedIdentityName: managedIdentityName
    keyVaultName: keyVaultName
    certificateName: certificateName
    certificateSubjectName: certificateSubjectName
    sshKeyName: sshKeyName
  }
}

output resourceGroupName string = testenvrg.outputs.name
output keyVaultName string = testenv.outputs.keyVaultName
output sshKey string = testenv.outputs.sshKey
output certificateSecureUrl string = testenv.outputs.certificateSecureUrl
