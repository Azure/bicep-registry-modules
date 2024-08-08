# Images `[Microsoft.Compute/images]`

This module deploys a Compute Image.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Compute/images` | [2022-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2022-11-01/images) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/compute/image:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module image 'br/public:avm/res/compute/image:<version>' = {
  name: 'imageDeployment'
  params: {
    // Required parameters
    name: 'cimin001'
    osAccountType: 'Standard_LRS'
    osDiskBlobUri: '<osDiskBlobUri>'
    osDiskCaching: 'ReadWrite'
    osType: 'Windows'
    // Non-required parameters
    location: '<location>'
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
      "value": "cimin001"
    },
    "osAccountType": {
      "value": "Standard_LRS"
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
    "location": {
      "value": "<location>"
    }
  }
}
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module image 'br/public:avm/res/compute/image:<version>' = {
  name: 'imageDeployment'
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
    hyperVGeneration: 'V1'
    location: '<location>'
    osState: 'Generalized'
    roleAssignments: [
      {
        name: '2dfcdedd-220c-4b6b-b8bd-58e22e0c5434'
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Owner'
      }
      {
        name: '<name>'
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
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
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
    "hyperVGeneration": {
      "value": "V1"
    },
    "location": {
      "value": "<location>"
    },
    "osState": {
      "value": "Generalized"
    },
    "roleAssignments": {
      "value": [
        {
          "name": "2dfcdedd-220c-4b6b-b8bd-58e22e0c5434",
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Owner"
        },
        {
          "name": "<name>",
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
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
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

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module image 'br/public:avm/res/compute/image:<version>' = {
  name: 'imageDeployment'
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
    hyperVGeneration: 'V1'
    location: '<location>'
    osState: 'Generalized'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
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
    "hyperVGeneration": {
      "value": "V1"
    },
    "location": {
      "value": "<location>"
    },
    "osState": {
      "value": "Generalized"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
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
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
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

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

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

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
