metadata name = 'Dev Center'
metadata description = 'This module deploys an Azure Dev Center.'

@description('Required. Name of the Dev Center.')
@minLength(3)
@maxLength(26)
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags resourceInput<'Microsoft.DevCenter/devcenters@2025-02-01'>.tags?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@sys.description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

// mport { customerManagedKeyWithAutoRotateType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
// description('Optional. The customer managed key definition.')
// aram customerManagedKey customerManagedKeyWithAutoRotateType?

@description('Optional. The display name of the Dev Center.')
param displayName string?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Settings to be used in the provisioning of all Dev Boxes that belong to this dev center.')
param devBoxProvisioningSettings devBoxProvisioningSettingsType?

@description('Optional. Network settings that will be enforced on network resources associated with the Dev Center.')
param networkSettings networkSettingsType?

@sys.description('Optional. The catalogs to create in the dev center. Catalogs help you provide a set of curated infrastructure-as-code(IaC) templates, known as environment definitions for your development teams to create environments. You can attach your own source control repository from GitHub or Azure Repos as a catalog and specify the folder with your environment definitions. Deployment Environments scans the folder for environment definitions and makes them available for dev teams to create environments.')
param catalogs catalogType[]?

@description('Optional. Dev Center settings to be used when associating a project with a catalog.')
param projectCatalogSettings projectCatalogSettingsType?

@description('Optional. Define the environment types that development teams can deploy. For example, sandbox, dev, test, and production. A dev center environment type is available to a specific project only after you add an associated project environment type. You can\'t delete a dev center environment type if any existing project environment types or deployed environments reference it.')
param environmentTypes environmentTypeType[]?

@description('Optional. Project policies provide a mechanism to restrict access to certain resources—specifically, SKUs, Images, and Network Connections—to designated projects. Creating a policy does not mean it has automatically been enforced on the selected projects. It must be explicitly assigned to a project as part of the scope property. You must first create the "Default" project policy before you can create any other project policies. The "Default" project policy is automatically assigned to all projects in the Dev Center.')
param projectPolicies projectPolicyType[]?

@description('Optional. The compute galleries to associate with the Dev Center. The Dev Center identity (system or user) must have "Contributor" access to the gallery.')
param galleries devCenterGalleryType[]?

@description('Optional. The attached networks to associate with the Dev Center. You can attach existing network connections to a dev center. You must attach a network connection to a dev center before you can use it in projects to create dev box pools. Network connections enable dev boxes to connect to existing virtual networks. The location, or Azure region, of the network connection determines where associated dev boxes are hosted.')
param attachedNetworks attachedNetworkType[]?

@description('Optional. The DevBox definitions to create in the Dev Center. A DevBox definition specifies the source operating system image and compute size, including CPU, memory, and storage. Dev Box definitions are used to create DevBox pools.')
param devboxDefinitions devboxDefinitionType[]?

@description('Optional. The projects to create in the Dev Center. A project is the point of access to Microsoft Dev Box for the development team members. A project contains dev box pools, which specify the dev box definitions and network connections used when dev boxes are created. Each project is associated with a single dev center. When you associate a project with a dev center, all the settings at the dev center level are applied to the project automatically.')
param projects projectType[]?

var enableReferencedModulesTelemetry = false

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned')
        : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : 'None')
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'DevCenter Project Admin': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '331c37c6-af14-46d9-b9f4-e1909e1b95a0'
  )
  'DevCenter Dev Box User': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '45d50f46-0b78-4001-a660-4198cbe8cd05'
  )
  'DevTest Labs User': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '76283e04-6283-4c54-8f91-bcf1374a3c64'
  )
  'Deployment Environments User': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18e40d4e-8d2e-438d-97e1-9528336e149c'
  )
  'Deployment Environments Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'eb960402-bf75-4cc3-8d68-35b34f960f72'
  )
  'Network Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '4d97b98b-1d4f-4787-a291-c67834d212e7'
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

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res-devcenter-devcenter.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

// resource cMKUserAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' existing = if (!empty(customerManagedKey.?userAssignedIdentityResourceId)) {
//   name: last(split(customerManagedKey.?userAssignedIdentityResourceId!, '/'))
//   scope: resourceGroup(
//     split(customerManagedKey.?userAssignedIdentityResourceId!, '/')[2],
//     split(customerManagedKey.?userAssignedIdentityResourceId!, '/')[4]
//   )
// }
//
// resource cMKKeyVault 'Microsoft.KeyVault/vaults@2024-11-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId)) {
//   name: last(split(customerManagedKey.?keyVaultResourceId!, '/'))
//   scope: resourceGroup(
//     split(customerManagedKey.?keyVaultResourceId!, '/')[2],
//     split(customerManagedKey.?keyVaultResourceId!, '/')[4]
//   )
//
//   resource cMKKey 'keys@2024-11-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId) && !empty(customerManagedKey.?keyName)) {
//     name: customerManagedKey.?keyName!
//   }
// }

