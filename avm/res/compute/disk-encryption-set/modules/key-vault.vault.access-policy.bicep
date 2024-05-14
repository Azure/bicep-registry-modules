metadata name = 'Key Vault Access Policies'
metadata description = 'This module deploys a Key Vault Access Policy.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent key vault. Required if the template is used in a standalone deployment.')
param keyVaultName string

@description('Optional. An array of 0 to 16 identities that have access to the key vault. All identities in the array must use the same tenant ID as the key vault\'s tenant ID.')
param accessPolicies accessPoliciesType

var formattedAccessPolicies = [for accessPolicy in (accessPolicies ?? []): {
  applicationId: accessPolicy.?applicationId ?? ''
  objectId: accessPolicy.objectId
  permissions: accessPolicy.permissions
  tenantId: accessPolicy.?tenantId ?? tenant().tenantId
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

// ================ //
// Definitions      //
// ================ //
type accessPoliciesType = {
  @description('Optional. The tenant ID that is used for authenticating requests to the key vault.')
  tenantId: string?

  @description('Required. The object ID of a user, service principal or security group in the tenant for the vault.')
  objectId: string

  @description('Optional. Application ID of the client making request on behalf of a principal.')
  applicationId: string?

  permissions: {
    @description('Optional. Permissions to keys.')
    keys: ('all' | 'backup' | 'create' | 'decrypt' | 'delete' | 'encrypt' | 'get' | 'getrotationpolicy' | 'import' | 'list' | 'purge' | 'recover' | 'release' | 'restore' | 'rotate' | 'setrotationpolicy' | 'sign' | 'unwrapKey' | 'update' | 'verify' | 'wrapKey')[]?

    @description('Optional. Permissions to secrets.')
    secrets: ('all' | 'backup' | 'delete' | 'get' | 'list' | 'purge' | 'recover' | 'restore' | 'set')[]?

    @description('Optional. Permissions to certificates.')
    certificates: ('all' | 'backup' | 'create' | 'delete' | 'deleteissuers' | 'get' | 'getissuers' | 'import' | 'list' | 'listissuers' | 'managecontacts' | 'manageissuers' | 'purge' | 'recover' | 'restore' | 'setissuers' | 'update')[]?

    @description('Optional. Permissions to storage accounts.')
    storage: ('all' | 'backup' | 'delete' | 'deletesas' | 'get' | 'getsas' | 'list' | 'listsas' | 'purge' | 'recover' | 'regeneratekey' | 'restore' | 'set' | 'setsas' | 'update')[]?
  }
}[]?
