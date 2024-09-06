metadata name = 'Storage Account File Shares'
metadata description = 'This module deploys a Storage Account File Share.'
metadata owner = 'Azure/module-maintainers'

@maxLength(24)
@description('Conditional. The name of the parent Storage Account. Required if the template is used in a standalone deployment.')
param storageAccountName string

@description('Conditional. The name of the parent file service. Required if the template is used in a standalone deployment.')
param fileServicesName string = 'default'

@description('Required. The name of the file share to create.')
param name string

@allowed([
  'Premium'
  'Hot'
  'Cool'
  'TransactionOptimized'
])
@description('Conditional. Access tier for specific share. Required if the Storage Account kind is set to FileStorage (should be set to "Premium"). GpV2 account can choose between TransactionOptimized (default), Hot, and Cool.')
param accessTier string = 'TransactionOptimized'

@description('Optional. The maximum size of the share, in gigabytes. Must be greater than 0, and less than or equal to 5120 (5TB). For Large File Shares, the maximum size is 102400 (100TB).')
param shareQuota int = 5120

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

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-04-01' existing = {
  name: storageAccountName

  resource fileService 'fileServices@2023-04-01' existing = {
    name: fileServicesName
  }
}

resource fileShare 'Microsoft.Storage/storageAccounts/fileServices/shares@2023-01-01' = {
  name: name
  parent: storageAccount::fileService
  properties: {
    accessTier: accessTier
    shareQuota: shareQuota
    rootSquash: enabledProtocols == 'NFS' ? rootSquash : null
    enabledProtocols: enabledProtocols
  }
}

// NOTE: This is a workaround for a bug of the resource provider. Ref: https://github.com/Azure/bicep-types-az/issues/1532
module fileShare_roleAssignments 'modules/nested_roleAssignment.bicep' = if (!empty(roleAssignments)) {
  name: '${uniqueString(deployment().name)}-Share-Rbac'
  params: {
    fileShareResourceId: fileShare.id
    roleAssignments: roleAssignments!
  }
}

@description('The name of the deployed file share.')
output name string = fileShare.name

@description('The resource ID of the deployed file share.')
output resourceId string = fileShare.id

@description('The resource group of the deployed file share.')
output resourceGroupName string = resourceGroup().name

// =============== //
//   Definitions   //
// =============== //

type roleAssignmentType = {
  @description('Optional. The name (as GUID) of the role assignment. If not provided, a GUID will be generated.')
  name: string?

  @description('Required. The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
  roleDefinitionIdOrName: string

  @description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
  principalId: string

  @description('Optional. The principal type of the assigned principal ID.')
  principalType: ('ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup' | 'Device')?

  @description('Optional. The description of the role assignment.')
  description: string?

  @description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".')
  condition: string?

  @description('Optional. Version of the condition.')
  conditionVersion: '2.0'?

  @description('Optional. The Resource Id of the delegated managed identity resource.')
  delegatedManagedIdentityResourceId: string?
}[]?
