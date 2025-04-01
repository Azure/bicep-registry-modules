targetScope = 'managementGroup'

@description('Required. The name of the custom role definition.')
param customRoleDefinitionName string = 'lzVendingAutomationCustomRole'

@description('Required. The description of the custom role definition.')
param customRoleDefinitionDescription string = 'CustomRoleDefinitionDescription'

@description('Required. The actions of the custom role definition.')
param customRoleDefinitionActions array = [
  'Microsoft.Authorization/*/read'
  'Microsoft.Resources/subscriptions/resourceGroups/read'
  'Microsoft.Resources/subscriptions/resourceGroups/resources/read'
  'Microsoft.Resources/subscriptions/resourceGroups/resources/write'
  'Microsoft.Resources/subscriptions/resourceGroups/resources/delete'
]

@description('Required. The notActions of the custom role definition.')
param customRoleDefinitionNotActions array = [
  'Microsoft.Authorization/roleAssignments/write'
  'Microsoft.Authorization/roleAssignments/delete'
]

@description('Required. The assignable scopes of the custom role definition.')
param managementGroupId string = 'bicep-lz-vending-automation-child'

@description('Required. The dataActions of the custom role definition.')
param customRoleDefinitionDataActions array = [
  'Microsoft.Resources/subscriptions/resourceGroups/read'
  'Microsoft.Resources/subscriptions/resourceGroups/resources/read'
]

@description('Required. The notDataActions of the custom role definition.')
param customRoleDefinitionNotDataActions array = [
  'Microsoft.Resources/subscriptions/resourceGroups/resources/write'
  'Microsoft.Resources/subscriptions/resourceGroups/resources/delete'
]

resource customRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' = {
  name: guid(deployment().name, customRoleDefinitionName)
  properties: {
    roleName: customRoleDefinitionName
    description: customRoleDefinitionDescription
    type: 'CustomRole'
    assignableScopes: [
      tenantResourceId('Microsoft.Management/managementGroups/', managementGroupId)
    ]
    permissions: [
      {
        actions: customRoleDefinitionActions
        notActions: customRoleDefinitionNotActions
        dataActions: customRoleDefinitionDataActions
        notDataActions: customRoleDefinitionNotDataActions
      }
    ]
  }
}

output customRoleDefinitionId string = customRoleDefinition.id
output customRoleDefinitionName string = customRoleDefinition.name
