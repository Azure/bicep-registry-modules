metadata name = 'Availability Sets'
metadata description = 'This module deploys an Availability Set.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the availability set that is being created.')
param name string

@description('Optional. The number of fault domains to use.')
param platformFaultDomainCount int = 2

@description('Optional. The number of update domains to use.')
param platformUpdateDomainCount int = 5

@description('Optional. SKU of the availability set.</p>- Use \'Aligned\' for virtual machines with managed disks.</p>- Use \'Classic\' for virtual machines with unmanaged disks.')
param skuName string = 'Aligned'

@description('Optional. Resource ID of a proximity placement group.')
param proximityPlacementGroupResourceId string = ''

@description('Optional. Resource location.')
param location string = resourceGroup().location

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. Tags of the availability set resource.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var builtInRoleNames = {
  'App Compliance Automation Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '0f37683f-2463-46b6-9ce7-9b788b988ba2')
  'App Compliance Automation Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ffc6bbe0-e443-4c3b-bf54-26581bb2f78e')
  'Avere Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4f8fab4f-1852-4a58-a46a-8eaf358af14a')
  'Avere Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c025889f-8102-4ebf-b32c-fc0c6f0c6bd9')
  'Azure Center for SAP solutions administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7b0c7e81-271f-4c71-90bf-e30bdfdbc2f7')
  'Azure Center for SAP solutions reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '05352d14-a920-4328-a0de-4cbe7430e26b')
  'Azure Center for SAP solutions service role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'aabbc5dd-1af0-458b-a942-81af88f9c138')
  'Azure Kubernetes Service Policy Add-on Deployment': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18ed5180-3e48-46fd-8541-4ea054d57064')
  'Compute Diagnostics Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'df2711a6-406d-41cf-b366-b0250bff9ad1')
  'Compute Gallery Sharing Admin': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '1ef6a3be-d0ac-425d-8c01-acb62866290b')
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Data Operator for Managed Disks': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '959f8984-c045-4866-89c7-12bf9737be2e')
  'Desktop Virtualization Power On Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '489581de-a3bd-480d-9518-53dea7416b33')
  'Desktop Virtualization Power On Off Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '40c5ff49-9181-41f8-ae61-143b0e78555e')
  'Desktop Virtualization Virtual Machine Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a959dbd1-f747-45e3-8ba6-dd80f235f97c')
  'DevTest Labs User': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '76283e04-6283-4c54-8f91-bcf1374a3c64')
  'Disk Backup Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3e5e47e6-65f7-47ef-90b5-e5dd4d455f24')
  'Disk Pool Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '60fc6e62-5479-42d4-8bf4-67625fcc2840')
  'Disk Restore Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b50d9833-a0cb-478e-945f-707fcc997c13')
  'Disk Snapshot Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7efff54f-a5b4-42b5-a1c5-5411624893ce')
  'Elastic SAN Snapshot Exporter': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '1c4770c0-34f7-4110-a1ea-a5855cc7a939')
  'Elastic SAN Volume Importer': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '90e8b822-3e73-47b5-868a-787dc80c008f')
  'Log Analytics Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '92aaf0da-9dab-42b6-94a3-d43ce8d16293')
  'Log Analytics Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '73c42c96-874c-492b-b04d-ab87d138a893')
  'Managed Application Contributor Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '641177b8-a67a-45b9-a033-47bc880bb21e')
  'Managed Application Operator Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c7393b34-138c-406f-901b-d8cf2b17e6ae')
  'Managed Applications Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b9331d33-8a36-4f8c-b097-4f54124fdb44')
  'Monitoring Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '749f88d5-cbae-40b8-bcfc-e573ddc772fa')
  'Monitoring Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '43d0d8ad-25c7-4714-9337-8ba259a9fe05')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Reservation Purchaser': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f7b75c60-3036-4b75-91c3-6b41c27c1689')
  'Resource Policy Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '36243c78-bf99-498c-9df9-86d9f8d28608')
  'Role Based Access Control Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f58310d9-a9f6-439a-9e8d-f62e7b41a168')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
  'Virtual Machine Administrator Login': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '1c0163c0-47e6-4577-8991-ea5c82e286e4')
  'Virtual Machine Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '9980e02c-c2be-4d73-94e8-173b1dc7cf3c')
  'Virtual Machine Data Access Administrator (preview)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '66f75aeb-eabe-4b70-9f1e-c350c4c9ad04')
  'Virtual Machine User Login': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'fb879df8-f326-4884-b1cf-06f3ad86be52')
  'VM Scanner Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'd24ecba3-c1f4-40fa-a7bb-4588a071e8fd')
  'Windows Admin Center Administrator Login': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a6333a3e-0164-44c3-b281-7a577aff287f')
}

resource avmTelemetry 'Microsoft.Resources/deployments@2023-07-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.compute-availabilityset.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

resource availabilitySet 'Microsoft.Compute/availabilitySets@2023-03-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    platformFaultDomainCount: platformFaultDomainCount
    platformUpdateDomainCount: platformUpdateDomainCount
    proximityPlacementGroup: !empty(proximityPlacementGroupResourceId) ? {
      id: proximityPlacementGroupResourceId
    } : null
  }
  sku: {
    name: skuName
  }
}

resource availabilitySet_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot delete or modify the resource or child resources.'
  }
  scope: availabilitySet
}

resource availabilitySet_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (roleAssignment, index) in (roleAssignments ?? []): {
  name: guid(availabilitySet.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : contains(roleAssignment.roleDefinitionIdOrName, '/providers/Microsoft.Authorization/roleDefinitions/') ? roleAssignment.roleDefinitionIdOrName : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName)
    principalId: roleAssignment.principalId
    description: roleAssignment.?description
    principalType: roleAssignment.?principalType
    condition: roleAssignment.?condition
    conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
    delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
  }
  scope: availabilitySet
}]

@description('The name of the availability set.')
output name string = availabilitySet.name

@description('The resource ID of the availability set.')
output resourceId string = availabilitySet.id

@description('The resource group the availability set was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = availabilitySet.location

// =============== //
//   Definitions   //
// =============== //

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

type roleAssignmentType = {
  @description('Required. The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
  roleDefinitionIdOrName: string

  @description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
  principalId: string

  @description('Optional. The principal type of the assigned principal ID.')
  principalType: ('ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup' | 'Device')?

  @description('Optional. The description of the role assignment.')
  description: string?

  @description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container"')
  condition: string?

  @description('Optional. Version of the condition.')
  conditionVersion: '2.0'?

  @description('Optional. The Resource Id of the delegated managed identity resource.')
  delegatedManagedIdentityResourceId: string?
}[]?
