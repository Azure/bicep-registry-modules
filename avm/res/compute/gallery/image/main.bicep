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

@sys.description('Required. OS type of the image to be created.')
@allowed([
  'Windows'
  'Linux'
])
param osType string

@sys.description('Optional. This property allows the user to specify whether the virtual machines created under this image are \'Generalized\' or \'Specialized\'.')
@allowed([
  'Generalized'
  'Specialized'
])
param osState string = 'Generalized'

@sys.description('Required. The name of the gallery Image Definition publisher.')
param publisher string

@sys.description('Required. The name of the gallery Image Definition offer.')
param offer string

@sys.description('Required. The name of the gallery Image Definition SKU.')
param sku string

@sys.description('Optional. The minimum number of the CPU cores recommended for this image.')
@minValue(1)
@maxValue(128)
param minRecommendedvCPUs int = 1

@sys.description('Optional. The maximum number of the CPU cores recommended for this image.')
@minValue(1)
@maxValue(128)
param maxRecommendedvCPUs int = 4

@sys.description('Optional. The minimum amount of RAM in GB recommended for this image.')
@minValue(1)
@maxValue(4000)
param minRecommendedMemory int = 4

@sys.description('Optional. The maximum amount of RAM in GB recommended for this image.')
@minValue(1)
@maxValue(4000)
param maxRecommendedMemory int = 16

@sys.description('''Optional. The hypervisor generation of the Virtual Machine.
- If this value is not specified, then it is determined by the securityType parameter.
- If the securityType parameter is specified, then the value of hyperVGeneration will be V2, else V1.
''')
@allowed([
  'V1'
  'V2'
])
param hyperVGeneration string?

@sys.description('Optional. The security type of the image. Requires a hyperVGeneration V2.')
@allowed([
  'Standard'
  'TrustedLaunch'
  'ConfidentialVM'
  'ConfidentialVMSupported'
])
param securityType string = 'Standard'

@sys.description('Optional. Specifiy if the image supports hibernation.')
param isHibernateSupported bool = false

@sys.description('''Optional. Specify if the image supports accelerated networking.
Accelerated networking enables single root I/O virtualization (SR-IOV) to a VM, greatly improving its networking performance.
This high-performance path bypasses the host from the data path, which reduces latency, jitter, and CPU utilization for the most demanding network workloads on supported VM types.
''')
param isAcceleratedNetworkSupported bool = true

@sys.description('Optional. The description of this gallery Image Definition resource. This property is updatable.')
param description string?

@sys.description('Optional. The Eula agreement for the gallery Image Definition. Has to be a valid URL.')
param eula string?

@sys.description('Optional. The privacy statement uri. Has to be a valid URL.')
param privacyStatementUri string?

@sys.description('Optional. The release note uri. Has to be a valid URL.')
param releaseNoteUri string?

@sys.description('Optional. The product ID.')
param productName string?

@sys.description('Optional. The plan ID.')
param planName string?

@sys.description('Optional. The publisher ID.')
param planPublisherName string?

@sys.description('Optional. The end of life date of the gallery Image Definition. This property can be used for decommissioning purposes. This property is updatable. Allowed format: 2020-01-10T23:00:00.000Z.')
param endOfLife string = ''

@sys.description('Optional. List of the excluded disk types (e.g., Standard_LRS).')
param excludedDiskTypes array = []

@sys.description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@sys.description('Optional. Tags for all resources.')
param tags object?

var builtInRoleNames = {
  'Compute Gallery Sharing Admin': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '1ef6a3be-d0ac-425d-8c01-acb62866290b')
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f58310d9-a9f6-439a-9e8d-f62e7b41a168')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
}

resource gallery 'Microsoft.Compute/galleries@2022-03-03' existing = {
  name: galleryName
}

resource image 'Microsoft.Compute/galleries/images@2022-03-03' = {
  name: name
  parent: gallery
  location: location
  tags: tags
  properties: {
    osType: osType
    osState: osState
    identifier: {
      publisher: publisher
      offer: offer
      sku: sku
    }
    recommended: {
      vCPUs: {
        min: minRecommendedvCPUs
        max: maxRecommendedvCPUs
      }
      memory: {
        min: minRecommendedMemory
        max: maxRecommendedMemory
      }
    }
    hyperVGeneration: hyperVGeneration ?? (!empty(securityType) ? 'V2' : 'V1')
    features: union([
        {
          name: 'IsAcceleratedNetworkSupported'
          value: '${isAcceleratedNetworkSupported}'
        }
        {
          name: 'IsHibernateSupported'
          value: '${isHibernateSupported}'
        }
      ],
      (securityType != 'Standard' ? [
        {
          name: 'SecurityType'
          value: securityType
        }
      ] : []))
    description: description
    eula: eula
    privacyStatementUri: privacyStatementUri
    releaseNoteUri: releaseNoteUri
    purchasePlan: {
      product: productName
      name: planName
      publisher: planPublisherName
    }
    endOfLifeDate: endOfLife
    disallowed: {
      diskTypes: excludedDiskTypes
    }
  }
}

resource image_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (roleAssignment, index) in (roleAssignments ?? []): {
  name: guid(image.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : contains(roleAssignment.roleDefinitionIdOrName, '/providers/Microsoft.Authorization/roleDefinitions/') ? roleAssignment.roleDefinitionIdOrName : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName)
    principalId: roleAssignment.principalId
    description: roleAssignment.?description
    principalType: roleAssignment.?principalType
    condition: roleAssignment.?condition
    conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
    delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
  }
  scope: image
}]

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
