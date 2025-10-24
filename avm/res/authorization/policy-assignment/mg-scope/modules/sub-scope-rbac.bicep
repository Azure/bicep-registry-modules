targetScope = 'subscription'

@description('Required. The ID Of the Azure Role Definition that is used to assign permissions to the identity. You need to provide the fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.. See https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles for the list IDs for built-in Roles. They must match on what is on the policy definition.')
param roleDefinitionId string

@description('Optional. Location for all resources.')
param location string = deployment().location

@description('Required. Specifies the name of the policy assignment. Maximum length is 24 characters for management group scope.')
@maxLength(24)
param name string

@description('Required. The managed identity principal ID associated with the policy assignment.')
param principalId string

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(subscription().id, roleDefinitionId, location, name)
  properties: {
    roleDefinitionId: roleDefinitionId
    principalId: principalId
    principalType: 'ServicePrincipal'
  }
}
