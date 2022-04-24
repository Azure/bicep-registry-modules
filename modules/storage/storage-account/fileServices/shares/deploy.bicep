@maxLength(24)
@description('Required. Name of the Storage Account.')
param storageAccountName string

@description('Optional. The name of the file service')
param fileServicesName string = 'default'

@description('Required. The name of the file share to create')
param name string

@description('Optional. The maximum size of the share, in gigabytes. Must be greater than 0, and less than or equal to 5TB (5120). For Large File Shares, the maximum size is 102400.')
param sharedQuota int = 5120

@allowed([
  'NFS'
  'SMB'
])
@description('Optional. The authentication protocol that is used for the file share. Can only be specified when creating a share.')
param enabledProtocols string = 'SMB'

@allowed([
  'AllSquash'
  'NoRootSquash'
  'RootSquash'
])
@description('Optional. Permissions for NFS file shares are enforced by the client OS rather than the Azure Files service. Toggling the root squash behavior reduces the rights of the root user for NFS shares.')
param rootSquash string = 'NoRootSquash'

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' existing = {
  name: storageAccountName

  resource fileService 'fileServices@2021-04-01' existing = {
    name: fileServicesName
  }
}

resource fileShare 'Microsoft.Storage/storageAccounts/fileServices/shares@2021-08-01' = {
  name: name
  parent: storageAccount::fileService
  properties: {
    shareQuota: sharedQuota
    rootSquash: enabledProtocols == 'NFS' ? rootSquash : null
    enabledProtocols: enabledProtocols
  }
}

module fileShare_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: fileShare.id
  }
}]

@description('The name of the deployed file share')
output name string = fileShare.name

@description('The resource ID of the deployed file share')
output resourceId string = fileShare.id

@description('The resource group of the deployed file share')
output resourceGroupName string = resourceGroup().name
