metadata name = 'AKS Resource Deletion Identity'
metadata description = 'Deploys the optional AKS1P resource-deletion managed identity and grants it Contributor at subscription scope.'

param location string
param name string
param tags resourceInput<'Microsoft.Resources/resourceGroups@2025-04-01'>.tags
param enableTelemetry bool

module identity 'br/public:avm/res/managed-identity/user-assigned-identity:0.6.0' = {
  name: '${uniqueString(resourceGroup().id, name)}-ResourceDeletionIdentity'
  params: {
    name: name
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

module contributorRoleAssignment 'br/public:avm/res/authorization/role-assignment/sub-scope:0.1.1' = {
  name: '${uniqueString(subscription().id, name)}-Contributor'
  scope: subscription()
  params: {
    roleDefinitionIdOrName: 'Contributor'
    principalId: identity.outputs.principalId
    principalType: 'ServicePrincipal'
    enableTelemetry: enableTelemetry
  }
}

output resourceId string = identity.outputs.resourceId
output principalId string = identity.outputs.principalId
