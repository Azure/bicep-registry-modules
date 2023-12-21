# Images `[Microsoft.Compute/images]`

This module deploys a Compute Image.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Compute/images` | [2022-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2022-11-01/images) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/compute.image:1.0.0`.

- [Using large parameter set](#example-1-using-large-parameter-set)
- [WAF-aligned](#example-2-waf-aligned)

### Example 1: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module image 'br:bicep/modules/compute.image:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-cimax'
  params: {
    // Required parameters
    name: 'cimax001'
    osAccountType: 'Premium_LRS'
    osDiskBlobUri: '<osDiskBlobUri>'
    osDiskCaching: 'ReadWrite'
    osType: 'Windows'
    // Non-required parameters
    diskEncryptionSetResourceId: '<diskEncryptionSetResourceId>'
    diskSizeGB: 128
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    hyperVGeneration: 'V1'
    osState: 'Generalized'
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Owner'
      }
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
      }
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
      }
    ]
    tags: {
      'hidden-title': 'This is visible in the resource name'
      tagA: 'You\'re it'
      tagB: 'Player'
    }
    zoneResilient: true
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "cimax001"
    },
    "osAccountType": {
      "value": "Premium_LRS"
    },
    "osDiskBlobUri": {
      "value": "<osDiskBlobUri>"
    },
    "osDiskCaching": {
      "value": "ReadWrite"
    },
    "osType": {
      "value": "Windows"
    },
    // Non-required parameters
    "diskEncryptionSetResourceId": {
      "value": "<diskEncryptionSetResourceId>"
    },
    "diskSizeGB": {
      "value": 128
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "hyperVGeneration": {
      "value": "V1"
    },
    "osState": {
      "value": "Generalized"
    },
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Owner"
        },
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "b24988ac-6180-42a0-ab88-20f7382dd24c"
        },
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "<roleDefinitionIdOrName>"
        }
      ]
    },
    "tags": {
      "value": {
        "hidden-title": "This is visible in the resource name",
        "tagA": "You\"re it",
        "tagB": "Player"
      }
    },
    "zoneResilient": {
      "value": true
    }
  }
}
```

</details>
<p>

### Example 2: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module image 'br:bicep/modules/compute.image:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-ciwaf'
  params: {
    // Required parameters
    name: 'ciwaf001'
    osAccountType: 'Premium_LRS'
    osDiskBlobUri: '<osDiskBlobUri>'
    osDiskCaching: 'ReadWrite'
    osType: 'Windows'
    // Non-required parameters
    diskEncryptionSetResourceId: '<diskEncryptionSetResourceId>'
    diskSizeGB: 128
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    hyperVGeneration: 'V1'
    osState: 'Generalized'
    tags: {
      'hidden-title': 'This is visible in the resource name'
      tagA: 'You\'re it'
      tagB: 'Player'
    }
    zoneResilient: true
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "ciwaf001"
    },
    "osAccountType": {
      "value": "Premium_LRS"
    },
    "osDiskBlobUri": {
      "value": "<osDiskBlobUri>"
    },
    "osDiskCaching": {
      "value": "ReadWrite"
    },
    "osType": {
      "value": "Windows"
    },
    // Non-required parameters
    "diskEncryptionSetResourceId": {
      "value": "<diskEncryptionSetResourceId>"
    },
    "diskSizeGB": {
      "value": 128
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "hyperVGeneration": {
      "value": "V1"
    },
    "osState": {
      "value": "Generalized"
    },
    "tags": {
      "value": {
        "hidden-title": "This is visible in the resource name",
        "tagA": "You\"re it",
        "tagB": "Player"
      }
    },
    "zoneResilient": {
      "value": true
    }
  }
}
```

</details>
<p>


## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the image. |
| [`osDiskBlobUri`](#parameter-osdiskbloburi) | string | The Virtual Hard Disk. |
| [`osType`](#parameter-ostype) | string | This property allows you to specify the type of the OS that is included in the disk if creating a VM from a custom image. - Windows or Linux. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataDisks`](#parameter-datadisks) | array | Specifies the parameters that are used to add a data disk to a virtual machine. |
| [`diskEncryptionSetResourceId`](#parameter-diskencryptionsetresourceid) | string | Specifies the customer managed disk encryption set resource ID for the managed image disk. |
| [`diskSizeGB`](#parameter-disksizegb) | int | Specifies the size of empty data disks in gigabytes. This element can be used to overwrite the name of the disk in a virtual machine image. This value cannot be larger than 1023 GB. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`extendedLocation`](#parameter-extendedlocation) | object | The extended location of the Image. |
| [`hyperVGeneration`](#parameter-hypervgeneration) | string | Gets the HyperVGenerationType of the VirtualMachine created from the image. - V1 or V2. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`managedDiskResourceId`](#parameter-manageddiskresourceid) | string | The managedDisk. |
| [`osAccountType`](#parameter-osaccounttype) | string | Specifies the storage account type for the managed disk. NOTE: UltraSSD_LRS can only be used with data disks, it cannot be used with OS Disk. - Standard_LRS, Premium_LRS, StandardSSD_LRS, UltraSSD_LRS. |
| [`osDiskCaching`](#parameter-osdiskcaching) | string | Specifies the caching requirements. Default: None for Standard storage. ReadOnly for Premium storage. - None, ReadOnly, ReadWrite. |
| [`osState`](#parameter-osstate) | string | The OS State. For managed images, use Generalized. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`snapshotResourceId`](#parameter-snapshotresourceid) | string | The snapshot resource ID. |
| [`sourceVirtualMachineResourceId`](#parameter-sourcevirtualmachineresourceid) | string | The source virtual machine from which Image is created. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`zoneResilient`](#parameter-zoneresilient) | bool | Default is false. Specifies whether an image is zone resilient or not. Zone resilient images can be created only in regions that provide Zone Redundant Storage (ZRS). |

### Parameter: `name`

The name of the image.

- Required: Yes
- Type: string

### Parameter: `osDiskBlobUri`

The Virtual Hard Disk.

- Required: Yes
- Type: string

### Parameter: `osType`

This property allows you to specify the type of the OS that is included in the disk if creating a VM from a custom image. - Windows or Linux.

- Required: Yes
- Type: string

### Parameter: `dataDisks`

Specifies the parameters that are used to add a data disk to a virtual machine.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `diskEncryptionSetResourceId`

Specifies the customer managed disk encryption set resource ID for the managed image disk.

- Required: No
- Type: string
- Default: `''`

### Parameter: `diskSizeGB`

Specifies the size of empty data disks in gigabytes. This element can be used to overwrite the name of the disk in a virtual machine image. This value cannot be larger than 1023 GB.

- Required: No
- Type: int
- Default: `128`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).

- Required: No
- Type: bool
- Default: `True`

### Parameter: `extendedLocation`

The extended location of the Image.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `hyperVGeneration`

Gets the HyperVGenerationType of the VirtualMachine created from the image. - V1 or V2.

- Required: No
- Type: string
- Default: `'V1'`

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `managedDiskResourceId`

The managedDisk.

- Required: No
- Type: string
- Default: `''`

### Parameter: `osAccountType`

Specifies the storage account type for the managed disk. NOTE: UltraSSD_LRS can only be used with data disks, it cannot be used with OS Disk. - Standard_LRS, Premium_LRS, StandardSSD_LRS, UltraSSD_LRS.

- Required: Yes
- Type: string

### Parameter: `osDiskCaching`

Specifies the caching requirements. Default: None for Standard storage. ReadOnly for Premium storage. - None, ReadOnly, ReadWrite.

- Required: Yes
- Type: string

### Parameter: `osState`

The OS State. For managed images, use Generalized.

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
| [`condition`](#parameter-roleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container" |
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

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container"

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

### Parameter: `snapshotResourceId`

The snapshot resource ID.

- Required: No
- Type: string
- Default: `''`

### Parameter: `sourceVirtualMachineResourceId`

The source virtual machine from which Image is created.

- Required: No
- Type: string
- Default: `''`

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `zoneResilient`

Default is false. Specifies whether an image is zone resilient or not. Zone resilient images can be created only in regions that provide Zone Redundant Storage (ZRS).

- Required: No
- Type: bool
- Default: `False`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the image. |
| `resourceGroupName` | string | The resource group the image was deployed into. |
| `resourceId` | string | The resource ID of the image. |

## Cross-referenced modules

_None_
