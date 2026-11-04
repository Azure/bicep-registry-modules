metadata name = 'Azure Local Gallery Image'
metadata description = 'This module imports a prepared customer-provided OS image into Azure Local. It does not build, harden, or patch the source image.'

@description('Required. Name of the resource to create.')
@minLength(1)
@maxLength(80)
param name string

@description('Optional. Azure region of the associated custom location. Defaults to the resource group location.')
param location string = resourceGroup().location

@description('Required. Resource ID of the Azure Local custom location on which to import the image.')
@minLength(1)
param customLocationResourceId string

@secure()
@minLength(1)
@description('Required. Path to a prepared source image: a VHDX on a cluster shared volume accessible to the Azure Local instance, or an HTTPS SAS URL for a VHD/VHDX page blob in Azure Storage. This is not a path on the deployment client. Treat the entire value as a secret; do not log it or place it in outputs. Image preparation, activation, upload, and SAS generation are caller responsibilities.')
param imagePath string

@description('Required. Operating system of the prepared source image.')
@allowed([
  'Windows'
  'Linux'
])
param osType string

@description('Optional. Hyper-V generation of the prepared source image. Use V1 or V2 to match the source; VHDX sources require V2.')
param hyperVGeneration resourceInput<'Microsoft.AzureStackHCI/galleryImages@2024-01-01'>.properties.hyperVGeneration = 'V2'

@description('Optional. Cloud-init data source supported by the prepared image, such as NoCloud or Azure. Omit when not applicable.')
param cloudInitDataSource resourceInput<'Microsoft.AzureStackHCI/galleryImages@2024-01-01'>.properties.cloudInitDataSource?

@description('Optional. Resource ID of an existing Azure Local storage container associated with the same custom location. Use the storage-container module resourceId output, not its filesystem path. When omitted, Azure Local selects the storage placement.')
param containerResourceId string?

@description('Optional. Image identifier containing publisher, offer, and SKU. This describes the customer image; it does not select a Marketplace image.')
param identifier resourceInput<'Microsoft.AzureStackHCI/galleryImages@2024-01-01'>.properties.identifier?

@description('Optional. Gallery image version metadata. This does not import an Azure Compute Gallery version or guarantee that changing the source or version in place is supported. Image properties may be creation-only; validate unchanged redeployment before relying on idempotency.')
param version resourceInput<'Microsoft.AzureStackHCI/galleryImages@2024-01-01'>.properties.version?

@description('Optional. Tags of the resource.')
param tags resourceInput<'Microsoft.AzureStackHCI/galleryImages@2024-01-01'>.tags?

import { lockType, roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.7.0'

@description('Optional. The lock settings of the resource.')
param lock lockType?

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var builtInRoleNames = {
  'Azure Stack HCI Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'bda0d508-adf1-4af0-9c28-88919fc3ae06'
  )
  'Azure Stack HCI VM Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '874d1c73-6003-4e60-a13a-cb31ea190a85'
  )
  'Azure Stack HCI VM Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '4b3fe76c-f777-4d24-a2d7-b027b0f7b273'
  )
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
  for roleAssignment in (roleAssignments ?? []): union(roleAssignment, {
    roleDefinitionId: builtInRoleNames[?roleAssignment.roleDefinitionIdOrName] ?? (contains(
        roleAssignment.roleDefinitionIdOrName,
        '/providers/Microsoft.Authorization/roleDefinitions/'
      )
      ? roleAssignment.roleDefinitionIdOrName
      : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName))
  })
]

// ============== //
// Resources      //
// ============== //

var telemetryIdPrefix = loadJsonContent('metadata.json', 'telemetryIdPrefix')

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '${telemetryIdPrefix}.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource galleryImage 'Microsoft.AzureStackHCI/galleryImages@2024-01-01' = {
  name: name
  location: location
  tags: tags
  extendedLocation: {
    type: 'CustomLocation'
    name: customLocationResourceId
  }
  properties: {
    imagePath: imagePath
    osType: osType
    hyperVGeneration: hyperVGeneration
    cloudInitDataSource: cloudInitDataSource
    containerId: containerResourceId
    identifier: identifier
    version: version
  }
}

resource galleryImage_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?notes ?? (lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.')
  }
  scope: galleryImage
}

resource galleryImage_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for roleAssignment in formattedRoleAssignments: {
    name: roleAssignment.?name ?? guid(galleryImage.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condition is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: galleryImage
  }
]

// ============ //
// Outputs      //
// ============ //

@description('The name of the gallery image.')
output name string = galleryImage.name

@description('The resource ID of the gallery image. Pass this to the virtual-machine-instance module storageProfile.imageReference.id.')
output resourceId string = galleryImage.id

@description('The resource group the gallery image was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the gallery image was deployed into.')
output location string = galleryImage.location