resource devcenter 'Microsoft.DevCenter/devcenters@2025-02-01' = {
  name: name
  location: location
  tags: tags
  identity: identity
  properties: {
    devBoxProvisioningSettings: devBoxProvisioningSettings
    displayName: displayName
    encryption: {}
    //encryption: !empty(customerManagedKey)
    //  ? {
    //      customerManagedKeyEncryption: {
    //        keyEncryptionKeyIdentity: {
    //          userAssignedIdentityResourceId: !empty(customerManagedKey.?userAssignedIdentityResourceId)
    //            ? cMKUserAssignedIdentity.id
    //            : null
    //          identityType: !empty(customerManagedKey.?userAssignedIdentityResourceId)
    //            ? 'userAssignedIdentity'
    //            : 'systemAssignedIdentity'
    //        }
    //        keyEncryptionKeyUrl: !empty(customerManagedKey.?keyVersion ?? '')
    //          ? '${cMKKeyVault::cMKKey.properties.keyUri}/${customerManagedKey!.?keyVersion}'
    //          : (customerManagedKey.?autoRotationEnabled ?? true)
    //              ? cMKKeyVault::cMKKey.properties.keyUri
    //              : cMKKeyVault::cMKKey.properties.keyUriWithVersion
    //      }
    //    }
    //  : {}
    networkSettings: networkSettings
    projectCatalogSettings: projectCatalogSettings
  }
}

module project_catalog 'catalog/main.bicep' = [
  for (catalog, index) in (catalogs ?? []): {
    name: '${uniqueString(deployment().name, location)}-Devcenter-Catalog-${index}'
    params: {
      name: catalog.name
      devcenterName: devcenter.name
      gitHub: catalog.?gitHub
      adoGit: catalog.?adoGit
      syncType: catalog.?syncType
      tags: catalog.?tags
      location: location
    }
  }
]

module devcenter_environmentType 'environment-type/main.bicep' = [
  for (environmentType, index) in (environmentTypes ?? []): {
    name: '${uniqueString(deployment().name, location)}-Devcenter-EnvironmentType-${index}'
    params: {
      devcenterName: devcenter.name
      name: environmentType.name
      tags: environmentType.?tags
      displayName: environmentType.?displayName
    }
  }
]

module devcenter_gallery 'gallery/main.bicep' = [
  for (gallery, index) in (galleries ?? []): {
    name: '${uniqueString(deployment().name, location)}-Devcenter-Gallery-${index}'
    params: {
      devcenterName: devcenter.name
      name: gallery.name
      galleryResourceId: gallery.galleryResourceId
      devCenterIdentityPrincipalId: gallery.?devCenterIdentityPrincipalId
    }
  }
]

module devcenter_attachedNetwork 'attachednetwork/main.bicep' = [
  for (attachedNetwork, index) in (attachedNetworks ?? []): {
    name: '${uniqueString(deployment().name, location)}-Devcenter-AttachedNetwork-${index}'
    params: {
      devcenterName: devcenter.name
      name: attachedNetwork.name
      networkConnectionResourceId: attachedNetwork.networkConnectionResourceId
    }
  }
]

module devcenter_devboxDefinition 'devboxdefinition/main.bicep' = [
  for (devboxDefinition, index) in (devboxDefinitions ?? []): {
    name: '${uniqueString(deployment().name, location)}-Devcenter-DevboxDefinition-${index}'
    params: {
      devcenterName: devcenter.name
      name: devboxDefinition.name
      imageResourceId: devboxDefinition.imageResourceId
      sku: devboxDefinition.sku
      hibernateSupport: devboxDefinition.?hibernateSupport ?? 'Disabled'
      tags: devboxDefinition.?tags
      location: devboxDefinition.?location ?? location
    }
    dependsOn: [
      devcenter_gallery
    ]
  }
]

resource devCenter_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: devcenter
}

resource devCenter_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(devcenter.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: devcenter
  }
]

