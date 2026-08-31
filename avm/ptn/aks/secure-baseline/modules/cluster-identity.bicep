metadata name = 'AKS Cluster Identity'
metadata description = 'Deploys the user-assigned identity and resource-group role assignments required by the AKS cluster.'

@description('Required. The name of the AKS managed cluster.')
param clusterName string

@description('Required. The Azure region in which to deploy the managed identity.')
param location string

@description('Optional. Tags supplied by the module consumer.')
param tags resourceInput<'Microsoft.Resources/resourceGroups@2025-04-01'>.tags = {}

@description('Optional. Enable/Disable usage telemetry for referenced AVM modules.')
param enableTelemetry bool = true

var clusterIdentityName = 'id-${clusterName}'
var clusterIdentityResourceId = resourceId('Microsoft.ManagedIdentity/userAssignedIdentities', clusterIdentityName)
var clusterIdentityRoleDefinitionIds = [
  subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f1a07417-d97a-45cb-824c-7a7467783830')
  subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4d97b98b-1d4f-4787-a291-c67834d212e7')
  subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
]

module clusterIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.6.0' = {
  name: '${uniqueString(clusterIdentityResourceId, location)}-UserAssignedIdentity'
  params: {
    name: clusterIdentityName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

module clusterIdentityRoleAssignments 'br/public:avm/res/authorization/role-assignment/rg-scope:0.1.1' = [
  for (roleDefinitionId, index) in clusterIdentityRoleDefinitionIds: {
    name: '${uniqueString(clusterIdentityResourceId, location)}-ClusterIdentityRole-${index}'
    params: {
      roleDefinitionIdOrName: roleDefinitionId
      principalId: clusterIdentity.outputs.principalId
      principalType: 'ServicePrincipal'
      enableTelemetry: enableTelemetry
    }
  }
]

@description('The resource ID of the AKS cluster user-assigned managed identity.')
output resourceId string = clusterIdentity.outputs.resourceId

@description('The client ID of the AKS cluster user-assigned managed identity.')
output clientId string = clusterIdentity.outputs.clientId

@description('The principal ID of the AKS cluster user-assigned managed identity.')
output principalId string = clusterIdentity.outputs.principalId

