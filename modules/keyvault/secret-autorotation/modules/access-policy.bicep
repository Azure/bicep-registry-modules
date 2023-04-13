@description('Name of the keyvault to whom the access policy should be created.')
param keyvaultName string

@description('Access policy principal ID')
param principalId string

@description('Create access policy of the keyvault secrets for the function app')
resource accessPolicy 'Microsoft.KeyVault/vaults/accessPolicies@2022-07-01' = {
  name: '${keyvaultName}/add'
  properties: {
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: principalId
        permissions: {
          secrets: [
            'Get'
            'List'
            'Set'
          ]
        }
      }
    ]
  }
}
