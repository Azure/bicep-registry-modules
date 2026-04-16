targetScope = 'resourceGroup'

@sys.description('Required. The principal ID to assign the role to.')
param principalId string

@sys.description('Required. The role definition ID to assign.')
param roleDefinitionId string

@sys.description('Optional. The principal type of the assigned principal ID.')
param principalType string = 'ServicePrincipal'

@sys.description('Optional. The description of the role assignment.')
param roleDescription string = ''

// Use the same GUID formula as avm/res/azure-stack-hci/cluster module's
// spConnectedMachineResourceManagerRolePermissions to ensure idempotent PUT.
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(subscription().subscriptionId, principalId, 'ConnectedMachineResourceManagerRolePermissions', resourceGroup().id)
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionId)
    principalId: principalId
    principalType: principalType
    description: roleDescription
  }
}
