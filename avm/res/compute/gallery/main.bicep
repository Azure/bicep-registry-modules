metadata name = 'Azure Compute Galleries'
metadata description = 'This module deploys an Azure Compute Gallery (formerly known as Shared Image Gallery).'
metadata owner = 'Azure/module-maintainers'

@minLength(1)
@sys.description('Required. Name of the Azure Compute Gallery.')
param name string

@sys.description('Optional. Location for all resources.')
param location string = resourceGroup().location

@sys.description('Optional. Description of the Azure Shared Image Gallery.')
param description string = ''

@sys.description('Optional. Applications to create.')
param applications array = []

@sys.description('Optional. Images to create.')
param images array = []

@sys.description('Optional. The lock settings of the service.')
param lock lockType

@sys.description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments roleAssignmentType

@sys.description('Optional. Tags for all resources.')
param tags object?

@sys.description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

var enableReferencedModulesTelemetry = false

var builtInRoleNames = {
  'Compute Gallery Sharing Admin': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '1ef6a3be-d0ac-425d-8c01-acb62866290b')
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f58310d9-a9f6-439a-9e8d-f62e7b41a168')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
}

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource gallery 'Microsoft.Compute/galleries@2022-03-03' = {
  name: name
  location: location
  tags: tags
  properties: {
    description: description
    identifier: {}
  }
}

resource gallery_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot delete or modify the resource or child resources.'
  }
  scope: gallery
}

resource gallery_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (roleAssignment, index) in (roleAssignments ?? []): {
  name: guid(gallery.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : contains(roleAssignment.roleDefinitionIdOrName, '/providers/Microsoft.Authorization/roleDefinitions/') ? roleAssignment.roleDefinitionIdOrName : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName)
    principalId: roleAssignment.principalId
    description: roleAssignment.?description
    principalType: roleAssignment.?principalType
    condition: roleAssignment.?condition
    conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
    delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
  }
  scope: gallery
}]

// Applications
module galleries_applications 'application/main.bicep' = [for (application, index) in applications: {
  name: '${uniqueString(deployment().name, location)}-Gallery-Application-${index}'
  params: {
    name: application.name
    galleryName: gallery.name
    supportedOSType: contains(application, 'supportOSType') ? application.supportedOSType : 'Windows'
    description: contains(application, 'description') ? application.description : ''
    eula: contains(application, 'eula') ? application.eula : ''
    privacyStatementUri: contains(application, 'privacyStatementUri') ? application.privacyStatementUri : ''
    releaseNoteUri: contains(application, 'releaseNoteUri') ? application.releaseNoteUri : ''
    endOfLifeDate: contains(application, 'endOfLifeDate') ? application.endOfLifeDate : ''
    roleAssignments: contains(application, 'roleAssignments') ? application.roleAssignments : []
    customActions: contains(application, 'customActions') ? application.customActions : []
    tags: application.?tags ?? tags
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

// Images
module galleries_images 'image/main.bicep' = [for (image, index) in images: {
  name: '${uniqueString(deployment().name, location)}-Gallery-Image-${index}'
  params: {
    name: image.name
    galleryName: gallery.name
    osType: contains(image, 'osType') ? image.osType : 'Windows'
    osState: contains(image, 'osState') ? image.osState : 'Generalized'
    publisher: contains(image, 'publisher') ? image.publisher : 'MicrosoftWindowsServer'
    offer: contains(image, 'offer') ? image.offer : 'WindowsServer'
    sku: contains(image, 'sku') ? image.sku : '2019-Datacenter'
    minRecommendedvCPUs: contains(image, 'minRecommendedvCPUs') ? image.minRecommendedvCPUs : 1
    maxRecommendedvCPUs: contains(image, 'maxRecommendedvCPUs') ? image.maxRecommendedvCPUs : 4
    minRecommendedMemory: contains(image, 'minRecommendedMemory') ? image.minRecommendedMemory : 4
    maxRecommendedMemory: contains(image, 'maxRecommendedMemory') ? image.maxRecommendedMemory : 16
    hyperVGeneration: contains(image, 'hyperVGeneration') ? image.hyperVGeneration : 'V1'
    securityType: contains(image, 'securityType') ? image.securityType : 'Standard'
    description: contains(image, 'description') ? image.description : ''
    eula: contains(image, 'eula') ? image.eula : ''
    privacyStatementUri: contains(image, 'privacyStatementUri') ? image.privacyStatementUri : ''
    releaseNoteUri: contains(image, 'releaseNoteUri') ? image.releaseNoteUri : ''
    productName: contains(image, 'productName') ? image.productName : ''
    planName: contains(image, 'planName') ? image.planName : ''
    planPublisherName: contains(image, 'planPublisherName') ? image.planPublisherName : ''
    endOfLife: contains(image, 'endOfLife') ? image.endOfLife : ''
    excludedDiskTypes: contains(image, 'excludedDiskTypes') ? image.excludedDiskTypes : []
    roleAssignments: contains(image, 'roleAssignments') ? image.roleAssignments : []
    tags: image.?tags ?? tags
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

@sys.description('The resource ID of the deployed image gallery.')
output resourceId string = gallery.id

@sys.description('The resource group of the deployed image gallery.')
output resourceGroupName string = resourceGroup().name

@sys.description('The name of the deployed image gallery.')
output name string = gallery.name

@sys.description('The location the resource was deployed into.')
output location string = gallery.location

// =============== //
//   Definitions   //
// =============== //

type lockType = {
  @sys.description('Optional. Specify the name of lock.')
  name: string?

  @sys.description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

type roleAssignmentType = {
  @sys.description('Required. The name of the role to assign. If it cannot be found you can specify the role definition ID instead.')
  roleDefinitionIdOrName: string

  @sys.description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
  principalId: string

  @sys.description('Optional. The principal type of the assigned principal ID.')
  principalType: ('ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup' | 'Device')?

  @sys.description('Optional. The description of the role assignment.')
  description: string?

  @sys.description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container"')
  condition: string?

  @sys.description('Optional. Version of the condition.')
  conditionVersion: '2.0'?

  @sys.description('Optional. The Resource Id of the delegated managed identity resource.')
  delegatedManagedIdentityResourceId: string?
}[]?
