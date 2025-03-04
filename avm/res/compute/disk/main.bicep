metadata name = 'Compute Disks'
metadata description = 'This module deploys a Compute Disk'

@description('Required. The name of the disk that is being created.')
param name string

@description('Optional. Resource location.')
param location string = resourceGroup().location

@allowed([
  'Standard_LRS'
  'Premium_LRS'
  'StandardSSD_LRS'
  'UltraSSD_LRS'
  'Premium_ZRS'
  'PremiumV2_LRS'
])
@description('Required. The disks sku name. Can be .')
param sku string

@allowed([
  'EdgeZone'
  ''
])
@description('Optional. Specifies the Edge Zone within the Azure Region where this Managed Disk should exist. Changing this forces a new Managed Disk to be created.')
param edgeZone string = ''

@allowed([
  'x64'
  'Arm64'
  ''
])
@description('Optional. CPU architecture supported by an OS disk.')
param architecture string = ''

@description('Optional. Set to true to enable bursting beyond the provisioned performance target of the disk.')
param burstingEnabled bool = false

@description('Optional. Percentage complete for the background copy when a resource is created via the CopyStart operation.')
param completionPercent int = 100

@allowed([
  'Attach'
  'Copy'
  'CopyStart'
  'Empty'
  'FromImage'
  'Import'
  'ImportSecure'
  'Restore'
  'Upload'
  'UploadPreparedSecure'
])
@description('Optional. Sources of a disk creation.')
param createOption string = 'Empty'

@description('Optional. A relative uri containing either a Platform Image Repository or user image reference.')
param imageReferenceId string = ''

@description('Optional. Logical sector size in bytes for Ultra disks. Supported values are 512 ad 4096.')
param logicalSectorSize int = 4096

@description('Optional. If create option is ImportSecure, this is the URI of a blob to be imported into VM guest state.')
param securityDataUri string = ''

@description('Optional. If create option is Copy, this is the ARM ID of the source snapshot or disk.')
param sourceResourceId string = ''

@description('Optional. If create option is Import, this is the URI of a blob to be imported into a managed disk.')
param sourceUri string = ''

@description('Conditional. The resource ID of the storage account containing the blob to import as a disk. Required if create option is Import.')
param storageAccountId string = ''

@description('Optional. If create option is Upload, this is the size of the contents of the upload including the VHD footer.')
param uploadSizeBytes int = 20972032

@description('Conditional. The size of the disk to create. Required if create option is Empty.')
param diskSizeGB int = 0

@description('Optional. The number of IOPS allowed for this disk; only settable for UltraSSD disks.')
param diskIOPSReadWrite int = 0

@description('Optional. The bandwidth allowed for this disk; only settable for UltraSSD disks.')
param diskMBpsReadWrite int = 0

@allowed([
  'V1'
  'V2'
])
@description('Optional. The hypervisor generation of the Virtual Machine. Applicable to OS disks only.')
param hyperVGeneration string = 'V2'

@description('Optional. The maximum number of VMs that can attach to the disk at the same time. Default value is 0.')
param maxShares int = 1

@allowed([
  'AllowAll'
  'AllowPrivate'
  'DenyAll'
])
@description('Optional. Policy for accessing the disk via network.')
param networkAccessPolicy string = 'DenyAll'

@description('Optional. Setting this property to true improves reliability and performance of data disks that are frequently (more than 5 times a day) by detached from one virtual machine and attached to another. This property should not be set for disks that are not detached and attached frequently as it causes the disks to not align with the fault domain of the virtual machine.')
param optimizedForFrequentAttach bool = false

@allowed([
  'Windows'
  'Linux'
  ''
])
@description('Optional. Sources of a disk creation.')
param osType string = ''

@allowed([
  'Disabled'
  'Enabled'
])
@description('Optional. Policy for controlling export on the disk.')
param publicNetworkAccess string = 'Disabled'

@description('Optional. True if the image from which the OS disk is created supports accelerated networking.')
param acceleratedNetwork bool = false

