metadata name = 'ACR Pull permissions'
metadata description = 'Assigns ACR Pull permissions to access an Azure Container Registry.'

@description('Required. The name of the container registry.')
param containerRegistryName string

@description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
param principalId string

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var acrPullRole = subscriptionResourceId(
  'Microsoft.Authorization/roleDefinitions',
  '7f951dda-4ed3-4680-a7ca-43fe172d538d'
)

module aksAcrPull 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.1' = {
  name: guid(subscription().id, resourceGroup().id, principalId, acrPullRole)
  params: {
    principalId: principalId
    resourceId: containerRegistry.id
    roleDefinitionId: acrPullRole
    principalType: 'ServicePrincipal'
    enableTelemetry: enableTelemetry
  }
}

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' existing = {
  name: containerRegistryName
}
