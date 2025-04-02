targetScope = 'managementGroup'

@description('Required. The name of the custom role definition.')
param customRoleDefinitionName string = 'lzVendingAutomationCustomRole'

@description('Required. The description of the custom role definition.')
param customRoleDefinitionDescription string = 'CustomRoleDefinitionDescription'

@description('Required. The actions of the custom role definition.')
param customRoleDefinitionActions array = [
  '*/read'
]

@description('Required. The assignable scopes of the custom role definition.')
param managementGroupId string = 'bicep-lz-vending-automation-child'

resource customRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' = {
  name: guid(deployment().name, customRoleDefinitionName)
  properties: {
    roleName: customRoleDefinitionName
    description: customRoleDefinitionDescription
    type: 'CustomRole'
    assignableScopes: [
      'providers/Microsoft.Management/managementGroups/${managementGroupId}'
    ]
    permissions: [
      {
        actions: customRoleDefinitionActions
      }
    ]
  }
}

output customRoleDefinitionId string = customRoleDefinition.id
output customRoleDefinitionName string = customRoleDefinition.name
