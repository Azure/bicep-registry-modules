metadata name = 'Compute Galleries Image Definitions'
metadata description = 'This module deploys an Azure Compute Gallery Image Definition.'
metadata owner = 'Azure/module-maintainers'

@sys.description('Required. Name of the image definition.')
param name string

@sys.description('Optional. Location for all resources.')
param location string = resourceGroup().location

@sys.description('Conditional. The name of the parent Azure Shared Image Gallery. Required if the template is used in a standalone deployment.')
@minLength(1)
param galleryName string

@description('Required. Properties used to create the image.')
param galleryImage imageType

@sys.description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@sys.description('Optional. Tags for all resources. This takes precedence over the tags of the galleryImage.tags property.')
param tags object?

var builtInRoleNames = {
  'Compute Gallery Sharing Admin': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '1ef6a3be-d0ac-425d-8c01-acb62866290b')
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f58310d9-a9f6-439a-9e8d-f62e7b41a168')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
}

resource gallery 'Microsoft.Compute/galleries@2023-07-03' existing = {
  name: galleryName
}

resource image 'Microsoft.Compute/galleries/images@2023-07-03' = {
  name: name
  parent: gallery
  location: location
  tags: tags // use from the parameter, as the galleryImage.tags have been stored there in the gallery.bicep before calling the template
  properties: {
    architecture: galleryImage.properties.?architecture
    description: galleryImage.properties.?description
    disallowed: {
      diskTypes: galleryImage.properties.?disallowed.?diskTypes ?? []
    }
    endOfLifeDate: galleryImage.properties.?endOfLifeDate
    eula: galleryImage.properties.?eula
    features: union(
      ((galleryImage.?isAcceleratedNetworkSupported ?? true) // sets the default to true if not specified
      ? [
          {
            name: 'IsAcceleratedNetworkSupported'
            value: '${galleryImage.?isAcceleratedNetworkSupported ?? true}'
          }
        ]
      : []),
      ((galleryImage.?isHibernateSupported) != null
        ? [
            {
              name: 'IsHibernateSupported'
              value: '${galleryImage.isHibernateSupported}'
            }
          ]
        : []),
      ((galleryImage.?securityType ?? 'Standard') != 'Standard' // sets the default to Standard if not specified
        ? [
            {
              name: 'SecurityType'
              value: galleryImage.securityType
            }
          ]
        : [])
    )
    hyperVGeneration: galleryImage.properties.hyperVGeneration ?? (!empty(galleryImage.?securityType) ? 'V2' : 'V1')
    identifier: {
      publisher: galleryImage.properties.identifier.publisher
      offer: galleryImage.properties.identifier.offer
      sku: galleryImage.properties.identifier.sku
    }
    osState: galleryImage.properties.osState
    osType: galleryImage.properties.osType
    privacyStatementUri: galleryImage.properties.?privacyStatementUri
    purchasePlan: galleryImage.properties.?purchasePlan ?? null
    recommended: galleryImage.properties.?recommended ?? null
    releaseNoteUri: galleryImage.properties.?releaseNoteUri
  }
}

resource image_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (roleAssignments ?? []): {
    name: guid(image.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
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
    scope: image
  }
]

@sys.description('The resource group the image was deployed into.')
output resourceGroupName string = resourceGroup().name

@sys.description('The resource ID of the image.')
output resourceId string = image.id

@sys.description('The name of the image.')
output name string = image.name

@sys.description('The location the resource was deployed into.')
output location string = image.location

// =============== //
//   Definitions   //
// =============== //

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
}[]?

@export()
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

  @sys.description('Required. Describes the properties of a gallery image definition.')
  properties: {
    @sys.description('Optional. The architecture of the image. Applicable to OS disks only.')
    architecture: 'x64' | 'Arm64'?

    @sys.description('Optional. The description of this gallery image definition resource. This property is updatable.')
    description: string?

    @sys.description('Optional. Describes the disallowed disk types.')
    disallowed: {
      @sys.description('Required. A list of disk types.')
      @metadata({ example: '''
      [
        'Standard_LRS'
      ]''' })
      diskTypes: string[]
    }?

    @sys.description('Optional. The end of life date of the gallery image definition. This property can be used for decommissioning purposes. This property is updatable.')
    endOfLifeDate: string?

    @sys.description('Optional. The Eula agreement for the gallery image definition.')
    eula: string?

    // features are skipped for now, as we prefer typed parameters

    @sys.description('Optional. The hypervisor generation of the Virtual Machine. If this value is not specified, then it is determined by the securityType parameter. If the securityType parameter is specified, then the value of hyperVGeneration will be V2, else V1.')
    hyperVGeneration: 'V1' | 'V2'?

    @sys.description('Required. This is the gallery image definition identifier.')
    identifier: {
      @sys.description('Required. The name of the gallery image definition offer.')
      publisher: string

      @sys.description('Required. The name of the gallery image definition publisher.')
      offer: string

      @sys.description('Required. The name of the gallery image definition SKU.')
      sku: string
    }

    @sys.description('Required. This property allows the user to specify whether the virtual machines created under this image are `Generalized` or `Specialized`.')
    osState: 'Generalized' | 'Specialized'

    @sys.description('Required. This property allows you to specify the type of the OS that is included in the disk when creating a VM from a managed image. Possible values are: `Windows`, `Linux`.')
    osType: 'Linux' | 'Windows'

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
  }

  @sys.description('Optional. The security type of the image. Requires a hyperVGeneration V2. Defaults to `Standard`.')
  securityType: ('Standard' | 'TrustedLaunch' | 'ConfidentialVM' | 'ConfidentialVMSupported')?

  @sys.description('Optional. Specify if the image supports accelerated networking. Defaults to true.')
  isAcceleratedNetworkSupported: bool?

  @sys.description('Optional. Specifiy if the image supports hibernation.')
  isHibernateSupported: bool?

  @sys.description('Optional. Array of role assignments to create.')
  roleAssignments: roleAssignmentType?
}

type resourceRangeType = {
  @sys.description('Optional. The minimum number of the resource.')
  min: int?

  @sys.description('Optional. The minimum number of the resource.')
  max: int?
}
