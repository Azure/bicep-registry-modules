targetScope = 'resourceGroup'

@description('Required. The resource ID of the managed identity to assign the role to.')
param msiResourceId string

@description('Required. Then role definition ID of the role to assign.')
param roleDefinitionId string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = {
  name: last(split(msiResourceId, '/'))
  scope: resourceGroup(split((msiResourceId ?? '//'), '/')[2], split((msiResourceId ?? '////'), '/')[4])
}

resource imageMSI_rg_rbac 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, managedIdentity.id, roleDefinitionId)
  properties: {
    principalId: managedIdentity.properties.principalId
    roleDefinitionId: roleDefinitionId
    principalType: 'ServicePrincipal'
  }
}
