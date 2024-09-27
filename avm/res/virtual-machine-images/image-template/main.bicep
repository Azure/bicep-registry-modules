metadata name = 'Virtual Machine Image Templates'
metadata description = 'This module deploys a Virtual Machine Image Template that can be consumed by Azure Image Builder (AIB).'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name prefix of the Image Template to be built by the Azure Image Builder service.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. The image build timeout in minutes. 0 means the default 240 minutes.')
@minValue(0)
@maxValue(960)
param buildTimeoutInMinutes int = 0

@description('Optional. Specifies the size for the VM.')
param vmSize string = 'Standard_D2s_v3'

@description('Optional. Specifies the size of OS disk.')
param osDiskSizeGB int = 128

@description('Optional. Resource ID of an already existing subnet, e.g.: /subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Network/virtualNetworks/<vnetName>/subnets/<subnetName>.</p>If no value is provided, a new temporary VNET and subnet will be created in the staging resource group and will be deleted along with the remaining temporary resources.')
param subnetResourceId string?

@description('Required. Image source definition in object format.')
param imageSource object

@description('Optional. Customization steps to be run when building the VM image.')
param customizationSteps array?

@description('Optional. Resource ID of the staging resource group in the same subscription and location as the image template that will be used to build the image.</p>If this field is empty, a resource group with a random name will be created.</p>If the resource group specified in this field doesn\'t exist, it will be created with the same name.</p>If the resource group specified exists, it must be empty and in the same region as the image template.</p>The resource group created will be deleted during template deletion if this field is empty or the resource group specified doesn\'t exist,</p>but if the resource group specified exists the resources created in the resource group will be deleted during template deletion and the resource group itself will remain.')
param stagingResourceGroupResourceId string?

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Tags of the resource.')
param tags object?

@description('Generated. Do not provide a value! This date value is used to generate a unique image template name.')
param baseTime string = utcNow('yyyy-MM-dd-HH-mm-ss')

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Required. The distribution targets where the image output needs to go to.')
param distributions distributionType[]

@description('Optional. List of User-Assigned Identities associated to the Build VM for accessing Azure resources such as Key Vaults from your customizer scripts. Be aware, the user assigned identities specified in the \'managedIdentities\' parameter must have the \'Managed Identity Operator\' role assignment on all the user assigned identities specified in this parameter for Azure Image Builder to be able to associate them to the build VM.')
param vmUserAssignedIdentities array = []

@description('Required. The managed identity definition for this resource.')
param managedIdentities managedIdentitiesType

@description('Optional. Configuration options and list of validations to be performed on the resulting image.')
param validationProcess validationProcessType

@allowed([
  'Enabled'
  'Disabled'
])
@description('Optional. The optimize property can be enabled while creating a VM image and allows VM optimization to improve image creation time.')
param optimizeVmBoot string?

