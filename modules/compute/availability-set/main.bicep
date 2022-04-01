@description('Required. The name of the availability set that is being created.')
param name string

@description('Optional. The number of fault domains to use.')
param availabilitySetFaultDomain int = 2

@description('Optional. The number of update domains to use.')
param availabilitySetUpdateDomain int = 5

@description('Optional. Sku of the availability set. Use \'Aligned\' for virtual machines with managed disks and \'Classic\' for virtual machines with unmanaged disks.')
param availabilitySetSku string = 'Aligned'

@description('Optional. Resource ID of a proximity placement group.')
param proximityPlacementGroupId string = ''

@description('Optional. Resource location.')
param location string = resourceGroup().location

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = 'NotSpecified'

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Tags of the availability set resource.')
param tags object = {}

resource availabilitySet 'Microsoft.Compute/availabilitySets@2021-07-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    platformFaultDomainCount: availabilitySetFaultDomain
    platformUpdateDomainCount: availabilitySetUpdateDomain
    proximityPlacementGroup: !empty(proximityPlacementGroupId) ? {
      id: proximityPlacementGroupId
    } : null
  }
  sku: {
    name: availabilitySetSku
  }
}

resource availabilitySet_lock 'Microsoft.Authorization/locks@2017-04-01' = if (lock != 'NotSpecified') {
  name: '${availabilitySet.name}-${lock}-lock'
  properties: {
    level: lock
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: availabilitySet
}

module availabilitySet_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-AvSet-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    resourceId: availabilitySet.id
  }
}]

@description('The name of the availability set')
output name string = availabilitySet.name

@description('The resource ID of the availability set')
output resourceId string = availabilitySet.id

@description('The resource group the availability set was deployed into')
output resourceGroupName string = resourceGroup().name