resource devCenter_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for (diagnosticSetting, index) in (diagnosticSettings ?? []): {
    name: diagnosticSetting.?name ?? '${name}-diagnosticSettings'
    properties: {
      storageAccountId: diagnosticSetting.?storageAccountResourceId
      workspaceId: diagnosticSetting.?workspaceResourceId
      eventHubAuthorizationRuleId: diagnosticSetting.?eventHubAuthorizationRuleResourceId
      eventHubName: diagnosticSetting.?eventHubName
      metrics: [
        for group in (diagnosticSetting.?metricCategories ?? [{ category: 'AllMetrics' }]): {
          category: group.category
          enabled: group.?enabled ?? true
          timeGrain: null
        }
      ]
      logs: [
        for group in (diagnosticSetting.?logCategoriesAndGroups ?? [{ categoryGroup: 'allLogs' }]): {
          categoryGroup: group.?categoryGroup
          category: group.?category
          enabled: group.?enabled ?? true
        }
      ]
      marketplacePartnerId: diagnosticSetting.?marketplacePartnerResourceId
      logAnalyticsDestinationType: diagnosticSetting.?logAnalyticsDestinationType
    }
    scope: devcenter
  }
]

@batchSize(1)
module devCenter_projectPolicy 'project-policy/main.bicep' = [
  for (projectPolicy, index) in (projectPolicies ?? []): {
    name: '${uniqueString(deployment().name, location)}-Devcenter-ProjectPolicy-${index}'
    params: {
      devcenterName: devcenter.name
      name: projectPolicy.name
      resourcePolicies: projectPolicy.?resourcePolicies
      projectsResourceIdOrName: projectPolicy.?projectsResourceIdOrName
    }
    dependsOn: [
      devcenter_gallery
      devCenter_project
    ]
  }
]

module devCenter_project 'br/public:avm/res/dev-center/project:0.1.0' = [
  for (project, index) in (projects ?? []): {
    name: '${uniqueString(deployment().name, location)}-Devcenter-Project-${index}'
    scope: resourceGroup(
      split(project.?resourceGroupResourceId ?? resourceGroup().id, '/')[2],
      split(project.?resourceGroupResourceId ?? resourceGroup().id, '/')[4]
    )
    params: {
      devCenterResourceId: devcenter.id
      name: project.name
      displayName: project.?displayName
      description: project.?description
      location: project.?location ?? location
      tags: project.?tags
      lock: project.?lock
      roleAssignments: project.?roleAssignments
      managedIdentities: project.?managedIdentities
      catalogSettings: project.?catalogSettings
      maxDevBoxesPerUser: project.?maxDevBoxesPerUser
      environmentTypes: project.?environmentTypes
      pools: project.?pools
      catalogs: project.?catalogs
      enableTelemetry: enableReferencedModulesTelemetry
    }
    dependsOn: [
      devcenter_devboxDefinition
    ]
  }
]

// ============ //
// Outputs      //
// ============ //

@description('The resource ID of the Dev Center.')
output resourceId string = devcenter.id

@description('The name of the Dev Center.')
output name string = devcenter.name

@description('The resource group the Dev Center was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the Dev Center was deployed into.')
output location string = devcenter.location

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string? = devcenter.?identity.?principalId

@description('The URI of the Dev Center.')
output devCenterUri string = devcenter.properties.devCenterUri

@description('The names of the DevBox definitions.')
output devboxDefinitionNames array = [
  for (devboxDefinition, index) in (devboxDefinitions ?? []): devcenter_devboxDefinition[index].outputs.name
]

// ================ //
// Definitions      //
// ================ //

@description('The type for Dev Box provisioning settings.')
type devBoxProvisioningSettingsType = {
  @description('Optional. Whether project catalogs associated with projects in this dev center can be configured to sync catalog items.')
  installAzureMonitorAgentEnableStatus: ('Enabled' | 'Disabled')?
}

@description('The type for network settings.')
type networkSettingsType = {
  @description('Optional. Indicates whether pools in this Dev Center can use Microsoft Hosted Networks. Defaults to Enabled if not set.')
  microsoftHostedNetworkEnableStatus: ('Enabled' | 'Disabled')?
}

@description('The type for project catalog settings.')
type projectCatalogSettingsType = {
  @description('Optional. Whether project catalogs associated with projects in this dev center can be configured to sync catalog items.')
  catalogItemSyncEnableStatus: ('Enabled' | 'Disabled')?
}

