@sys.description('Required. The name of the API Management service to assign the role on.')
param apimServiceName string

@sys.description('Required. The principal ID of the identity to grant the API Management Service Reader role to.')
param principalId string

resource apiManagementServiceReaderRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: '71522526-b88f-4d52-b57f-d31fc3546d0d' // Api Management Service Reader
  scope: resourceGroup()
}

resource apimService 'Microsoft.ApiManagement/service@2024-06-01-preview' existing = {
  name: apimServiceName
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(apimService.id, principalId, apiManagementServiceReaderRole.id)
  scope: apimService
  properties: {
    roleDefinitionId: apiManagementServiceReaderRole.id
    principalId: principalId
    principalType: 'ServicePrincipal'
  }
}
