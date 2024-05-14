metadata name = 'Azure NetApp Files Capacity Pool Volumes'
metadata description = 'This module deploys an Azure NetApp Files Capacity Pool Volume.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent NetApp account. Required if the template is used in a standalone deployment.')
param netAppAccountName string

@description('Conditional. The name of the parent capacity pool. Required if the template is used in a standalone deployment.')
param capacityPoolName string

@description('Required. The name of the pool volume.')
param name string

@description('Optional. Location of the pool volume.')
param location string = resourceGroup().location

@description('Optional. The pool service level. Must match the one of the parent capacity pool.')
@allowed([
  'Premium'
  'Standard'
  'StandardZRS'
  'Ultra'
])
param serviceLevel string = 'Standard'

@description('Optional. A unique file path for the volume. This is the name of the volume export. A volume is mounted using the export path. File path must start with an alphabetical character and be unique within the subscription.')
param creationToken string = name

@description('Required. Maximum storage quota allowed for a file system in bytes.')
param usageThreshold int

@description('Optional. Set of protocol types.')
param protocolTypes array = []

@description('Required. The Azure Resource URI for a delegated subnet. Must have the delegation Microsoft.NetApp/volumes.')
param subnetResourceId string

@description('Optional. Export policy rules.')
param exportPolicyRules array = []

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
  'User Access Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  )
}

resource netAppAccount 'Microsoft.NetApp/netAppAccounts@2022-11-01' existing = {
  name: netAppAccountName

  resource capacityPool 'capacityPools@2022-11-01' existing = {
    name: capacityPoolName
  }
}

resource volume 'Microsoft.NetApp/netAppAccounts/capacityPools/volumes@2022-11-01' = {
  name: name
  parent: netAppAccount::capacityPool
  location: location
  properties: {
    serviceLevel: serviceLevel
    creationToken: creationToken
    usageThreshold: usageThreshold
    protocolTypes: protocolTypes
    subnetId: subnetResourceId
    exportPolicy: !empty(exportPolicyRules)
      ? {
          rules: exportPolicyRules
        }
      : null
  }
}

resource volume_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (roleAssignments ?? []): {
    name: guid(volume.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
    properties: {
      roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName)
        ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName]
        : contains(roleAssignment.roleDefinitionIdOrName, '/providers/Microsoft.Authorization/roleDefinitions/')
            ? roleAssignment.roleDefinitionIdOrName
            : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName)
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: volume
  }
]

@description('The name of the Volume.')
output name string = volume.name

@description('The Resource ID of the Volume.')
output resourceId string = volume.id

@description('The name of the Resource Group the Volume was created in.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = volume.location

// =============== //
//   Definitions   //
// =============== //

type roleAssignmentType = {
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
