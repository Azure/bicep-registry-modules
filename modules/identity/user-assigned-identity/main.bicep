@minLength(5)
@maxLength(50)
@description('Required. Name of User Assigned Identity.')
param name string

@description('Required. Define the Azure Location that the Azure User Assigned Identity should be created within.')
param location string

@description('Optional. Tags for Azure User Assigned Identity')
param tags object = {}

@description('Optional. roles list which will create roleAssignment for userAssignedIdentities.')
param roles array = []
/* Example
[
  {
    name: 'Contributor'
    roleDefinitionId: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
    principalType: 'ServicePrincipal'
  }
  {
    name: 'Azure Kubernetes Service RBAC Admin'
    roleDefinitionId: '3498e952-d568-435e-9b2c-8d77e338d7f7'
    principalType: 'ServicePrincipal'
  }
]
*/
resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: name
  location: location
  tags: tags
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for role in roles: {
  name: guid(managedIdentity.id, role.name)
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', role.roleDefinitionId)
    principalId: managedIdentity.properties.principalId
    principalType: role.principalType
  }
}]

@description('Id of the User Assigned Identity created.')
output id string = managedIdentity.id

@description('Name of the User Assigned Identity created.')
output name string = managedIdentity.name

@description('The id of the service principal object associated with the created identity.')
output principalId string = managedIdentity.properties.principalId

@description('The id of the tenant which the identity belongs to.')
output tenantId string = managedIdentity.properties.tenantId

@description('The id of the app associated with the identity. This is a random generated UUID by MSI.')
output clientId string = managedIdentity.properties.clientId
