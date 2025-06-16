@description('Required. The resource ID of the backing Azure Compute Gallery.')
param galleryResourceId string

@description('Required. The principal ID of the Dev Center identity (system or user) that will be assigned the "Contributor" role on the backing Azure Compute Gallery.')
param devCenterIdentityPrincipalId string

resource gallery 'Microsoft.Compute/galleries@2024-03-03' existing = {
  name: last(split(galleryResourceId, '/'))
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(devCenterIdentityPrincipalId, gallery.id, 'Contributor')
  scope: gallery
  properties: {
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'b24988ac-6180-42a0-ab88-20f7382dd24c' // Contributor
    )
    principalId: devCenterIdentityPrincipalId
    principalType: 'ServicePrincipal'
  }
}