import { sourceType } from 'catalog/main.bicep'
@export()
@sys.description('The type for a Dev Center Catalog.')
type catalogType = {
  @sys.description('Required. The name of the catalog. Must be between 3 and 63 characters and can contain alphanumeric characters, hyphens, underscores, and periods.')
  name: string

  @sys.description('Optional. GitHub repository configuration for the catalog.')
  gitHub: sourceType?

  @sys.description('Optional. Azure DevOps Git repository configuration for the catalog.')
  adoGit: sourceType?

  @sys.description('Optional. Indicates the type of sync that is configured for the catalog. Defaults to "Scheduled".')
  syncType: ('Manual' | 'Scheduled')?

  @sys.description('Optional. Resource tags to apply to the catalog.')
  tags: object?
}

@description('The type for environment types.')
type environmentTypeType = {
  @description('Required. The name of the environment type.')
  name: string

  @description('Optional. The display name of the environment type.')
  displayName: string?

  @description('Optional. Tags of the resource.')
  tags: object?
}

import { resourcePolicyType } from 'project-policy/main.bicep'
@description('The type for project policies.')
type projectPolicyType = {
  @description('Required. The name of the project policy.')
  name: string

  @description('Required. Resource policies that are a part of this project policy.')
  resourcePolicies: resourcePolicyType

  @description('Optional. Project names or resource IDs that will be in scope of this project policy. Project names can be used if the project is in the same resource group as the Dev Center. If the project is in a different resource group or subscription, the full resource ID must be provided. If not provided, the policy status will be set to "Unassigned".')
  projectsResourceIdOrName: string[]?
}

@description('The type for Dev Center Gallery.')
type devCenterGalleryType = {
  @description('Required. It must be between 3 and 63 characters, can only include alphanumeric characters, underscores and periods, and can not start or end with "." or "_".')
  @minLength(3)
  @maxLength(63)
  name: string

  @description('Required. The resource ID of the backing Azure Compute Gallery. The devcenter identity (system or user) must have "Contributor" access to the gallery.')
  galleryResourceId: string

  @description('Optional. The principal ID of the Dev Center identity (system or user) that will be assigned the "Contributor" role on the backing Azure Compute Gallery. This is only required if the Dev Center identity has not been granted the right permissions on the gallery. The portal experience handles this automatically.')
  devCenterIdentityPrincipalId: string?
}

@description('The type for Dev Center Attached Network.')
type attachedNetworkType = {
  @description('Required. The name of the attached network.')
  name: string

  @description('Required. The resource ID of the Network Connection you want to attach to the Dev Center.')
  networkConnectionResourceId: string
}

import { skuType } from 'devboxdefinition/main.bicep'
@description('The type for Dev Box definitions.')
type devboxDefinitionType = {
  @description('Required. The name of the DevBox definition.')
  name: string

  @description('Required. The Image ID, or Image version ID. When Image ID is provided, its latest version will be used. When using custom images from a compute gallery, Microsoft Dev Box supports only images that are compatible with Dev Box and use the security type Trusted Launch enabled. See "https://learn.microsoft.com/en-us/azure/dev-box/how-to-configure-azure-compute-gallery#compute-gallery-image-requirements" for more information about image requirements.')
  imageResourceId: string

  @description('Required. The SKU configuration for the dev box definition. See "https://learn.microsoft.com/en-us/rest/api/devcenter/administrator/skus/list-by-subscription?view=rest-devcenter-administrator-2024-02-01" for more information about SKUs.')
  sku: skuType

  @description('Optional. Settings for hibernation support.')
  hibernateSupport: 'Enabled' | 'Disabled'?

  @description('Optional. Location for the DevBox definition.')
  location: string?

  @description('Optional. Tags of the resource.')
  tags: object?
}

import { catalogSettingsType, environmentTypeType as projectEnvironmentTypeType } from 'br/public:avm/res/dev-center/project:0.1.0'
import { stopOnDisconnectType, stopOnNoConnectType, devBoxDefinitionTypeType, poolScheduleType } from '../project/pool/main.bicep'

