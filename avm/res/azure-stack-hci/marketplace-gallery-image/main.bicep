metadata name = 'Azure Stack HCI Marketplace Gallery Image'
metadata description = 'This module deploys an Azure Stack HCI Marketplace Gallery Image.'

// ============== //
//   Parameters   //
// ============== //

@description('Required. Name of the resource to create.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Required. The custom location ID.')
param customLocationResourceId string

@description('Required. Operating system type that the gallery image uses.')
@allowed([
  'Windows'
  'Linux'
])
param osType string

@description('Required. The gallery image identifier configuration containing publisher, offer, and SKU.')
param identifier resourceInput<'Microsoft.AzureStackHCI/marketplaceGalleryImages@2025-04-01-preview'>.properties.identifier

@description('Optional. The hypervisor generation of the Virtual Machine.')
@allowed([
  'V1'
  'V2'
])
param hyperVGeneration string = 'V2'

@description('Optional. Datasource for the gallery image when provisioning with cloud-init.')
@allowed([
  'NoCloud'
  'Azure'
])
param cloudInitDataSource string?

@description('Optional. Storage Container resourceId of the storage container to be used for marketplace gallery image.')
param containerResourceId string?

@description('Required. Gallery image version configuration.')
param version resourceInput<'Microsoft.AzureStackHCI/marketplaceGalleryImages@2025-04-01-preview'>.properties.version

@description('Optional. Tags for the marketplace gallery image.')
param tags resourceInput<'Microsoft.AzureStackHCI/marketplaceGalleryImages@2025-04-01-preview'>.tags?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

var builtInRoleNames = {
  // Add other relevant built-in roles here for your resource as per BCPNFR5
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'User Access Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  )
  'Role Based Access Control Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
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

// ============= //
//   Resources   //
// ============= //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: take(
    '46d3xbcp.res.azurestackhci-markplgalleryimg.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}',
    64
  )
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

resource marketplaceGalleryImage 'Microsoft.AzureStackHCI/marketplaceGalleryImages@2025-04-01-preview' = {
  name: name
  location: location
  tags: tags
  extendedLocation: {
    name: customLocationResourceId
    type: 'CustomLocation'
  }
  properties: {
    cloudInitDataSource: cloudInitDataSource
    containerId: containerResourceId
    hyperVGeneration: hyperVGeneration
    identifier: {
      offer: identifier.offer
      publisher: identifier.publisher
      sku: identifier.sku
    }
    osType: osType
    version: version
  }
}

resource marketplaceGalleryImage_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(
      marketplaceGalleryImage.id,
      roleAssignment.principalId,
      roleAssignment.roleDefinitionId
    )
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: marketplaceGalleryImage
  }
]

@description('The name of the marketplace gallery image.')
output name string = marketplaceGalleryImage.name

@description('The resource ID of the marketplace gallery image.')
output resourceId string = marketplaceGalleryImage.id

@description('The resource group of the marketplace gallery image.')
output resourceGroupName string = resourceGroup().name

@description('The location of the marketplace gallery image.')
output location string = marketplaceGalleryImage.location
