# Compute Galleries Image Definitions `[Microsoft.Compute/galleries/images]`

This module deploys an Azure Compute Gallery Image Definition.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Compute/galleries/images` | [2023-07-03](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2023-07-03/galleries/images) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`galleryImage`](#parameter-galleryimage) | object | Properties used to create the image. |
| [`name`](#parameter-name) | string | Name of the image definition. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`galleryName`](#parameter-galleryname) | string | The name of the parent Azure Shared Image Gallery. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-tags) | object | Tags for all resources. This takes precedence over the tags of the galleryImage.tags property. |

### Parameter: `galleryImage`

Properties used to create the image.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-galleryimagename) | string | The resource name. |
| [`properties`](#parameter-galleryimageproperties) | object | Describes the properties of a gallery image definition. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`isAcceleratedNetworkSupported`](#parameter-galleryimageisacceleratednetworksupported) | bool | Specify if the image supports accelerated networking. Defaults to true. |
| [`isHibernateSupported`](#parameter-galleryimageishibernatesupported) | bool | Specifiy if the image supports hibernation. |
| [`location`](#parameter-galleryimagelocation) | string | The location of the resource. Defaults to the gallery resource location. |
| [`roleAssignments`](#parameter-galleryimageroleassignments) | array | Array of role assignments to create. |
| [`securityType`](#parameter-galleryimagesecuritytype) | string | The security type of the image. Requires a hyperVGeneration V2. Defaults to `Standard`. |
| [`tags`](#parameter-galleryimagetags) | object | Tags for all resources. Defaults to the tags of the gallery. |

### Parameter: `galleryImage.name`

The resource name.

- Required: Yes
- Type: string

### Parameter: `galleryImage.properties`

Describes the properties of a gallery image definition.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`identifier`](#parameter-galleryimagepropertiesidentifier) | object | This is the gallery image definition identifier. |
| [`osState`](#parameter-galleryimagepropertiesosstate) | string | This property allows the user to specify whether the virtual machines created under this image are `Generalized` or `Specialized`. |
| [`osType`](#parameter-galleryimagepropertiesostype) | string | This property allows you to specify the type of the OS that is included in the disk when creating a VM from a managed image. Possible values are: `Windows`, `Linux`. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`architecture`](#parameter-galleryimagepropertiesarchitecture) | string | The architecture of the image. Applicable to OS disks only. |
| [`description`](#parameter-galleryimagepropertiesdescription) | string | The description of this gallery image definition resource. This property is updatable. |
| [`disallowed`](#parameter-galleryimagepropertiesdisallowed) | object | Describes the disallowed disk types. |
| [`endOfLifeDate`](#parameter-galleryimagepropertiesendoflifedate) | string | The end of life date of the gallery image definition. This property can be used for decommissioning purposes. This property is updatable. |
| [`eula`](#parameter-galleryimagepropertieseula) | string | The Eula agreement for the gallery image definition. |
| [`hyperVGeneration`](#parameter-galleryimagepropertieshypervgeneration) | string | The hypervisor generation of the Virtual Machine. If this value is not specified, then it is determined by the securityType parameter. If the securityType parameter is specified, then the value of hyperVGeneration will be V2, else V1. |
| [`privacyStatementUri`](#parameter-galleryimagepropertiesprivacystatementuri) | string | The privacy statement uri. |
| [`purchasePlan`](#parameter-galleryimagepropertiespurchaseplan) | object | Describes the gallery image definition purchase plan. This is used by marketplace images. |
| [`recommended`](#parameter-galleryimagepropertiesrecommended) | object | The properties describe the recommended machine configuration for this Image Definition. These properties are updatable. |
| [`releaseNoteUri`](#parameter-galleryimagepropertiesreleasenoteuri) | string | The release note uri. Has to be a valid URL. |

### Parameter: `galleryImage.properties.identifier`

This is the gallery image definition identifier.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`offer`](#parameter-galleryimagepropertiesidentifieroffer) | string | The name of the gallery image definition publisher. |
| [`publisher`](#parameter-galleryimagepropertiesidentifierpublisher) | string | The name of the gallery image definition offer. |
| [`sku`](#parameter-galleryimagepropertiesidentifiersku) | string | The name of the gallery image definition SKU. |

### Parameter: `galleryImage.properties.identifier.offer`

The name of the gallery image definition publisher.

- Required: Yes
- Type: string

### Parameter: `galleryImage.properties.identifier.publisher`

The name of the gallery image definition offer.

- Required: Yes
- Type: string

### Parameter: `galleryImage.properties.identifier.sku`

The name of the gallery image definition SKU.

- Required: Yes
- Type: string

### Parameter: `galleryImage.properties.osState`

This property allows the user to specify whether the virtual machines created under this image are `Generalized` or `Specialized`.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Generalized'
    'Specialized'
  ]
  ```

### Parameter: `galleryImage.properties.osType`

This property allows you to specify the type of the OS that is included in the disk when creating a VM from a managed image. Possible values are: `Windows`, `Linux`.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Linux'
    'Windows'
  ]
  ```

### Parameter: `galleryImage.properties.architecture`

The architecture of the image. Applicable to OS disks only.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Arm64'
    'x64'
  ]
  ```

### Parameter: `galleryImage.properties.description`

The description of this gallery image definition resource. This property is updatable.

- Required: No
- Type: string

### Parameter: `galleryImage.properties.disallowed`

