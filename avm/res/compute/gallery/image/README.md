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
| `Microsoft.Compute/galleries/images` | [2022-03-03](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2022-03-03/galleries/images) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the image definition. |
| [`offer`](#parameter-offer) | string | The name of the gallery Image Definition offer. |
| [`osType`](#parameter-ostype) | string | OS type of the image to be created. |
| [`publisher`](#parameter-publisher) | string | The name of the gallery Image Definition publisher. |
| [`sku`](#parameter-sku) | string | The name of the gallery Image Definition SKU. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`galleryName`](#parameter-galleryname) | string | The name of the parent Azure Shared Image Gallery. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-description) | string | The description of this gallery Image Definition resource. This property is updatable. |
| [`endOfLife`](#parameter-endoflife) | string | The end of life date of the gallery Image Definition. This property can be used for decommissioning purposes. This property is updatable. Allowed format: 2020-01-10T23:00:00.000Z. |
| [`eula`](#parameter-eula) | string | The Eula agreement for the gallery Image Definition. Has to be a valid URL. |
| [`excludedDiskTypes`](#parameter-excludeddisktypes) | array | List of the excluded disk types (e.g., Standard_LRS). |
| [`hyperVGeneration`](#parameter-hypervgeneration) | string | The hypervisor generation of the Virtual Machine.<li>If this value is not specified, then it is determined by the securityType parameter.<li>If the securityType parameter is specified, then the value of hyperVGeneration will be V2, else V1.<p> |
| [`isAcceleratedNetworkSupported`](#parameter-isacceleratednetworksupported) | bool | Specify if the image supports accelerated networking.<p>Accelerated networking enables single root I/O virtualization (SR-IOV) to a VM, greatly improving its networking performance.<p>This high-performance path bypasses the host from the data path, which reduces latency, jitter, and CPU utilization for the most demanding network workloads on supported VM types.<p> |
| [`isHibernateSupported`](#parameter-ishibernatesupported) | bool | Specifiy if the image supports hibernation. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`maxRecommendedMemory`](#parameter-maxrecommendedmemory) | int | The maximum amount of RAM in GB recommended for this image. |
| [`maxRecommendedvCPUs`](#parameter-maxrecommendedvcpus) | int | The maximum number of the CPU cores recommended for this image. |
| [`minRecommendedMemory`](#parameter-minrecommendedmemory) | int | The minimum amount of RAM in GB recommended for this image. |
| [`minRecommendedvCPUs`](#parameter-minrecommendedvcpus) | int | The minimum number of the CPU cores recommended for this image. |
| [`osState`](#parameter-osstate) | string | This property allows the user to specify whether the virtual machines created under this image are 'Generalized' or 'Specialized'. |
| [`planName`](#parameter-planname) | string | The plan ID. |
| [`planPublisherName`](#parameter-planpublishername) | string | The publisher ID. |
| [`privacyStatementUri`](#parameter-privacystatementuri) | string | The privacy statement uri. Has to be a valid URL. |
| [`productName`](#parameter-productname) | string | The product ID. |
| [`releaseNoteUri`](#parameter-releasenoteuri) | string | The release note uri. Has to be a valid URL. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`securityType`](#parameter-securitytype) | string | The security type of the image. Requires a hyperVGeneration V2. |
| [`tags`](#parameter-tags) | object | Tags for all resources. |

### Parameter: `name`

Name of the image definition.

- Required: Yes
- Type: string

### Parameter: `offer`

The name of the gallery Image Definition offer.

- Required: Yes
- Type: string

### Parameter: `osType`

OS type of the image to be created.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Linux'
    'Windows'
  ]
  ```

### Parameter: `publisher`

The name of the gallery Image Definition publisher.

- Required: Yes
- Type: string

### Parameter: `sku`

The name of the gallery Image Definition SKU.

- Required: Yes
- Type: string

### Parameter: `galleryName`

The name of the parent Azure Shared Image Gallery. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `description`

The description of this gallery Image Definition resource. This property is updatable.

- Required: No
- Type: string

### Parameter: `endOfLife`

The end of life date of the gallery Image Definition. This property can be used for decommissioning purposes. This property is updatable. Allowed format: 2020-01-10T23:00:00.000Z.

- Required: No
- Type: string
- Default: `''`

### Parameter: `eula`

The Eula agreement for the gallery Image Definition. Has to be a valid URL.

- Required: No
- Type: string

### Parameter: `excludedDiskTypes`

List of the excluded disk types (e.g., Standard_LRS).

- Required: No
- Type: array
- Default: `[]`

### Parameter: `hyperVGeneration`

The hypervisor generation of the Virtual Machine.<li>If this value is not specified, then it is determined by the securityType parameter.<li>If the securityType parameter is specified, then the value of hyperVGeneration will be V2, else V1.<p>

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

Specify if the image supports accelerated networking.<p>Accelerated networking enables single root I/O virtualization (SR-IOV) to a VM, greatly improving its networking performance.<p>This high-performance path bypasses the host from the data path, which reduces latency, jitter, and CPU utilization for the most demanding network workloads on supported VM types.<p>

- Required: No
- Type: bool
- Default: `True`

### Parameter: `isHibernateSupported`

Specifiy if the image supports hibernation.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `maxRecommendedMemory`

The maximum amount of RAM in GB recommended for this image.

- Required: No
- Type: int
- Default: `16`

### Parameter: `maxRecommendedvCPUs`

The maximum number of the CPU cores recommended for this image.

- Required: No
- Type: int
- Default: `4`

### Parameter: `minRecommendedMemory`

The minimum amount of RAM in GB recommended for this image.

- Required: No
- Type: int
- Default: `4`

### Parameter: `minRecommendedvCPUs`

The minimum number of the CPU cores recommended for this image.

- Required: No
- Type: int
- Default: `1`

### Parameter: `osState`

This property allows the user to specify whether the virtual machines created under this image are 'Generalized' or 'Specialized'.

- Required: No
- Type: string
- Default: `'Generalized'`
- Allowed:
  ```Bicep
  [
    'Generalized'
    'Specialized'
  ]
  ```

### Parameter: `planName`

The plan ID.

- Required: No
- Type: string

### Parameter: `planPublisherName`

The publisher ID.

- Required: No
- Type: string

### Parameter: `privacyStatementUri`

The privacy statement uri. Has to be a valid URL.

- Required: No
- Type: string

### Parameter: `productName`

The product ID.

- Required: No
- Type: string

### Parameter: `releaseNoteUri`

The release note uri. Has to be a valid URL.

- Required: No
- Type: string

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

### Parameter: `securityType`

The security type of the image. Requires a hyperVGeneration V2.

- Required: No
- Type: string
- Default: `'Standard'`
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

Tags for all resources.

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
