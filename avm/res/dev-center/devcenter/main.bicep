metadata name = 'Dev Center'
metadata description = 'This module deploys an Azure Dev Center.'

@description('Required. Name of the Dev Center.')
@minLength(3)
@maxLength(26)
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

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
param projects array = []

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
      osStorageType: devboxDefinition.?osStorageType
      sku: devboxDefinition.sku
      hibernateSupport: devboxDefinition.?hibernateSupport ?? 'Disabled'
      tags: devboxDefinition.?tags
      location: devboxDefinition.?location ?? location
    }
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

module devCenter_project '../project/main.bicep' = [
  for (project, index) in (projects ?? []): {
    name: '${uniqueString(deployment().name, location)}-Devcenter-Project-${index}'
    scope: resourceGroup(
      split(project.?resourceGroupResourceId ?? resourceGroup().id, '/')[2],
      split(project.?resourceGroupResourceId ?? resourceGroup().id, '/')[4]
    )
    params: {
      devCenterResourceId: devcenter.id
      name: project.name
    }
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
  @description('Required. The name of the gallery resource.')
  name: string

  @description('Required. The resource ID of the backing Azure Compute Gallery. The devcenter identity (system or user) must have "Contributor" access to the gallery.')
  galleryResourceId: string
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

  @description('Required. The Image ID, or Image version ID. When Image ID is provided, its latest version will be used.')
  imageResourceId: string

  @description('Optional. The storage type used for the operating system disk of the DevBox.')
  osStorageType: string?

  @description('Required. The SKU configuration for the dev box definition. See "https://learn.microsoft.com/en-us/rest/api/devcenter/administrator/skus/list-by-subscription?view=rest-devcenter-administrator-2024-02-01" for more information about SKUs.')
  sku: skuType

  @description('Optional. Settings for hibernation support.')
  hibernateSupport: 'Enabled' | 'Disabled'?

  @description('Optional. Location for the DevBox definition.')
  location: string?

  @description('Optional. Tags of the resource.')
  tags: object?
}
