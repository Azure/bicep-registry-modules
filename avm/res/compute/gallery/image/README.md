# Compute Galleries Image Definitions `[Microsoft.Compute/galleries/images]`

This module deploys an Azure Compute Gallery Image Definition.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Compute/galleries/images` | [2023-07-03](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2023-07-03/galleries/images) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`identifier`](#parameter-identifier) | object | This is the gallery image definition identifier. |
| [`name`](#parameter-name) | string | Name of the image definition. |
| [`osState`](#parameter-osstate) | string | This property allows the user to specify the state of the OS of the image. |
| [`osType`](#parameter-ostype) | string | This property allows you to specify the type of the OS that is included in the disk when creating a VM from a managed image. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`galleryName`](#parameter-galleryname) | string | The name of the parent Azure Shared Image Gallery. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`architecture`](#parameter-architecture) | string | The architecture of the image. Applicable to OS disks only. |
| [`description`](#parameter-description) | string | The description of this gallery image definition resource. This property is updatable. |
| [`disallowed`](#parameter-disallowed) | object | Describes the disallowed disk types. |
| [`endOfLifeDate`](#parameter-endoflifedate) | string | The end of life date of the gallery image definition. This property can be used for decommissioning purposes. This property is updatable. |
| [`eula`](#parameter-eula) | string | The Eula agreement for the gallery image definition. |
| [`hyperVGeneration`](#parameter-hypervgeneration) | string | The hypervisor generation of the Virtual Machine. If this value is not specified, then it is determined by the securityType parameter. If the securityType parameter is specified, then the value of hyperVGeneration will be V2, else V1. |
| [`isAcceleratedNetworkSupported`](#parameter-isacceleratednetworksupported) | bool | Specify if the image supports accelerated networking. |
| [`isHibernateSupported`](#parameter-ishibernatesupported) | bool | Specifiy if the image supports hibernation. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`memory`](#parameter-memory) | object | Describes the resource range (1-4000 GB RAM). |
| [`privacyStatementUri`](#parameter-privacystatementuri) | string | The privacy statement uri. |
| [`purchasePlan`](#parameter-purchaseplan) | object | Describes the gallery image definition purchase plan. This is used by marketplace images. |
| [`releaseNoteUri`](#parameter-releasenoteuri) | string | The release note uri. Has to be a valid URL. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`securityType`](#parameter-securitytype) | string | The security type of the image. Requires a hyperVGeneration V2. |
| [`tags`](#parameter-tags) | object | Tags for all the image. |
| [`vCPUs`](#parameter-vcpus) | object | Describes the resource range (1-128 CPU cores). |

### Parameter: `identifier`

This is the gallery image definition identifier.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`offer`](#parameter-identifieroffer) | string | The name of the gallery image definition offer. |
| [`publisher`](#parameter-identifierpublisher) | string | The name of the gallery image definition publisher. |
| [`sku`](#parameter-identifiersku) | string | The name of the gallery image definition SKU. |

### Parameter: `identifier.offer`

The name of the gallery image definition offer.

- Required: Yes
- Type: string

### Parameter: `identifier.publisher`

The name of the gallery image definition publisher.

- Required: Yes
- Type: string

### Parameter: `identifier.sku`

The name of the gallery image definition SKU.

- Required: Yes
- Type: string

### Parameter: `name`

Name of the image definition.

- Required: Yes
- Type: string

### Parameter: `osState`

This property allows the user to specify the state of the OS of the image.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Generalized'
    'Specialized'
  ]
  ```

### Parameter: `osType`

This property allows you to specify the type of the OS that is included in the disk when creating a VM from a managed image.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Linux'
    'Windows'
  ]
  ```

### Parameter: `galleryName`

The name of the parent Azure Shared Image Gallery. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `architecture`

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

### Parameter: `description`

The description of this gallery image definition resource. This property is updatable.

- Required: No
- Type: string

### Parameter: `disallowed`

Describes the disallowed disk types.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`diskTypes`](#parameter-disalloweddisktypes) | array | A list of disk types. |

### Parameter: `disallowed.diskTypes`

A list of disk types.

- Required: Yes
- Type: array
- Example:
  ```Bicep
  [
    'Standard_LRS'
  ]
  ```

### Parameter: `endOfLifeDate`

The end of life date of the gallery image definition. This property can be used for decommissioning purposes. This property is updatable.

- Required: No
- Type: string

### Parameter: `eula`

The Eula agreement for the gallery image definition.

- Required: No
- Type: string

### Parameter: `hyperVGeneration`

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

### Parameter: `isAcceleratedNetworkSupported`

Specify if the image supports accelerated networking.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `isHibernateSupported`

Specifiy if the image supports hibernation.

- Required: No
- Type: bool

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `memory`

Describes the resource range (1-4000 GB RAM).

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      max: 16
      min: 4
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`max`](#parameter-memorymax) | int | The minimum number of the resource. |
| [`min`](#parameter-memorymin) | int | The minimum number of the resource. |

### Parameter: `memory.max`

The minimum number of the resource.

- Required: No
- Type: int

### Parameter: `memory.min`

The minimum number of the resource.

- Required: No
- Type: int

### Parameter: `privacyStatementUri`

The privacy statement uri.

- Required: No
- Type: string

### Parameter: `purchasePlan`

Describes the gallery image definition purchase plan. This is used by marketplace images.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-purchaseplanname) | string | The plan ID. |
| [`product`](#parameter-purchaseplanproduct) | string | The product ID. |
| [`publisher`](#parameter-purchaseplanpublisher) | string | The publisher ID. |

### Parameter: `purchasePlan.name`

The plan ID.

- Required: Yes
- Type: string

### Parameter: `purchasePlan.product`

The product ID.

- Required: Yes
- Type: string

### Parameter: `purchasePlan.publisher`

The publisher ID.

- Required: Yes
- Type: string

### Parameter: `releaseNoteUri`

The release note uri. Has to be a valid URL.

- Required: No
- Type: string

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Compute Gallery Sharing Admin'`
  - `'Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`

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
| [`name`](#parameter-roleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
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

### Parameter: `roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

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

### Parameter: `securityType`

The security type of the image. Requires a hyperVGeneration V2.

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

### Parameter: `tags`

Tags for all the image.

- Required: No
- Type: object
- Example:
  ```Bicep
  {
      key1: 'value1'
      key2: 'value2'
  }
  ```

### Parameter: `vCPUs`

Describes the resource range (1-128 CPU cores).

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      max: 4
      min: 1
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`max`](#parameter-vcpusmax) | int | The minimum number of the resource. |
| [`min`](#parameter-vcpusmin) | int | The minimum number of the resource. |

### Parameter: `vCPUs.max`

The minimum number of the resource.

- Required: No
- Type: int

### Parameter: `vCPUs.min`

The minimum number of the resource.

- Required: No
- Type: int

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the image. |
| `resourceGroupName` | string | The resource group the image was deployed into. |
| `resourceId` | string | The resource ID of the image. |