Describes the disallowed disk types.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`diskTypes`](#parameter-galleryimagepropertiesdisalloweddisktypes) | array | A list of disk types. |

### Parameter: `galleryImage.properties.disallowed.diskTypes`

A list of disk types.

- Required: Yes
- Type: array

### Parameter: `galleryImage.properties.endOfLifeDate`

The end of life date of the gallery image definition. This property can be used for decommissioning purposes. This property is updatable.

- Required: No
- Type: string

### Parameter: `galleryImage.properties.eula`

The Eula agreement for the gallery image definition.

- Required: No
- Type: string

### Parameter: `galleryImage.properties.hyperVGeneration`

The hypervisor generation of the Virtual Machine. If this value is not specified, then it is determined by the securityType parameter. If the securityType parameter is specified, then the value of hyperVGeneration will be V2, else V1.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'V1'
    'V2'
  ]
  ```

### Parameter: `galleryImage.properties.privacyStatementUri`

The privacy statement uri.

- Required: No
- Type: string

### Parameter: `galleryImage.properties.purchasePlan`

Describes the gallery image definition purchase plan. This is used by marketplace images.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-galleryimagepropertiespurchaseplanname) | string | The plan ID. |
| [`product`](#parameter-galleryimagepropertiespurchaseplanproduct) | string | The product ID. |
| [`publisher`](#parameter-galleryimagepropertiespurchaseplanpublisher) | string | The publisher ID. |

### Parameter: `galleryImage.properties.purchasePlan.name`

The plan ID.

- Required: Yes
- Type: string

### Parameter: `galleryImage.properties.purchasePlan.product`

The product ID.

- Required: Yes
- Type: string

### Parameter: `galleryImage.properties.purchasePlan.publisher`

The publisher ID.

- Required: Yes
- Type: string

### Parameter: `galleryImage.properties.recommended`

The properties describe the recommended machine configuration for this Image Definition. These properties are updatable.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`memory`](#parameter-galleryimagepropertiesrecommendedmemory) | object | Describes the resource range (1-4000 GB RAM). Defaults to min=4, max=16. |
| [`vCPUs`](#parameter-galleryimagepropertiesrecommendedvcpus) | object | Describes the resource range (1-128 CPU cores). Defaults to min=1, max=4. |

### Parameter: `galleryImage.properties.recommended.memory`

Describes the resource range (1-4000 GB RAM). Defaults to min=4, max=16.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`max`](#parameter-galleryimagepropertiesrecommendedmemorymax) | int | The minimum number of the resource. |
| [`min`](#parameter-galleryimagepropertiesrecommendedmemorymin) | int | The minimum number of the resource. |

### Parameter: `galleryImage.properties.recommended.memory.max`

The minimum number of the resource.

- Required: No
- Type: int

### Parameter: `galleryImage.properties.recommended.memory.min`

The minimum number of the resource.

- Required: No
- Type: int

### Parameter: `galleryImage.properties.recommended.vCPUs`

Describes the resource range (1-128 CPU cores). Defaults to min=1, max=4.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`max`](#parameter-galleryimagepropertiesrecommendedvcpusmax) | int | The minimum number of the resource. |
| [`min`](#parameter-galleryimagepropertiesrecommendedvcpusmin) | int | The minimum number of the resource. |

### Parameter: `galleryImage.properties.recommended.vCPUs.max`

The minimum number of the resource.

- Required: No
- Type: int

### Parameter: `galleryImage.properties.recommended.vCPUs.min`

The minimum number of the resource.

- Required: No
- Type: int

### Parameter: `galleryImage.properties.releaseNoteUri`

The release note uri. Has to be a valid URL.

- Required: No
- Type: string

### Parameter: `galleryImage.isAcceleratedNetworkSupported`

Specify if the image supports accelerated networking. Defaults to true.

- Required: No
- Type: bool

### Parameter: `galleryImage.isHibernateSupported`

Specifiy if the image supports hibernation.

- Required: No
- Type: bool

### Parameter: `galleryImage.location`

The location of the resource. Defaults to the gallery resource location.

- Required: No
- Type: string

### Parameter: `galleryImage.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-galleryimageroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-galleryimageroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-galleryimageroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-galleryimageroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-galleryimageroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-galleryimageroleassignmentsdescription) | string | The description of the role assignment. |
| [`principalType`](#parameter-galleryimageroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `galleryImage.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `galleryImage.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `galleryImage.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `galleryImage.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `galleryImage.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `galleryImage.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `galleryImage.roleAssignments.principalType`

The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Device'
    'ForeignGroup'
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `galleryImage.securityType`

The security type of the image. Requires a hyperVGeneration V2. Defaults to `Standard`.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'ConfidentialVM'
    'ConfidentialVMSupported'
    'Standard'
    'TrustedLaunch'
  ]
  ```

### Parameter: `galleryImage.tags`

Tags for all resources. Defaults to the tags of the gallery.

- Required: No
- Type: object

### Parameter: `name`

Name of the image definition.

- Required: Yes
- Type: string

### Parameter: `galleryName`

The name of the parent Azure Shared Image Gallery. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-roleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-roleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | string | The description of the role assignment. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `roleAssignments.principalType`

The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Device'
    'ForeignGroup'
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `tags`

Tags for all resources. This takes precedence over the tags of the galleryImage.tags property.

- Required: No
- Type: object


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the image. |
| `resourceGroupName` | string | The resource group the image was deployed into. |
| `resourceId` | string | The resource ID of the image. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
