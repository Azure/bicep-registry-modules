metadata name = 'Azure Compute Galleries'
metadata description = 'This module deploys an Azure Compute Gallery (formerly known as Shared Image Gallery).'

// ============ //
// Parameters   //
// ============ //

@minLength(1)
@sys.description('Required. Name of the Azure Compute Gallery.')
param name string

@sys.description('Optional. Location for all resources.')
param location string = resourceGroup().location

@sys.description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@sys.description('Optional. Description of the Azure Shared Image Gallery.')
param description string?

@sys.description('Optional. Applications to create.')
param applications applicationsType[]?

@sys.description('Optional. Images to create.')
param images imageType[]? // use a UDT here to not overload the main module, as it has images and applications parameters

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.3.0'
@sys.description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.3.0'
@sys.description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@sys.description('Optional. Tags for all resources.')
@metadata({
  example: '''
  {
      key1: 'value1'
      key2: 'value2'
  }
  '''
})
param tags object?

@sys.description('Optional. Profile for gallery sharing to subscription or tenant.')
param sharingProfile object?

@sys.description('Optional. Soft deletion policy of the gallery.')
param softDeletePolicy object?

var builtInRoleNames = {
  'Compute Gallery Sharing Admin': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '1ef6a3be-d0ac-425d-8c01-acb62866290b'
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
  for (roleAssignment, index) in (roleAssignments ?? []): union(roleAssignment, {
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

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.compute-gallery.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource gallery 'Microsoft.Compute/galleries@2023-07-03' = {
  name: name
  location: location
  tags: tags
  properties: {
    description: description
    // identifier: {} // Contains only read-only properties
    sharingProfile: sharingProfile
    softDeletePolicy: softDeletePolicy
  }
}

resource gallery_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: gallery
}

resource gallery_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(gallery.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: gallery
  }
]

module galleries_applications 'application/main.bicep' = [
  for (application, index) in (applications ?? []): {
    name: '${uniqueString(deployment().name, location)}-Gallery-Application-${index}'
    params: {
      location: location
      name: application.name
      galleryName: gallery.name
      supportedOSType: application.supportedOSType
      description: application.?description
      eula: application.?eula
      privacyStatementUri: application.?privacyStatementUri
      releaseNoteUri: application.?releaseNoteUri
      endOfLifeDate: application.?endOfLifeDate
      roleAssignments: application.?roleAssignments
      customActions: application.?customActions
      tags: application.?tags ?? tags
    }
  }
]

module galleries_images 'image/main.bicep' = [
  for (image, index) in (images ?? []): {
    name: '${uniqueString(deployment().name, location)}-Gallery-Image-${index}'
    params: {
      name: image.name
      location: image.?location ?? location
      galleryName: gallery.name
      description: image.?description
      osType: image.osType
      osState: image.osState
      identifier: image.identifier
      vCPUs: image.?vCPUs
      memory: image.?memory
      hyperVGeneration: image.?hyperVGeneration
      securityType: image.?securityType
      isAcceleratedNetworkSupported: image.?isAcceleratedNetworkSupported
      isHibernateSupported: image.?isHibernateSupported
      architecture: image.?architecture
      eula: image.?eula
      privacyStatementUri: image.?privacyStatementUri
      releaseNoteUri: image.?releaseNoteUri
      purchasePlan: image.?purchasePlan
      endOfLifeDate: image.?endOfLife
      disallowed: { diskTypes: image.?excludedDiskTypes ?? [] }
      roleAssignments: image.?roleAssignments
      tags: image.?tags ?? tags
    }
  }
]

// ============ //
// Outputs      //
// ============ //

@sys.description('The resource ID of the deployed image gallery.')
output resourceId string = gallery.id

@sys.description('The resource group of the deployed image gallery.')
output resourceGroupName string = resourceGroup().name

@sys.description('The name of the deployed image gallery.')
output name string = gallery.name

@sys.description('The location the resource was deployed into.')
output location string = gallery.location

@sys.description('The resource ids of the deployed images.')
output imageResourceIds array = [
  for index in range(0, length(images ?? [])): galleries_images[index].outputs.resourceId
]

// =============== //
//   Definitions   //
// =============== //

import { identifierType, purchasePlanType, resourceRangeType } from './image/main.bicep'
@export()
type imageType = {
  @sys.description('Required. Name of the image definition.')
  @minLength(1)
  @maxLength(80)
  name: string

  @sys.description('Optional. The description of this gallery image definition resource. This property is updatable.')
  description: string?

  @sys.description('Required. This property allows you to specify the type of the OS that is included in the disk when creating a VM from a managed image.')
  osType: ('Linux' | 'Windows')

  @sys.description('Required. This property allows the user to specify the state of the OS of the image.')
  osState: ('Generalized' | 'Specialized')

  @sys.description('Required. This is the gallery image definition identifier.')
  identifier: identifierType

  @sys.description('Optional. Describes the resource range (1-128 CPU cores). Defaults to min=1, max=4.')
  vCPUs: resourceRangeType?

  @sys.description('Optional. Describes the resource range (1-4000 GB RAM). Defaults to min=4, max=16.')
  memory: resourceRangeType?

  @sys.description('Optional. The hypervisor generation of the Virtual Machine. If this value is not specified, then it is determined by the securityType parameter. If the securityType parameter is specified, then the value of hyperVGeneration will be V2, else V1.')
  hyperVGeneration: ('V1' | 'V2')?

  @sys.description('Optional. The security type of the image. Requires a hyperVGeneration V2. Defaults to `Standard`.')
  securityType: (
    | 'Standard'
    | 'ConfidentialVM'
    | 'TrustedLaunchSupported'
    | 'TrustedLaunch'
    | 'TrustedLaunchAndConfidentialVmSupported'
    | 'ConfidentialVMSupported')?

  @sys.description('Optional. Specify if the image supports accelerated networking. Defaults to true.')
  isAcceleratedNetworkSupported: bool?

  @sys.description('Optional. Specify if the image supports hibernation.')
  isHibernateSupported: bool?

  @sys.description('Optional. The architecture of the image. Applicable to OS disks only.')
  architecture: ('x64' | 'Arm64')?

  @sys.description('Optional. The Eula agreement for the gallery image definition.')
  eula: string?

  @sys.description('Optional. The privacy statement uri.')
  privacyStatementUri: string?

  @sys.description('Optional. The release note uri. Has to be a valid URL.')
  releaseNoteUri: string?

  @sys.description('Optional. Describes the gallery image definition purchase plan. This is used by marketplace images.')
  purchasePlan: purchasePlanType?

  @sys.description('Optional. The end of life date of the gallery image definition. This property can be used for decommissioning purposes. This property is updatable.')
  endOfLife: string?

  @sys.description('Optional. Describes the disallowed disk types.')
  excludedDiskTypes: string[]?
}

import { customActionType } from './application/main.bicep'
type applicationsType = {
  @sys.description('Required. Name of the application definition.')
  @minLength(1)
  @maxLength(80)
  name: string

  @sys.description('Required. The OS type of the application.')
  supportedOSType: 'Linux' | 'Windows'

  @sys.description('Optional. The description of this gallery application definition resource. This property is updatable.')
  description: string?

  @sys.description('Optional. The Eula agreement for the gallery application definition.')
  eula: string?

  @sys.description('Optional. The privacy statement uri.')
  privacyStatementUri: string?

  @sys.description('Optional. The release note uri. Has to be a valid URL.')
  releaseNoteUri: string?

  @sys.description('Optional. The end of life date of the gallery application definition. This property can be used for decommissioning purposes. This property is updatable.')
  endOfLifeDate: string?

  @sys.description('Optional. Array of role assignments to create.')
  roleAssignments: roleAssignmentType[]?

  @sys.description('Optional. A list of custom actions that can be performed with all of the Gallery Application Versions within this Gallery Application.')
  customActions: customActionType[]?

  @sys.description('Optional. Tags for all resources.')
  tags: object?
}