@description('The type for Dev Center Projects.')
type projectType = {
  @description('Required. The name of the project.')
  @minLength(3)
  @maxLength(63)
  name: string

  @description('Optional. The display name of project.')
  displayName: string?

  @description('Optional. The description of the project.')
  description: string?

  @description('Optional. Location for the project.')
  location: string?

  @description('Optional. Resource tags to apply to the project.')
  tags: object?

  @description('Optional. The lock settings of the project.')
  lock: lockType?

  @description('Optional. Array of role assignments to create for the project.')
  roleAssignments: roleAssignmentType[]?

  @description('Optional. The managed identity definition for the project resource. Only one user assigned identity can be used per project.')
  managedIdentities: managedIdentityAllType?

  @description('Optional. The resource group resource ID where the project will be deployed. If not provided, the project will be deployed to the same resource group as the Dev Center.')
  resourceGroupResourceId: string?

  @description('Optional. Settings to be used when associating a project with a catalog. The Dev Center this project is associated with must allow configuring catalog item sync types before configuring project level catalog settings.')
  catalogSettings: catalogSettingsType?

  @description('Optional. When specified, limits the maximum number of Dev Boxes a single user can create across all pools in the project. This will have no effect on existing Dev Boxes when reduced.')
  @minValue(0)
  maxDevBoxesPerUser: int?

  @description('Optional. The environment types to create. Environment types must be first created in the Dev Center and then made available to a project using project level environment types. The name should be equivalent to the name of the environment type in the Dev Center.')
  environmentTypes: projectEnvironmentTypeType[]?

  @description('Optional. The type of pool to create in the project. A project pool is a container for dev boxes that share the same configuration, like a dev box definition and a network connection. Essentially, a project pool defines the specifications for the dev boxes that developers can create from a specific project in the Dev Box service.')
  pools: {
    @description('Required. The name of the project pool. This name must be unique within a project and is visible to developers when creating dev boxes.')
    @minLength(3)
    @maxLength(63)
    name: string

    @description('Optional. The display name of the pool.')
    displayName: string?

    @description('Optional. Indicates if the pool is created from an existing Dev Box Definition or if one is provided directly. Defaults to "Reference".')
    devBoxDefinitionType: ('Reference' | 'Value')?

    @description('Required. Name of a Dev Box definition in parent Project of this Pool. If creating a pool from a definition defined in the Dev Center, then this will be the name of the definition. If creating a pool from a custom definition (e.g. Team Customizations), first the catalog must be added to this project, and second must use the format "\\~Catalog\\~{catalogName}\\~{imagedefinition YAML name}" (e.g. "\\~Catalog\\~eshopRepo\\~frontend-dev").')
    devBoxDefinitionName: string

    @description('Conditional. A definition of the machines that are created from this Pool. Required if devBoxDefinitionType is "Value".')
    devBoxDefinition: devBoxDefinitionTypeType?

    @description('Optional. Resource tags to apply to the pool.')
    tags: object?

    @description('Required. Each dev box creator will be granted the selected permissions on the dev boxes they create. Indicates whether owners of Dev Boxes in this pool are added as a "local administrator" or "standard user" on the Dev Box.')
    localAdministrator: ('Enabled' | 'Disabled')

    @description('Required. Indicates whether the pool uses a Virtual Network managed by Microsoft or a customer provided network. For the easiest configuration experience, the Microsoft hosted network can be used for dev box deployment. For organizations that require customized networking, use a network connection resource.')
    virtualNetworkType: ('Managed' | 'Unmanaged')

    @description('Conditional. The region of the managed virtual network. Required if virtualNetworkType is "Managed".')
    managedVirtualNetworkRegion: string?

    @description('Conditional. Name of a Network Connection in parent Project of this Pool. Required if virtualNetworkType is "Unmanaged". The region hosting a pool is determined by the region of the network connection. For best performance, create a dev box pool for every region where your developers are located. The network connection cannot be configured with "None" domain join type and must be first attached to the Dev Center before used by the pool. Will be set to "managedNetwork" if virtualNetworkType is "Managed".')
    networkConnectionName: string?

    @description('Optional. Indicates whether Dev Boxes in this pool are created with single sign on enabled. The also requires that single sign on be enabled on the tenant. Changing this setting will not affect existing dev boxes.')
    singleSignOnStatus: ('Enabled' | 'Disabled')?

    @description('Optional. Stop on "disconnect" configuration settings for Dev Boxes created in this pool. Dev boxes in this pool will hibernate after the grace period after the user disconnects.')
    stopOnDisconnect: stopOnDisconnectType?

    @description('Optional. Stop on "no connect" configuration settings for Dev Boxes created in this pool. Dev boxes in this pool will hibernate after the grace period if the user never connects.')
    stopOnNoConnect: stopOnNoConnectType?

    @description('Optional. The schedule for the pool. Dev boxes in this pool will auto-stop every day as per the schedule configuration.')
    schedule: poolScheduleType?

    @description('Optional. Location for the pool.')
    location: string?
  }[]?

  @description('Optional. The catalogs to create in the project. Catalogs are templates from a git repository that can be used to create environments.')
  catalogs: catalogType[]?
}
