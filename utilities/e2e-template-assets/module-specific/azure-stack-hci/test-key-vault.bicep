@description('Required. Name prefix of the disposable test vault. A suffix unique to the deployment is appended because a deleted vault keeps its name until it is purged.')
param name string

@description('Required. Location of the test vault.')
param location string

resource vault 'Microsoft.KeyVault/vaults@2026-02-01' = {
  name: '${take(name, 11)}${uniqueString(deployment().name, resourceGroup().id)}'
  location: location
  properties: {
    tenantId: subscription().tenantId
    sku: {
      family: 'A'
      name: 'standard'
    }
    enableRbacAuthorization: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 7
    enabledForTemplateDeployment: true
    accessPolicies: []
  }
}

@description('The disposable vault used by the module-under-test SSH-key helper.')
output name string = vault.name
