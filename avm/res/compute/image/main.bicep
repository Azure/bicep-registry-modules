metadata name = 'Images'
metadata description = 'This module deploys a Compute Image.'

@description('Required. The name of the image.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Required. The Virtual Hard Disk.')
param osDiskBlobUri string

@description('Required. This property allows you to specify the type of the OS that is included in the disk if creating a VM from a custom image.')
@allowed([
  'Windows'
  'Linux'
])
param osType string

@description('Required. Specifies the caching requirements. Default: None for Standard storage. ReadOnly for Premium storage.')
@allowed([
  'None'
  'ReadOnly'
  'ReadWrite'
])
param osDiskCaching string

@description('Required. Specifies the storage account type for the managed disk. NOTE: UltraSSD_LRS can only be used with data disks, it cannot be used with OS Disk.')
@allowed([
  'Standard_LRS'
  'Premium_LRS'
  'StandardSSD_LRS'
  'UltraSSD_LRS'
])
param osAccountType string

@description('Optional. Default is false. Specifies whether an image is zone resilient or not. Zone resilient images can be created only in regions that provide Zone Redundant Storage (ZRS).')
param zoneResilient bool = false

@description('Optional. Gets the HyperVGenerationType of the VirtualMachine created from the image.')
@allowed([
  'V1'
  'V2'
])
param hyperVGeneration string = 'V1'

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.4.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. The extended location of the Image.')
param extendedLocation object?

@description('Optional. The source virtual machine from which Image is created.')
param sourceVirtualMachineResourceId string?

@description('Optional. Specifies the customer managed disk encryption set resource ID for the managed image disk.')
param diskEncryptionSetResourceId string?

@description('Optional. The managedDisk.')
param managedDiskResourceId string?

@description('Optional. Specifies the size of empty data disks in gigabytes. This element can be used to overwrite the name of the disk in a virtual machine image. This value cannot be larger than 1023 GB.')
param diskSizeGB int = 128

@description('Optional. The OS State. For managed images, use Generalized.')
@allowed([
  'Generalized'
  'Specialized'
])
param osState string = 'Generalized'

@description('Optional. The snapshot resource ID.')
param snapshotResourceId string?

@description('Optional. Specifies the parameters that are used to add a data disk to a virtual machine.')
param dataDisks array = []

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
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
  name: '46d3xbcp.res.compute-image.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource image 'Microsoft.Compute/images@2024-07-01' = {
  name: name
  location: location
  tags: tags
  extendedLocation: extendedLocation
  properties: {
    storageProfile: {
      osDisk: {
        osType: osType
        blobUri: osDiskBlobUri
        caching: osDiskCaching
        storageAccountType: osAccountType
        osState: osState
        diskEncryptionSet: !empty(diskEncryptionSetResourceId)
          ? {
              id: diskEncryptionSetResourceId
            }
          : null
        diskSizeGB: diskSizeGB
        managedDisk: !empty(managedDiskResourceId)
          ? {
              id: managedDiskResourceId
            }
          : null
        snapshot: !empty(snapshotResourceId)
          ? {
              id: snapshotResourceId
            }
          : null
      }
      dataDisks: dataDisks
      zoneResilient: zoneResilient
    }
    hyperVGeneration: hyperVGeneration
    sourceVirtualMachine: !empty(sourceVirtualMachineResourceId)
      ? {
          id: sourceVirtualMachineResourceId
        }
      : null
  }
}

resource image_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(image.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: image
  }
]

@description('The resource ID of the image.')
output resourceId string = image.id

@description('The resource group the image was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the image.')
output name string = image.name

@description('The location the resource was deployed into.')
output location string = image.location
