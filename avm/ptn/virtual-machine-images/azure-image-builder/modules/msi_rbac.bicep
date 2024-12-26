targetScope = 'resourceGroup'

@description('Required. The resource ID of the managed identity to assign the role to.')
param msiResourceId string

@description('Optional. Then name of the AIB role definition to create.')
param roleDefinitionName string = 'Custom Azure Image Builder Image Definition' // TODO figure out logic to make conditional

resource contributorRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: 'b24988ac-6180-42a0-ab88-20f7382dd24c' // Contributor
  scope: tenant()
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = {
  name: last(split(msiResourceId, '/'))
  scope: resourceGroup(split((msiResourceId ?? '//'), '/')[2], split((msiResourceId ?? '////'), '/')[4])
}

resource aibRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' = {
  name: guid(resourceGroup().id, roleDefinitionName)
  properties: {
    roleName: roleDefinitionName
    description: 'Image Builder access to create & access resources for the image build.'
    type: 'customRole'
    permissions: [
      {
        actions: [
          // Allow VM Image Builder to distribute images
          'Microsoft.Compute/images/write'
          'Microsoft.Compute/galleries/images/versions/write'
          'Microsoft.Compute/images/delete'

          // Permission to customize existing images
          'Microsoft.Compute/images/read'
          'Microsoft.Compute/galleries/read'
          'Microsoft.Compute/galleries/images/read'
          'Microsoft.Compute/galleries/images/versions/read'

          // Permission to customize images on your virtual networks
          'Microsoft.Network/virtualNetworks/read'
          'Microsoft.Network/virtualNetworks/subnets/join/action'
        ]
        notActions: []
      }
    ]
    assignableScopes: [
      resourceGroup().id
    ]
  }
}

resource imageMSI_rg_rbac 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, managedIdentity.id, contributorRole.id)
  properties: {
    principalId: managedIdentity.properties.principalId
    roleDefinitionId: !empty(roleDefinitionName) ? aibRoleDefinition.id : contributorRole.id
    principalType: 'ServicePrincipal'
  }
}