var identity = {
  type: 'UserAssigned'
  userAssignedIdentities: reduce(
    map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
    {},
    (cur, next) => union(cur, next)
  ) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }
}

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
  name: '46d3xbcp.res.virtualmachineimages-imagetemplate.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource imageTemplate 'Microsoft.VirtualMachineImages/imageTemplates@2023-07-01' = {
  #disable-next-line use-stable-resource-identifiers // Disabling as ImageTemplates are not idempotent and hence always must have new name
  name: '${name}-${baseTime}'
  location: location
  tags: tags
  identity: identity
  properties: {
    buildTimeoutInMinutes: buildTimeoutInMinutes
    vmProfile: {
      vmSize: vmSize
      osDiskSizeGB: osDiskSizeGB
      userAssignedIdentities: vmUserAssignedIdentities
      vnetConfig: !empty(subnetResourceId)
        ? {
            subnetId: subnetResourceId
          }
        : null
    }
    source: imageSource
    customize: customizationSteps
    stagingResourceGroup: stagingResourceGroupResourceId
    distribute: [
      for distribution in distributions: union(
        {
          type: distribution.type
          artifactTags: distribution.?artifactTags ?? {
            sourceType: imageSource.type
            sourcePublisher: imageSource.?publisher
            sourceOffer: imageSource.?offer
            sourceSku: imageSource.?sku
            sourceVersion: imageSource.?version
            sourceImageId: imageSource.?imageId
            sourceImageVersionID: imageSource.?imageVersionID
            creationTime: baseTime
          }
        },
        (distribution.type == 'ManagedImage'
          ? {
              runOutputName: distribution.?runOutputName ?? '${distribution.imageName}-${baseTime}-ManagedImage'
              location: distribution.?location ?? location
              #disable-next-line use-resource-id-functions // Disabling rule as this is an input parameter that is used inside an array.
              imageId: distribution.?imageResourceId ?? '${subscription().id}/resourceGroups/${resourceGroup().name}/providers/Microsoft.Compute/images/${distribution.imageName}-${baseTime}'
            }
          : {}),
        (distribution.type == 'SharedImage'
          ? {
              runOutputName: distribution.?runOutputName ?? (!empty(distribution.?sharedImageGalleryImageDefinitionResourceId)
                ? '${last(split((distribution.sharedImageGalleryImageDefinitionResourceId ?? '/'), '/'))}-SharedImage'
                : 'SharedImage')
              galleryImageId: !empty(distribution.?sharedImageGalleryImageDefinitionTargetVersion)
                ? '${distribution.sharedImageGalleryImageDefinitionResourceId}/versions/${distribution.sharedImageGalleryImageDefinitionTargetVersion}'
                : distribution.sharedImageGalleryImageDefinitionResourceId
              excludeFromLatest: distribution.?excludeFromLatest ?? false
              replicationRegions: distribution.?replicationRegions ?? [location]
              storageAccountType: distribution.?storageAccountType ?? 'Standard_LRS'
            }
          : {}),
        (distribution.type == 'VHD'
          ? {
              runOutputName: distribution.?runOutputName ?? '${distribution.imageName}-VHD'
            }
          : {})
      )
    ]
    validate: validationProcess
    optimize: optimizeVmBoot != null
      ? {
          vmBoot: {
            state: optimizeVmBoot
          }
        }
      : null
  }
}

resource imageTemplate_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: imageTemplate
}

resource imageTemplate_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(imageTemplate.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: imageTemplate
  }
]

@description('The resource ID of the image template.')
output resourceId string = imageTemplate.id

@description('The resource group the image template was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The full name of the deployed image template.')
output name string = imageTemplate.name

@description('The prefix of the image template name provided as input.')
output namePrefix string = name

@description('The command to run in order to trigger the image build.')
output runThisCommand string = 'Invoke-AzResourceAction -ResourceName ${imageTemplate.name} -ResourceGroupName ${resourceGroup().name} -ResourceType Microsoft.VirtualMachineImages/imageTemplates -Action Run -Force'

@description('The location the resource was deployed into.')
output location string = imageTemplate.location

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

type managedIdentitiesType = {
  @description('Optional. The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption.')
  userAssignedResourceIds: string[]
}

@discriminator('type')
type distributionType = sharedImageDistributionType | managedImageDistributionType | unManagedDistributionType

