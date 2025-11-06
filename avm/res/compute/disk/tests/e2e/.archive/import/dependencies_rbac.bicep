targetScope = 'subscription'

@description('Required. The principal ID of the created Managed Identity.')
param managedIdentityPrincipalId string

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(subscription().subscriptionId, managedIdentityPrincipalId, 'Contributor')
  properties: {
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'b24988ac-6180-42a0-ab88-20f7382dd24c'
    ) // Contributor
    principalId: managedIdentityPrincipalId
    principalType: 'ServicePrincipal'
  }
}
