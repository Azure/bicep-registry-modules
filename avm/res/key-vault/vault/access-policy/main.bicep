metadata name = 'Key Vault Access Policies'
metadata description = 'This module deploys a Key Vault Access Policy.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent key vault. Required if the template is used in a standalone deployment.')
param keyVaultName string

@description('Optional. An array of 0 to 16 identities that have access to the key vault. All identities in the array must use the same tenant ID as the key vault\'s tenant ID.')
param accessPolicies array = []

var formattedAccessPolicies = [for accessPolicy in accessPolicies: {
  applicationId: contains(accessPolicy, 'applicationId') ? accessPolicy.applicationId : ''
  objectId: contains(accessPolicy, 'objectId') ? accessPolicy.objectId : ''
  permissions: accessPolicy.permissions
  tenantId: contains(accessPolicy, 'tenantId') ? accessPolicy.tenantId : tenant().tenantId
}]

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyVaultName
}

resource policies 'Microsoft.KeyVault/vaults/accessPolicies@2022-07-01' = {
  name: 'add'
  parent: keyVault
  properties: {
    accessPolicies: formattedAccessPolicies
  }
}

@description('The name of the resource group the access policies assignment was created in.')
output resourceGroupName string = resourceGroup().name

@description('The name of the access policies assignment.')
output name string = policies.name

@description('The resource ID of the access policies assignment.')
output resourceId string = policies.id