type sharedImageDistributionType = {
  @description('Optional. The name to be used for the associated RunOutput. If not provided, a name will be calculated.')
  runOutputName: string?

  @description('Optional. Tags that will be applied to the artifact once it has been created/updated by the distributor. If not provided will set tags based on the provided image source.')
  artifactTags: object?

  @description('Required. The type of distribution.')
  type: 'SharedImage'

  @description('Conditional. Resource ID of Compute Gallery Image Definition to distribute image to, e.g.: /subscriptions/<subscriptionID>/resourceGroups/<SIG resourcegroup>/providers/Microsoft.Compute/galleries/<SIG name>/images/<image definition>.')
  sharedImageGalleryImageDefinitionResourceId: string

  @description('Optional. Version of the Compute Gallery Image. Supports the following Version Syntax: Major.Minor.Build (i.e., \'1.1.1\' or \'10.1.2\'). If not provided, a version will be calculated.')
  sharedImageGalleryImageDefinitionTargetVersion: string?

  @description('Optional. The exclude from latest flag of the image. Defaults to [false].')
  excludeFromLatest: bool?

  @description('Optional. The replication regions of the image. Defaults to the value of the \'location\' parameter.')
  replicationRegions: string[]?

  @description('Optional. The storage account type of the image. Defaults to [Standard_LRS].')
  storageAccountType: ('Standard_LRS' | 'Standard_ZRS')?
}

type unManagedDistributionType = {
  @description('Required. The type of distribution.')
  type: 'VHD'

  @description('Optional. The name to be used for the associated RunOutput. If not provided, a name will be calculated.')
  runOutputName: string?

  @description('Optional. Tags that will be applied to the artifact once it has been created/updated by the distributor. If not provided will set tags based on the provided image source.')
  artifactTags: object?

  @description('Conditional. Name of the managed or unmanaged image that will be created.')
  imageName: string
}

type managedImageDistributionType = {
  @description('Required. The type of distribution.')
  type: 'ManagedImage'

  @description('Optional. The name to be used for the associated RunOutput. If not provided, a name will be calculated.')
  runOutputName: string?

  @description('Optional. Tags that will be applied to the artifact once it has been created/updated by the distributor. If not provided will set tags based on the provided image source.')
  artifactTags: object?

  @description('Optional. Azure location for the image, should match if image already exists. Defaults to the value of the \'location\' parameter.')
  location: string?

  @description('Required. The resource ID of the managed image. Defaults to a compute image with name \'imageName-baseTime\' in the current resource group.')
  imageResourceId: string?

  @description('Conditional. Name of the managed or unmanaged image that will be created.')
  imageName: string
}

type validationProcessType = {
  @description('Optional. If validation fails and this field is set to false, output image(s) will not be distributed. This is the default behavior. If validation fails and this field is set to true, output image(s) will still be distributed. Please use this option with caution as it may result in bad images being distributed for use. In either case (true or false), the end to end image run will be reported as having failed in case of a validation failure. [Note: This field has no effect if validation succeeds.].')
  continueDistributeOnFailure: bool?

  @description('Optional. A list of validators that will be performed on the image. Azure Image Builder supports File, PowerShell and Shell validators.')
  inVMValidations: {
    @description('Required. The type of validation.')
    type: ('PowerShell' | 'Shell' | 'File')

    @description('Optional. Friendly Name to provide context on what this validation step does.')
    name: string?

    @description('Optional. URI of the PowerShell script to be run for validation. It can be a github link, Azure Storage URI, etc.')
    scriptUri: string?

    @description('Optional. Array of commands to be run, separated by commas.')
    inline: string[]?

    @description('Optional. Valid codes that can be returned from the script/inline command, this avoids reported failure of the script/inline command.')
    validExitCodes: int[]?

    @description('Optional. Value of sha256 checksum of the file, you generate this locally, and then Image Builder will checksum and validate.')
    sha256Checksum: string?

    @description('Optional. The source URI of the file.')
    sourceUri: string?

    @description('Optional. Destination of the file.')
    destination: string?

    @description('Optional. If specified, the PowerShell script will be run with elevated privileges using the Local System user. Can only be true when the runElevated field above is set to true.')
    runAsSystem: bool?

    @description('Optional. If specified, the PowerShell script will be run with elevated privileges.')
    runElevated: bool?
  }[]?

  @description('Optional. If this field is set to true, the image specified in the \'source\' section will directly be validated. No separate build will be run to generate and then validate a customized image. Not supported when performing customizations, validations or distributions on the image.')
  sourceValidationOnly: bool?
}?
