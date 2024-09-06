metadata name = 'ACR Pull permissions'
metadata description = 'Assigns ACR Pull permissions to access an Azure Container Registry.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the container registry.')
param name string

@description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
param principalId string

var acrPullRole = subscriptionResourceId(
  'Microsoft.Authorization/roleDefinitions',
  '7f951dda-4ed3-4680-a7ca-43fe172d538d'
)

module aksAcrPull 'br/public:avm/res/container-registry/registry:0.4.0' = {
  name: 'acrpullrole-deployment'
  params: {
    name: name
    roleAssignments: [
      {
        roleDefinitionIdOrName: acrPullRole
        principalType: 'ServicePrincipal'
        principalId: principalId
      }
    ]
  }
}
