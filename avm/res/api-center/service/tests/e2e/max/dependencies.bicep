@description('Required. The name of the managed identity to create.')
param managedIdentityName string

@description('Required. The name of the API Management service to create.')
param apiManagementServiceName string

@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: managedIdentityName
  location: location
}

resource apiManagementServiceReaderRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: '71522526-b88f-4d52-b57f-d31fc3546d0d' // Api Management Service Reader
  scope: resourceGroup()
}

resource apiManagementServiceReaderRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(apiManagementService.id, managedIdentity.id, apiManagementServiceReaderRole.id)
  scope: apiManagementService
  properties: {
    roleDefinitionId: apiManagementServiceReaderRole.id
    principalId: managedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

resource apiManagementService 'Microsoft.ApiManagement/service@2024-06-01-preview' = {
  name: apiManagementServiceName
  location: location
  sku: {
    name: 'Consumption'
    capacity: 0
  }
  identity: {
    type: 'None'
  }
  properties: {
    publisherEmail: 'apiteam@contoso.com'
    publisherName: 'Contoso API Team'
  }
}

resource petApi 'Microsoft.ApiManagement/service/apis@2024-06-01-preview' = {
  parent: apiManagementService
  name: 'petstore-api'
  properties: {
    displayName: 'Petstore API'
    path: 'pets'
    protocols: [
      'https'
    ]
    serviceUrl: 'https://petstore.example.com/api'
    subscriptionRequired: false
  }
}

resource petApiGetOperation 'Microsoft.ApiManagement/service/apis/operations@2024-06-01-preview' = {
  parent: petApi
  name: 'list-pets'
  properties: {
    displayName: 'List Pets'
    method: 'GET'
    urlTemplate: '/pets'
    responses: [
      {
        statusCode: 200
        description: 'A list of pets.'
      }
    ]
  }
}

resource orderApi 'Microsoft.ApiManagement/service/apis@2024-06-01-preview' = {
  parent: apiManagementService
  name: 'order-api'
  properties: {
    displayName: 'Order API'
    path: 'orders'
    protocols: [
      'https'
    ]
    serviceUrl: 'https://orders.example.com/api'
    subscriptionRequired: false
  }
}

resource orderApiGetOperation 'Microsoft.ApiManagement/service/apis/operations@2024-06-01-preview' = {
  parent: orderApi
  name: 'list-orders'
  properties: {
    displayName: 'List Orders'
    method: 'GET'
    urlTemplate: '/orders'
    responses: [
      {
        statusCode: 200
        description: 'A list of orders.'
      }
    ]
  }
}

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The resource ID of the created API Management service.')
output apiManagementServiceResourceId string = apiManagementService.id