@description('Required. If set to 1, 2 or 3, the availability zone is hardcoded to that value. If zero, then availability zones are not used. Note that the availability zone number here are the logical availability zone in your Azure subscription. Different subscriptions might have a different mapping of the physical zone and logical zone.To understand more, please refer to [Physical and logical availability zones](https://learn.microsoft.com/en-us/azure/reliability/availability-zones-overview?tabs=azure-cli#physical-and-logical-availability-zones) and [Distribute VMs and disks across availability zones](https://learn.microsoft.com/en-us/azure/virtual-machines/disks-high-availability#distribute-vms-and-disks-across-availability-zones).')
@allowed([
  0
  1
  2
  3
])
param availabilityZone int

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. Tags of the availability set resource.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Data Operator for Managed Disks': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '959f8984-c045-4866-89c7-12bf9737be2e'
  )
  'Disk Backup Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '3e5e47e6-65f7-47ef-90b5-e5dd4d455f24'
  )
  'Disk Pool Operator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '60fc6e62-5479-42d4-8bf4-67625fcc2840'
  )
  'Disk Restore Operator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'b50d9833-a0cb-478e-945f-707fcc997c13'
  )
  'Disk Snapshot Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '7efff54f-a5b4-42b5-a1c5-5411624893ce'
  )
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
  'User Access Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  )
}

var formattedRoleAssignments = [
  for (roleAssignment, index) in (roleAssignments ?? []): union(roleAssignment, {
    roleDefinitionId: builtInRoleNames[?roleAssignment.roleDefinitionIdOrName] ?? (contains(
        roleAssignment.roleDefinitionIdOrName,
        '/providers/Microsoft.Authorization/roleDefinitions/'
      )
      ? roleAssignment.roleDefinitionIdOrName
      : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName))
  })
]

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.compute-disk.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource disk 'Microsoft.Compute/disks@2023-10-02' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: sku
  }
  extendedLocation: !empty(edgeZone)
    ? {
        type: edgeZone
        name: edgeZone
      }
    : null
  properties: {
    burstingEnabled: burstingEnabled
    completionPercent: completionPercent
    creationData: {
      createOption: createOption
      imageReference: createOption == 'FromImage'
        ? {
            id: imageReferenceId
          }
        : null
      logicalSectorSize: contains(sku, 'Ultra') ? logicalSectorSize : null
      securityDataUri: createOption == 'ImportSecure' ? securityDataUri : null
      sourceResourceId: createOption == 'Copy' ? sourceResourceId : null
      sourceUri: createOption == 'Import' ? sourceUri : null
      storageAccountId: createOption == 'Import' ? storageAccountId : null
      uploadSizeBytes: createOption == 'Upload' ? uploadSizeBytes : null
    }
    diskIOPSReadWrite: contains(sku, 'Ultra') ? diskIOPSReadWrite : null
    diskMBpsReadWrite: contains(sku, 'Ultra') ? diskMBpsReadWrite : null
    diskSizeGB: createOption == 'Empty' ? diskSizeGB : null
    hyperVGeneration: !empty(osType) ? hyperVGeneration : null
    maxShares: maxShares
    networkAccessPolicy: networkAccessPolicy
    optimizedForFrequentAttach: optimizedForFrequentAttach
    osType: !empty(osType) ? osType : any(null)
    publicNetworkAccess: publicNetworkAccess
    supportedCapabilities: !empty(osType)
      ? {
          acceleratedNetwork: acceleratedNetwork
          architecture: !empty(architecture) ? architecture : null
        }
      : {}
  }
  zones: availabilityZone != 0 ? array(string(availabilityZone)) : null
}

resource disk_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: disk
}

resource disk_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(disk.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: disk
  }
]

@description('The resource group the  disk was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the disk.')
output resourceId string = disk.id

@description('The name of the disk.')
output name string = disk.name

@description('The location the resource was deployed into.')
output location string = disk.location

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
