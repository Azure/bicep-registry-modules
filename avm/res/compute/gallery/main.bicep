metadata name = 'Azure Compute Galleries'
metadata description = 'This module deploys an Azure Compute Gallery (formerly known as Shared Image Gallery).'
metadata owner = 'Azure/module-maintainers'

@minLength(1)
@sys.description('Required. Name of the Azure Compute Gallery.')
param name string

@sys.description('Optional. Location for all resources.')
param location string = resourceGroup().location

@sys.description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

// ============ //
// Parameters   //
// ============ //

@sys.description('Optional. Description of the Azure Shared Image Gallery.')
param description string?

@sys.description('Optional. Applications to create.')
param applications array?

@sys.description('Optional. Images to create.')
param images imageType[]?

@sys.description('Optional. The lock settings of the service.')
param lock lockType?

@sys.description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType?

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
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
  'User Access Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  )
}

// ============== //
// Resources      //
// ============== //

resource avmTelemetry 'Microsoft.Resources/deployments@2023-07-01' = if (enableTelemetry) {
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

resource gallery 'Microsoft.Compute/galleries@2022-03-03' = {
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
  for (roleAssignment, index) in (roleAssignments ?? []): {
    name: guid(gallery.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
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
      location: image.?location ?? location
      name: image.name
      galleryName: gallery.name
      osType: image.properties.osType
      osState: image.?properties.osState ?? 'Generalized'
      publisher: image.properties.identifier.publisher
      offer: image.properties.identifier.offer ?? image.offer // offer is deprecated. use identifier.offer instead
      sku: image.properties.identifier.sku
      minRecommendedvCPUs: image.?properties.recommended.vCPUs.min
      maxRecommendedvCPUs: image.?properties.recommended.vCPUs.max
      minRecommendedMemory: image.?properties.recommended.memory.min
      maxRecommendedMemory: image.?properties.recommended.memory.min
      hyperVGeneration: image.?properties.hyperVGeneration
      securityType: image.?securityType ?? 'Standard'
      isAcceleratedNetworkSupported: image.?isAcceleratedNetworkSupported ?? true
      description: image.?description
      eula: image.?properties.eula
      privacyStatementUri: image.?properties.privacyStatementUri
      releaseNoteUri: image.?properties.releaseNoteUri
      productName: image.?properties.purchasePlan.product
      planName: image.?properties.purchasePlan.name
      planPublisherName: image.?properties.purchasePlan.publisher
      endOfLife: image.?properties.endOfLife
      excludedDiskTypes: image.?properties.disallowed.excludedDiskTypes
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

type lockType = {
  @sys.description('Optional. Specify the name of lock.')
  name: string?

  @sys.description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}

type roleAssignmentType = {
  @sys.description('Required. The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
  roleDefinitionIdOrName: string

  @sys.description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
  principalId: string

  @sys.description('Optional. The principal type of the assigned principal ID.')
  principalType: ('ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup' | 'Device')?

  @sys.description('Optional. The description of the role assignment.')
  description: string?

  @sys.description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".')
  condition: string?

  @sys.description('Optional. Version of the condition.')
  conditionVersion: '2.0'?

  @sys.description('Optional. The Resource Id of the delegated managed identity resource.')
  delegatedManagedIdentityResourceId: string?
}[]

type imageType = {
  @sys.description('Required. The resource name.')
  @minLength(1)
  @maxLength(80)
  name: string

  @sys.description('Optional. The location of the resource. Defaults to the gallery resource location.')
  location: string?

  @sys.description('Optional. Tags for all resources. Defaults to the tags of the gallery.')
  @metadata({
    example: '''
  {
      key1: 'value1'
      key2: 'value2'
  }
  '''
  })
  tags: object?

  @sys.description('Optional. Describes the properties of a gallery image definition.')
  properties: {
    @sys.description('Optional. The description of this gallery image definition resource. This property is updatable.')
    description: string?

    @sys.description('Optional. Describes the disallowed disk types.')
    disallowed: {
      @sys.description('Required. A list of disk types.')
      @metadata({ example: '''[
        'Standard_LRS'
      ]''' })
      diskTypes: string[]
    }?

    @sys.description('Optional. The end of life date of the gallery image definition. This property can be used for decommissioning purposes. This property is updatable.')
    endOfLife: string?

    @sys.description('Optional. The Eula agreement for the gallery image definition.')
    eula: string?

    @sys.description('Optional. The hypervisor generation of the Virtual Machine. If this value is not specified, then it is determined by the securityType parameter. If the securityType parameter is specified, then the value of hyperVGeneration will be V2, else V1.')
    hyperVGeneration: ('V1' | 'V2')?

    @sys.description('Optional. This property allows the user to specify whether the virtual machines created under this image are `Generalized` or `Specialized`.')
    osType: ('Generalized' | 'Specialized')?

    @sys.description('Required. This property allows you to specify the type of the OS that is included in the disk when creating a VM from a managed image. Possible values are: `Windows`, `Linux`.')
    osState: ('Linux' | 'Windows')

    @sys.description('Required. This is the gallery image definition identifier.')
    identifier: {
      @sys.description('Required. The name of the gallery image definition offer.')
      publisher: string

      @sys.description('Required. The name of the gallery image definition publisher.')
      offer: string

      @sys.description('Required. The name of the gallery image definition SKU.')
      sku: string
    }

    @sys.description('Optional. The privacy statement uri.')
    privacyStatementUri: string?

    @sys.description('Optional. Describes the gallery image definition purchase plan. This is used by marketplace images.')
    purchasePlan: {
      @sys.description('Required. The plan ID.')
      name: string

      @sys.description('Required. The product ID.')
      product: string

      @sys.description('Required. The publisher ID.')
      publisher: string
    }?

    @sys.description('Optional. The properties describe the recommended machine configuration for this Image Definition. These properties are updatable.')
    recommended: {
      @sys.description('Optional. Describes the resource range (1-128 CPU cores). Defaults to min=1, max=4.')
      vCPUs: resourceRangeType?

      @sys.description('Optional. Describes the resource range (1-4000 GB RAM). Defaults to min=4, max=16.')
      memory: resourceRangeType?
    }?

    @sys.description('Optional. The release note uri. Has to be a valid URL.')
    releaseNoteUri: string?
  }?

  @sys.description('Optional. The security type of the image. Requires a hyperVGeneration V2. Defaults to `Standard`.')
  securityType: ('Standard' | 'TrustedLaunch' | 'ConfidentialVM' | 'ConfidentialVMSupported')?

  @sys.description('Optional. Specify if the image supports accelerated networking. Accelerated networking enables single root I/O virtualization (SR-IOV) to a VM, greatly improving its networking performance. This high-performance path bypasses the host from the data path, which reduces latency, jitter, and CPU utilization for the most demanding network workloads on supported VM types. Defaults to true.')
  isAcceleratedNetworkSupported: bool?

  @sys.description('Optional. Specifiy if the image supports hibernation.')
  isHibernateSupported: bool?

  @sys.description('Optional. Note: This is a deprecated property, please use the corresponding  `identifier.offer` instead.')
  offer: string?

  @sys.description('Optional. Note: This is a deprecated property, please use the corresponding  `identifier.publisher` instead.')
  publisher: string?

  @sys.description('Optional. Note: This is a deprecated property, please use the corresponding  `identifier.sku` instead.')
  sku: string?

  @sys.description('Optional. Note: This is a deprecated property, please use the corresponding `osState` instead.')
  osType: string?

  @sys.description('Optional. Note: This is a deprecated property, please use the corresponding `hyperVGeneration` instead.')
  hyperVGeneration: string?

  @sys.description('Optional. Note: This is a deprecated property, please use the corresponding `osType` instead.')
  osState: string?

  @sys.description('Optional. Note: This is a deprecated property, please use the corresponding `recommended.memory.min` instead.')
  minRecommendedMemory: int?

  @sys.description('Optional. Note: This is a deprecated property, please use the corresponding `recommended.memory.max` instead.')
  maxRecommendedMemory: int?

  @sys.description('Optional. Note: This is a deprecated property, please use the corresponding `recommended.vCPUs.min` instead.')
  minRecommendedvCPUs: int?

  @sys.description('Optional. Note: This is a deprecated property, please use the corresponding `recommended.vCPUs.max` instead.')
  maxRecommendedvCPUs: int?
}

type resourceRangeType = {
  @sys.description('Optional. The minimum number of the resource.')
  min: int?

  @sys.description('Optional. The minimum number of the resource.')
  max: int?
}
