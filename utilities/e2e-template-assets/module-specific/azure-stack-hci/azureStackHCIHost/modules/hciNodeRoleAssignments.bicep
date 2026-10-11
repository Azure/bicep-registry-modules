@description('Required. Names of the registered HCI Arc machines.')
param hciNodeNames string[]

@description('Required. The HCI resource-provider service principal object ID.')
@secure()
param hciResourceProviderObjectId string

var arcNodeResourceIds = [for nodeName in hciNodeNames: resourceId('Microsoft.HybridCompute/machines', nodeName)]
var azureConnectedMachineResourceManagerRoleID = subscriptionResourceId(
  'Microsoft.Authorization/roleDefinitions',
  'f5819b54-e033-4d82-ac66-4fec3cbf3f4c'
)
var azureStackHCIDeviceManagementRole = subscriptionResourceId(
  'Microsoft.Authorization/roleDefinitions',
  '865ae368-6a45-4bd1-8fbf-0d5151f56fc1'
)
var readerRoleID = subscriptionResourceId(
  'Microsoft.Authorization/roleDefinitions',
  'acdd72a7-3385-48ef-bd42-f606fba81ae7'
)

resource nodeAzureConnectedMachineResourceManagerRolePermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for hciNode in arcNodeResourceIds: {
    name: guid(
      subscription().subscriptionId,
      hciResourceProviderObjectId,
      'azureConnectedMachineResourceManager',
      hciNode,
      resourceGroup().id
    )
    properties: {
      roleDefinitionId: azureConnectedMachineResourceManagerRoleID
      principalId: reference(hciNode, '2026-07-15', 'Full').identity.principalId
      principalType: 'ServicePrincipal'
      description: 'Created by Azure Stack HCI deployment template'
    }
  }
]

resource nodeazureStackHCIDeviceManagementRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for hciNode in arcNodeResourceIds: {
    name: guid(
      subscription().subscriptionId,
      hciResourceProviderObjectId,
      'azureStackHCIDeviceManagementRole',
      hciNode,
      resourceGroup().id
    )
    properties: {
      roleDefinitionId: azureStackHCIDeviceManagementRole
      principalId: reference(hciNode, '2026-07-15', 'Full').identity.principalId
      principalType: 'ServicePrincipal'
      description: 'Created by Azure Stack HCI deployment template'
    }
  }
]

resource nodereaderRoleIDPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for hciNode in arcNodeResourceIds: {
    name: guid(subscription().subscriptionId, hciResourceProviderObjectId, 'reader', hciNode, resourceGroup().id)
    properties: {
      roleDefinitionId: readerRoleID
      principalId: reference(hciNode, '2026-07-15', 'Full').identity.principalId
      principalType: 'ServicePrincipal'
      description: 'Created by Azure Stack HCI deployment template'
    }
  }
]
