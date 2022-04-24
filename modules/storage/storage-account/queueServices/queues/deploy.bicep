@maxLength(24)
@description('Required. Name of the Storage Account.')
param storageAccountName string

@description('Optional. The name of the queue service')
param queueServicesName string = 'default'

@description('Required. The name of the storage queue to deploy')
param name string

@description('Required. A name-value pair that represents queue metadata.')
param metadata object = {}

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' existing = {
  name: storageAccountName

  resource queueServices 'queueServices@2021-06-01' existing = {
    name: queueServicesName
  }
}

resource queue 'Microsoft.Storage/storageAccounts/queueServices/queues@2019-06-01' = {
  name: name
  parent: storageAccount::queueServices
  properties: {
    metadata: metadata
  }
}

module queue_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: queue.id
  }
}]

@description('The name of the deployed queue')
output name string = queue.name

@description('The resource ID of the deployed queue')
output resourceId string = queue.id

@description('The resource group of the deployed queue')
output resourceGroupName string = resourceGroup().name
