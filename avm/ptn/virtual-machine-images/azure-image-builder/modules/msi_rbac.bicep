targetScope = 'resourceGroup'

param msiResourceId string

resource contributorRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: 'b24988ac-6180-42a0-ab88-20f7382dd24c' // Contributor
  scope: tenant()
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = {
  name: last(split(msiResourceId, '/'))
  scope: resourceGroup(split((msiResourceId ?? '//'), '/')[2], split((msiResourceId ?? '////'), '/')[4])
}

resource imageMSI_rg_rbac 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, managedIdentity.id, contributorRole.id)
  properties: {
    principalId: managedIdentity.properties.principalId
    roleDefinitionId: contributorRole.id
    principalType: 'ServicePrincipal'
  }
}
