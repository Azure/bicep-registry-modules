@maxLength(24)
@description('Required. Name of the Storage Account.')
param storageAccountName string

@description('Optional. Name of the blob service.')
param blobServicesName string = 'default'

@description('Required. The name of the storage container to deploy')
param name string

@description('Optional. Name of the immutable policy.')
param immutabilityPolicyName string = 'default'

@allowed([
  'Container'
  'Blob'
  'None'
])
@description('Optional. Specifies whether data in the container may be accessed publicly and the level of access.')
param publicAccess string = 'None'

@description('Optional. Configure immutability policy.')
param immutabilityPolicyProperties object = {}

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' existing = {
  name: storageAccountName

  resource blobServices 'blobServices@2021-06-01' existing = {
    name: blobServicesName
  }
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = {
  name: name
  parent: storageAccount::blobServices
  properties: {
    publicAccess: publicAccess
  }
}

module immutabilityPolicy 'immutabilityPolicies/deploy.bicep' = if (!empty(immutabilityPolicyProperties)) {
  name: immutabilityPolicyName
  params: {
    storageAccountName: storageAccount.name
    blobServicesName: storageAccount::blobServices.name
    containerName: container.name
    immutabilityPeriodSinceCreationInDays: contains(immutabilityPolicyProperties, 'immutabilityPeriodSinceCreationInDays') ? immutabilityPolicyProperties.immutabilityPeriodSinceCreationInDays : 365
    allowProtectedAppendWrites: contains(immutabilityPolicyProperties, 'allowProtectedAppendWrites') ? immutabilityPolicyProperties.allowProtectedAppendWrites : true
  }
}

module container_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: container.id
  }
}]

@description('The name of the deployed container')
output name string = container.name

@description('The resource ID of the deployed container')
output resourceId string = container.id

@description('The resource group of the deployed container')
output resourceGroupName string = resourceGroup().name
