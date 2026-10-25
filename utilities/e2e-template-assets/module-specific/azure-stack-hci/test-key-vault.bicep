@description('Required. Name of the disposable test vault.')
param name string

@description('Required. Location of the test vault.')
param location string

resource vault 'Microsoft.KeyVault/vaults@2026-02-01' = {
  name: name
  location: location
  properties: {
    tenantId: subscription().tenantId
    sku: {
      family: 'A'
      name: 'standard'
    }
    enableRbacAuthorization: true
    enableSoftDelete: true
    enablePurgeProtection: false
    softDeleteRetentionInDays: 7
    enabledForTemplateDeployment: true
    accessPolicies: []
  }
}

@description('The disposable vault used by the module-under-test SSH-key helper.')
output name string = vault.name
